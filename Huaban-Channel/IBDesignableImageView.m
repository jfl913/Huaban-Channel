//
//  IBDesignableImageView.m
//  
//
//  Created by jfl913 on 15/7/3.
//
//

#import "IBDesignableImageView.h"

@implementation IBDesignableImageView

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0 ? YES : FALSE;
}

@end
