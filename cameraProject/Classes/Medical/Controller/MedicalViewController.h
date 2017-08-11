//
//  MedicalViewController.h
//  cameraProject
//
//  Created by Zhouhoo on 16/12/20.
//  Copyright © 2016年 ziHou. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HeaderDelegate <NSObject>
- (void)pushSheBei;
@end

@interface MedicalViewController : UIViewController<HeaderDelegate>
@property (nonatomic, assign) id<HeaderDelegate> delegate;
@end
