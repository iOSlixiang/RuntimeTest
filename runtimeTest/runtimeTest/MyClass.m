//
//  MyClass.m
//  runtimeTest
//
//  Created by 张理想 on 2022/4/14.
//

#import "MyClass.h"
#import "MyClass+Category.h"
#import <objc/runtime.h>

@interface MyClass ()
{
    NSInteger       _instance1;
    NSString    *   _instance2;
}
@property (nonatomic, assign) NSUInteger integer;
- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2;

@end

@implementation MyClass

+ (void)classMethod1 {
    
}
- (void)method1 {
    NSLog(@"call method method1");
}
- (void)method2 {
}
 

- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2 {
    NSLog(@"arg1 : %ld, arg2 : %@", arg1, arg2);
}
+(void)categoryMethod{
    NSLog(@"测试objc_class中的方法列表是否包含分类中的方法");
    unsigned int outCount = 0;
    Method *methodList = class_copyMethodList(MyClass.class, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methodList[i];
        const char *name = sel_getName(method_getName(method));
        NSLog(@"CategoryClass method: %s", name);
         
        // 分类方法method2在objc_class的方法列表中
        if (strcmp(name, sel_getName(@selector(method2)))) {
          
        }
    }
}

@end
