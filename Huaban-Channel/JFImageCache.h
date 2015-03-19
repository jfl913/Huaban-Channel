//
//  JFImageCache.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/13.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JFImageCacheType){
    JFImageCacheTypeNone, //从网络下载
    JFImageCacheTypeDisk,
    JFImageCacheTypeMemory
};

typedef void(^JFWebImageQueryCompletedBlock)(UIImage *image, JFImageCacheType cacheType);

@interface JFImageCache : NSObject

+ (instancetype)sharedImageCache;

- (void)storeImage:(UIImage *)image forKey:(NSString *)key;
- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk;
- (void)storeImage:(UIImage *)image recalculateFromImage:(BOOL)recalculate imageData:(NSData *)imageData forKey:(NSString *)key toDisk:(BOOL)toDisk;

- (NSOperation *)queryDiskCacheForKey:(NSString *)key done:(JFWebImageQueryCompletedBlock)doneBlock;

- (UIImage *)imageFromDiskCacheForKey:(NSString *)key;

@end
