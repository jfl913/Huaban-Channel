//
//  HBAvatar.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/4/14.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "HBAvatar.h"

@implementation HBAvatar

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"ID": @"id",
             };
}

- (NSString *)key
{
    // 后面这一串是默认头像的key
    return _key ? : @"23a58517fb73f86bca85937f069724486b3e00a44caa-GMc99I";
}

@end
