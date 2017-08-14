//
//  PowerViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/4/19.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "PowerViewController.h"
#import "OneLoginViewController.h"
@interface PowerViewController ()
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *dataArr1;
@property (nonatomic,strong)NSMutableArray *yearArr;
@property (nonatomic,strong)NSMutableArray *yearArr1;
@property (nonatomic,copy) NSString *access_way;
@end

@implementation PowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"发电政策";
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArr = [[NSMutableArray alloc] init];
    [self requestData];
}

- (void)setUI{
    UIScrollView *bgScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight-64-44)];
    bgScroll.contentSize = CGSizeMake(KWidth, 65+20*self.dataArr.count+20+20*1+18*self.dataArr.count+6+30+40+30+30+30+20);
    [self.view addSubview:bgScroll];
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, KWidth-20, 65+20*self.dataArr.count+20*1+18*self.dataArr.count+6+30+40+30+30+30+20+20+20)];
    bgImage.image = [UIImage imageNamed:@"大bg"];
    [bgScroll addSubview:bgImage];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 10, 13)];
    //    lineView.backgroundColor = RGBColor(57, 162, 255);
    lineView.image = [UIImage imageNamed:@"政策"];
    [bgImage addSubview:lineView];

    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 120, 13)];
    textLabel.text = @"发电政策";
    textLabel.textColor = RGBColor(57, 162, 255);
    textLabel.font = [UIFont systemFontOfSize:13];
    [bgImage addSubview:textLabel];
    
    UIView *hengxian = [[UIView alloc] initWithFrame:CGRectMake(10, 32, KWidth-40, 2)];
    hengxian.backgroundColor = RGBColor(31, 103, 159);
    [bgImage addSubview:hengxian];

    
    UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 44, (KWidth-40)/4, 13)];
    oneLabel.text = @"消纳方式";
    oneLabel.textColor = [UIColor blackColor];
    oneLabel.font = [UIFont systemFontOfSize:13];
    oneLabel.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:oneLabel];
    
    UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/3, 44, (KWidth-40)/3, 13)];
    twoLabel.text = @"电价和补贴";
    twoLabel.textColor = [UIColor blackColor];
    twoLabel.font = [UIFont systemFontOfSize:13];
    twoLabel.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:twoLabel];
    
    UILabel *threeLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-(KWidth-40)/3, 44, (KWidth-40)/3, 13)];
    threeLabel.text = @"补贴年限";
    threeLabel.textColor = [UIColor blackColor];
    threeLabel.font = [UIFont systemFontOfSize:13];
    threeLabel.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:threeLabel];

    
    UIImageView *image = [[UIImageView alloc] init];
    if (self.access_way == 0) {
        image.frame = CGRectMake(17, 65, 9, 9);
    }else{
        image.frame = CGRectMake(17, 65+20*self.dataArr.count+20*1, 9, 9);
    }
    
    image.image = [UIImage imageNamed:@"fpower_selectered"];
    [bgImage addSubview:image];
    
    UILabel *oneLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(22, 65, (KWidth-40)/4, 13)];
    oneLabel1.text = @"全额上网";
    oneLabel1.textColor = [UIColor blackColor];
    oneLabel1.font = [UIFont systemFontOfSize:11];
    oneLabel1.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:oneLabel1];
    
    for (int i=0; i<self.dataArr.count; i++) {
        UILabel *secondLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-50, 65+18*i, (KWidth-40)/4+40, 13)];
        secondLabel1.text = self.dataArr[i];
        secondLabel1.textColor = [UIColor blackColor];
        secondLabel1.font = [UIFont systemFontOfSize:11];
        secondLabel1.textAlignment = NSTextAlignmentCenter;
        [bgImage addSubview:secondLabel1];

    }
    for (int i=0; i<self.yearArr.count; i++) {
        UILabel *thiredLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-80, 65+18*i, (KWidth-40)/4, 13)];
        thiredLabel1.text = self.yearArr[i];
        thiredLabel1.textColor = [UIColor blackColor];
        thiredLabel1.font = [UIFont systemFontOfSize:11];
        thiredLabel1.textAlignment = NSTextAlignmentCenter;
        [bgImage addSubview:thiredLabel1];
    }
    
//    UILabel *thiredLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-80, 83, (KWidth-40)/4, 13)];
//    thiredLabel1.text = @"20年";
//    thiredLabel1.textColor = [UIColor blackColor];
//    thiredLabel1.font = [UIFont systemFontOfSize:11];
//    thiredLabel1.textAlignment = NSTextAlignmentCenter;
//    [bgImage addSubview:thiredLabel1];
    
    UILabel *oneLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(22, 65+20*self.dataArr.count, (KWidth-40)/4, 13)];
    oneLabel2.text = @"自发自用";
    oneLabel2.textColor = [UIColor blackColor];
    oneLabel2.font = [UIFont systemFontOfSize:11];
    oneLabel2.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:oneLabel2];
    
    for (int i=0; i<1; i++) {
        UILabel *secondLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-60, 65+20*self.dataArr.count+18*i, (KWidth-40)/4+60, 13)];
        secondLabel3.text = @"自用电价:同时段国网电价";
        secondLabel3.textColor = [UIColor blackColor];
        secondLabel3.font = [UIFont systemFontOfSize:11];
        secondLabel3.textAlignment = NSTextAlignmentCenter;
        [bgImage addSubview:secondLabel3];

    }
    for (int i=0; i<1; i++) {
        UILabel *thiredLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-80, 65+20*self.dataArr.count+18*i, (KWidth-40)/4, 13)];
        thiredLabel1.text = @"";
        thiredLabel1.textColor = [UIColor blackColor];
        thiredLabel1.font = [UIFont systemFontOfSize:11];
        thiredLabel1.textAlignment = NSTextAlignmentCenter;
        [bgImage addSubview:thiredLabel1];
    }
    
    UILabel *oneLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(22, 65+20*self.dataArr.count+20*1, (KWidth-40)/4, 13)];
    oneLabel3.text = @"余电上网";
    oneLabel3.textColor = [UIColor blackColor];
    oneLabel3.font = [UIFont systemFontOfSize:11];
    oneLabel3.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:oneLabel3];
    
    for (int i=0; i<self.dataArr1.count; i++) {
        UILabel *secondLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-60, 65+20*self.dataArr.count+20*1+18*i, (KWidth-40)/4+60, 13)];
        secondLabel4.text = self.dataArr1[i];
        secondLabel4.textColor = [UIColor blackColor];
        secondLabel4.font = [UIFont systemFontOfSize:11];
        secondLabel4.textAlignment = NSTextAlignmentCenter;
        [bgImage addSubview:secondLabel4];
    }

    for (int i=0; i<self.yearArr1.count; i++) {
        UILabel *thiredLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-80, 65+20*self.dataArr.count+20*1+18*i, (KWidth-40)/4, 13)];
        thiredLabel2.text = self.yearArr1[i];
        thiredLabel2.textColor = [UIColor blackColor];
        thiredLabel2.font = [UIFont systemFontOfSize:11];
        thiredLabel2.textAlignment = NSTextAlignmentCenter;
        [bgImage addSubview:thiredLabel2];

    }
    
    
    UIView *garyLineView = [[UIView alloc] init];
    garyLineView.frame = CGRectMake(25, 65+20*self.dataArr.count+20*1+18*self.dataArr.count, KWidth-50, 1);
    garyLineView.backgroundColor = [UIColor lightGrayColor];
    [bgImage addSubview:garyLineView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 65+20*self.dataArr.count+20*1+18*self.dataArr.count+6, 300, 13)];
    tipLabel.text = @"例:全额上网 发电100度 收益=100*0.98+100*0.1";
    tipLabel.textColor = [UIColor darkGrayColor];
    tipLabel.font = [UIFont systemFontOfSize:10];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    [bgImage addSubview:tipLabel];
    
    UIImageView *lineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 65+20*self.dataArr.count+20*1+18*self.dataArr.count+6+30, 10, 13)];
    //    lineView.backgroundColor = RGBColor(57, 162, 255);
    lineView1.image = [UIImage imageNamed:@"政策"];
    [bgImage addSubview:lineView1];
    
    UILabel *textLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 65+20*self.dataArr.count+20*1+18*self.dataArr.count+6+30, 120, 13)];
    textLabel1.text = @"计算公式";
    textLabel1.textColor = RGBColor(57, 162, 255);
    textLabel1.font = [UIFont systemFontOfSize:13];
    [bgImage addSubview:textLabel1];
    
    UIView *hengxian1 = [[UIView alloc] initWithFrame:CGRectMake(10, 65+20*self.dataArr.count+20*1+18*self.dataArr.count+6+30+20, KWidth-40, 2)];
    hengxian1.backgroundColor = RGBColor(31, 103, 159);
    [bgImage addSubview:hengxian1];
    
    UILabel *downlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-100, 65+20*self.dataArr.count+20*1+18*self.dataArr.count+6+30+17+15, 200, 20)];
    downlabel1.text = @"电量的计算公式:";
    downlabel1.textAlignment = NSTextAlignmentCenter;
    [bgImage addSubview:downlabel1];
    
    UILabel *downlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-75, 65+20*self.dataArr.count+20*1+18*self.dataArr.count+6+30+40+20, 200, 20)];
    downlabel2.text = @"Q:电量,单位库仑 (C)";
    downlabel2.font = [UIFont systemFontOfSize:14];
    downlabel2.textAlignment = NSTextAlignmentLeft;
    [bgImage addSubview:downlabel2];
    
    UILabel *downlabel3 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-75, 65+20*1+20*self.dataArr.count+18*self.dataArr.count+6+30+40+30+20, 200, 20)];
    downlabel3.text = @"I:电流,单位安培 (A)";
    downlabel3.font = [UIFont systemFontOfSize:14];
    downlabel3.textAlignment = NSTextAlignmentLeft;
    [bgImage addSubview:downlabel3];
    
    UILabel *downlabel4 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-75, 65+20*1+20*self.dataArr.count+18*self.dataArr.count+6+30+40+30+30+20, 200, 20)];
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
    NSString *URL = [NSString stringWithFormat:@"%@/app/gens/gen/get-gen-policy",kUrl];
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
        NSLog(@"发电政策%@",responseObject);
        NSNumber *code = responseObject[@"result"][@"errorCode"];
        NSString *errorcode = [NSString stringWithFormat:@"%@",code];
        if ([errorcode isEqualToString:@"41111"])  {
            [self newLogin];
        }
        self.access_way = responseObject[@"content"][@"access_way"];
        [self.dataArr removeAllObjects];
        [self.yearArr removeAllObjects];
        [self.dataArr1 removeAllObjects];
        [self.yearArr1 removeAllObjects];
        NSString *dianjia11 = responseObject[@"content"][@"benchmark_price"];
        NSString *dianjia = [[NSString alloc] init];
        if ([dianjia11 isEqual:NULL]) {
            dianjia = [NSString stringWithFormat:@"标杆电价: 元/度"];
        }else{
            dianjia = [NSString stringWithFormat:@"标杆电价:%@元/度",dianjia11];
        }
        NSString *guo1 = responseObject[@"content"][@"state_subsidies"];
        NSString *guo = [[NSString alloc] init];
        if ([guo1 isEqual:NULL]) {
            guo = [NSString stringWithFormat:@"补贴: 元/度(国补)"];
        }else{
            guo = [NSString stringWithFormat:@"补贴:%@元/度(国补)",guo1];
        }
        NSString *sheng1 = responseObject[@"content"][@"province_subsidies"];
        NSString *sheng = [[NSString alloc] init];
        if ([sheng1 isEqual:NULL]) {
            sheng = [NSString stringWithFormat:@"补贴: 元/度(省补)"];
        }else{
            sheng = [NSString stringWithFormat:@"补贴:%@元/度(省补)",sheng1];
        }
        NSString *city1 = responseObject[@"content"][@"city_subsidies"];
        NSString *city = [[NSString alloc] init];
        if ([city1 isEqual:NULL]) {
            city = [NSString stringWithFormat:@"补贴: 元/度(市补)"];
        }else{
            city = [NSString stringWithFormat:@"补贴:%@元/度(市补)",city1];
        }
        NSString *town1 = responseObject[@"content"][@"town_subsidies"];
        NSString *town = [[NSString alloc] init];
        if ([town1 isEqual:NULL]) {
            town = [NSString stringWithFormat:@"补贴: 元/度(区补)"];
        }else{
            town = [NSString stringWithFormat:@"补贴:%@元/度(区补)",town1];
        }
        NSString *dianjia1 = [NSString stringWithFormat:@"上网电价:%@元/度",responseObject[@"content"][@"surplus_ele_tariff"]];
            [_dataArr addObject:dianjia];
            [_dataArr1 addObject:dianjia1];
        if (![guo isEqualToString:@"补贴:0元/度(国补)"]) {
            [_dataArr addObject:guo];
            [_dataArr1 addObject:guo];
        }
        if (![sheng isEqualToString:@"补贴:0元/度(省补)"]) {
            [_dataArr addObject:sheng];
            [_dataArr1 addObject:sheng];
        }
        if (![city isEqualToString:@"补贴:0元/度(市补)"]) {
            [_dataArr addObject:city];
            [_dataArr1 addObject:city];
        }
        if (![town isEqualToString:@"补贴:0元/度(区补)"]) {
            [_dataArr addObject:town];
            [_dataArr1 addObject:town];
        }
        
        NSString *dianyear = @"";
        NSString *guoyear1 = responseObject[@"content"][@"deadline"];
        NSString *guoyear = [[NSString alloc] init];
        if ( [guoyear1 isEqual:NULL]) {
            guoyear = [NSString stringWithFormat:@" 年"];
        }else{
            guoyear = [NSString stringWithFormat:@"%@年",guoyear1];
        }
        NSString *shengyear1 = responseObject[@"content"][@"province_deadline"];
        NSString *shengyear = [[NSString alloc] init];
        if ( [shengyear1 isEqual:NULL]) {
            shengyear = [NSString stringWithFormat:@" 年"];
        }else{
            shengyear = [NSString stringWithFormat:@"%@年",shengyear1];
        }
        NSString *cityyear1 = responseObject[@"content"][@"city_deadline"];
        NSString *cityyear = [[NSString alloc] init];
        if ( [cityyear1 isEqual:NULL]) {
            cityyear = [NSString stringWithFormat:@" 年"];
        }else{
            cityyear = [NSString stringWithFormat:@"%@年",cityyear1];
        }
        NSString *townyear1 = responseObject[@"content"][@"town_deadline"];
        NSString *townyear = [[NSString alloc] init];
        if ( [townyear1 isEqual:NULL]) {
            townyear = [NSString stringWithFormat:@" 年"];
        }else{
            townyear = [NSString stringWithFormat:@"%@年",cityyear1];
        }
                [_yearArr addObject:dianyear];
        [_yearArr1 addObject:dianyear];
        if (![guoyear isEqualToString:@"0年"]) {
            [_yearArr addObject:guoyear];
            [_yearArr1 addObject:guoyear];
        }
        if (![shengyear isEqualToString:@"0年"]) {
            [_yearArr addObject:shengyear];
            [_yearArr1 addObject:shengyear];
        }
        if (![cityyear isEqualToString:@"0年"]) {
            [_yearArr addObject:cityyear];
            [_yearArr1 addObject:cityyear];
        }
        if (![townyear isEqualToString:@"0年"]) {
            [_yearArr addObject:townyear];
            [_yearArr1 addObject:townyear];
        }
        
        
        [self setUI];
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}
-(NSMutableArray *)dataArr1{
    if (!_dataArr1) {
        _dataArr1 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr1;
}
-(NSMutableArray *)yearArr{
    if (!_yearArr) {
        _yearArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _yearArr;
}
-(NSMutableArray *)yearArr1{
    if (!_yearArr1) {
        _yearArr1 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _yearArr1;
}


- (void)newLoginTwo{
    [MBProgressHUD showText:@"您的账号已过期,请重新登录"];
    [self performSelector:@selector(backTo) withObject: nil afterDelay:2.0f];
}
- (void)newLogin{
    [MBProgressHUD showText:@"请重新登录"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
