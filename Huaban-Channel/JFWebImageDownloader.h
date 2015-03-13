//
//  JFWebImageDownloader.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/11.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^SDWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);
typedef void(^SDWebImageDownloaderCompletedBlock)(UIImage *image, NSData *data, NSError *error, BOOL finished);

@interface JFWebImageDownloader : NSObject

+ (instancetype)sharedDownloader;

- (NSOperation *)downloadImageWithURL:(NSURL *)url
                            progress:(SDWebImageDownloaderProgressBlock)progressBlock
                           completed:(SDWebImageDownloaderCompletedBlock)completedBlock;

@end
