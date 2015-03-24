//
//  JFWebImageManager.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/5.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "JFWebImageManager.h"
#import "JFWebImageOperation.h"
#import "JFWebImageMacro.h"


typedef void(^JFWebImageNoParamsBlock)();

@interface JFWebImageCombinedOperation : NSObject <JFWebImageOperation>

@property (nonatomic, strong) NSOperation *cacheOperation;
@property (nonatomic, copy) JFWebImageNoParamsBlock cancelBlock;
@property (nonatomic, getter = isCancelled) BOOL cancelled;

@end


@implementation JFWebImageManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _imageCache = [JFImageCache sharedImageCache];
        _imageDownloader = [JFWebImageDownloader sharedDownloader];
    }
    
    return self;
}

+ (instancetype)sharedManager
{
    static JFWebImageManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [JFWebImageManager new];
    });
    
    return instance;
}

- (id <JFWebImageOperation>)downloadImageWithURL:(NSURL *)url
                  progress:(JFWebImageDownloaderProgressBlock)progressBlock
                 completed:(JFWebImageCompletionWithFinishedBlock)completedBlock
{
    NSParameterAssert(completedBlock);
    
    if ([url isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:(NSString *)url];
    }
    
    if (![url isKindOfClass:[NSURL class]]) {
        url = nil;
    }
    
    __block JFWebImageCombinedOperation *operation = [JFWebImageCombinedOperation new];
    
    if (!url) {
        dispatch_main_sync_safe(^{
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil];
            completedBlock(nil, error, JFImageCacheTypeNone, YES, url);
        });
        
        return operation;
    }
    
    NSString *key = [url absoluteString];
    
    operation.cacheOperation = [self.imageCache queryDiskCacheForKey:key done:^(UIImage *image, JFImageCacheType cacheType) {
        if (operation.isCancelled) {
            return;
        }
        if (image) {
            dispatch_main_sync_safe(^{
                if (!operation.isCancelled) {
                    completedBlock(image, nil, cacheType, YES, url);
                }
            });
        }else{
            id <JFWebImageOperation> subOperation = [self.imageDownloader downloadImageWithURL:url progress:progressBlock completed:^(UIImage *downloadImage, NSData *data, NSError *error, BOOL finished) {
                if (error) {
                    if (!operation.isCancelled) {
                        completedBlock(nil, error, JFImageCacheTypeNone, YES, url);
                    }
                }else if (downloadImage && finished){
                    [self.imageCache storeImage:downloadImage recalculateFromImage:NO imageData:data forKey:key toDisk:YES];
                    dispatch_main_sync_safe(^{
                        if (!operation.isCancelled) {
                            completedBlock(downloadImage, nil, JFImageCacheTypeNone, YES, url);
                        }
                    });
                }
            }];
            
            operation.cancelBlock = ^{
                [subOperation cancel];
            };
        }
    }];

    return operation;
}

@end

@implementation JFWebImageCombinedOperation

- (void)cancel
{
    self.cancelled = YES;
    if (self.cacheOperation) {
        [self.cacheOperation cancel];
        self.cacheOperation = nil;
    }
    
    if (self.cancelBlock) {
        self.cancelBlock();
        _cancelBlock = nil;
    }
}

@end
