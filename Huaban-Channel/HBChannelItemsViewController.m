//
//  HBChannelItemsViewController.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/4/16.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "HBChannelItemsViewController.h"
#import "HBAPIManager.h"
#import "HBChannelItem.h"
#import "HBChannelItemsViewCell.h"
#import "HRToastManager.h"

#define kHBChannelItemsPerPage 20

@interface HBChannelItemsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HBChannelItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.channel.title;
    self.dataArray = [@[] mutableCopy];
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
                                                             [self.activityIndicatorView stopAnimating];
                                                             NSString *erroMessage = error.userInfo[@"message"];
                                                             [HRToastManager showErrorMessage:erroMessage];
                                                         }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HBChannelItemsViewCell *channelItemsViewCell = [tableView dequeueReusableCellWithIdentifier:@"HBChannelItemsViewCell" forIndexPath:indexPath];
    HBChannelItem *channelItem = self.dataArray[indexPath.row];
    channelItemsViewCell.channelItem = channelItem;
    [channelItemsViewCell updateCell];
    
    return channelItemsViewCell;
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
