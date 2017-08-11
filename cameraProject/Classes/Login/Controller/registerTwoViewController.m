//
//  registerTwoViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/1/3.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "registerTwoViewController.h"
#import "MBProgressHUD.h"
#import "registerThreeViewController.h"
@interface registerTwoViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *codeNumLabel;

@property (weak, nonatomic) IBOutlet UIButton *requestCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *passLabel;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation registerTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.codeNumLabel.keyboardType = UIKeyboardTypeNumberPad;
}
- (IBAction)requestBtnClick:(id)sender {
    if(_codeNumLabel.text.length==6){
        MyLog(@"跳转");
        [self yanzheng];
        
    }else{
        [MBProgressHUD showText:@"验证码错误"];
    }
}
- (IBAction)getCodeBtnClick:(id)sender {
    [self requestData];
    self.passLabel.text = [NSString stringWithFormat:@"验证码短信已发送至手机: %@",_telNum];
}

///定时器方法的实现, 倒计时开始
static NSInteger count = 0;
- (void)countdownTime:(NSTimer *)timer {
    count--;
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"(%ld)重新获取", (long)count] forState:UIControlStateNormal];
    //    _getCode.backgroundColor = [UIColor lightGrayColor];
    if (count == 0) {
        [self.timer invalidate];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getCodeBtn.enabled = YES;
    }
}

#pragma textField delegate
//限制输入字数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.codeNumLabel) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
}

#pragma mark - 请求数据
//请求数据,获取验证码
- (void)requestData {
    NSString *URLstring = [NSString stringWithFormat:@"%@/xapi/get-code",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/html",  @"text/json",@"text/JavaScript", nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.telNum forKey:@"phone"];
    
    //post请求
    [manager POST:URLstring parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //数据请求成功后，返回 responseObject 结果集
        MyLog(@"%@",responseObject);
        [self.timer invalidate];//在创建新的定时器之前,需要将之前的定时器置为无效
        count = 60;
        self.getCodeBtn.enabled = NO;
        //创建定时器对象
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownTime:) userInfo:nil repeats:YES];
        [self.codeNumLabel becomeFirstResponder];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"%@",error);
        [MBProgressHUD showText:@"请求失败"];
    }];
    

    
}
//验证验证码
- (void)yanzheng {
    NSString *URLstring = [NSString stringWithFormat:@"%@/xapi/check-code",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.telNum forKey:@"phone"];
    [parameters setValue:self.codeNumLabel.text forKey:@"code"];
    //post请求
    [manager POST:URLstring parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //数据请求成功后，返回 responseObject 结果集
        MyLog(@"%@",responseObject);
        if ([responseObject[@"result"][@"success"] intValue] ==1) {
            registerThreeViewController *VC = [[registerThreeViewController alloc] init];
            VC.telNum = self.telNum;
            VC.code = self.codeNumLabel.text;
            VC.isForget = self.isForget;
            [self.navigationController pushViewController:VC animated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"%@",error);
        [MBProgressHUD showText:@"请求失败"];
    }];
    
    
    
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
