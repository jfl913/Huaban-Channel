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
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    self.session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
}

- (void)updateCell
{
    self.channelTitleLabel.text = self.channel.title;
    self.channelMetaLabel.text = [NSString stringWithFormat:@"%ld", (long)self.channel.itemCount];
    NSString *urlString = [self.channel iconURLForWidth:140];
    NSLog(@"url: %@", urlString);
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
//
//    self.dataTask = [self.session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (!error) {
//            UIImage *image = [UIImage imageWithData:data];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.iconImageView.image = image;
//            });
//        }
//    }];
//    [self.dataTask resume];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
