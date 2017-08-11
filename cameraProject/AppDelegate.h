//
//  AppDelegate.h
//  cameraProject
//
//  Created by Zhouhoo on 16/12/19.
//  Copyright © 2016年 ziHou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic ,strong)dispatch_source_t timer;//  注意:此处应该使用强引用 strong
@property (nonatomic,assign) NSInteger count;
@end

