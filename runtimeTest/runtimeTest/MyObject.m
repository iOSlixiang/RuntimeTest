//
//  MyObject.m
//  runtimeTest
//
//  Created by 张理想 on 2022/4/24.
//

#import "MyObject.h"
#import <objc/runtime.h>

static NSMutableDictionary *map = nil;

@implementation MyObject
+ (void)load
{
    map = [NSMutableDictionary dictionary];
    map[@"name1"]                = @"name";
    map[@"status1"]              = @"status";
    map[@"name2"]                = @"name";
    map[@"status2"]              = @"status";
}

- (void)setDataWithDic:(NSDictionary *)dic
{
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        NSString *propertyKey = [self propertyForKey:key];
        if (propertyKey)
        {
            objc_property_t property = class_getProperty([self class], [propertyKey UTF8String]);
            // TODO: 针对特殊数据类型做处理
            NSString *attributeString = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            
            [self setValue:obj forKey:propertyKey];
        }
    }];
}
-(NSString *)propertyForKey:(NSString *)key{
    return map[key];
}
- (void)sing{
    
    NSLog(@"接受者重定向 :%s",__func__);
}
@end
