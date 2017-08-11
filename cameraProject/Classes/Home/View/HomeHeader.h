//
//  HomeHeader.h
//  cameraProject
//
//  Created by Zhouhoo on 16/12/20.
//  Copyright © 2016年 ziHou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverAction.h"
#import "SDCycleScrollView.h"
@protocol HomeHeaderDelegate <NSObject>
- (void)pushToSao;
- (void)pushToMessage;
@end



@interface HomeHeader : UIView<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (nonatomic, assign) id<HomeHeaderDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (nonatomic,assign) BOOL isNewMessage;
@property (nonatomic,strong) PopoverAction *multichatAction;
@end
