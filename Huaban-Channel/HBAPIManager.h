//
//  HBAPIManager.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/2.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "JFHTTPSessionManager.h"

@interface HBAPIManager : JFHTTPSessionManager

+ (instancetype)sharedManager;

@end

@interface HBAPIManager (Channel)

- (void)fetchFeaturedChannelsWithOffset:(NSInteger)offset
                                  limit:(NSInteger)limit
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *error))failure;

- (void)fetchChannelItemsWithChannelID:(NSInteger)channelID
                                offset:(NSInteger)offset
                                 limit:(NSInteger)limit
                               success:(void (^)(id responseObject))success
                               failure:(void (^)(NSError *error))failure;

@end

@interface HBAPIManager (Account)

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

@end

@interface HBAPIManager (User)

- (void)fetchUserInfoWithSuccess:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;

@end
