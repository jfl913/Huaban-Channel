//
//  JFWebImageManager.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/5.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFWebImageManager : NSObject

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

+ (instancetype)sharedManager;

@end
