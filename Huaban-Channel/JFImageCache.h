//
//  JFImageCache.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/13.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JFImageCache : NSObject

+ (instancetype)sharedImageCache;

- (void)storeImage:(UIImage *)image forKey:(NSString *)key;
- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk;
- (void)storeImage:(UIImage *)image recalculateFromImage:(BOOL)recalculate imageData:(NSData *)imageData forKey:(NSString *)key toDisk:(BOOL)toDisk;

@end
