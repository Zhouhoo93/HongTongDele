//
//  YTBarButtonItemSelecteView.h
//  YTBarButtonItemSelecteView-Demo
//
//  Created by lan on 2017/4/29.
//  Copyright © 2017年 com.tzshlyt.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTBarButtonItemSelecteView : UIView

@property (nonatomic, assign) CGFloat buttonWidth;
@property (nonatomic, assign) CGFloat buttonHeight;

- (instancetype)initWithView:(UIView *)view;

- (void) addActionWithTitle:(NSString *)title
                      image:(UIImage *)image
                    handler:(void(^)(UIButton *action))handler;

- (void)showBelowBarButtonItem:(UIBarButtonItem *)item;
- (void)hide;

@end
