//
//  UIImageView+JFWebCache.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/5.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "UIImageView+JFWebCache.h"
#import "JFWebImageMacro.h"
#import <objc/runtime.h>

static char loadOperationKey;

@implementation UIImageView (JFWebCache)

- (void)sd_setImageWithURL:(NSURL *)url
{
    [self sd_setImageWithURL:url placeholderImage:nil progress:nil completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder progress:(JFWebImageDownloaderProgressBlock)progressBlock completed:(JFWebImageCompletionBlock)completedBlock
{
    [self sd_cancelCurrentImageLoad];
    self.image = placeholder;
    if (url) {
        id <JFWebImageOperation> operation = [[JFWebImageManager sharedManager] downloadImageWithURL:url progress:progressBlock completed:^(UIImage *image, NSError *error, JFImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            dispatch_main_sync_safe(^{
                if (image) {
                    self.image = image;
                    [self setNeedsLayout];
                }
                
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
                
            });

        }];
        
        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
        
    }else{
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:@"JFWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"url is nil"}];
            if (completedBlock) {
                completedBlock(nil, error, JFImageCacheTypeNone, url);
            }

        });
    }

}

- (void)sd_cancelCurrentImageLoad
{
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

- (void)sd_cancelImageLoadOperationWithKey:(NSString *)key
{
    NSMutableDictionary *operationDictionary = [self operationDictionary];
    id operation = operationDictionary[key];
    if ([operation conformsToProtocol:@protocol(JFWebImageOperation)]) {
        [(id <JFWebImageOperation>) operation cancel];
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
