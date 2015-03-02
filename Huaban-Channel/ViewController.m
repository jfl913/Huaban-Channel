//
//  ViewController.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/2/28.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "ViewController.h"
#import "HBChannel.h"

static NSString *API_SERVER = @"https://api.huaban.com";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *dataArray = [NSMutableArray array];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURL *baseURL = [NSURL URLWithString:API_SERVER];
    NSURL *url = [NSURL URLWithString:@"mobile_topics/featured?limit=100" relativeToURL:baseURL];
    NSURLSessionDataTask *sessionDataTask = [session
                                             dataTaskWithURL:url
                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                 if (!error) {
                                                     NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                                     NSArray *array = jsonObject[@"topics"];
                                                     for (NSDictionary *dic in array) {
                                                         HBChannel *channel = [MTLJSONAdapter modelOfClass:[HBChannel class] fromJSONDictionary:dic error:nil];
                                                         [dataArray addObject:channel];
                                                     }
                                                     
                                                     NSLog(@"channel: %@", dataArray);
                                                 }
    }];
    [sessionDataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
