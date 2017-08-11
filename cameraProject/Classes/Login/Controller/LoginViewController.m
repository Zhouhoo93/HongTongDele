//
//  LoginViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 16/12/19.
//  Copyright © 2016年 ziHou. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "registerViewController.h"
#import "MBProgressHUD.h"
#import "ZHTabBarController.h"
#import "HSingleGlobalData.h"
//#import "HYBNetworking.h"
#import "AFNetworking.h"
#import "HSingleGlobalData.h"
#import "ElectricityViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *NameTextField;
@property (weak, nonatomic) IBOutlet UITextField *PassWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
     [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([HSingleGlobalData sharedInstance].passName.length>0) {
        _NameTextField.text = [HSingleGlobalData sharedInstance].passName;
    }
    if ([HSingleGlobalData sharedInstance].passWord.length>0) {
        _PassWordTextField.text = [HSingleGlobalData sharedInstance].passWord;
    }
    [_NameTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _NameTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_PassWordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    //监听输入框内容改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(infoAction) name:UITextFieldTextDidChangeNotification object:nil];
    
}

//登录按钮状态改变
- (void)infoAction{
    if(_NameTextField.text.length == 11&&_PassWordTextField.text.length>0){
           _loginBtn.enabled = YES;
        _loginBtn.selected = YES;
    }else{
        _loginBtn.enabled = NO;
        _loginBtn.selected = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginBtnClick:(id)sender {

    [self requestPassWord];
    
}
- (IBAction)forgetPassWordBtnClick:(id)sender {
    registerViewController *VC =[[registerViewController alloc] init];
    //    [self presentViewController:VC animated:YES completion:nil];
    VC.isForget = YES;
    [self.navigationController pushViewController:VC animated:YES];
    MyLog(@"忘记密码");
}
- (IBAction)registerBtnClick:(id)sender {

    registerViewController *VC =[[registerViewController alloc] init];
    VC.isForget = NO;
//    [self presentViewController:VC animated:YES completion:nil];
    [self.navigationController pushViewController:VC animated:YES];
    MyLog(@"立即注册");
}

//跳转首页界面
- (void)goHomeController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZHTabBarController *baseNaviVC = [storyboard instantiateViewControllerWithIdentifier:@"Main"];
    
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController =baseNaviVC;
    
    [HSingleGlobalData sharedInstance].passName = _NameTextField.text;
    [HSingleGlobalData sharedInstance].passWord = _PassWordTextField.text;
    // 如果完成验证, 则存储此号码.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:_NameTextField.text forKey:@"passName"];
    [userDefaults setValue:_PassWordTextField.text forKey:@"passWord"];
    [userDefaults synchronize];
}

#pragma mark - 验证账号密码
//验证账号密码
- (void)requestPassWord {
    NSString *URL = [NSString stringWithFormat:@"%@/auth/login",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.NameTextField.text forKey:@"phone"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *regis = [userDefaults valueForKey:@"registerid"];
    [parameters setValue:regis forKey:@"registration_id"];
    NSLog(@"regisID%@",[HSingleGlobalData sharedInstance].registerid);
    [parameters setValue:self.PassWordTextField.text forKey:@"password"];

    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"正确%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
             [self goHomeController];
            NSString *token = [NSString stringWithFormat:@"%@",responseObject[@"content"]];
            [HSingleGlobalData sharedInstance].token = token;
            [HSingleGlobalData sharedInstance].passName = self.NameTextField.text;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:token forKey:@"token"];
            [userDefaults setValue:self.NameTextField.text forKey:@"phone"];
            [userDefaults synchronize];

        }else{
            [MBProgressHUD showText:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"errorMsg"]]];
            NSLog(@"%@",responseObject[@"result"][@"errorMsg"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
//        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
}




#pragma textField delegate
//限制输入字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.NameTextField) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    } else if (textField == self.PassWordTextField){
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 15) {
            return NO;
        }
    }
    return YES;
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
