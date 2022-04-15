//
//  logAllClass.h
//  runtimeTest
//
//  Created by 张理想 on 2022/4/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogAllClass : NSObject
{
    NSString *_occupation;
    NSString *_nationality;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSUInteger age;

- (NSDictionary *)allProperties;
- (NSDictionary *)allIvars;
- (NSDictionary *)allMethods;

-(void)allClassName;

+(void)startMethod;

@end

NS_ASSUME_NONNULL_END
