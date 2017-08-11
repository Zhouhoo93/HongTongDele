//
//  SmallTableViewCell.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/2/9.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmallModel.h"
@protocol MycellDelegate <NSObject>

@optional
-(void)didClickButton:(UIButton *)button;
- (void)disselectButton:(UIButton *)button;
@end

@interface SmallTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (nonatomic,strong) NSMutableArray *selectArr;
@property (nonatomic,strong) SmallModel *model;
@property(nonatomic,weak) id<MycellDelegate> delegate;  
@end
