//
//  HBChannelsViewCell.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/3.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBChannel.h"

@interface HBChannelsViewCell : UITableViewCell

@property (nonatomic, strong) HBChannel *channel;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end
