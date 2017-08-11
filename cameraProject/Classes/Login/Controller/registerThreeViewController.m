//
//  registerThreeViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/1/3.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "registerThreeViewController.h"
#import "HomeViewController.h"
#import "ZHTabBarController.h"
#import "HSingleGlobalData.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
@interface registerThreeViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic,strong)UIButton *finishBtn;
@end

@implementation registerThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.passWordTextField.delegate = self;
    _oneBtn.enabled = NO;
    _twoBtn.enabled = NO;
    _threeBtn.enabled = NO;
    [self setGaryView];
    [self setFinishButton];
}

-(void)setGaryView{
    UIView *gary = [[UIView alloc] initWithFrame:CGRectMake(0, 230, KWidth, KHeight-210)];
    gary.backgroundColor = RGBColor(235, 235, 235);
    [self.view addSubview:gary];
}

- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(21, 113, KWidth-42, 38)];
        if (self.isForget) {
            [_finishBtn setTitle:@"完成设置" forState:UIControlStateNormal];
        }else{
        [_finishBtn setTitle:@"完成注册" forState:UIControlStateNormal];
        }
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_finishBtn setBackgroundImage:[UIImage imageNamed:@"图层-34"] forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(requestRegister) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_finishBtn];
        
    }
    return  _finishBtn;
}

- (void)setFinishButton{
    [self.bgView addSubview:_finishBtn];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(170);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(KWidth-40, 38));
    }];
}
- (IBAction)canWatchBtnClick:(id)sender {
    [self showAndHidePassword:sender];
}
- (void)finishBtnClick{
    
    // 如果完成验证, 则存储此号码.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:self.telNum forKey:@"phone"];
    [userDefaults setValue:self.passWordTextField.text forKey:@"passWord"];
    [userDefaults synchronize];
    [HSingleGlobalData sharedInstance].passName =self.telNum;
    [HSingleGlobalData sharedInstance].passWord =self.passWordTextField.text;
    MyLog(@"跳转");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZHTabBarController *baseNaviVC = [storyboard instantiateViewControllerWithIdentifier:@"Main"];
    [self.navigationController pushViewController:baseNaviVC animated:YES];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)requestRegister{
    if(self.isForget){
        [self ForgetrequestRegister];
    }else{
        
        NSString *URLstring = [NSString stringWithFormat:@"%@/auth/register",kUrl];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:self.telNum forKey:@"phone"];
        [parameters setValue:self.passWordTextField.text forKey:@"password"];
        [parameters setValue:[HSingleGlobalData sharedInstance].registerid forKey:@"registration_id"];
        [parameters setValue:self.code forKey:@"code"];
        //post请求
        [manager POST:URLstring parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //数据请求成功后，返回 responseObject 结果集
            MyLog(@"%@",responseObject);
            if([responseObject[@"result"][@"success"] intValue] ==1){
                [MBProgressHUD showText:@"注册成功"];
                NSString *token = [NSString stringWithFormat:@"%@",responseObject[@"content"]];
                [HSingleGlobalData sharedInstance].token = token;
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setValue:token forKey:@"token"];
                [userDefaults synchronize];
                
                [self finishBtnClick];
            }else{
                [MBProgressHUD showText:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"errorMsg"]]];
                NSLog(@"%@",responseObject[@"reslut"][@"errorMsg"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            MyLog(@"%@",error);
            [MBProgressHUD showText:@"注册失败"];
        }];
    }
    
}

- (void)ForgetrequestRegister{
    NSString *URLstring = [NSString stringWithFormat:@"%@/auth/reset",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.telNum forKey:@"phone"];
    [parameters setValue:self.passWordTextField.text forKey:@"password"];
    //    [parameters setValue:[HSingleGlobalData sharedInstance].registerid forKey:@"registration_id"];
    [parameters setValue:self.code forKey:@"code"];
    //post请求
    [manager POST:URLstring parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //数据请求成功后，返回 responseObject 结果集
        MyLog(@"%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            [MBProgressHUD showText:@"忘记密码设置成功"];
            NSString *token = [NSString stringWithFormat:@"%@",responseObject[@"content"]];
            [HSingleGlobalData sharedInstance].token = token;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:token forKey:@"token"];
            [userDefaults synchronize];
            
            [self finishBtnClick];
        }else{
            [MBProgressHUD showText:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"errorMsg"]]];
            NSLog(@"%@",responseObject[@"reslut"][@"errorMsg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"%@",error);
        [MBProgressHUD showText:@"注册失败"];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//显示和隐藏登录视图的密码。
-(void)showAndHidePassword:(UIButton *)sender
{
    //避免明文/密文切换后光标位置偏移
    self.passWordTextField.enabled = NO;    // the first one;
    self.passWordTextField.secureTextEntry = sender.selected;
    sender.selected = !sender.selected;
    self.passWordTextField.enabled = YES;  // the second one;
    [self.passWordTextField becomeFirstResponder]; // the third one
}

#pragma mark - 判断密码强度函数
/*
 声明：包含大写/小写/数字/特殊字符
 两种以下密码强度低
 两种密码强度中
 大于两种密码强度高
 密码强度标准根据需要随时调整
 */
//判断是否包含
-(BOOL) judgeRange:(NSArray*) _termArray Password:(NSString*) _password
{
    NSRange range;
    BOOL result =NO;
    for(int i=0; i<[_termArray count]; i++)
    {
        range = [_password rangeOfString:[_termArray objectAtIndex:i]];
        if(range.location != NSNotFound)
        {
            result =YES;
        }
    }
    return result;
}

//条件
- (NSString*)judgePasswordStrength:(NSString*) _password
{
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    
    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
    NSArray* termArray3 = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    NSArray* termArray4 = [[NSArray alloc] initWithObjects:@"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、", nil];
    NSString* result1 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray1 Password:_password]];
    NSString* result2 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray2 Password:_password]];
    NSString* result3 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray3 Password:_password]];
    NSString* result4 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray4 Password:_password]];
    
    [resultArray addObject:[NSString stringWithFormat:@"%@",result1]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result2]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result3]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result4]];
    int intResult=0;
    for (int j=0; j<[resultArray count]; j++)
    {
        if ([[resultArray objectAtIndex:j] isEqualToString:@"1"])
        {
            intResult++;
        }
    }
    NSString* resultString = [[NSString alloc] init];
    if (intResult < 2)
    {
        resultString = @"0";
    }
    else if (intResult == 2&&[_password length]>=6)
    {
        resultString = @"1";
    }
    if (intResult > 2&&[_password length]>=6)
    {
        resultString = @"2";
    }
    return resultString;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length>5&&textField.text.length<17) {
        _finishBtn.enabled = YES;
    }else{
        _finishBtn.enabled = NO;
    }
    
    NSString *resultString = [[NSString alloc]init];
    if ([string isEqualToString:@""]) { //按了删除键
        resultString = [textField.text substringToIndex:textField.text.length - 1];
    } else {
        resultString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }
    NSInteger result = [[self judgePasswordStrength:resultString] integerValue];
    switch (result) {
        case 0:
            [_oneBtn setBackgroundColor:[UIColor redColor]];
            [_twoBtn setBackgroundColor:[UIColor whiteColor]];
            [_threeBtn setBackgroundColor:[UIColor whiteColor]];
            break;
        case 1:
            [_twoBtn setBackgroundColor:[UIColor redColor]];
            [_oneBtn setBackgroundColor:[UIColor redColor]];
            [_threeBtn setBackgroundColor:[UIColor whiteColor]];
            
            break;
        case 2:
            [_oneBtn setBackgroundColor:[UIColor redColor]];
            [_twoBtn setBackgroundColor:[UIColor redColor]];
            [_threeBtn setBackgroundColor:[UIColor redColor]];
            
            break;
        default:
            break;
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
