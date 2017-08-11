//
//  LeadViewController.m
//  HelloBox
//
//  Created by qjkj on 16/1/28.
//  Copyright © 2016年 guofu. All rights reserved.
//

#import "LeadViewController.h"
#import "GFTabBarController.h"
#define KWIDTH [UIScreen mainScreen].bounds.size.width
#define KHDIGHT [UIScreen mainScreen].bounds.size.height

@interface LeadViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation LeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initGuid];
}
- (void)initGuid {
    NSArray *names = @[@"leadImage01", @"leadImage02", @"leadImage03"];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, KHDIGHT)];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView setContentSize:CGSizeMake(KWIDTH * 3, KHDIGHT)];
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.bounces = NO;
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * KWIDTH, 0, KWIDTH, KHDIGHT)];
        imageView.userInteractionEnabled = YES;
        [imageView setImage:[UIImage imageNamed:names[i]]];
        [self.scrollView addSubview:imageView];
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(KWIDTH * 2, 0, KWIDTH, KHDIGHT);
    //btn.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:btn];
    [btn addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)handleAction:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GFTabBarController *baseTabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"Main"];
    self.view.window.rootViewController = baseTabBarVC;
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
