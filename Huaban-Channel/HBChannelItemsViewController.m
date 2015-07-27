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
#import <Masonry.h>
#import "HBAccessToken.h"
#import <SSKeychain.h>

static NSString *const reuseCellIdentifier = @"HBChannelItemsViewCellID";
static NSString *const userDataPath = @"api.user.data";

#define kHBChannelItemsPerPage 20

@interface HBChannelItemsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

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
                                                                 if (((NSArray *)responseObject).count < kHBChannelItemsPerPage) {
                                                                     [self setupTableFooterView];
                                                                 }else{
                                                                     self.tableView.tableFooterView = nil;
                                                                 }

                                                                 [self.activityIndicatorView stopAnimating];
                                                                 [self.tableView reloadData];
                                                             });
                                                         } failure:^(NSError *error) {
                                                             NSLog(@"error: %@", error);
                                                         }];
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
    
    
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

- (void)handleRefresh
{
    [[HBAPIManager sharedManager] fetchChannelItemsWithChannelID:self.channel.channelID
                                                          offset:NSNotFound
                                                           limit:kHBChannelItemsPerPage
                                                         success:^(id responseObject) {
                                                             [self.dataArray addObjectsFromArray:responseObject];
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (((NSArray *)responseObject).count < kHBChannelItemsPerPage) {
                                                                     [self setupTableFooterView];
                                                                 }else{
                                                                     self.tableView.tableFooterView = nil;
                                                                 }
                                                                 [self.refreshControl endRefreshing];
                                                                 [self.tableView reloadData];
                                                             });
                                                         } failure:^(NSError *error) {
                                                             [self.refreshControl endRefreshing];
                                                             NSLog(@"error: %@", error);
                                                         }];
}

- (void)loadMore
{
    __weak typeof(self) weakSelf = self;
    
    NSInteger offset = weakSelf.dataArray.count ? ((HBChannelItem *)(weakSelf.dataArray.lastObject)).channelItemID : NSNotFound;
    [[HBAPIManager sharedManager] fetchChannelItemsWithChannelID:self.channel.channelID
                                                          offset:offset
                                                           limit:kHBChannelItemsPerPage
                                                         success:^(id responseObject) {
                                                             [weakSelf.dataArray addObjectsFromArray:responseObject];
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (((NSArray *)responseObject).count < kHBChannelItemsPerPage) {
                                                                     [weakSelf setupTableFooterView];
                                                                 }else{
                                                                     weakSelf.tableView.tableFooterView = nil;
                                                                 }
                                                                 [weakSelf.tableView reloadData];
                                                                 [weakSelf.tableView.infiniteScrollingView stopAnimating];
                                                             });
                                                         } failure:^(NSError *error) {
                                                             [weakSelf.tableView.infiniteScrollingView stopAnimating];
                                                             NSLog(@"error: %@", error);
                                                         }];

}

- (IBAction)followItemTapped:(id)sender
{
    [self loginHuaBan];
}

- (void)setupTableFooterView
{
    // 一开始就要设置好view的frame，如果用下面的autolayout来设置view的width，height，tableFooterView只有往上拖才会显示，一松手就又弹回去隐藏住了
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *label = [UILabel new];
    label.text = @"没有更多了";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:12];
    [view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(view.mas_centerY);
    }];
    
    self.tableView.tableFooterView = view;
}

- (void)loginHuaBan
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"花瓣"
                                                                             message:@"登录"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"用户名";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"密码";
    }];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *username = ((UITextField *)alertController.textFields.firstObject).text;
        NSString *password = ((UITextField *)alertController.textFields.lastObject).text;
        [self loginWithUsername:username password:password];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:loginAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    [[HBAPIManager sharedManager] loginWithUsername:username
                                           password:password
                                            success:^(HBAccessToken *token) {
                                                [self setUpAccessToken:token];
                                                [self fetchUserInfo];
                                            } failure:^(NSError *error) {
                                                NSLog(@"error: %@", error);
                                            }];
    
}

- (void)setUpAccessToken:(HBAccessToken *)token
{
    [[HBAPIManager sharedManager].requestSerializer setValue:[NSString stringWithFormat:@"bearer %@", token.accessToken] forHTTPHeaderField:@"Authorization"];
    [SSKeychain setPassword:token.accessToken forService:@"HuabBan" account:@"accessToken"];
    [SSKeychain setPassword:token.refreshToken forService:@"HuaBan" account:@"refreshToken"];
}

- (void)fetchUserInfo
{
    [[HBAPIManager sharedManager] fetchUserInfoWithSuccess:^(HBUser *user) {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *userPath = [documentsDirectory stringByAppendingPathComponent:userDataPath];
        [NSKeyedArchiver archiveRootObject:user toFile:userPath];
    } failure:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArray.count == 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
    return rowHeight + 1.0 / [UIScreen mainScreen].scale;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
       [tableView setSeparatorInset:UIEdgeInsetsZero];
   }

    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
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
