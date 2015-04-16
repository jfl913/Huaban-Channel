//
//  HBAvatar.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/4/14.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import <Mantle.h>

@interface HBAvatar : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSInteger ID;
@property (nonatomic, copy) NSString *farm;
@property (nonatomic, copy) NSString *bucket;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *type;
@property (nonatomic) NSInteger width;
@property (nonatomic) NSInteger height;
@property (nonatomic) NSInteger frames;

@end
