//
//  HBUser.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/4/14.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "HBUser.h"

@implementation HBUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"userID": @"user_id",
             };
}

- (NSString *)avatarURLWithHeight:(NSInteger)height
{
    NSString *key = self.hbAvatar.key ? : @"23a58517fb73f86bca85937f069724486b3e00a44caa-GMc99I";
    return [NSString stringWithFormat:@"http://img.hb.aicdn.com/%@_sq%ldsf", key ,(long)height];
}

- (HBAvatar *)hbAvatar
{
    if ([_avatar isKindOfClass:[NSDictionary class]]) {
        _hbAvatar = [MTLJSONAdapter modelOfClass:[HBAvatar class] fromJSONDictionary:_avatar error:nil];
    }
    
    return _hbAvatar;
}

@end
