//
//  MessageCenterTableViewCell.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/1/5.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "MessageCenterTableViewCell.h"

@implementation MessageCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)CallKeFU:(id)sender {
    [self.delegate Call];
}
- (IBAction)CallKeFu:(id)sender {
    [self.delegate Call];

}



@end
