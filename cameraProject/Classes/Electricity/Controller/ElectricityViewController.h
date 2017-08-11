//
//  ElectricityViewController.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/4/11.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import <QuartzCore/CADisplayLink.h>  
//引入语音合成类

@class

IFlySpeechSynthesizer;

@class

IFlyDataUploader;

//注意要添加语音合成代理
@interface ElectricityViewController : UIViewController<IFlySpeechSynthesizerDelegate>
//声明语音合成的对象
{
NSTimer *theTimer;
}
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@property (strong, nonatomic) UITextView *content;

@end
