//
//  CommentViewController.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/7/6.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol popBtnDelegate <NSObject>

- (void)backToVC;

@end
@interface CommentViewController : UIViewController
/*
 * 输入框字体，用来计算表情的大小
 */
@property (nonatomic,copy) NSString *userID;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *touImage;
@property (nonatomic,copy) NSString *LabelText;
@property(nonatomic, strong) UIFont *font;
@property(nonatomic, weak)id<popBtnDelegate> delegate;
@end
