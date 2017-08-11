//
//  XYFeedCell.h
//  Demo
//
//  Created by wuw on 16/6/15.
//  Copyright © 2016年 fifyrio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYFeedModel.h"
#import "commentModel.h"
@protocol zanBtnDelegate <NSObject>

- (void)zan:(NSString *)pinglunID;
- (void)quxiaozan:(NSString *)pinglunID;
@end



@interface XYFeedCell : UICollectionViewCell
@property (nonatomic,strong) XYFeedModel *model;
@property(nonatomic, weak)id<zanBtnDelegate> delegate;
@end
