//
//  JFWebImageManager.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/5.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFImageCache.h"
#import "JFWebImageDownloader.h"

typedef void(^JFWebImageCompletionWithFinishedBlock)(UIImage *image, NSError *error, JFImageCacheType cacheType, BOOL finished, NSURL *imageURL);

@interface JFWebImageManager : NSObject

@property (nonatomic, strong) JFImageCache *imageCache;
@property (nonatomic, strong) JFWebImageDownloader *imageDownloader;

+ (instancetype)sharedManager;

- (id <JFWebImageOperation>)downloadImageWithURL:(NSURL *)url
                             progress:(JFWebImageDownloaderProgressBlock)progressBlock
                            completed:(JFWebImageCompletionWithFinishedBlock)completedBlock;

@end
