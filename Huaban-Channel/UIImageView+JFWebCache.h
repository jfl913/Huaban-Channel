//
//  UIImageView+JFWebCache.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/5.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFWebImageDownloader.h"
#import "JFWebImageManager.h"

@interface UIImageView (JFWebCache)

- (void)sd_setImageWithURL:(NSURL *)url;

- (void)sd_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                  progress:(JFWebImageDownloaderProgressBlock)progressBlock
                 completed:(JFWebImageCompletionBlock)completedBlock;

@end
