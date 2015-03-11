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
//#import <SDWebImage/UIImageView+WebCache.h>

#define kHBChannelsPerPage 100

static NSString *const cellIdentifier = @"HBChannelsViewCell";

@interface HBChannelsViewController ()

@property (nonatomic, strong) NSMutableArray *followingChannels;
@property (nonatomic, strong) NSMutableArray *featuredChannels;

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation HBChannelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:configuration];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
        return self.followingChannels.count;
    }else{
        return self.featuredChannels.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBChannelsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    if (indexPath.section == 0) {
        
    }else{
        cell.channel = self.featuredChannels[indexPath.row];
//        cell.iconImageView.image = nil;
        [cell updateCell];
        
        
        
//        if (cell.dataTask) {
//            [cell.dataTask cancel];
//            NSLog(@"cancel");
//        }
        
//        NSString *urlString = [cell.channel iconURLForWidth:140];
//        cell.dataTask = [self.session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//            if (!error) {
//                UIImage *image = [UIImage imageWithData:data];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    cell.iconImageView.image = image;
//                });
//            }
//        }];
//        [cell.dataTask resume];
//        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    }
    
    return cell;
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
