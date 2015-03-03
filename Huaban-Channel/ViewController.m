//
//  ViewController.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/2/28.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "ViewController.h"
#import "HBChannel.h"
#import "JFHTTPSessionManager.h"
#import "HBAPIManager.h"

static NSString *API_SERVER = @"https://api.huaban.com";

#define kHBChannelsPerPage 100

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    HBAPIManager *manager = [HBAPIManager sharedManager];
    [manager fetchFeaturedChannelsWithOffset:NSNotFound limit:kHBChannelsPerPage success:^(id responseObject) {
        NSLog(@"responseObject: %@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
