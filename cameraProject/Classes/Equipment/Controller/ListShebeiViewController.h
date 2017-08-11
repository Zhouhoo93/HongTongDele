//
//  ListShebeiViewController.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/5/11.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListShebeiModel.h"
@interface ListShebeiViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *bidLabel;
@property (weak, nonatomic) IBOutlet UILabel *dianliuLabel;
@property (weak, nonatomic) IBOutlet UILabel *xinghaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dianyaLabel;
@property (weak, nonatomic) IBOutlet UILabel *dianfeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *StatusLabel;
@property (nonatomic,strong) ListShebeiModel *model;
@property (nonatomic,assign) BOOL isGuDing;
@property (nonatomic,assign) BOOL isQuan;
@end
