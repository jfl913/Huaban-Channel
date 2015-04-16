//
//  HBChannelItemsViewCell.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/4/16.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "HBChannelItemsViewCell.h"
#import "UIImageView+JFWebCache.h"

@interface HBChannelItemsViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UILabel *channelItemTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLable;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLable;

@end

@implementation HBChannelItemsViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCell
{
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[self.channelItem.user avatarURLWithHeight:140]]];
    self.usernameLabel.text = self.channelItem.user.username;
    self.timestampLabel.text = @(self.channelItem.createdAt).stringValue;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:[self.channelItem imageURLWithWidth:640 isSquare:NO]]];
    self.channelItemTextLabel.text = self.channelItem.text;
    self.likeCountLable.text = @(self.channelItem.likeCount).stringValue;
    self.commentCountLable.text = @(self.channelItem.commentCount).stringValue;
}

@end
