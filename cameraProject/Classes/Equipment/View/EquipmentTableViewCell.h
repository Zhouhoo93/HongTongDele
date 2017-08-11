//
//  EquipmentTableViewCell.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/5/10.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EquipmentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UIImageView *SmallBg;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDown;

@end
