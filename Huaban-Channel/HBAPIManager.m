//
//  HBAPIManager.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/2.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "HBAPIManager.h"
#import "HBChannelAPI.h"

static NSString *API_SERVER = @"https://api.huaban.com";

typedef void(^JFSuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void(^JFFailureBlock)(NSURLSessionDataTask *task, NSError *error);

@implementation HBAPIManager

+ (instancetype)sharedManager
{
    static HBAPIManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HBAPIManager alloc] initWithBaseURL:[NSURL URLWithString:API_SERVER]];
    });
    
    return manager;
}

- (void)fetchFeaturedChannelsWithOffset:(NSInteger)offset
                                  limit:(NSInteger)limit
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure
{
    NSString *max = offset != NSNotFound ? [NSString stringWithFormat:@"&max=%ld", (long)offset] : @"";
    NSString *path = [NSString stringWithFormat:@"/mobile_topics/featured?limit=%ld%@", (long)limit, max];
    
    [self requestWithMethod:@"GET"
                      relativePath:path
                        parameters:nil
                       resultClass:[HBChannel class]
                           listKey:@"topics"
                           success:success
                           failure:failure];
}

- (void)requestWithMethod:(NSString *)method
                  relativePath:(NSString *)relativePath
                    parameters:(NSDictionary *)parameters
                   resultClass:(Class)resultClass
                       listKey:(NSString *)listKey
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure
{
    JFSuccessBlock jfSuccessBlock = ^(NSURLSessionDataTask *task, id responseObject){
        if (listKey.length > 0) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[listKey] isKindOfClass:[NSArray class]]) {
                    NSArray *array = responseObject[listKey];
                    NSMutableArray *parsedArray = [NSMutableArray array];
                    for (NSDictionary *dic in array) {
                        [parsedArray addObject:[MTLJSONAdapter modelOfClass:resultClass fromJSONDictionary:dic error:nil]];
                    }
                    if (success) {
                        success(parsedArray);
                    }
                }else if ([responseObject[listKey] isKindOfClass:[NSDictionary class]]){
                    MTLModel *model = [MTLJSONAdapter modelOfClass:resultClass fromJSONDictionary:responseObject[listKey] error:nil];
                    success(model);
                }
            }
        }
    };
    
    JFFailureBlock jfFailureBlock = ^(NSURLSessionDataTask *task, NSError *error)
    {
        if (failure) {
            failure(error);
        }
    };
    
    if ([method isEqualToString:@"GET"]) {
        [self GET:relativePath
       parameters:parameters
          success:jfSuccessBlock
          failure:jfFailureBlock];
    }
}

@end
