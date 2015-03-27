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
    HBAPIManager *manager = [HBAPIManager sharedManager];
    [manager fetchFeaturedChannelsWithOffset:NSNotFound limit:kHBChannelsPerPage success:^(id responseObject) {
        [self.featuredChannels addObjectsFromArray:responseObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods

- (void)handleRefresh
{
    HBAPIManager *manager = [HBAPIManager sharedManager];
    [manager fetchFeaturedChannelsWithOffset:NSNotFound limit:kHBChannelsPerPage success:^(id responseObject) {
        [self.featuredChannels addObjectsFromArray:responseObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
    } failure:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (!self.followingChannels.count && !self.featuredChannels.count) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
