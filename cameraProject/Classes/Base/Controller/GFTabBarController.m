//
//  GFTabBarController.m
//  HelloBoxVersionTwo
//
//  Created by guofu on 15/12/17.
//  Copyright © 2015年 guofu. All rights reserved.
//

#import "GFTabBarController.h"

#import "GFBarButton.h"
#import "GFTabBarView.h"    //自定义的TabBarView, 可更改图片
@interface GFTabBarController ()<GFTabBarViewDelegate>
@property (strong, nonatomic) GFTabBarView *GFTabBar;

@end

@implementation GFTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.tabBar removeFromSuperview];
    // 1.添加自己的tabbar
    self.GFTabBar = [[GFTabBarView alloc] init];
    self.GFTabBar.delegate = self;
    self.GFTabBar.frame = self.tabBar.bounds;
    self.GFTabBar.backgroundColor = [UIColor whiteColor];
    [self.tabBar addSubview:self.GFTabBar];
    for (int i = 0; i < 3; i++) {
        NSString *name = [NSString stringWithFormat:@"TabBar%d", i];
        NSString *selName = [NSString stringWithFormat:@"TabBar%dSel", i];
        [self.GFTabBar addBarButtonWithNormalName:name selectedName:selName];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToHome) name:@"backToHome" object:nil];
}

-(void)backToHome{
    self.selectedViewController = [self.viewControllers objectAtIndex:0];
}
#pragma mark - MJTabBar的代理方法
- (void)tabBar:(GFTabBarView *)tabBar didSelectButtonFrom:(NSInteger)from to:(NSInteger)to
{
    // 选中最新的控制器
    self.selectedIndex = to;
}
- (void)changeSeclect {
    [self.GFTabBar change:0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
