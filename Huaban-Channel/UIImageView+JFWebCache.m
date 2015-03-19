//
//  UIImageView+JFWebCache.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/5.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "UIImageView+JFWebCache.h"
#import "JFWebImageManager.h"
#import "JFWebImageDownloader.h"
#import <objc/runtime.h>

static char loadOperationKey;


//如果本身在主线程，再获得主线程会出错
#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}


typedef void(^JFWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);
typedef void(^JFWebImageCompletionBlock)(UIImage *image, NSError *error, NSURL *imageURL);


@implementation UIImageView (JFWebCache)

- (void)sd_setImageWithURL:(NSURL *)url
{
    [self sd_setImageWithURL:url placeholderImage:nil progress:nil completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder progress:(JFWebImageDownloaderProgressBlock)progressBlock completed:(JFWebImageCompletionBlock)completedBlock
{
    [self sd_cancelCurrentImageLoad];
    self.image = placeholder;
    [self setNeedsLayout];
    if (url) {
        NSOperation *operation = [[JFWebImageManager sharedManager] downloadImageWithURL:url progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, JFImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            dispatch_main_sync_safe(^{
                self.image = image;
                [self setNeedsLayout];
            });

        }];
        
        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    }

}

- (void)sd_cancelCurrentImageLoad
{
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

- (void)sd_cancelImageLoadOperationWithKey:(NSString *)key
{
    NSMutableDictionary *operationDictionary = [self operationDictionary];
    NSOperation *operation = operationDictionary[key];
    if (operation) {
        [operation cancel];
    }
    [operationDictionary removeObjectForKey:key];
}

- (void)sd_setImageLoadOperation:(NSOperation *)operation forKey:(NSString *)key
{
    [self sd_cancelImageLoadOperationWithKey:key];
    NSMutableDictionary *operationDictionary = [self operationDictionary];
    [operationDictionary setObject:operation forKey:key];
}

- (NSMutableDictionary *)operationDictionary
{
    NSMutableDictionary *operations = objc_getAssociatedObject(self, &loadOperationKey);
    if (operations) {
        return operations;
    }
    
    operations = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, &loadOperationKey, operations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return operations;
}

@end
