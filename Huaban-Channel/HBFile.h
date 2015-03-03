//
//  HBFile.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/2.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import <Mantle.h>

@interface HBFile : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *farm;
@property (nonatomic, copy) NSString *bucket;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger frames;

@end
