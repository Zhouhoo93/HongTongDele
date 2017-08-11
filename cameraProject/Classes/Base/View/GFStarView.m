//
//  GFStarView.m
//  pingfen
//
//  Created by qjkj on 15/12/30.
//  Copyright © 2015年 guofu. All rights reserved.
//

#import "GFStarView.h"
typedef void (^GFBlock)();

@implementation GFStarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.number = 5;
        self.width = (CGFloat)self.frame.size.width/self.number;
        self.height = (CGFloat)self.frame.size.height;
        [self creatStar];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.number = 5;
        [self creatStar];
    }
    return self;
}
- (void)creatStar { //默认
    CGFloat x = 0;
    CGFloat y = 0;
    //    CGFloat w = CGRectGetWidth(self.frame);
    //    CGFloat h = CGRectGetHeight(self.frame);
    [self setWidth:14];
    [self setHeight:14];
    for (int i = 0; i < self.number; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 200 + i;
        imageView.frame= CGRectMake(x, y, self.width, self.height);
        imageView.image = [UIImage imageNamed:@"2five-pointed-star"];
        [self addSubview:imageView];
        x = x + self.width;
    }
}
- (void)setScore:(CGFloat)score {
    if (score == 0 || score < 0) return;
    NSInteger num = (NSInteger)score;
    if (score > 5) {
        num = 5;
    }
    GFBlock change = ^() {
        for (int i = 0; i <num; i++) {
            UIImageView *imageView = [self viewWithTag:200+i];
            imageView.image = [UIImage imageNamed:@"_five-pointed-star"];
        }
    };
    if (score == num) {
        change();
    }
    if (score > num) {
        change();
        UIImageView *imageView = [self viewWithTag:200+num];
        imageView.image = [UIImage imageNamed:@"3five-pointed-star"];
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
