//
//  BaojingqiViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/5/11.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "BaojingqiViewController.h"

@interface BaojingqiViewController ()

@end

@implementation BaojingqiViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
    self.tabBarController.tabBar.hidden = YES;
    NSString*string =self.model.position;
    NSArray *array = [string componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
    NSLog(@"%@",array);
    NSString *string1 = [array[0] substringToIndex:9];//截取掉下标7之后的字符串
    NSString *string2 = [array[1] substringToIndex:9];//截取掉下标7之后的字符串
    NSString *string3 = [NSString stringWithFormat:@"%@,%@", string1, string2 ];
    NSLog(@"%@",string3);
    self.bidLabel.text = self.model.bid;
    self.zuobiaoLabel.text = string3;
    self.xinghaoLabel.text = self.model.product_model;
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
