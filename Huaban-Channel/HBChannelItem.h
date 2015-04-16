//
//  HBChannelItem.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/4/14.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "MTLModel.h"
#import "HBUser.h"
#import "HBFile.h"

@interface HBChannelItem : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSInteger channelItemID;
@property (nonatomic) NSInteger channelID;
@property (nonatomic, strong) HBUser *user;
@property (nonatomic, strong) HBFile *file;
@property (nonatomic) NSInteger likeCount;
@property (nonatomic) NSInteger commentCount;
@property (nonatomic, copy) NSString *text;
@property (nonatomic) NSInteger createdAt;
@property (nonatomic, strong) NSArray *comments;

- (NSString *)imageURLWithWidth:(NSInteger)width isSquare:(BOOL)isSquare;

@end
