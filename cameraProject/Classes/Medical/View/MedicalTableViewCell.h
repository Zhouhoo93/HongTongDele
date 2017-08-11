//
//  MedicalTableViewCell.h
//  cameraProject
//
//  Created by Zhouhoo on 16/12/20.
//  Copyright © 2016年 ziHou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "distanceModel.h"
@protocol daohangDelegate
@required
-(void)daohang;
-(void)deleCell:(UIButton *)sender;
- (void)XiangYingBtnClick:(NSString *)ID:(NSString *)bid;
@end

@interface MedicalTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *actualLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *touImage;
@property (weak, nonatomic) IBOutlet UIImageView *deleimg;
@property (weak, nonatomic) IBOutlet UIButton *smallBtn;
@property (nonatomic,assign) BOOL isHelpTable;
@property (weak, nonatomic) IBOutlet UIImageView *dongHuaImage;
@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString *latitude;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *registration_id;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *helper_id;
@property (nonatomic,copy) NSString *bid;
@property (nonatomic,copy) NSString *straight_line_distance;
@property (nonatomic,copy) NSString *actual_distance;
@property (nonatomic ,strong)dispatch_source_t timer;//  注意:此处应该使用强引用 strong
@property (weak, nonatomic) IBOutlet UIButton *deleBtn;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) distanceModel *model;
@property (nonatomic, strong) id<daohangDelegate> daohangDelegate;
@property (nonatomic,assign) BOOL isCall;
@property (nonatomic,assign) BOOL lianXuhujiao;
@property (nonatomic,strong) NSMutableArray *straight_line_distanceArr;
@property (weak, nonatomic) IBOutlet UILabel *xiangYingLabel;
@property (nonatomic,assign) BOOL isTongYi;
@property (nonatomic,strong) NSMutableArray *actual_distanceArr;
@end
