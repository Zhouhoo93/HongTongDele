//
//  XYFeedCell.m
//  Demo
//
//  Created by wuw on 16/6/15.
//  Copyright © 2016年 fifyrio. All rights reserved.
//

#import "XYFeedCell.h"
#import "PBEmojiLabel.h"
#import "LiuqsTextAttachment.h"
@interface XYFeedCell()
@property (weak, nonatomic) IBOutlet UILabel *goodNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIButton *touImage;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,copy) NSString *pinglunnum;
@end

@implementation XYFeedCell
- (void)setModel:(XYFeedModel *)model{
    _model = model;
    self.pinglunnum = model.ID;
//    self.goodNumberLabel.text = model.num;
    NSString *str1 = [NSString stringWithFormat:@" %@",model.num];
    [self.zanBtn setTitle:str1 forState:UIControlStateNormal];
    self.zanBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    [self.zanBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.zanBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    if ([model.isSelect isEqualToString:@"已点赞"]) {
        self.zanBtn.selected = YES;
    }else{
        self.zanBtn.selected = NO;
    }
    self.contentLabel.text = model.content;
    self.userLabel.text = model.user_name;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.user_pic]];
    //然后就是添加照片语句，这次不是`imageWithName`了，是 imageWithData。
     UIImage *image = [UIImage imageWithData:data];
    if (data.length > 0) {
        [self.touImage setImage:image forState:UIControlStateNormal];
    }else{
//        self.touImage.image = [UIImage imageNamed:@"moren"];
        [self.touImage setImage:[UIImage imageNamed:@"moren"] forState:UIControlStateNormal];
    }
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
 
    
    NSDateFormatter *date1 = [[NSDateFormatter alloc]init];
    [date1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date1 dateFromString:model.updated_at];
    NSDate *endD = [date1 dateFromString:DateTime];
    
    NSString *str;
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 4.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:startD toDate:endD options:0];
    // 5.输出结果
    NSLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
    if (cmps.day != 0) {
        str = [NSString stringWithFormat:@"%zd天前",cmps.day];
        
    }else if (cmps.day==0 && cmps.hour != 0) {
        str = [NSString stringWithFormat:@"%zd小时前",cmps.hour];
        
    }else if (cmps.day== 0 && cmps.hour== 0 && cmps.minute!=0) {
        str = [NSString stringWithFormat:@"%zd分钟前",cmps.minute];
        
    }else{
        str = [NSString stringWithFormat:@"1分钟前"];
        
    }
    self.timeLabel.text = str;
}

- (IBAction)zanBtnClick:(UIButton *)sender {
    if([self.model.isSelect isEqualToString:@"已点赞"]){
        self.pinglunnum=self.model.ID;
        sender.selected = NO;
        if ([self.delegate respondsToSelector:@selector(quxiaozan:)]) {
            
            // 4、委托方：发送方，调用协议方法，发送传递值
//            NSString *str = self.zanBtn.titleLabel.text;
//            NSInteger num = [str integerValue]-1;
//            [self.zanBtn setTitle:[NSString stringWithFormat:@" %d",num] forState:UIControlStateNormal];
            [self.delegate quxiaozan:self.pinglunnum];
           
            self.zanBtn.selected = NO;
            
            
        }
    }else{
        sender.selected = YES;
        if ([self.delegate respondsToSelector:@selector(zan:)]) {
//            NSString *str = self.zanBtn.titleLabel.text;
//            NSInteger num = [str integerValue]+1;
//            [self.zanBtn setTitle:[NSString stringWithFormat:@" %d",num] forState:UIControlStateSelected];
            // 4、委托方：发送方，调用协议方法，发送传递值
            [self.delegate zan:self.pinglunnum];
           
            self.zanBtn.selected = YES;
        }

    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
