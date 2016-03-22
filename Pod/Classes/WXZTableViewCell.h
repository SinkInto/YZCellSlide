//
//  WXZTableViewCell.h
//  MYBSlide
//
//  Created by wangxiangzhao on 16/3/16.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WXZTableViewCell;

@protocol WXZTableViewCellDelegate <NSObject>

@optional

- (BOOL)wxz_canSlideInTableViewCell:(WXZTableViewCell *)tableViewCell;
- (NSArray *)wxz_titlesForSlideViewInTableViewCell:(WXZTableViewCell *)tableViewCell;
- (void)wxz_tableViewCell:(WXZTableViewCell *)tableViewCell didSelectedSlideViewIndex:(NSInteger)index;

@end

@interface WXZTableViewCell : UITableViewCell

@property (nonatomic, weak) UIView *actualContentView;

@property (nonatomic, weak) id <WXZTableViewCellDelegate>delegate;

@end
