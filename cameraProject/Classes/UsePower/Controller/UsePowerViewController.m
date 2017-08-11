//
//  UsePowerViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/4/19.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "UsePowerViewController.h"
#import "LoginViewController.h"
@interface UsePowerViewController ()
@property (nonatomic,strong)UILabel *twoLabel1;
@property (nonatomic,strong)UILabel *twoLabel2;
@property (nonatomic,strong)UILabel *twoLabel3;
@property (nonatomic,strong)UILabel *threeLabel1;
@property (nonatomic,strong)UILabel *threeLabel2;
@property (nonatomic,strong)UILabel *threeLabel3;
@property (nonatomic,strong)UILabel *fourLabel1;
@property (nonatomic,strong)UILabel *fourLabel2;
@property (nonatomic,strong)UILabel *fourLabel3;
@property (nonatomic,strong)UILabel *fourLabel4;
@property (nonatomic,strong)UILabel *fourLabel5;
@property (nonatomic,strong)UILabel *fourLabel6;
@end

@implementation UsePowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"用电政策";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    [self requestData];
}

-(void)setUI{
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 74, KWidth-20, 400)];
    bgImage.image = [UIImage imageNamed:@"大bg"];
    [self.view addSubview:bgImage];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 10, 13)];
//    lineView.backgroundColor = RGBColor(57, 162, 255);
    lineView.image = [UIImage imageNamed:@"政策"];
    [bgImage addSubview:lineView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 120, 13)];
    textLabel.text = @"用电政策";
    textLabel.textColor = RGBColor(57, 162, 255);
    textLabel.font = [UIFont systemFontOfSize:13];
    [bgImage addSubview:textLabel];
    
    UIView *hengxian = [[UIView alloc] initWithFrame:CGRectMake(10, 32, KWidth-40, 2)];
    hengxian.backgroundColor = RGBColor(31, 103, 159);
    [bgImage addSubview:hengxian];
    
    UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 55, (KWidth-40)/4, 13)];
    oneLabel.text = @"用电阶梯";
    oneLabel.textColor = [UIColor blackColor];
    oneLabel.font = [UIFont systemFontOfSize:12];
    oneLabel.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:oneLabel];
    
    UILabel *oneLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 88, (KWidth-40)/4, 13)];
    oneLabel1.text = @"第一阶梯";
    oneLabel1.textColor = [UIColor blackColor];
    oneLabel1.font = [UIFont systemFontOfSize:12];
    oneLabel1.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:oneLabel1];
    
    UILabel *oneLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 121, (KWidth-40)/4, 13)];
    oneLabel2.text = @"第二阶梯";
    oneLabel2.textColor = [UIColor blackColor];
    oneLabel2.font = [UIFont systemFontOfSize:12];
    oneLabel2.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:oneLabel2];
    
    UILabel *oneLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 154, (KWidth-40)/4, 13)];
    oneLabel3.text = @"第三阶梯";
    oneLabel3.textColor = [UIColor blackColor];
    oneLabel3.font = [UIFont systemFontOfSize:12];
    oneLabel3.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:oneLabel3];
    
    UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/4, 55, (KWidth-40)/4, 13)];
    twoLabel.text = @"阶梯分级(度)";
    twoLabel.textColor = [UIColor blackColor];
    twoLabel.font = [UIFont systemFontOfSize:12];
    twoLabel.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:twoLabel];
    //第一阶梯 阶梯分级
    self.twoLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/4, 88, (KWidth-40)/4, 13)];
    self.twoLabel1.text = @"≤";
    self.twoLabel1.textColor = [UIColor blackColor];
    self.twoLabel1.font = [UIFont systemFontOfSize:12];
    self.twoLabel1.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:self.twoLabel1];
    //第二阶梯 阶梯分级
    self.twoLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/4, 121, (KWidth-40)/4, 13)];
    self.twoLabel2.text = @"";
    self.twoLabel2.textColor = [UIColor blackColor];
    self.twoLabel2.font = [UIFont systemFontOfSize:12];
    self.twoLabel2.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:self.twoLabel2];
    //第三阶梯 阶梯分级
    self.twoLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/4, 154, (KWidth-40)/4, 13)];
    self.twoLabel3.text = @"";
    self.twoLabel3.textColor = [UIColor blackColor];
    self.twoLabel3.font = [UIFont systemFontOfSize:12];
    self.twoLabel3.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:self.twoLabel3];
    
    UILabel *threeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/2, 55, (KWidth-40)/4, 13)];
    threeLabel.text = @"固定电价";
    threeLabel.textColor = [UIColor blackColor];
    threeLabel.font = [UIFont systemFontOfSize:12];
    threeLabel.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:threeLabel];
    //第一阶梯 固定电价
    self.threeLabel1= [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/2, 88, (KWidth-40)/4, 13)];
    self.threeLabel1.text = @"";
    self.threeLabel1.textColor = [UIColor blackColor];
    self.threeLabel1.font = [UIFont systemFontOfSize:12];
    self.threeLabel1.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:self.threeLabel1];
    //第二阶梯 固定电价
    self.threeLabel2= [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/2, 121, (KWidth-40)/4, 13)];
    self.threeLabel2.text = @"";
    self.threeLabel2.textColor = [UIColor blackColor];
    self.threeLabel2.font = [UIFont systemFontOfSize:12];
    self.threeLabel2.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:self.threeLabel2];
    //第三阶梯 固定电价
    self.threeLabel3= [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/2, 154, (KWidth-40)/4, 13)];
    self.threeLabel3.text = @"";
    self.threeLabel3.textColor = [UIColor blackColor];
    self.threeLabel3.font = [UIFont systemFontOfSize:12];
    self.threeLabel3.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:self.threeLabel3];
    
    
    UILabel *fourLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/4*3, 55, (KWidth-40)/4, 13)];
    fourLabel.text = @"峰谷电价";
    fourLabel.textColor = [UIColor blackColor];
    fourLabel.font = [UIFont systemFontOfSize:12];
    fourLabel.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:fourLabel];
    //第一阶梯峰谷
    self.fourLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/4*3, 78, (KWidth-40)/4, 13)];
    self.fourLabel1.text = @"峰:";
    self.fourLabel1.textColor = [UIColor blackColor];
    self.fourLabel1.font = [UIFont systemFontOfSize:11];
    self.fourLabel1.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:self.fourLabel1];
    
    self.fourLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/4*3, 93, (KWidth-40)/4, 13)];
    self.fourLabel2.text = @"谷:";
    self.fourLabel2.textColor = [UIColor blackColor];
    self.fourLabel2.font = [UIFont systemFontOfSize:11];
    self.fourLabel2.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:self.fourLabel2];
    //第二阶梯 峰谷
    self.fourLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/4*3, 111, (KWidth-40)/4, 13)];
    self.fourLabel3.text = @"峰:";
    self.fourLabel3.textColor = [UIColor blackColor];
    self.fourLabel3.font = [UIFont systemFontOfSize:11];
    self.fourLabel3.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:self.fourLabel3];
    
    self.fourLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/4*3, 126, (KWidth-40)/4, 13)];
    self.fourLabel4.text = @"谷:";
    self.fourLabel4.textColor = [UIColor blackColor];
    self.fourLabel4.font = [UIFont systemFontOfSize:11];
    self.fourLabel4.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:self.fourLabel4];
    //第三阶梯峰谷
    self.fourLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/4*3, 144, (KWidth-40)/4, 13)];
    self.fourLabel5.text = @"峰:";
    self.fourLabel5.textColor = [UIColor blackColor];
    self.fourLabel5.font = [UIFont systemFontOfSize:11];
    self.fourLabel5.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:self.fourLabel5];
    
    self.fourLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/4*3, 159, (KWidth-40)/4, 13)];
    self.fourLabel6.text = @"谷:";
    self.fourLabel6.textColor = [UIColor blackColor];
    self.fourLabel6.font = [UIFont systemFontOfSize:11];
    self.fourLabel6.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:self.fourLabel6];
    
    UIView *garyLineView = [[UIView alloc] init];
    garyLineView.frame = CGRectMake(25, 187, KWidth-50, 1);
    garyLineView.backgroundColor = [UIColor lightGrayColor];
    [bgImage addSubview:garyLineView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 192, 300, 13)];
    tipLabel.text = @"用电情况要根据用电阶梯,进行峰谷电分时用电,可以使居民用户省电";
    tipLabel.textColor = [UIColor darkGrayColor];
    tipLabel.font = [UIFont systemFontOfSize:8];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    [bgImage addSubview:tipLabel];
    
    
    UIImageView *lineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 225, 10, 13)];
    //    lineView.backgroundColor = RGBColor(57, 162, 255);
    lineView1.image = [UIImage imageNamed:@"政策"];
    [bgImage addSubview:lineView1];
    
    UILabel *textLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 225, 120, 13)];
    textLabel1.text = @"计算公式";
    textLabel1.textColor = RGBColor(57, 162, 255);
    textLabel1.font = [UIFont systemFontOfSize:13];
    [bgImage addSubview:textLabel1];
    
    UIView *hengxian1 = [[UIView alloc] initWithFrame:CGRectMake(10, 243, KWidth-40, 2)];
    hengxian1.backgroundColor = RGBColor(31, 103, 159);
    [bgImage addSubview:hengxian1];
    
    UILabel *downlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-100, 260, 200, 20)];
    downlabel1.text = @"电量的计算公式:";
    downlabel1.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:downlabel1];
    
    UILabel *downlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-75, 300, 200, 20)];
    downlabel2.text = @"Q:电量,单位库仑 (C)";
    downlabel2.font = [UIFont systemFontOfSize:14];
    downlabel2.textAlignment = NSTextAlignmentLeft;
    [bgImage addSubview:downlabel2];

    UILabel *downlabel3 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-75, 325, 200, 20)];
    downlabel3.text = @"I:电流,单位安培 (A)";
    downlabel3.font = [UIFont systemFontOfSize:14];
    downlabel3.textAlignment = NSTextAlignmentLeft;
    [bgImage addSubview:downlabel3];
    
    UILabel *downlabel4 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-75, 350, 200, 20)];
    downlabel4.text = @"t:时间,单位秒 (s)";
    downlabel4.font = [UIFont systemFontOfSize:14];
    downlabel4.textAlignment = NSTextAlignmentLeft;
    [bgImage addSubview:downlabel4];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/app/uses/use/get-use-policy",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"用电政策%@",responseObject);
        NSNumber *code = responseObject[@"result"][@"errorCode"];
        NSString *errorcode = [NSString stringWithFormat:@"%@",code];
        if ([errorcode isEqualToString:@"41111"])  {
            [self newLogin];
        }
        NSArray *Arr = responseObject[@"content"];
        NSDictionary *dic1 = Arr[0];
        NSDictionary *dic2 = Arr[1];
        NSDictionary *dic3 = Arr[2];
        self.twoLabel1.text = [NSString stringWithFormat:@"%@~%@",dic1[@"start_cap"],dic1[@"end_cap"]];
        self.twoLabel2.text = [NSString stringWithFormat:@"%@~%@",dic2[@"start_cap"],dic2[@"end_cap"]];
        self.twoLabel3.text = [NSString stringWithFormat:@">%@",dic3[@"start_cap"],dic1[@"end_cap"]];
        self.threeLabel1.text = [NSString stringWithFormat:@"%@",dic1[@"fixed_price"]];
        self.threeLabel2.text = [NSString stringWithFormat:@"%@",dic2[@"fixed_price"]];
        self.threeLabel3.text = [NSString stringWithFormat:@"%@",dic3[@"fixed_price"]];
        if (dic1[@"med_price"] ==0) {
            self.fourLabel1.text = [NSString stringWithFormat:@"峰:--"];
        }else{
            CGFloat med_price = [dic1[@"med_price"] floatValue];
            self.fourLabel1.text = [NSString stringWithFormat:@"峰:%.3f",med_price];
        }
        if (dic1[@"low_price"] ==0) {
            
            self.fourLabel2.text = [NSString stringWithFormat:@"谷:--"];
        }else{
            CGFloat low_price = [dic1[@"low_price"] floatValue];
            self.fourLabel2.text = [NSString stringWithFormat:@"谷:%.3f",low_price];
        }
        if (dic2[@"med_price"] ==0) {
            self.fourLabel3.text = [NSString stringWithFormat:@"峰:--"];
        }else{
            CGFloat med_price = [dic2[@"med_price"] floatValue];
            self.fourLabel3.text = [NSString stringWithFormat:@"峰:%.3f",med_price];
        }
        if (dic2[@"low_price"] ==0) {
            self.fourLabel4.text = [NSString stringWithFormat:@"谷:--"];
        }else{
            CGFloat low_price = [dic2[@"low_price"] floatValue];
            self.fourLabel4.text = [NSString stringWithFormat:@"谷:%.3f",low_price];
        }
        if (dic3[@"med_price"] ==0) {
            self.fourLabel5.text = [NSString stringWithFormat:@"峰:--"];
        }else{
            CGFloat med_price = [dic3[@"med_price"] floatValue];
            self.fourLabel5.text = [NSString stringWithFormat:@"峰:%.3f",med_price];
        }
        if (dic3[@"low_price"] ==0) {
            self.fourLabel6.text = [NSString stringWithFormat:@"谷:--"];
        }else{
            CGFloat low_price = [dic3[@"low_price"] floatValue];
            self.fourLabel6.text = [NSString stringWithFormat:@"谷:%.3f",low_price];
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
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
    LoginViewController *VC =[[LoginViewController alloc] init];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
