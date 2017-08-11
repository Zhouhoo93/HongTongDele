//
//  RelationTableViewCell.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/5/29.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RelationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *removeBtn;
@property (nonatomic,copy) NSString *cellTag;
@end
