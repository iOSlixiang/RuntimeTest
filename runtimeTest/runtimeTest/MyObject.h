//
//  MyObject.h
//  runtimeTest
//
//  Created by 张理想 on 2022/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyObject : NSObject


@property (nonatomic, copy) NSString    *   name;
@property (nonatomic, copy) NSString    *   status;

@property (nonatomic, strong) NSDictionary *dataWithDic;

- (void)sing;
@end

NS_ASSUME_NONNULL_END
