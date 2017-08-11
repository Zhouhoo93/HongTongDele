//
//  EditUserViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/5/28.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "EditUserViewController.h"

@interface EditUserViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberText;

@end

@implementation EditUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑用户";
    self.nameTextField.text = [HSingleGlobalData sharedInstance].editName;
    self.phoneNumberText.text = [HSingleGlobalData sharedInstance].editPhone;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SureBtnClick:(id)sender {
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
