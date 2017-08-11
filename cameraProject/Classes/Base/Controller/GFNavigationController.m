//
//  GFNavigationController.m
//  HelloBoxVersionTwo
//
//  Created by guofu on 15/12/17.
//  Copyright © 2015年 guofu. All rights reserved.
//

#import "GFNavigationController.h"
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@interface GFNavigationController ()

@end

@implementation GFNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
//系统第一次使用这个类的时候调用
+ (void)initialize {
    
    // 1.设置导航栏主题
    UINavigationBar *naviBar = [UINavigationBar appearance];
    [naviBar setBarTintColor:RGBColor(60, 149, 245)];
    // 设置标题文字颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [naviBar setTitleTextAttributes:attrs];
    //去掉导航栏下边的线
    naviBar.shadowImage=[[UIImage alloc]init];
    
}


/**
 *  重写这个方法,能拦截所有的pop操作
 */
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    return [super popViewControllerAnimated:YES];
}
/**
 *  重写这个方法,能拦截所有的push操作
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 0){
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 22, 22);
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        [leftView addSubview:backBtn];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewControllerAnimated:)];
        viewController.navigationItem.leftBarButtonItem = backItem;
        backItem.tintColor = [UIColor whiteColor];
    }
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
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
