//
//  JFHTTPRequestSerializer.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/4/28.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFHTTPRequestSerializer : NSObject

+ (instancetype)serializer;

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters;

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

@end
