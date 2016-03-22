//
//  WXZTableViewCell.m
//  MYBSlide
//
//  Created by wangxiangzhao on 16/3/16.
//  Copyright © 2016年 wangxiangzhao. All rights reserved.
//

#import "WXZTableViewCell.h"

#define BUTTON_PADDING 5.
#define SLIDE_ANIMATION_DURATION .3
#define SLIDE_BUTTON_BASE_TAG 10000
#define SLIDE_BUTTON_BG [UIColor redColor]

@interface WXZTableViewCell ()

@property (nonatomic, assign) BOOL isCanSlide;
@property (nonatomic, strong) NSArray *slideTitles;
@property (nonatomic, assign) CGFloat slideX;
@property (nonatomic, assign) CGFloat slideWidth;

@property (nonatomic, weak) UIView *_contentView;

@end

@implementation WXZTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self loadSubView];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self setMenuOptionsViewHidden:YES animated:NO completionHandler:nil];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadSubView];
    }
    return self;
}

- (void)loadSubView {
    UIView *contentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    contentView.backgroundColor = self.contentView.backgroundColor;
    [self.contentView addSubview:contentView];
    [self.contentView sendSubviewToBack:contentView];
    self._contentView = contentView;
    self.actualContentView = self.contentView;
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panRecognizer.delegate = self;
    [self addGestureRecognizer:panRecognizer];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self._contentView.frame = self.actualContentView.bounds;
    [self.contentView sendSubviewToBack:self._contentView];
    [self.contentView bringSubviewToFront:self.actualContentView];
    [self layoutSlideView];
}

- (void)layoutSlideView {
    self.slideX = CGRectGetWidth(self.bounds);
    self.slideWidth = 0.;
    CGFloat height = CGRectGetHeight(self.bounds);
    [self._contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            CGFloat width = [self slideSubButtonWidthWithButton:obj];
            self.slideX -= width;
            self.slideWidth += width;
            obj.frame = self.isCanSlide ? CGRectMake(self.slideX, 0, width, height) : CGRectZero;
        }
    }];
}

- (CGFloat)slideSubButtonWidthWithButton:(UIButton *)button {
    NSString *title = button.titleLabel.text;
    CGFloat width = roundf([title sizeWithFont:button.titleLabel.font].width + 2. * BUTTON_PADDING);
    return width;
}

- (void)setDelegate:(id<WXZTableViewCellDelegate>)delegate {
    _delegate = delegate;
    [self contentForDelegate];
    [self setNeedsDisplay];
}

- (void)setActualContentView:(UIView *)actualContentView {
    if (actualContentView) {
        _actualContentView = actualContentView;
        if (self.contentView != actualContentView) {
            [self.contentView addSubview:actualContentView];
        }
    }
}

- (void)setSlideTitles:(NSArray *)slideTitles {
    _slideTitles = slideTitles;
    if (self.isCanSlide && slideTitles) {
        [slideTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = SLIDE_BUTTON_BASE_TAG + idx;
            [button setTitle:obj forState:UIControlStateNormal];
            [button setBackgroundColor:SLIDE_BUTTON_BG];
            [self._contentView addSubview:button];
            [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        }];
    }
}

- (void)contentForDelegate {
    if (_delegate) {
        self.isCanSlide = [_delegate wxz_canSlideInTableViewCell:self];
        self.slideTitles = [_delegate wxz_titlesForSlideViewInTableViewCell:self];
    }
}


- (void)setMenuOptionsViewHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler
{
    if (self.selected) {
        [self setSelected:NO animated:NO];
    }
    CGRect frame = CGRectMake((hidden) ? 0 : - self.slideWidth, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    [UIView animateWithDuration:(animated) ? SLIDE_ANIMATION_DURATION : 0.
                          delay:0.
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self._contentView.frame = frame;
     } completion:^(BOOL finished) {
         self.isCanSlide = hidden;
//         self.shouldDisplayContextMenuView = !hidden;
//         if (!hidden) {
//             [self.delegate contextMenuDidShowInCell:self];
//         } else {
//             [self.delegate contextMenuDidHideInCell:self];
//         }
         if (completionHandler) {
             completionHandler();
         }
     }];
}



- (void)handlePan:(UIPanGestureRecognizer *)gesture {
 
}

- (void)clicked:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(wxz_tableViewCell:didSelectedSlideViewIndex:)]) {
        [_delegate wxz_tableViewCell:self didSelectedSlideViewIndex:button.tag - SLIDE_BUTTON_BASE_TAG];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark * UIPanGestureRecognizer delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.x) > fabs(translation.y);
    }
    return YES;
}

@end
