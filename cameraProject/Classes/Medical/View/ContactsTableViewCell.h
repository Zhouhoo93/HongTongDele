//
//  ContactsTableViewCell.h
//  cameraProject
//
//  Created by Zhouhoo on 16/12/21.
//  Copyright © 2016年 ziHou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *touImage;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIView *midView;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *textLabel1;
@property (nonatomic,assign) BOOL isHelpTable;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *from_id;
@property (nonatomic,copy) NSString *bid;
@end
