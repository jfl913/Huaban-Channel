//
//  HBChannelItemsViewCell.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/4/17.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "HBChannelItemsViewCell.h"
#import <Masonry.h>
#import "UIImageView+JFWebCache.h"
#import <Masonry.h>
#import "NSDate+JFToNow.h"

#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight    [UIScreen mainScreen].bounds.size.height
#define kSpace 10
#define kImageWidth ScreenWidth
#define kHeaderViewHeight 52
#define kBottomViewHeight 52

@interface HBChannelItemsViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemImageViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionLabelBottomConstraint;

@end

@implementation HBChannelItemsViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)updateCell
{
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[self.channelItem.user avatarURLWithHeight:140]]];
    self.usernameLabel.text = self.channelItem.user.username;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.channelItem.createdAt];
    self.timeLabel.text = [date jf_toNow];
    
    if (self.channelItem.file) {
        CGFloat imageHeight = [self imageHeightWithFile:self.channelItem.file];
        self.itemImageViewHeightConstraint.constant = imageHeight;
        self.itemImageViewBottomConstraint.constant = kSpace;
        [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:[self.channelItem imageURLWithWidth:640 isSquare:NO]]];
    }else{
        self.itemImageViewHeightConstraint.constant = 0;
        self.itemImageViewBottomConstraint.constant = 0;
    }
    
    if (self.channelItem.text.length == 0) {
        self.itemImageViewBottomConstraint.constant = 0;
        self.descriptionLabelBottomConstraint.constant = 0;
    }else{
        self.itemImageViewBottomConstraint.constant = kSpace;
        self.descriptionLabelBottomConstraint.constant = kSpace;
    }
    
    self.descriptionLabel.text = self.channelItem.text;
    self.likeCountLabel.text = self.channelItem.likeCount > 0 ? [NSString stringWithFormat:@"%ld", (long)self.channelItem.likeCount] : @"";
    self.commentCountLabel.text = self.channelItem.commentCount > 0 ? [NSString stringWithFormat:@"%ld", (long)self.channelItem.commentCount] : @"";
}

- (CGFloat)imageHeightWithFile:(HBFile *)file
{
    if (file) {
        CGFloat imageHeight = kImageWidth * file.height * 1.0 / file.width;
        return imageHeight;
    }
    
    return 0;
}

- (CGFloat)heightForRow
{
    // 之所以加上kSpace，是对后面的contentView的frame调整时，布局合理
    return (self.bottomView.frame.origin.y + self.bottomView.frame.size.height);
}

@end
