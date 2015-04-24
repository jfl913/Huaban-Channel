//
//  UITableView+JFLayoutCell.m
//  Huaban-Channel
//
//  Created by jfl913 on 15/4/20.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import "UITableView+JFLayoutCell.h"
#import <objc/runtime.h>

static char reuseCellDictionaryKey;

@implementation UITableView (JFLayoutCell)

- (CGFloat)jf_heightForCellWithIdentifier:(NSString *)identifier
                            configuration:(ConfigurationBlock)configuraionBlock
{
    UITableViewCell *cell = [self jf_cellForReuseIdentifier:identifier];
    
    cell.contentView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.frame), self.rowHeight);
    
    if (configuraionBlock) {
        configuraionBlock(cell);
    }
    
    NSLayoutConstraint *contentViewWidthConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView
                                                                                  attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                                                                                     toItem:nil
                                                                                  attribute:NSLayoutAttributeNotAnAttribute multiplier:1
                                                                                   constant:CGRectGetWidth(self.frame)];
    [cell.contentView addConstraint:contentViewWidthConstraint];
    
    CGSize fittingSize = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    [cell.contentView removeConstraint:contentViewWidthConstraint];
    
    if (self.separatorStyle != UITableViewCellSeparatorStyleNone) {
        fittingSize.height += 1.0 / [UIScreen mainScreen].scale;
    }
    
    return fittingSize.height;
}

- (UITableViewCell *)jf_cellForReuseIdentifier:(NSString *)identifier
{
    NSMutableDictionary *reuseCellDictionary = objc_getAssociatedObject(self, &reuseCellDictionaryKey);
    if (!reuseCellDictionary) {
        reuseCellDictionary = @{}.mutableCopy;
        objc_setAssociatedObject(self, &reuseCellDictionaryKey, reuseCellDictionary, OBJC_ASSOCIATION_RETAIN);
    }
    
    UITableViewCell *cell = reuseCellDictionary[identifier];
    if (!cell) {
        cell = [self dequeueReusableCellWithIdentifier:identifier];
        reuseCellDictionary[identifier] = cell;
    }
    
    return cell;
    
}

@end
