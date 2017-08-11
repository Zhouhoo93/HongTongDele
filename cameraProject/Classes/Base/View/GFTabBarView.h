//
//  GFTabBarView.h
//  HelloBoxVersionTwo
//
//  Created by guofu on 15/12/17.
//  Copyright © 2015年 guofu. All rights reserved.
//  自定义的tabBar, frame和系统的tabbar相同, 里边创建自定义的按钮

#import <UIKit/UIKit.h>
#import "GFBarButton.h"
@class GFTabBarView;
@protocol GFTabBarViewDelegate <NSObject>
//告诉他从哪里切换到哪里
- (void)tabBar:(GFTabBarView *)tabBarView didSelectButtonFrom:(NSInteger)from to:(NSInteger)to;

@end
@interface GFTabBarView : UIImageView
//存储默认选中按钮
@property (strong, nonatomic) GFBarButton *selectedButton;
@property (weak, nonatomic) id<GFTabBarViewDelegate> delegate;

//提供一个创建barButton的方法, 需要两种状态的按钮的图片
- (void)addBarButtonWithNormalName:(NSString *)normalName selectedName:(NSString *)selectedName;

- (void)change:(NSInteger)to;

@end
