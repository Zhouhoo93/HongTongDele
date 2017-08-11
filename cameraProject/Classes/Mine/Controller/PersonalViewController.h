//
//  PersonalViewController.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/1/16.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol touxiangDelegate
@required
-(void)genggai;
@end
@interface PersonalViewController : UIViewController
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *sex;
@property (nonatomic,copy)NSString *headimgurl;
@property (nonatomic, strong) id<touxiangDelegate> myDelegate;
@end
