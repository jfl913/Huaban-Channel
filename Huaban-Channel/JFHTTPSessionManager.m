//
//  JFHTTPSessionManager.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/2.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "JFHTTPSessionManager.h"
#import "NSString+Base64Encode.h"

@interface JFHTTPSessionManager ()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, copy) NSString *clientSecret;

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

- (void)setClientID:(NSString *)clientID andClientSecret:(NSString *)clientSecret
{
    self.clientID = clientID;
    self.clientSecret = clientSecret;
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
    NSURLSessionDataTask *dataTask = [self dataTaskWithURLString:URLString
                                                  bodyParameters:parameters
                                                         success:success
                                                         failure:failure];
    [dataTask resume];
    return dataTask;
}


// 暂时只实现了GET方法
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(NSDictionary *)parameters
                                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURL *url = [NSURL URLWithString:URLString relativeToURL:self.baseURL];
    NSString *completeURLString = [[url absoluteString] stringByAppendingFormat:@"?%@", [self stringFromQueryParameters:parameters]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:completeURLString]];
    request.HTTPMethod = method;
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

- (NSURLSessionDataTask *)dataTaskWithURLString:(NSString *)URLString
                                     bodyParameters:(NSDictionary *)parameters
                                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURL *url = [NSURL URLWithString:URLString relativeToURL:self.baseURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *authInfo = [[NSString stringWithFormat:@"%@:%@", self.clientID, self.clientSecret] base64encode];
    NSString *basicAuth = [NSString stringWithFormat:@"Basic %@", authInfo];
    [request addValue:basicAuth forHTTPHeaderField:@"Authorization"];
    request.HTTPBody = [[self stringFromQueryParameters:parameters] dataUsingEncoding:NSUTF8StringEncoding];
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
