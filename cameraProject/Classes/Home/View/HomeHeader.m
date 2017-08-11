//
//  HomeHeader.m
//  cameraProject
//
//  Created by Zhouhoo on 16/12/20.
//  Copyright © 2016年 ziHou. All rights reserved.
//

#import "HomeHeader.h"
#import "PopoverView.h"
#import "ScanViewController.h"
#import "SDCycleScrollView.h"

@implementation HomeHeader
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setImageLunBo];
    self.ImageView.userInteractionEnabled = YES;

}

- (void)setImageLunBo{
    // 情景一：采用本地图片实现
    NSArray *images = @[[UIImage imageNamed:@"轮播1"],
                        [UIImage imageNamed:@"轮播2"],
                        [UIImage imageNamed:@"轮播3"],
                        [UIImage imageNamed:@"轮播4"]
                        ];
    
    // 情景二：采用网络图片实现
    //    NSArray *imagesURL = @[
    //                           [NSURL URLWithString:@"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg"],
    //                           [NSURL URLWithString:@"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg"],
    //                           [NSURL URLWithString:@"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"],
    //                           [NSURL URLWithString:@"https://ss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=0c231a5bb34543a9f54ea98c782abeb0/a71ea8d3fd1f41342830c1d1211f95cad1c85e1e.jpg"]
    //                           ];
    CGFloat w = KWidth;
    // 创建不带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, w, 226) imagesGroup:images];
    cycleScrollView.delegate = self;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    [self.ImageView addSubview:cycleScrollView];
    // 轮播时间间隔，默认1.0秒，可自定义
    cycleScrollView.autoScrollTimeInterval = 3.0;
}

//
//
//- (NSArray<PopoverAction *> *)QQActions {
//    // 发起多人聊天 action
//    self.multichatAction = [[PopoverAction alloc] init];
//    if (self.isNewMessage) {
//        self.multichatAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"mm_title_btn_compose_normaled"] title:@"消息中心" handler:^(PopoverAction *action) {
//#pragma mark - 该Block不会导致内存泄露, Block内代码无需刻意去设置弱引用.
//            [self.delegate pushToMessage];
//            self.isNewMessage = NO;
//            NSNotification *notice = [NSNotification notificationWithName:@"OldMessage" object:nil];
//            [[NSNotificationCenter defaultCenter] postNotification:notice];
//            //        multichatAction.image = [UIImage imageNamed:@"register_selectored"];
//        }];
//
//    }else{
//        self.multichatAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"mm_title_btn_compose_normal"] title:@"消息中心" handler:^(PopoverAction *action) {
//    #pragma mark - 该Block不会导致内存泄露, Block内代码无需刻意去设置弱引用.
//            [self.delegate pushToMessage];
//        }];
//    }
//        // 扫一扫 action
//    PopoverAction *QRAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"mm_title_btn_qrcode_normal"] title:@"扫一扫" handler:^(PopoverAction *action) {
//        _noticeLabel.text = action.title;
//        if (self.delegate && [self.delegate respondsToSelector:@selector(pushToSao)]) {
//            [self.delegate pushToSao];
//        }
//    }];
//        return @[self.multichatAction, QRAction];
//}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", index);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
