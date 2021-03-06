//
//  JFWebImageDownloader.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/11.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "JFWebImageDownloader.h"
#import "JFWebImageDownloaderOperation.h"
#import "JFImageCache.h"

@interface JFWebImageDownloader ()

@property (nonatomic, strong) NSOperationQueue *downloadQueue;
@property (nonatomic, strong) NSMutableDictionary *httpHeaders;
@property (nonatomic) NSTimeInterval downloadTimeout;
@property (nonatomic, strong) JFImageCache *imageCache;

@end

@implementation JFWebImageDownloader

+ (instancetype)sharedDownloader
{
    static JFWebImageDownloader *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.downloadQueue = [[NSOperationQueue alloc] init];
        self.downloadQueue.maxConcurrentOperationCount = 6;
        self.httpHeaders = [NSMutableDictionary dictionaryWithObject:@"image/webp,image/*;q=0.8" forKey:@"Accept"];
        self.downloadTimeout = 15.0;
        self.imageCache = [JFImageCache sharedImageCache];
        
    }
    return self;
}

- (id <JFWebImageOperation>)downloadImageWithURL:(NSURL *)url
                            progress:(JFWebImageDownloaderProgressBlock)progressBlock
                           completed:(JFWebImageDownloaderCompletedBlock)completedBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:self.downloadTimeout];
    request.HTTPShouldUsePipelining = YES;
    request.allHTTPHeaderFields = self.httpHeaders;
    
    JFWebImageDownloaderOperation *operation = [[JFWebImageDownloaderOperation alloc] initWithRequest:request progress:progressBlock completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        completedBlock(image, data, error, finished);
    } cancelled:^{
        
    }];
    
    [self.downloadQueue addOperation:operation];
    
    return operation;
    
}

@end
