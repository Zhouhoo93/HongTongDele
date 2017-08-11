//
//  YTBarButtonItemSelecteView.m
//  YTBarButtonItemSelecteView-Demo
//
//  Created by lan on 2017/4/29.
//  Copyright © 2017年 com.tzshlyt.demo. All rights reserved.
//

#import "YTBarButtonItemSelecteView.h"

@interface YTBarButtonItemSelecteView ()

typedef void (^actionBlock)(UIButton *);

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *buttonHandlers;

@property (nonatomic, strong) UIView *showInView;
@property (nonatomic, strong) UIBarButtonItem *barButtonItem;
@property (nonatomic, strong) UIView *buttonsView;

@end

@implementation YTBarButtonItemSelecteView

- (instancetype)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");
    self.showInView = view;
    return [self initWithFrame:view.bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = self.showInView.autoresizingMask;
        self.buttonWidth = 130.f;
        self.buttonHeight = 44.f;
    
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        
        _buttons = [NSMutableArray array];
        _buttonHandlers = [NSMutableArray array];
        _buttonsView = [[UIView alloc] initWithFrame:CGRectZero];
        _buttonsView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_buttonsView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(hide)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)addActionWithTitle:(NSString *)title
                     image:(UIImage *)image
                   handler:(void (^)(UIButton *))handler {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = self.buttons.count;
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttons addObject:button];
    [self.buttonHandlers addObject:handler];
    [self.buttonsView addSubview:button];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIView *barItemView = [UIView new];
    CGRect statusFrame = [UIApplication sharedApplication].statusBarFrame;
    
    CGFloat w = KWidth-32;
    CGFloat h = 36 * self.buttons.count;
    CGFloat x = 16;
    CGFloat y = 133 ;
    if (barItemView.center.x > self.showInView.center.x) { // rightBarButtonItem
        x = self.showInView.frame.size.width - w;
    }
    self.buttonsView.frame = CGRectMake(x, y, w, h);
    
    for (NSUInteger i = 0; i < self.buttons.count; i++) {
        UIButton *button = self.buttons[i];
        button.frame = CGRectMake(0, i * 36, KWidth-32, 36);
    }
}

- (void)buttonAction:(UIButton *)sender {
    [self hide];
    actionBlock hander = self.buttonHandlers[sender.tag];
    if (hander != nil) {
        hander(sender);
    }
}

- (void)showBelowBarButtonItem:(UIBarButtonItem *)item{
    [self hide];
    self.barButtonItem = item;
    [self.showInView addSubview:self];
}

- (void)hide {
    [self removeFromSuperview];
}

@end
