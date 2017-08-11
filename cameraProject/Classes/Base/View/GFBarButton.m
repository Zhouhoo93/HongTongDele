//
//  GFBarButton.m
//  HelloBoxVersionTwo
//
//  Created by guofu on 15/12/17.
//  Copyright © 2015年 guofu. All rights reserved.
//

#import "GFBarButton.h"

@implementation GFBarButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/**
 *  只要覆盖了这个方法,按钮就不存在高亮状态
 */
- (void)setHighlighted:(BOOL)highlighted
{
        //[super setHighlighted:highlighted];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
