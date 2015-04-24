//
//  UITableView+JFLayoutCell.h
//  Huaban-Channel
//
//  Created by jfl913 on 15/4/20.
//  Copyright (c) 2015年 jfl913. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfigurationBlock)(id cell);

@interface UITableView (JFLayoutCell)

- (CGFloat)jf_heightForCellWithIdentifier:(NSString *)identifier
                            configuration:(ConfigurationBlock)configuraionBlock;

@end
