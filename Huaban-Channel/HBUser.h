//
//  HBUser.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/4/14.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import <Mantle.h>
#import "HBAvatar.h"

@interface HBUser : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSInteger userID;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *urlname;
@property (nonatomic, strong) id avatar;
@property (nonatomic, strong) HBAvatar *hbAvatar;

- (NSString *)avatarURLWithHeight:(NSInteger)height;

@end
