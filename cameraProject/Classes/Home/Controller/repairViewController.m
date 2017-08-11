//
//  repairViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/7/12.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "repairViewController.h"
#import "YTBarButtonItemSelecteView.h"
@interface repairViewController ()

@end

@implementation repairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selectBtnClick:(id)sender {
    YTBarButtonItemSelecteView *selecteView = [[YTBarButtonItemSelecteView alloc] initWithView:self.navigationController.view];
    
    [selecteView addActionWithTitle:@"故障1"
                              image:[UIImage imageNamed:@"history"]
                            handler:^(UIButton *action) {
                                
                            }];
    
    [selecteView addActionWithTitle:@"故障2"
                              image:[UIImage imageNamed:@"edit"]
                            handler:^(UIButton *action) {
                                
                                
                            }];
    [selecteView addActionWithTitle:@"故障3"
                              image:[UIImage imageNamed:@"more"]
                            handler:^(UIButton *action) {
                                
                            }];
    [selecteView showBelowBarButtonItem:sender];

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
