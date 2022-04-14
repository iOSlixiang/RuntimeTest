//
//  MyClass.m
//  runtimeTest
//
//  Created by 张理想 on 2022/4/14.
//

#import "MyClass.h"

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
@end
