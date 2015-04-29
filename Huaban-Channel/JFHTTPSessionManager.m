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
    self.requestSerializer = [JFHTTPRequestSerializer serializer];
    self.baseURL = url;
    
    return self;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
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

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"POST"
                                                        URLString:URLString
                                                       parameters:parameters
                                                          success:success
                                                          failure:failure];
    [dataTask resume];
    return dataTask;
}

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(NSDictionary *)parameters
                                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURL *url = [NSURL URLWithString:URLString relativeToURL:self.baseURL];
    NSMutableURLRequest *mutableURLRequest = [self.requestSerializer requestWithMethod:method
                                                                             URLString:url.absoluteString
                                                                            parameters:parameters];
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.session dataTaskWithRequest:mutableURLRequest
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

@end
