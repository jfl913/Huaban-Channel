//
//  IBDesignableOnePixelConstant.m
//  
//
//  Created by jfl913 on 15/7/3.
//
//

#import "IBDesignableOnePixelConstant.h"

@implementation IBDesignableOnePixelConstant

- (void)setOnePixelConstant:(NSInteger)onePixelConstant
{
    _onePixelConstant = onePixelConstant;
    self.constant = onePixelConstant * 1.0 / [UIScreen mainScreen].scale;
}

@end
