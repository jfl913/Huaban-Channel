//
//  JFWebImageDownloaderOperation.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/11.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "JFWebImageDownloaderOperation.h"

@interface JFWebImageDownloaderOperation ()

@property (copy, nonatomic) SDWebImageDownloaderProgressBlock progressBlock;
@property (copy, nonatomic) SDWebImageDownloaderCompletedBlock completedBlock;
@property (copy, nonatomic) SDWebImageNoParamsBlock cancelBlock;

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, getter = isExecuting) BOOL executing;
@property (nonatomic, getter = isFinished) BOOL finished;
@property (nonatomic) NSInteger expectedSize;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *connection;

@end

@implementation JFWebImageDownloaderOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)initWithRequest:(NSURLRequest *)request
             progress:(SDWebImageDownloaderProgressBlock)progressBlock
            completed:(SDWebImageDownloaderCompletedBlock)completedBlock
            cancelled:(SDWebImageNoParamsBlock)cancelBlock
{
    self = [super init];
    if (self) {
        self.request = request;
        self.progressBlock = progressBlock;
        self.completedBlock = completedBlock;
        self.cancelBlock = cancelBlock;
        self.executing = NO;
        self.finished = NO;
    }
    return self;
}

- (void)start
{
    if (self.isCancelled) {
        self.finished = YES;
        [self reset];
        return;
    }
    
    self.executing = YES;
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
    [self.connection start];
    if (self.connection) {
        if (self.progressBlock) {
            self.progressBlock(0, NSURLResponseUnknownLength);
        }
        
        CFRunLoopRun();
        
        if (!self.isFinished) {
            [self.connection cancel];
            [self connection:self.connection didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorTimedOut userInfo:@{NSURLErrorFailingURLErrorKey : self.request.URL}]];
        }
    }else{
        if (self.completedBlock) {
            self.completedBlock(nil, nil, [NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: @"Connection can't be initialized"}], YES);
        }
    }
}

- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)reset
{
    self.progressBlock = nil;
    self.completedBlock = nil;
    self.cancelBlock = nil;
    self.connection = nil;
    self.imageData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    CFRunLoopStop(CFRunLoopGetCurrent());
    
    if (self.completedBlock) {
        self.completedBlock(nil, nil, error, YES);
    }
    
    [self done];
}

- (void)done
{
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"response: %@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"data: %@", data);
}


@end
