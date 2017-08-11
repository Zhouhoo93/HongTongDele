//
//  SmallTableViewCell.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/2/9.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "SmallTableViewCell.h"

@implementation SmallTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_selectArr removeAllObjects];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    if (self.rightBtn.selected) {
//        [self.rightBtn setSelected:NO];
//    }else{
//        [self.rightBtn setSelected:YES];
//    }
    // Configure the view for the selected state
}
- (IBAction)rightBtnClick:(id)sender {
    if (_rightBtn.selected) {
        _rightBtn.selected = NO;
        [self.delegate disselectButton:sender];
        
    }else{
        _rightBtn.selected = YES;
        [self.delegate didClickButton:sender];

    }
}

-(NSMutableArray *)selectArr{
    if (!_selectArr) {
        _selectArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _selectArr;
}

-(SmallModel *)model{
    if (!_model) {
        _model = [[SmallModel alloc] init];
    }
    return _model;
}
@end
