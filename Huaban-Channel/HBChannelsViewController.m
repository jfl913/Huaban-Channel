//
//  HBChannelsViewController.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/3/3.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "HBChannelsViewController.h"
#import "HBAPIManager.h"
#import "HBChannelAPI.h"
#import "HBChannelsViewCell.h"
#import <Masonry.h>
#import <SVPullToRefresh.h>

#define kHBChannelsPerPage 100

static NSString *const cellReuseIdentifier = @"HBChannelsViewCell";
static NSString *const zeroFollowingcellReuseIdentifier = @"ZeroFollowingcell";

@interface HBChannelsViewController ()

@property (nonatomic, strong) NSMutableArray *followingChannels;
@property (nonatomic, strong) NSMutableArray *featuredChannels;

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation HBChannelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.featuredChannels = [NSMutableArray array];
    self.followingChannels = [NSMutableArray array];
    
    [[HBAPIManager sharedManager] fetchFeaturedChannelsWithOffset:NSNotFound
                                                            limit:kHBChannelsPerPage
                                                          success:^(id responseObject) {
                                                              self.featuredChannels = responseObject;
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    if (self.featuredChannels.count < kHBChannelsPerPage) {
                                                                        [self setupTableFooterView];
                                                                    }else{
                                                                        self.tableView.tableFooterView = nil;
                                                                    }
                                                                    [self.tableView reloadData];
                                                                });
                                                            } failure:^(NSError *error) {
                                                                NSLog(@"error: %@", error);
                                                            }];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

#pragma mark - Methods

- (void)handleRefresh
{
    HBAPIManager *manager = [HBAPIManager sharedManager];
    [manager fetchFeaturedChannelsWithOffset:NSNotFound limit:kHBChannelsPerPage success:^(id responseObject) {
        self.featuredChannels = responseObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.featuredChannels.count < kHBChannelsPerPage) {
                [self setupTableFooterView];
            }else{
                self.tableView.tableFooterView = nil;
            }
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
    } failure:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

- (void)loadMore
{
    __weak typeof(self)weakSelf = self;
    NSArray *array = self.featuredChannels;
    NSInteger offset = array.count > 0 ? ((HBChannel *)[array lastObject]).seq : NSNotFound;
    [[HBAPIManager sharedManager] fetchFeaturedChannelsWithOffset:offset
                                                            limit:kHBChannelsPerPage
                                                          success:^(id responseObject) {
        [weakSelf.featuredChannels addObjectsFromArray:responseObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([(NSArray *)responseObject count] < kHBChannelsPerPage) {
                UIView *view = [UIView new];
                view.backgroundColor = [UIColor lightGrayColor];
                
                UILabel *label = [UILabel new];
                label.text = @"没有更多了";
                label.textColor = [UIColor blackColor];
                label.font = [UIFont systemFontOfSize:12];
                [view addSubview:label];
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
                    make.height.equalTo(@40);
                }];
                
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(view.mas_centerX);
                    make.centerY.equalTo(view.mas_centerY);
                }];
                
                weakSelf.tableView.tableFooterView = view;
                weakSelf.tableView.infiniteScrollingView.enabled = NO;
                
            }
            
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        });
    } failure:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];

}

- (void)setupTableFooterView
{
    // 一开始就要设置好view的frame，如果用下面的autolayout来设置view的width，height，tableFooterView只有网上拖才会显示，一松手就又弹回去隐藏住了
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *label = [UILabel new];
    label.text = @"没有更多了";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12];
    [view addSubview:label];
    
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
//        make.height.equalTo(@40);
//    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(view.mas_centerY);
    }];
    
    self.tableView.tableFooterView = view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (!self.followingChannels.count && !self.featuredChannels.count) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        if (self.followingChannels.count == 0) {
            return 1;
        }
        return self.followingChannels.count;
    }else{
        return self.featuredChannels.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.followingChannels.count == 0) {
        UITableViewCell *zeroFollowingCell = [tableView dequeueReusableCellWithIdentifier:zeroFollowingcellReuseIdentifier forIndexPath:indexPath];
        return zeroFollowingCell;
    }
    
    HBChannelsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if (self.followingChannels.count > 0) {
            cell.channel = self.followingChannels[indexPath.row];
        }
    }else{
        if (self.featuredChannels.count > 0) {
            cell.channel = self.featuredChannels[indexPath.row];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *label = [UILabel new];
    label.text = section == 0 ? @"我关注的话题" : @"推荐话题";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12];
    [view addSubview:label];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(12);
        make.centerY.equalTo(view.mas_centerY);
    }];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

@end
