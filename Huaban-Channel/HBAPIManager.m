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
    
    return [self requestWithMethod:@"GET"
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
    __block NSArray *dataArray = [NSArray array];
    // 暂时只实现了GET方法
    if ([method isEqualToString:@"GET"]) {
        [self GET:relativePath parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            dataArray = [self parseResponseObject:responseObject withResultClass:resultClass andListKey:listKey];
            success(dataArray);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failure(error);
        }];
    }
}

//有一些条件未判断，以后遇到再补充
- (NSArray *)parseResponseObject:(id)responseObject withResultClass:(Class)resultClass andListKey:(NSString *)listKey
{
    NSMutableArray *parsedArray = [NSMutableArray array];
    if (listKey.length > 0) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[listKey] isKindOfClass:[NSArray class]]) {
                NSArray *array = responseObject[listKey];
                for (NSDictionary *dic in array) {
                    [parsedArray addObject:[MTLJSONAdapter modelOfClass:resultClass fromJSONDictionary:dic error:nil]];
                }
            }else if ([responseObject[listKey] isKindOfClass:[NSDictionary class]]){
                [parsedArray addObject:[MTLJSONAdapter modelOfClass:resultClass fromJSONDictionary:responseObject[listKey] error:nil]];
            }
        }
    }
    
    return parsedArray;
}


@end
