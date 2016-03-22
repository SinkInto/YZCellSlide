//
//  WXZTableView.m
//  MYBSlide
//
//  Created by wangxiangzhao on 16/3/16.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import "WXZTableView.h"

@interface WXZTableView () <UITableViewDataSource, UITableViewDelegate, WXZTableViewCellDelegate>

@end

@implementation WXZTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_wxzDelegate respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [_wxzDelegate numberOfSectionsInTableView:self];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_wxzDelegate respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        return [_wxzDelegate tableView:self numberOfRowsInSection:section];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_wxzDelegate respondsToSelector:@selector(wxz_tableView:cellForRowAtIndexPath:)]) {
        WXZTableViewCell *cell = [_wxzDelegate wxz_tableView:self cellForRowAtIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    } else if ([_wxzDelegate respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        return [_wxzDelegate tableView:self cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (BOOL)wxz_canSlideInTableViewCell:(WXZTableViewCell *)tableViewCell {
    if ([_wxzDelegate respondsToSelector:@selector(wxz_tableView:canEditRowAtIndexPath:)]) {
        return [_wxzDelegate wxz_tableView:self canEditRowAtIndexPath:[self indexPathForCell:tableViewCell]];
    }
    return NO;
}

- (NSArray *)wxz_titlesForSlideViewInTableViewCell:(WXZTableViewCell *)tableViewCell {
    if ([_wxzDelegate respondsToSelector:@selector(wxz_tableView:titlesForSlideViewForRowAtIndexPath:)]) {
        return [_wxzDelegate wxz_tableView:self titlesForSlideViewForRowAtIndexPath:[self indexPathForCell:tableViewCell]];
    }
    return [NSArray array];
}

- (void)wxz_tableViewCell:(WXZTableViewCell *)tableViewCell didSelectedSlideViewIndex:(NSInteger)index {
    if ([_wxzDelegate respondsToSelector:@selector(wxz_tableView:commitEditingIndex:forRowAtIndexPath:)]) {
        [_wxzDelegate wxz_tableView:self commitEditingIndex:index forRowAtIndexPath:[self indexPathForCell:tableViewCell]];
    }
}

@end
