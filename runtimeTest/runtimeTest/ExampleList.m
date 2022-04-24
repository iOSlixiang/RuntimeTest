//
//  ExampleList.m
//  runtimeTest
//
//  Created by 张理想 on 2022/4/14.
//

#import "ExampleList.h"
#import "MyClass.h"
#import "MySubClass.h"
#import "MyObject.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation ExampleList
+(void)load{
    NSLog(@"%s",__func__);
}
-(instancetype)init{
    if (self = [super init]) {
        NSLog(@"%s",__func__);
    }
    return self;
}

-(void)startMethod{
//    [self logClassInfo];
//    [self runtimeNewClass];
//
//    [self runtimeNewInstance];
     
    [self runtimeMyObject];
}
#pragma mark - 打印类信息
-(void)logClassInfo{
    MyClass *myClass = [[MyClass alloc] init];
    unsigned int outCount = 0;
    Class cls = myClass.class;
    // 类名
    NSLog(@"class name: %s", class_getName(cls));
    NSLog(@"==========================================================");
    // 父类
    NSLog(@"super class name: %s", class_getName(class_getSuperclass(cls)));
    NSLog(@"==========================================================");
    // 是否是元类
    NSLog(@"MyClass is %@ a meta-class", (class_isMetaClass(cls) ? @"" : @"not"));
    NSLog(@"==========================================================");
    Class meta_class = objc_getMetaClass(class_getName(cls));
    NSLog(@"%s's meta-class is %s", class_getName(cls), class_getName(meta_class));
    NSLog(@"==========================================================");
    // 变量实例大小
    NSLog(@"instance size: %zu", class_getInstanceSize(cls));
    NSLog(@"==========================================================");
    // 成员变量
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"instance variable's name: %s at index: %d", ivar_getName(ivar), i);
    }
    free(ivars);
    Ivar string = class_getInstanceVariable(cls, "_string");
    if (string != NULL) {
        NSLog(@"instace variable %s", ivar_getName(string));
    }
    NSLog(@"==========================================================");
    // 属性操作
    objc_property_t * properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"property's name: %s", property_getName(property));
    }
    free(properties);
    objc_property_t array = class_getProperty(cls, "array");
    if (array != NULL) {
        NSLog(@"property %s", property_getName(array));
    }
    NSLog(@"==========================================================");
    // 方法操作
    Method *methods = class_copyMethodList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        NSLog(@"method's signature: %s", method_getName(method));
    }
    free(methods);
    Method method1 = class_getInstanceMethod(cls, @selector(method1));
    if (method1 != NULL) {
        NSLog(@"method %s", method_getName(method1));
    }
    Method classMethod = class_getClassMethod(cls, @selector(classMethod1));
    if (classMethod != NULL) {
        NSLog(@"class method : %s", method_getName(classMethod));
    }
    NSLog(@"MyClass is%@ responsd to selector: method3WithArg1:arg2:", class_respondsToSelector(cls, @selector(method3WithArg1:arg2:)) ? @"" : @" not");
    IMP imp = class_getMethodImplementation(cls, @selector(method1));
    imp();
    NSLog(@"==========================================================");
    // 协议
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList(cls, &outCount);
    Protocol * protocol;
    for (int i = 0; i < outCount; i++) {
        protocol = protocols[i];
        NSLog(@"protocol name: %s", protocol_getName(protocol));
    }
    NSLog(@"MyClass is%@ responsed to protocol %s", class_conformsToProtocol(cls, protocol) ? @"" : @" not", protocol_getName(protocol));
    NSLog(@"==========================================================");
}
#pragma mark -  动态创建 类
// 自定义一个方法
void sayFunction(id self, SEL _cmd, id some) {
    NSLog(@"%s",__func__);
    NSLog(@"%@岁的%@说：%@", object_getIvar(self, class_getInstanceVariable([self class], "_age")),[self valueForKey:@"name"],some);
}
-(void)runtimeCreate {
    // 动态创建对象 创建一个Person 继承自 NSObject类
    Class People = objc_allocateClassPair([NSObject class], "Person", 0);
    
    // 为该类添加NSString *_name成员变量
    class_addIvar(People, "_name", sizeof(NSString*), log2(sizeof(NSString*)), @encode(NSString*));
    // 为该类添加int _age成员变量
    class_addIvar(People, "_age", sizeof(int), sizeof(int), @encode(int));
    
    // 注册方法名为say的方法
    SEL s = sel_registerName("say:");
    // 为该类增加名为say的方法
    class_addMethod(People, s, (IMP)sayFunction, "v@:@");

    // 注册该类
    objc_registerClassPair(People);
    
    // 创建一个类的实例
    id peopleInstance = [[People alloc] init];
    
    // KVC 动态改变 对象peopleInstance 中的实例变量
    [peopleInstance setValue:@"苍老师" forKey:@"name"];
    
    // 从类中获取成员变量Ivar
    Ivar ageIvar = class_getInstanceVariable(People, "_age");
    // 为peopleInstance的成员变量赋值
    object_setIvar(peopleInstance, ageIvar, @18);
    
    // 调用 peopleInstance 对象中的 s 方法选择器对于的方法
    // objc_msgSend(peopleInstance, s, @"大家好!"); // 这样写也可以，请看我博客说明
     ((void (*)(id, SEL, id))objc_msgSend)(peopleInstance, s, @"大家好");
    peopleInstance = nil; //当People类或者它的子类的实例还存在，则不能调用objc_disposeClassPair这个方法；因此这里要先销毁实例对象后才能销毁类；
    
    // 销毁类
    objc_disposeClassPair(People);
}
void submethod(Class cla, SEL _cmd) {
    NSLog(@"%s",__func__);
   
}
void method1(id self, SEL _cmd) {
    NSLog(@"%s",__func__);
    NSLog(@"%@", object_getIvar(self, class_getInstanceVariable([self class], "_ivar1")));
}
-(void)runtimeNewClass{
 
    Class cls = objc_allocateClassPair(MyClass.class, "MySubClass1", 0);
    SEL subSel = @selector(submethod1);
    class_addMethod(cls, subSel, (IMP)submethod, "v@:");
    class_replaceMethod(cls, @selector(method1), (IMP)method1, "v@:");
  
    class_addIvar(cls, "_ivar1", sizeof(NSString *), log(sizeof(NSString *)),  "ivar_getTypeEncoding");
 
    objc_property_attribute_t type = {"T", "@\"NSString\""};
    objc_property_attribute_t ownership = { "C", "" };
    objc_property_attribute_t backingivar = { "V", "_backingivar"};
    objc_property_attribute_t attrs[] = {type, ownership, backingivar};
    class_addProperty(cls, "property2", attrs, 3);
    
    objc_registerClassPair(cls);
   
    
    id instance = [[cls alloc] init];
    

    [instance setValue:@"苍老师" forKey:@"ivar1"];

    Ivar ageIvar = class_getInstanceVariable(cls, "_ivar1");
    object_setIvar(instance, ageIvar, @"3");
    NSLog(@"instance value object_getIvar: %@ ", object_getIvar(instance, ageIvar));
    
    [instance performSelector:subSel];
    [instance performSelector:@selector(method1)];
     
    // 属性操作
    unsigned int outCount = 0;
    objc_property_t * properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"property's name: %s", property_getName(property));
        NSLog(@"property's name: %s", property_getAttributes(property));
   
    }
    free(properties);
    
    objc_property_t array = class_getProperty(cls, "property2");
    if (array != NULL) {
        NSLog(@"property value %s", property_getName(array));
    }
    
    // 成员变量
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"instance name: %s ", ivar_getName(ivar));
        // 初始化是的成员变量
        NSLog(@"instance value: %s ", ivar_getTypeEncoding(ivar));
        //当前实例 的成员变量
        NSLog(@"instance value: %@ ", object_getIvar(instance, ivar));
        
    }
    free(ivars);
}
#pragma mark - 动态创建 实例
-(void)runtimeNewInstance{
 
    id theObject = class_createInstance(NSString.class, sizeof(unsigned));
     
    id str1 = [theObject init];
    NSLog(@"%@", [str1 class]);
    id str2 = @"test";
    NSLog(@"%@", [str2 class]);
}

#pragma mark - 动态解析 dic
-(void)runtimeMyObject{
    
    
    MyObject *object = [[MyObject alloc]init];
    
    object.dataWithDic = @{@"name1": @"张三", @"status1": @"star"};
    
    NSLog(@"%@ -- %@",object.name,object.status);
    
    object.dataWithDic = @{@"name2": @"张三", @"status2": @"end"};
    
    NSLog(@"%@ -- %@",object.name,object.status);
    
}

@end
