//
//  registerViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 16/12/19.
//  Copyright © 2016年 ziHou. All rights reserved.
//

#import "registerViewController.h"
#import "HomeViewController.h"
#import "ZHTabBarController.h"
#import "AppDelegate.h"
#import "HSingleGlobalData.h"
#import "MBProgressHUD.h"
#import "registerTwoViewController.h"
//#import "HYBNetworking.h"
@interface registerViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *procotolBtn;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *smallBtn;
@property (weak, nonatomic) IBOutlet UIButton *tekeCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *telTextField;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic,assign) BOOL isGo;
@end

@implementation registerViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (IBAction)smallBtnClick:(id)sender {
    if (_smallBtn.selected) {
        _smallBtn.selected = NO;
        _isGo = NO;
        _tekeCodeBtn.enabled = NO;
    }else{
        _smallBtn.selected = YES;
        _isGo = YES;
        _tekeCodeBtn.enabled = YES;
    }
}
- (IBAction)rightBtnClick:(id)sender {
    MyLog(@"协议");
}
- (IBAction)takeCodeBtnClick:(id)sender {
    MyLog(@"跳转");
    BOOL isTrue = [registerViewController isValidateMobile:self.telTextField.text];
    if (isTrue&&_telTextField.text.length==11) {
   
            [self requestData];  //请求验证码
        
    } else {
        [MBProgressHUD showText:@"请输入正确的手机号码"];
    }

}

-(void)requestData{
    
    NSString *URLstring = [NSString stringWithFormat:@"%@/auth/check-tel",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.telTextField.text forKey:@"phone"];

    //post请求
    [manager POST:URLstring parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //数据请求成功后，返回 responseObject 结果集
        MyLog(@"%@",responseObject);
        NSLog(@"%@",responseObject[@"result"][@"errorMsg"]);
        if ([responseObject[@"result"][@"success"] intValue] ==1) {
            registerTwoViewController *two = [[registerTwoViewController alloc] init];
            two.telNum = _telTextField.text;
            two.isForget = self.isForget;
            [self.navigationController pushViewController:two animated:YES];
        }else{
            if (responseObject[@"result"][@"errorCode"]) {
                registerTwoViewController *two = [[registerTwoViewController alloc] init];
                two.telNum = _telTextField.text;
                two.isForget = YES;
                [self.navigationController pushViewController:two animated:YES];
            }else{
                [MBProgressHUD showText:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"errorMsg"]]];
                NSLog(@"%@",responseObject[@"result"][@"errorMsg"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"%@",error);
        [MBProgressHUD showText:@"请求出错"];
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //监听输入框内容改变
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(infoAction) name:UITextFieldTextDidChangeNotification object:nil];
    self.isGo = NO;
    self.tekeCodeBtn.enabled = NO;
    _telTextField.keyboardType = UIKeyboardTypeNumberPad;
    if (self.isForget) {
        _smallBtn.selected = YES;
        _isGo = YES;
        _tekeCodeBtn.enabled = YES;
        self.smallBtn.hidden = YES;
        self.textLabel.hidden = YES;
        self.procotolBtn.hidden = YES;
        self.lineView.hidden = YES;
    }
}

////登录按钮状态改变
//- (void)infoAction{
//    if(_telTextField.text.length == 11 &&_isGo==YES){
//        _tekeCodeBtn.enabled = YES;
//    }else{
//        _tekeCodeBtn.enabled = NO;
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//判断号码是否符合规则
+ (BOOL)isValidateMobile:(NSString *)mobile {
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(17[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


#pragma textField delegate
//限制输入字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.telTextField) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
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
