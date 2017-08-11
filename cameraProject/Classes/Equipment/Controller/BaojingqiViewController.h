//
//  BaojingqiViewController.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/5/11.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baojingqiModel.h"
@interface BaojingqiViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *bidLabel;
@property (weak, nonatomic) IBOutlet UILabel *xinghaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *zuobiaoLabel;
@property (nonatomic,strong) baojingqiModel *model;
@end
