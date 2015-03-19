//
//  JFImageCache.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/13.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "JFImageCache.h"
#import <CommonCrypto/CommonDigest.h>

@interface JFImageCache ()

@property (nonatomic, strong) NSCache *memCache;
@property (nonatomic, strong) NSString *diskCachePath;
@property (nonatomic) dispatch_queue_t ioQueue;


@end

@implementation JFImageCache
{
    NSFileManager *_fileManager;
}

+ (instancetype)sharedImageCache
{
    static JFImageCache *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init
{
    return [self initWithNamespace:@"default"];
}

- (instancetype)initWithNamespace:(NSString *)namespace
{
    self = [super init];
    if (self) {
        NSString *fullNamespace = [NSString stringWithFormat:@"com.hackemist.JFWebImageCache.%@", namespace];
        _ioQueue = dispatch_queue_create("com.hackemist.JFWebImageCache", DISPATCH_QUEUE_SERIAL);
        _memCache = [[NSCache alloc] init];
        _memCache.name = fullNamespace;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _diskCachePath = [paths.firstObject stringByAppendingPathComponent:fullNamespace];
        dispatch_sync(_ioQueue, ^{
            _fileManager = [NSFileManager new];
        });
        
    }
    return self;
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key
{
    [self storeImage:image recalculateFromImage:YES imageData:nil forKey:key toDisk:YES];
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk
{
    [self storeImage:image recalculateFromImage:YES imageData:nil forKey:key toDisk:toDisk];
}

- (void)storeImage:(UIImage *)image recalculateFromImage:(BOOL)recalculate imageData:(NSData *)imageData forKey:(NSString *)key toDisk:(BOOL)toDisk
{
    if (!image || !key) {
        return;
    }
    
    [self.memCache setObject:image forKey:key cost:(image.size.width * image.size.height * image.scale)];
    if (toDisk) {
        dispatch_async(self.ioQueue, ^{
            if (imageData) {
                if (![_fileManager fileExistsAtPath:self.diskCachePath]) {
                    [_fileManager createDirectoryAtPath:self.diskCachePath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                [_fileManager createFileAtPath:[self defaultCachePathForKey:key] contents:imageData attributes:nil];
            }
        });
    }
}

- (NSString *)defaultCachePathForKey:(NSString *)key {
    return [self cachePathForKey:key inPath:self.diskCachePath];
}

- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path
{
    NSString *fileName = [self cachedFileNameForKey:key];
    return [path stringByAppendingPathComponent:fileName];
}


- (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSMutableString *fileName = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [fileName appendFormat:@"%02x", r[i]];
    }
    
    return fileName;
}

- (NSOperation *)queryDiskCacheForKey:(NSString *)key done:(JFWebImageQueryCompletedBlock)doneBlock
{
    if (!doneBlock) {
        return nil;
    }
    
    if (!key) {
        doneBlock(nil, JFImageCacheTypeNone);
        return nil;
    }
    
    UIImage *image = [self imageFromMemoryCacheForKey:key];
    if (image) {
        doneBlock(image, JFImageCacheTypeMemory);
        return nil;
    }
    
    NSOperation *operation = [NSOperation new];
    dispatch_async(self.ioQueue, ^{
        if (operation.isCancelled) {
            return;
        }
        
        UIImage *diskImage = [self diskImageForKey:key];
        if (diskImage) {
            [self.memCache setObject:diskImage forKey:key cost:diskImage.size.width * diskImage.size.height *diskImage.scale];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            doneBlock(diskImage, JFImageCacheTypeDisk);
        });
    });
    
    return operation;
}

- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key
{
    return [self.memCache objectForKey:key];
}

- (UIImage *)imageFromDiskCacheForKey:(NSString *)key
{
    UIImage *image = [self imageFromMemoryCacheForKey:key];
    if (image) {
        return image;
    }
    
    UIImage *diskImage = [self diskImageForKey:key];
    if (diskImage) {
        [self.memCache setObject:diskImage forKey:key cost:(diskImage.size.width * diskImage.size.height * diskImage.scale)];
    }
    return diskImage;
    
}

- (UIImage *)diskImageForKey:(NSString *)key
{
    NSString *defaultPath = [self defaultCachePathForKey:key];
    NSData *data = [NSData dataWithContentsOfFile:defaultPath];
    return [UIImage imageWithData:data];
}


@end
