//
//  WXZTableView.h
//  MYBSlide
//
//  Created by wangxiangzhao on 16/3/16.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXZTableViewCell.h"

@class WXZTableView;

@protocol WXZTableViewDelegate <UITableViewDataSource, UITableViewDelegate>

- (WXZTableViewCell *)wxz_tableView:(WXZTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (BOOL)wxz_tableView:(WXZTableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)wxz_tableView:(WXZTableView *)tableView titlesForSlideViewForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)wxz_tableView:(WXZTableView *)tableView commitEditingIndex:(NSInteger)index forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface WXZTableView : UITableView

@property (nonatomic, weak) id <WXZTableViewDelegate>wxzDelegate;

@end
