//
//  HBChannelItemsViewController.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/4/17.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "HBChannelItemsViewController.h"
#import "HBChannelItemsViewCell.h"
#import "HBAPIManager.h"
#import "HBChannelItem.h"
#import "UITableView+JFLayoutCell.h"
#import <SVPullToRefresh.h>

static NSString *const reuseCellIdentifier = @"HBChannelItemsViewCellID";

#define kHBChannelItemsPerPage 20

@interface HBChannelItemsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation HBChannelItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = @[].mutableCopy;
    [self.activityIndicatorView startAnimating];
    [[HBAPIManager sharedManager] fetchChannelItemsWithChannelID:self.channel.channelID
                                                          offset:NSNotFound
                                                           limit:kHBChannelItemsPerPage
                                                         success:^(id responseObject) {
                                                             [self.dataArray addObjectsFromArray:responseObject];
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 [self.activityIndicatorView stopAnimating];
                                                                 [self.tableView reloadData];
                                                             });
                                                         } failure:^(NSError *error) {
                                                             NSLog(@"error: %@", error);
                                                         }];
    __weak typeof(self) weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (void)loadMore
{
    __weak typeof(self) weakSelf = self;
    
    NSInteger offset = weakSelf.dataArray.count ? ((HBChannelItem *)(weakSelf.dataArray.lastObject)).channelItemID : NSNotFound;
    [[HBAPIManager sharedManager] fetchChannelItemsWithChannelID:self.channel.channelID
                                                          offset:offset
                                                           limit:kHBChannelItemsPerPage
                                                         success:^(id responseObject) {
                                                             [self.dataArray addObjectsFromArray:responseObject];
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 [self.tableView reloadData];
                                                             });
                                                         } failure:^(NSError *error) {
                                                             NSLog(@"error: %@", error);
                                                         }];

}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count == 0) {
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        return 0;
    }
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleDefault;
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HBChannelItemsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellIdentifier];
    cell.channelItem = self.dataArray[indexPath.row];
    [cell updateCell];
    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static HBChannelItemsViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [tableView dequeueReusableCellWithIdentifier:reuseCellIdentifier];
    });

    
    sizingCell.channelItem = self.dataArray[indexPath.row];
    [sizingCell updateCell];
    
    sizingCell.bounds = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.bounds));
    // 配置完cell的内容后，再调用这两个方法，顺序不能反了，要不然cell高度计算就会错误
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGFloat rowHeight = [sizingCell heightForRow];
    return rowHeight + 1;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
