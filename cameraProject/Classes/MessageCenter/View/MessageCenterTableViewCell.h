//
//  MessageCenterTableViewCell.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/1/5.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CallDelegate <NSObject>
- (void)Call;

@end
@interface MessageCenterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (nonatomic, assign) id<CallDelegate> delegate;
@end
