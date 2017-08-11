//
//  AlarmTableViewCell.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/1/5.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end
