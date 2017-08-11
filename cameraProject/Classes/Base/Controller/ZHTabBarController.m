//
//  ZHTabBarController.m
//  cameraProject
//
//  Created by Zhouhoo on 16/12/20.
//  Copyright © 2016年 ziHou. All rights reserved.
//

#import "ZHTabBarController.h"
#import "HomeViewController.h"
@interface ZHTabBarController ()

@end

@implementation ZHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tabBar.backgroundColor = RGBColor(59, 72, 102);
    // 设置一个自定义 View,大小等于 tabBar 的大小
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    // 给自定义 View 设置颜色
    bgView.backgroundColor = RGBColor(59, 72, 102);
    // 将自定义 View 添加到 tabBar 上
    [self.tabBar insertSubview:bgView atIndex:0];
    // Do any additional setup after loading the view.
    // 1.添加第一个控制器
    // 1.1 初始化
//    HomeViewController *oneVC = [[HomeViewController alloc]init];
    
    // 1.2 把oneVC添加为UINavigationController的根控制器
//    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:oneVC];
    
    // 设置tabBar的标题
//    nav1.title = @"首页";
//    [nav1.navigationBar setBackgroundImage:[UIImage imageNamed:@"commentary_num_bg"] forBarMetrics:UIBarMetricsDefault];
    
    // 设置tabBar的图标
//    nav1.tabBarItem.image = [UIImage imageNamed:@"tab_home_icon"];
    
    // 设置navigationBar的标题
//    oneVC.navigationItem.title = @"首页";
    
    // 1.3 把UINavigationController交给UITabBarController管理
//    [self addChildViewController:nav1];
    
    // 2.添加第2个控制器
//    UIViewController *twoVC = [[UIViewController alloc]init];
//    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:twoVC];
//    nav2.title = @"个人中心";
//    twoVC.navigationItem.title = @"个人中心";
//    [self addChildViewController:nav2];

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
