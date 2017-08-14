//
//  LiveViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/8/14.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "LiveViewController.h"
#import "GLCore.h"
#import "GLRoomPublisher.h"
#import "UseIdLoginController.h"
@interface LiveViewController ()<GLRoomPublisherDelegate>
@property (nonatomic,strong)GLRoomPublisher *publisher;
@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UseIdLoginController *viewController = [[UseIdLoginController alloc] init];
    //    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
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
