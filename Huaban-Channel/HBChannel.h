//
//  HBChannel.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/2.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HBChannel : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSInteger channelID;
@property (nonatomic, copy) NSString *title;
//@property (nonatomic) HBFile *icon;
@property (nonatomic) NSInteger createdAt;
@property (nonatomic) NSInteger itemCount;
@property (nonatomic) NSInteger userCount;
@property (nonatomic) NSInteger updatedAt;
@property (nonatomic, copy) NSString *channelDescription;
//@property (nonatomic) BOOL isFollowing;
//@property (nonatomic) NSInteger badge;
//@property (nonatomic) NSInteger seq;


@end
