//
//  HBChannelsViewCell.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/3.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "HBChannelsViewCell.h"
//#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+JFWebCache.h"

@interface HBChannelsViewCell ()


@property (weak, nonatomic) IBOutlet UILabel *channelTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *channelMetaLabel;

//@property (nonatomic, strong) NSURLSession *session;


@end

@implementation HBChannelsViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateCell
{
    self.channelTitleLabel.text = self.channel.title;
    self.channelMetaLabel.text = [NSString stringWithFormat:@"%ld", (long)self.channel.itemCount];
    NSString *urlString = [self.channel iconURLForWidth:140];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
