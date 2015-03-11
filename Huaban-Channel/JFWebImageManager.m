//
//  JFWebImageManager.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/5.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "JFWebImageManager.h"

@implementation JFWebImageManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }
    
    return self;
}

+ (instancetype)sharedManager
{
    static JFWebImageManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JFWebImageManager alloc] init];
    });
    
    return manager;
}

@end
