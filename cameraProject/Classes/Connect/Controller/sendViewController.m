//
//  sendViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/5/21.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "sendViewController.h"
#import "HomeViewController.h"
#import "OneLoginViewController.h"
#import "AddressPickerView.h"
#import "BurglarViewController.h"
#import "BurglarViewController.h"
@interface sendViewController ()<AddressPickerViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *dianliuText;
@property (weak, nonatomic) IBOutlet UITextField *addressText;
@property (weak, nonatomic) IBOutlet UIImageView *quane;
@property (weak, nonatomic) IBOutlet UIImageView *guding;
@property (weak, nonatomic) IBOutlet UIImageView *fenggu;
@property (weak, nonatomic) IBOutlet UIImageView *yue;
@property (nonatomic,copy) NSString *access_way;
@property (nonatomic,copy) NSString *use_ele_way;
@property (nonatomic ,strong) AddressPickerView * pickerView;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (nonatomic,copy)NSString *province;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *town;
@property (nonatomic,copy)NSString *addressID;
@end

@implementation sendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.pickerView];
}
- (IBAction)selectDingwei:(id)sender {
    BurglarViewController *vc = [[BurglarViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)selectAddress:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.pickerView show];
    }else{
        [self.pickerView hide];
    }
    
}
- (IBAction)sendBtnClick:(id)sender {
    NSString  *num = [NSString stringWithFormat:@"%@",self.dianliuText.text];
    int num1 = [num intValue];
    if (num1>19&&num1<61) {
        NSString *URL = [NSString stringWithFormat:@"%@/app/roofs/roof/up-bid-scan",kUrl];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefaults valueForKey:@"token"];
        [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:[HSingleGlobalData sharedInstance].BID forKey:@"bid"];
        [parameters setValue:self.access_way forKey:@"access_way"];
        [parameters setValue:self.use_ele_way forKey:@"use_ele_way"];
        [parameters setValue:self.addressID forKey:@"area_id"];
        [parameters setValue:self.addressText.text forKey:@"address"];
        [parameters setValue:[HSingleGlobalData sharedInstance].BID forKey:@"bid"];
//        [parameters setValue:@"012017042311480007" forKey:@"bid"];
//        [parameters setValue:[HSingleGlobalData sharedInstance].province forKey:@"province"];
//        [parameters setValue:[HSingleGlobalData sharedInstance].city forKey:@"city"];
//        [parameters setValue:[HSingleGlobalData sharedInstance].district forKey:@"district"];
        [parameters setValue:[HSingleGlobalData sharedInstance].position forKey:@"position"];
        NSString  *num = [NSString stringWithFormat:@"%@",self.dianliuText.text];
        int num1 = [num intValue];
        NSNumber * Membership_Id =  [NSNumber numberWithInt:num1];
        [parameters setValue:Membership_Id forKey:@"rated_current"];
        NSLog(@"%@",parameters);
        [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            MyLog(@"正确%@",responseObject);
            if ([responseObject[@"result"][@"success"] intValue] ==0) {
                NSString *str = responseObject[@"result"][@"errorMsg"];
                [MBProgressHUD showText:str];
            }else{
            NSNumber *code = responseObject[@"result"][@"errorCode"];
            NSString *errorcode = [NSString stringWithFormat:@"%@",code];
            if ([errorcode isEqualToString:@"41111"])  {
                [self newLogin];
            }else if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
                [self newLoginTwo];
                
            }else{
                HomeViewController *vc = [[HomeViewController alloc] init];
                vc.hidesBottomBarWhenPushed = NO;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            MyLog(@"失败%@",error);
            //        [MBProgressHUD showText:@"%@",error[@"error"]];
        }];

    }else{
        [MBProgressHUD showText:@"额定电流输入有误,请重新输入"];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)quaneshangwang:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        _quane.image = [UIImage imageNamed:@"s1"];
         self.access_way = @"1";
    }else{
        sender.selected = YES;
        _quane.image = [UIImage imageNamed:@"s2"];
         self.access_way = @"0";
    }
}
- (IBAction)yueshangwang:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        _yue.image = [UIImage imageNamed:@"s1"];
        self.access_way = @"0";
    }else{
        sender.selected = YES;
        _yue.image = [UIImage imageNamed:@"s2"];
         self.access_way = @"1";
    }
}
- (IBAction)guding:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        _guding.image = [UIImage imageNamed:@"s1"];
        self.use_ele_way = @"1";
    }else{
        sender.selected = YES;
        _guding.image = [UIImage imageNamed:@"s2"];
        self.use_ele_way = @"0";
    }
}
- (IBAction)fenggu:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        _fenggu.image = [UIImage imageNamed:@"s1"];
        self.use_ele_way = @"0";
    }else{
        sender.selected = YES;
        _fenggu.image = [UIImage imageNamed:@"s2"];
        self.use_ele_way = @"1";
    }
}
     - (void)newLogin{
         [MBProgressHUD showText:@"请重新登录"];
         [self performSelector:@selector(backTo) withObject: nil afterDelay:2.0f];
     }
     
     - (void)newLoginTwo{
         [MBProgressHUD showText:@"您的账号已过期,请重新登录"];
         [self performSelector:@selector(backTo) withObject: nil afterDelay:2.0f];
     }
     
     -(void)backTo{
         [self clearLocalData];
         OneLoginViewController *VC =[[OneLoginViewController alloc] init];
         VC.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:VC animated:YES];
     }
     - (void)clearLocalData{
         //极光推送取消设置标签和别名
         //    [JPUSHService setTags:nil alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
         //    }];
         //
         NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
         //    [userDefaults setValue:nil forKey:@"passName"];
         //    [userDefaults setValue:nil forKey:@"passWord"];
         [userDefaults setValue:nil forKey:@"token"];
         //    [userDefaults setValue:nil forKey:@"registerid"];
         [userDefaults synchronize];
         //    [HSingleGlobalData sharedInstance].passName = nil;
         //    [HSingleGlobalData sharedInstance].passWord  =nil;
         [HSingleGlobalData sharedInstance].token =nil;
         [HSingleGlobalData sharedInstance].BID =nil;
         [HSingleGlobalData sharedInstance].address =nil;
         [HSingleGlobalData sharedInstance].position =nil;
         [HSingleGlobalData sharedInstance].city =nil;
     }

#pragma mark - AddressPickerViewDelegate
- (void)cancelBtnClick{
    NSLog(@"点击了取消按钮");
//    [self btnClick:_addressBtn];
    [self selectAddress:_addressBtn];
}
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area{

    self.province = [province stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.city = [city stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.town = [area stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *strarray = [self.town componentsSeparatedByString:@"-"];
    self.addressID = strarray[1];
    [self.addressBtn setTitle:self.town forState:UIControlStateNormal];
    [self selectAddress:_addressBtn];
}

- (AddressPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc]initWithFrame:CGRectMake(0, KHeight , KWidth, 215)];
        _pickerView.delegate = self;
    }
    return _pickerView;
}
- (IBAction)go:(id)sender {
    BurglarViewController *vc = [[BurglarViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
