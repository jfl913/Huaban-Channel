//
//  HBChannelItem.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/4/14.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "HBChannelItem.h"

@implementation HBChannelItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"channelItemID": @"post_id",
             @"channelID": @"topic_id",
             @"likeCount": @"like_count",
             @"commentCount": @"comment_count",
             @"text": @"raw_text",
             @"createdAt": @"created_at",
             };
}

+ (NSValueTransformer *)userJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HBUser class]];
}

+ (NSValueTransformer *)fileJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[HBFile class]];
}

- (NSString *)imageURLWithWidth:(NSInteger)width isSquare:(BOOL)isSquare
{
    NSString *prefix = isSquare ? @"sq" : @"fw";
    prefix = width ? [NSString stringWithFormat:@"_%@%ld", prefix, (long)width] : @"";
    return [NSString stringWithFormat:@"http://hb-topic-img.b0.upaiyun.com/%@%@", self.file.key, prefix];
}

@end