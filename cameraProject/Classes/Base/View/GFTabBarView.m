//
//  GFTabBarView.m
//  HelloBoxVersionTwo
//
//  Created by guofu on 15/12/17.
//  Copyright © 2015年 guofu. All rights reserved.
//

#import "GFTabBarView.h"


@interface GFTabBarView ()


@end

@implementation GFTabBarView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

//提供一个创建barButton的方法, 需要两种状态的按钮的图片
- (void)addBarButtonWithNormalName:(NSString *)normalName selectedName:(NSString *)selectedName {
    GFBarButton *barButton = [GFBarButton buttonWithType:UIButtonTypeCustom];
    [barButton setImage:[UIImage imageNamed:normalName] forState:UIControlStateNormal];
    [barButton setImage:[UIImage imageNamed:selectedName] forState:UIControlStateSelected];
    
    [self addSubview:barButton];
    
    
    //监听按钮点击事件, 当点击下去的时候就触发事件
    [barButton addTarget:self action:@selector(barButtonAction:) forControlEvents:UIControlEventTouchDown];
    
    //默认第一个为选中状态
    if (self.subviews.count == 1) {
        [self barButtonAction:barButton];
        //barButton.backgroundColor = [UIColor greenColor];
    }
    if (self.subviews.count == 2) {
        //barButton.backgroundColor = [UIColor redColor];
    }
    if (self.subviews.count == 3) {
        //barButton.backgroundColor = [UIColor yellowColor];
    }
    
}
//当子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger count = self.subviews.count;
    for (NSInteger i = 0; i<count; i++) {
        GFBarButton *button = self.subviews[i];
        button.tag = i;
        // 设置frame
        CGFloat buttonY = 0;
        CGFloat buttonW = self.frame.size.width / count;
        CGFloat buttonH = self.frame.size.height;
        CGFloat buttonX = i * buttonW;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }
    
}

//按钮响应事件
- (void)barButtonAction:(GFBarButton *)sender {
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectButtonFrom:self.selectedButton.tag to:sender.tag];
    }
    //更改按钮状态
    self.selectedButton.selected = NO;
    sender.selected = YES;
    self.selectedButton = sender;
}
//切换
- (void)change:(NSInteger)to {
    GFBarButton *btn = self.subviews[to];
    //更改按钮状态
    self.selectedButton.selected = NO;
    btn.selected = YES;
    self.selectedButton = btn;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
