//
//  HBAccessToken.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/4/27.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "HBAccessToken.h"

@implementation HBAccessToken

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"accessToken": @"access_token",
             @"refreshToken": @"refresh_token",
             @"tokenType": @"token_type",
             @"expiresIn": @"expires_in",
             };
}

@end