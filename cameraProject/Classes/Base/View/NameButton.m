//
//  NameButton.m
//  NewsText
//
//  Created by qjkj on 15/12/21.
//  Copyright © 2015年 QJKJ. All rights reserved.
//

#import "NameButton.h"

@interface NameButton()
@property (nonatomic, strong) UIFont *titleFont;
@end

@implementation NameButton
/**
 *  从文件中解析一个对象的时候就会调用这个方法
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

/**
 *  通过代码创建控件的时候就会调用
 */
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    self.titleFont = [UIFont systemFontOfSize:14];
    self.titleLabel.font = self.titleFont;
    
    // 图标居中
    self.imageView.contentMode = UIViewContentModeCenter;
}
/**
 *  控制器内部label的frame
 *  contentRect : 按钮自己的边框
 */
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    NSDictionary *attrs = @{NSFontAttributeName : self.titleFont};
    CGFloat titleW;
    titleW = [self.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

/**
 *  控制器内部imageView的frame
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 30;
    CGFloat imageX = contentRect.size.width - imageW;
    CGFloat imageY = 0;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
}
- (CGRect)backgroundRectForBounds:(CGRect)bounds {
    return CGRectMake(0, 0, 300, 30);
}
@end
