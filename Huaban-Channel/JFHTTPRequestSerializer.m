//
//  JFHTTPRequestSerializer.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/4/28.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "JFHTTPRequestSerializer.h"

@interface JFHTTPRequestSerializer ()

@property (nonatomic, strong) NSArray *HTTPMethodsEncodingParametersInURI;
@property (nonatomic, strong) NSMutableDictionary *mutableHTTPRequestHeaders;

@end

@implementation JFHTTPRequestSerializer

+ (instancetype)serializer
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.HTTPMethodsEncodingParametersInURI = @[@"GET", @"HEAD", @"DELETE"];
    self.mutableHTTPRequestHeaders = @{}.mutableCopy;
    
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
{
    NSParameterAssert(method);
    NSParameterAssert(URLString);
    
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:url];
    mutableRequest.HTTPMethod = method;
    
    [self.mutableHTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL *stop) {
        if (![mutableRequest valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    if ([self.HTTPMethodsEncodingParametersInURI containsObject:method.uppercaseString]) {
        mutableRequest.URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", URLString, [self stringFromQueryParameters:parameters]]];
        return mutableRequest;
    }
    
    if (parameters) {
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
            [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        }
        
        mutableRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    }
    
    return mutableRequest;
}

- (NSString *)stringFromQueryParameters:(NSDictionary *)queryParameters
{
    NSMutableArray *parts = [NSMutableArray array];
    [queryParameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *part = [NSString stringWithFormat:@"%@=%@",
                          [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                          [obj stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [parts addObject:part];
    }];
    
    return [parts componentsJoinedByString:@"&"];
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    [self.mutableHTTPRequestHeaders setObject:value forKey:field];
}

@end
