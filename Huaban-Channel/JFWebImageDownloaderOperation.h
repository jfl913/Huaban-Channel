//
//  JFWebImageDownloaderOperation.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/11.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFWebImageDownloader.h"
#import "JFWebImageOperation.h"

typedef void(^SDWebImageNoParamsBlock)();

@interface JFWebImageDownloaderOperation : NSOperation <JFWebImageOperation>

- (instancetype)initWithRequest:(NSURLRequest *)request
             progress:(JFWebImageDownloaderProgressBlock)progressBlock
            completed:(JFWebImageDownloaderCompletedBlock)completedBlock
            cancelled:(SDWebImageNoParamsBlock)cancelBlock;

@end
