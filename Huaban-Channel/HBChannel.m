//
//  HBChannel.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/2.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "HBChannel.h"

@implementation HBChannel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"channelID": @"topic_id",
             @"createdAt": @"created_at",
             @"itemCount": @"post_count",
             @"userCount": @"follower_count",
             @"updatedAt": @"updated_at",
             @"channelDescription": @"description",
             };
}

+ (NSValueTransformer *)iconJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HBFile class]];
}

- (NSString *)iconURLForWidth:(NSInteger)width
{
    return [NSString stringWithFormat:@"http://hb-topic-img.b0.upaiyun.com/%@_sq%ld", self.icon.key, (long)width];
}

@end
