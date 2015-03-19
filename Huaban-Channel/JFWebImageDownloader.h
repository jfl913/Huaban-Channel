//
//  JFWebImageDownloader.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/11.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JFWebImageOperation.h"

typedef void(^JFWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);
typedef void(^JFWebImageDownloaderCompletedBlock)(UIImage *image, NSData *data, NSError *error, BOOL finished);

@interface JFWebImageDownloader : NSObject

+ (instancetype)sharedDownloader;

- (id <JFWebImageOperation>)downloadImageWithURL:(NSURL *)url
                            progress:(JFWebImageDownloaderProgressBlock)progressBlock
                           completed:(JFWebImageDownloaderCompletedBlock)completedBlock;

@end
