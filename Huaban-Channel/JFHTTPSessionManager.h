//
//  JFHTTPSessionManager.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/2.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFHTTPSessionManager : NSObject

@property (nonatomic, strong) NSURL *baseURL;

- (instancetype)initWithBaseURL:(NSURL *)url;

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
