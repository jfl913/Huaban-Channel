//
//  HBAccessToken.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/4/27.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>

@interface HBAccessToken : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *tokenType;
@property (nonatomic) NSInteger expiresIn;

@end