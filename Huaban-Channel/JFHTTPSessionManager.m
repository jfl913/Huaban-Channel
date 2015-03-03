//
//  JFHTTPSessionManager.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/2.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "JFHTTPSessionManager.h"

@interface JFHTTPSessionManager ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation JFHTTPSessionManager

- (instancetype)init
{
    return [self initWithBaseURL:nil];
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:configuration];
    self.baseURL = url;
    
    return self;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"GET"
                                                        URLString:URLString
                                                       parameters:parameters
                                                          success:success
                                                          failure:failure];
    [dataTask resume];
    return dataTask;
}


// 暂时只实现了GET方法
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURL *url = [NSURL URLWithString:URLString relativeToURL:self.baseURL];
    NSMutableString *queryString = [NSMutableString string];
    
    if (parameters) {
        if ([parameters isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictionary = parameters;
            NSArray *allKeys = dictionary.allKeys;
            for (id key in allKeys) {
                [queryString appendFormat:@"%@=%@&", key, dictionary[key]];
            }
        }
    }
    
    NSString *subQueryString = [NSString string];
    if ([queryString hasSuffix:@"&"]) {
        subQueryString = [queryString substringToIndex:(queryString.length - 1)];
    }
    
    NSString *completeURLString = [[url absoluteString] stringByAppendingFormat:@"?%@", subQueryString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:completeURLString]];
    [request setHTTPMethod:method];
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                         if (error) {
                                                             if (failure) {
                                                                 failure(dataTask, error);
                                                             }
                                                         }else{
                                                             if (success) {
                                                                 id JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                                                 success(dataTask, JSONObject);
                                                             }
                                                         }
                                                         
                                                         
    }];
    return dataTask;
}

@end
