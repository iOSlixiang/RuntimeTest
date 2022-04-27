//
//  MyMessageForwarding.m
//  runtimeTest
//
//  Created by 张理想 on 2022/4/26.
//

#import "MyMessage.h"
#import <objc/runtime.h>
#import <objc/message.h>

#import "MyObject.h"


static int showType = 3 ;

@implementation MyMessage

// 第一步：我们不动态添加方法，返回NO，进入第二步；
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (showType != 1) {
        return NO;
    }
    // 我们没有给MyMessage类声明sing方法，我们这里动态添加方法
    if ([NSStringFromSelector(sel) isEqualToString:@"sing"]) {
        class_addMethod(self, sel, (IMP)otherSing, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];

}
// 第二部：我们不指定备选对象响应aSelector，进入第三步；
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if (showType  != 2) {
        return nil;
    }
     // MyObject 实现了SEL方法
    if (aSelector == @selector(sing)) {
        return [MyObject new];
    }else{
        return [super forwardingTargetForSelector:aSelector];
    }

}

// 第三步：返回方法选择器，然后进入第四部；
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if ([NSStringFromSelector(aSelector) isEqualToString:@"sing"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    
    return [super methodSignatureForSelector:aSelector];
}
// 第四部：这步我们修改调用方法,接受对象
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    // 修改响应方法
    [anInvocation setSelector:@selector(dance)];
    // 这还要指定是哪个对象的方法
    [anInvocation invokeWithTarget:self];
    
    
    // 改变调用对象
    [anInvocation setSelector:@selector(sing)];
    MyObject *instance = [[MyObject alloc] init];
    [anInvocation invokeWithTarget:instance];
}

// 若forwardInvocation没有实现，则会调用此方法
- (void)doesNotRecognizeSelector:(SEL)aSelector
{
    NSLog(@"消息无法处理：%@", NSStringFromSelector(aSelector));
}


void otherSing(id self, SEL cmd)
{
    NSLog(@"%@ 唱歌啦！",((MyMessage *)self).name);
}
- (void)dance
{
    NSLog(@"跳舞！！！come on！");
}
@end
