//
//  HBChannelItemsViewCell.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/4/17.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBChannelItem.h"

@interface HBChannelItemsViewCell : UITableViewCell

@property (nonatomic, strong) HBChannelItem *channelItem;

- (void)updateCell;
- (CGFloat)heightForRow;

@end
