//
//  NibianqiViewController.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/5/11.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nibianqiModel.h"
@interface NibianqiViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *gonglvLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinpaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *xinghaolabel;
@property (weak, nonatomic) IBOutlet UILabel *StatusLabel;
@property (nonatomic,strong) nibianqiModel *model;
@end
