//
//  MineTableViewCell.h
//  cameraProject
//
//  Created by Zhouhoo on 16/12/21.
//  Copyright © 2016年 ziHou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;

@end
