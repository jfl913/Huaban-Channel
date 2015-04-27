//
//  NSDate+JFToNow.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/4/27.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "NSDate+JFToNow.h"

#define kOneYear (12*30*24*60*60)
#define kOneMonth (30*24*60*60)
#define kOneWeek (7*24*60*60)
#define kOneDay (24*60*60)
#define kOneHour (60*60)
#define kOneMinute (60)

@implementation NSDate (JFToNow)

- (NSString *)jf_toNow
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self];
    if (timeInterval > kOneYear) {
        NSInteger year = timeInterval / kOneYear;
        return [NSString stringWithFormat:@"%ld年前", (long)year];
    }else if (timeInterval > kOneMonth){
        NSInteger month = timeInterval / kOneMonth;
        return [NSString stringWithFormat:@"%ld月前", (long)month];
    }else if (timeInterval > kOneWeek){
        NSInteger week = timeInterval / kOneWeek;
        return [NSString stringWithFormat:@"%ld周前", (long)week];
    }else if (timeInterval > kOneDay){
        NSInteger day = timeInterval / kOneDay;
        return [NSString stringWithFormat:@"%ld天前", (long)day];
    }else if (timeInterval > kOneHour){
        NSInteger hour = timeInterval / kOneHour;
        return [NSString stringWithFormat:@"%ld小时前", (long)hour];
    }else if (timeInterval > kOneMinute){
        NSInteger minute = timeInterval / kOneMinute;
        return [NSString stringWithFormat:@"%ld分钟前", (long)minute];
    }else{
        return @"刚刚";
    }
}

@end
