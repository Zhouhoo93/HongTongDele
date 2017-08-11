//
//  DetailsViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/3/13.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *YesButton;
@property (weak, nonatomic) IBOutlet UIButton *NoButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"报警详情";
    if (self.text.length>0) {
        [self.textView setText:self.text];
    }
}
- (IBAction)YesBtnClick:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        _NoButton.selected = YES;
    }else{
        sender.selected = YES;
        _NoButton.selected = NO;
    }
}
- (IBAction)NoBtnClick:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        _YesButton.selected = YES;
    }else{
        sender.selected = YES;
        _YesButton.selected = NO;
    }
}
- (IBAction)SaveBtnClick:(id)sender {
    if (self.YesButton.selected || self.NoButton.selected) {
        NSString *URL = [NSString stringWithFormat:@"%@/app/expens/expen/%@/alert/%@/up-result",kUrl,self.pid,self.ID];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.requestSerializer = requestSerializer;
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefaults valueForKey:@"token"];
        [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:self.textView.text forKey:@"reason"];
        if (_YesButton.selected) {
            [parameters setValue:@"0" forKey:@"result"];
        }else{
            [parameters setValue:@"1" forKey:@"result"];
        }
        
        
        [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"报警详情保存%@",responseObject);
            
            if (responseObject[@"result"][@"success"]==0) {
                NSString *errMsg = responseObject[@"result"][@"errorMsg"];
                [MBProgressHUD showText:errMsg];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
                  NSLog(@"%@",error);  //这里打印错误信息
              }];

    }else{
        [MBProgressHUD showText:@"请选择选项"];
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
