//
//  NibianqiViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/5/11.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "NibianqiViewController.h"

@interface NibianqiViewController ()

@end

@implementation NibianqiViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
    self.tabBarController.tabBar.hidden = YES;
    self.gonglvLabel.text = [NSString stringWithFormat:@"%@A",self.model.power_rating];
    self.pinpaiLabel.text = self.model.brand;
    self.xinghaolabel.text = self.model.product_model;
    NSInteger status = [self.model.status integerValue];
    if (status == 1) {
        self.StatusLabel.text = @"在线";
        self.StatusLabel.textColor = [UIColor greenColor];
    }else{
        self.StatusLabel.text = @"离线";
        self.StatusLabel.textColor = [UIColor darkGrayColor];
    }
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
