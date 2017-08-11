//
//  AdministrationTableViewCell.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/1/19.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdministrationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (nonatomic,copy) NSString *bid;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *position;

@property (nonatomic,copy) NSString *name;

@end
