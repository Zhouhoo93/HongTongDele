//
//  HMTextView.h
//  黑马微博
//
//  Created by apple on 14-7-10.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMTextView : UITextView
@property (nonatomic, copy) NSString *placehoder;
@property (nonatomic, strong) UIColor *placehoderColor;
@property (nonatomic, assign) NSInteger wordCount;
@property (nonatomic, weak) UILabel *placehoderLabel;
@property (nonatomic, strong) UILabel * limitLabel;
@end
