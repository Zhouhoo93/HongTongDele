//
//  ListShebeiViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/5/11.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "ListShebeiViewController.h"
#import "LoginViewController.h"
@interface ListShebeiViewController ()
@property (nonatomic,strong) UIScrollView *bgScroll;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *dataArr1;
@property (nonatomic,strong)NSMutableArray *yearArr;
@property (nonatomic,strong)NSMutableArray *yearArr1;
@property (nonatomic,copy) NSString *access_way;
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

@implementation ListShebeiViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    [self setyongdian];
    [self requestfadian];
    [self requestyongdian];
}

- (void)setUI{
   
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, KWidth, KHeight-64)];
    bgImage.image = [UIImage imageNamed:@"圆角矩形-1"];
    bgImage.userInteractionEnabled = YES;
    [self.view addSubview:bgImage];
    
    self.bgScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 14, KWidth, KHeight-64-40-10)];
    self.bgScroll.contentSize = CGSizeMake(0, 630);
    [bgImage addSubview:self.bgScroll];
    
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, -50, 18, 18)];
    leftImage.image = [UIImage imageNamed:@"图层-15"];
    [self.bgScroll addSubview:leftImage];
    NSInteger status = [_model.status integerValue];
    if (status==1 ) {
        UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-80, -50, 50, 40)];
        rightImage.image = [UIImage imageNamed:@"在线"];
        [self.bgScroll addSubview:rightImage];
    }else{
        UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-80, -50, 50, 40)];
        rightImage.image = [UIImage imageNamed:@"离线"];
        [self.bgScroll addSubview:rightImage];
    }
   

    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, -48, 122, 21)];
    topLabel.text = @"发用电监测设备";
    topLabel.font = [UIFont systemFontOfSize:14];
    [self.bgScroll addSubview:topLabel];
    
    for (int i=0; i<4; i++) {
        UILabel * leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 26*i-20, 71, 21)];
        leftLabel.textAlignment = NSTextAlignmentRight;
        leftLabel.font = [UIFont systemFontOfSize:13];
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 26*i-20, 150, 21)];
        rightLabel.textAlignment = NSTextAlignmentLeft;
        rightLabel.font = [UIFont systemFontOfSize:13];
        if (i==0) {
            leftLabel.text = @"型号:";
            rightLabel.text = self.model.product_model;
        }else if(i==1){
            leftLabel.text = @"额定功率:";
            NSInteger gonglv = [self.model.installed_capacity integerValue];
            rightLabel.text = [NSString stringWithFormat:@"%ldkW",gonglv/1000];
        }else if (i==2){
            leftLabel.text = @"额定电流:";
            if([self.model.rated_current isEqual:NULL]){
                rightLabel.text = self.model.rated_current;
            }else{
                rightLabel.text = @"";
            }
            
        }else{
            leftLabel.text = @"BID:";
            rightLabel.text = self.model.bid;
        }
        [self.bgScroll addSubview:leftLabel];
        [self.bgScroll addSubview:rightLabel];
    }
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 85, KWidth-40, 145)];
    if(_model.access_way ==1){
       image.image = [UIImage imageNamed:@"自发自用"];
    }else{
       image.image = [UIImage imageNamed:@"全额上网"];
    }
   
    [self.bgScroll addSubview:image];
    
}

- (void)setyongdian{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 15+230, 5, 13)];
        lineView.backgroundColor = RGBColor(57, 162, 255);
//    lineView.image = [UIImage imageNamed:@"政策"];
    [self.bgScroll addSubview:lineView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 15+230, 120, 13)];
    textLabel.text = @"居民阶梯电价表";
    textLabel.textColor = RGBColor(57, 162, 255);
    textLabel.font = [UIFont systemFontOfSize:13];
    [self.bgScroll addSubview:textLabel];
    
//    UIView *hengxian = [[UIView alloc] initWithFrame:CGRectMake(10, 32+230, KWidth-40, 2)];
//    hengxian.backgroundColor = RGBColor(31, 103, 159);
//    [self.bgScroll addSubview:hengxian];
    
    UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 55+230, (KWidth-40)/3, 13)];
    oneLabel.text = @"用电阶梯";
    oneLabel.textColor = [UIColor blackColor];
    oneLabel.font = [UIFont systemFontOfSize:12];
    oneLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgScroll addSubview:oneLabel];
    
    UILabel *oneLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 88+230, (KWidth-40)/3, 13)];
    oneLabel1.text = @"第一阶梯";
    oneLabel1.textColor = [UIColor blackColor];
    oneLabel1.font = [UIFont systemFontOfSize:12];
    oneLabel1.textAlignment = NSTextAlignmentCenter;
    [self.bgScroll addSubview:oneLabel1];
    
    UILabel *oneLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 121+230, (KWidth-40)/3, 13)];
    oneLabel2.text = @"第二阶梯";
    oneLabel2.textColor = [UIColor blackColor];
    oneLabel2.font = [UIFont systemFontOfSize:12];
    oneLabel2.textAlignment = NSTextAlignmentCenter;
    [self.bgScroll addSubview:oneLabel2];
    
    UILabel *oneLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 154+230, (KWidth-40)/3, 13)];
    oneLabel3.text = @"第三阶梯";
    oneLabel3.textColor = [UIColor blackColor];
    oneLabel3.font = [UIFont systemFontOfSize:12];
    oneLabel3.textAlignment = NSTextAlignmentCenter;
    [self.bgScroll addSubview:oneLabel3];
    
    UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/3, 55+230, (KWidth-40)/3, 13)];
    twoLabel.text = @"阶梯分级(度)";
    twoLabel.textColor = [UIColor blackColor];
    twoLabel.font = [UIFont systemFontOfSize:12];
    twoLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgScroll addSubview:twoLabel];
    //第一阶梯 阶梯分级
    self.twoLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/3, 88+230, (KWidth-40)/3, 13)];
    self.twoLabel1.text = @"≤";
    self.twoLabel1.textColor = [UIColor blackColor];
    self.twoLabel1.font = [UIFont systemFontOfSize:12];
    self.twoLabel1.textAlignment = NSTextAlignmentCenter;
    [self.bgScroll addSubview:self.twoLabel1];
    //第二阶梯 阶梯分级
    self.twoLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/3, 121+230, (KWidth-40)/3, 13)];
    self.twoLabel2.text = @"";
    self.twoLabel2.textColor = [UIColor blackColor];
    self.twoLabel2.font = [UIFont systemFontOfSize:12];
    self.twoLabel2.textAlignment = NSTextAlignmentCenter;
    [self.bgScroll addSubview:self.twoLabel2];
    //第三阶梯 阶梯分级
    NSInteger use = [_model.use_ele_way integerValue];
    if (use==0) {
        self.isGuDing = YES;
    }else{
        self.isGuDing = NO;
    }
    
    self.twoLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/3, 154+230, (KWidth-40)/3, 13)];
    self.twoLabel3.text = @"";
    self.twoLabel3.textColor = [UIColor blackColor];
    self.twoLabel3.font = [UIFont systemFontOfSize:12];
    self.twoLabel3.textAlignment = NSTextAlignmentCenter;
    [self.bgScroll addSubview:self.twoLabel3];
    if (_isGuDing) {
        UILabel *threeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/3*2, 55+230, (KWidth-40)/3, 13)];
        threeLabel.text = @"固定电价";
        threeLabel.textColor = [UIColor blackColor];
        threeLabel.font = [UIFont systemFontOfSize:12];
        threeLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgScroll addSubview:threeLabel];
        //第一阶梯 固定电价
        self.threeLabel1= [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/3*2, 88+230, (KWidth-40)/3, 13)];
        self.threeLabel1.text = @"";
        self.threeLabel1.textColor = [UIColor blackColor];
        self.threeLabel1.font = [UIFont systemFontOfSize:12];
        self.threeLabel1.textAlignment = NSTextAlignmentCenter;
        [self.bgScroll addSubview:self.threeLabel1];
        //第二阶梯 固定电价
        self.threeLabel2= [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/3*2, 121+230, (KWidth-40)/3, 13)];
        self.threeLabel2.text = @"";
        self.threeLabel2.textColor = [UIColor blackColor];
        self.threeLabel2.font = [UIFont systemFontOfSize:12];
        self.threeLabel2.textAlignment = NSTextAlignmentCenter;
        [self.bgScroll addSubview:self.threeLabel2];
        //第三阶梯 固定电价
        self.threeLabel3= [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/3*2, 154+230, (KWidth-40)/3, 13)];
        self.threeLabel3.text = @"";
        self.threeLabel3.textColor = [UIColor blackColor];
        self.threeLabel3.font = [UIFont systemFontOfSize:12];
        self.threeLabel3.textAlignment = NSTextAlignmentCenter;
        [self.bgScroll addSubview:self.threeLabel3];

    }else{
    
    
    UILabel *fourLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/3*2, 55+230, (KWidth-40)/3, 13)];
    fourLabel.text = @"阶梯用电";
    fourLabel.textColor = [UIColor blackColor];
    fourLabel.font = [UIFont systemFontOfSize:12];
    fourLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgScroll addSubview:fourLabel];
    //第一阶梯峰谷
    self.fourLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/3*2, 78+230, (KWidth-40)/3, 13)];
    self.fourLabel1.text = @"峰:";
    self.fourLabel1.textColor = [UIColor blackColor];
    self.fourLabel1.font = [UIFont systemFontOfSize:11];
    self.fourLabel1.textAlignment = NSTextAlignmentCenter;
    [self.bgScroll addSubview:self.fourLabel1];
    
    self.fourLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/3*2, 93+230, (KWidth-40)/3, 13)];
    self.fourLabel2.text = @"谷:";
    self.fourLabel2.textColor = [UIColor blackColor];
    self.fourLabel2.font = [UIFont systemFontOfSize:11];
    self.fourLabel2.textAlignment = NSTextAlignmentCenter;
    [self.bgScroll addSubview:self.fourLabel2];
    //第二阶梯 峰谷
    self.fourLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/3*2, 111+230, (KWidth-40)/3, 13)];
    self.fourLabel3.text = @"峰:";
    self.fourLabel3.textColor = [UIColor blackColor];
    self.fourLabel3.font = [UIFont systemFontOfSize:11];
    self.fourLabel3.textAlignment = NSTextAlignmentCenter;
    [self.bgScroll addSubview:self.fourLabel3];
    
    self.fourLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/3*2, 126+230, (KWidth-40)/3, 13)];
    self.fourLabel4.text = @"谷:";
    self.fourLabel4.textColor = [UIColor blackColor];
    self.fourLabel4.font = [UIFont systemFontOfSize:11];
    self.fourLabel4.textAlignment = NSTextAlignmentCenter;
    [self.bgScroll addSubview:self.fourLabel4];
    //第三阶梯峰谷
    self.fourLabel5 = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/3*2, 144+230, (KWidth-40)/3, 13)];
    self.fourLabel5.text = @"峰:";
    self.fourLabel5.textColor = [UIColor blackColor];
    self.fourLabel5.font = [UIFont systemFontOfSize:11];
    self.fourLabel5.textAlignment = NSTextAlignmentCenter;
    [self.bgScroll addSubview:self.fourLabel5];
    
    self.fourLabel6 = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/3*2, 159+230, (KWidth-40)/3, 13)];
    self.fourLabel6.text = @"谷:";
    self.fourLabel6.textColor = [UIColor blackColor];
    self.fourLabel6.font = [UIFont systemFontOfSize:11];
    self.fourLabel6.textAlignment = NSTextAlignmentCenter;
    [self.bgScroll addSubview:self.fourLabel6];
    }
    UIView *garyLineView = [[UIView alloc] init];
    garyLineView.frame = CGRectMake(25, 187+230, KWidth-50, 1);
    garyLineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgScroll addSubview:garyLineView];
    
//    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 192+230, 300, 13)];
//    tipLabel.text = @"用电情况要根据用电阶梯,进行峰谷电分时用电,可以使居民用户省电";
//    tipLabel.textColor = [UIColor darkGrayColor];
//    tipLabel.font = [UIFont systemFontOfSize:8];
//    tipLabel.textAlignment = NSTextAlignmentLeft;
//    [self.bgScroll addSubview:tipLabel];

}

- (void)setfadian{
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 15+430, 5, 13)];
        lineView.backgroundColor = RGBColor(57, 162, 255);
    [self.bgScroll addSubview:lineView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 15+430, 120, 13)];
    textLabel.text = @"光伏发电政策";
    textLabel.textColor = RGBColor(57, 162, 255);
    textLabel.font = [UIFont systemFontOfSize:13];
    [self.bgScroll addSubview:textLabel];
    
    UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 44+430, (KWidth-40)/4, 13)];
    oneLabel.text = @"消纳方式";
    oneLabel.textColor = [UIColor blackColor];
    oneLabel.font = [UIFont systemFontOfSize:13];
    oneLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgScroll addSubview:oneLabel];
    
    UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+(KWidth-40)/3, 44+430, (KWidth-40)/3, 13)];
    twoLabel.text = @"电价和补贴";
    twoLabel.textColor = [UIColor blackColor];
    twoLabel.font = [UIFont systemFontOfSize:13];
    twoLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgScroll addSubview:twoLabel];
    
    UILabel *threeLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-(KWidth-40)/3, 44+430, (KWidth-40)/3, 13)];
    threeLabel.text = @"补贴年限";
    threeLabel.textColor = [UIColor blackColor];
    threeLabel.font = [UIFont systemFontOfSize:13];
    threeLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgScroll addSubview:threeLabel];
    
    
    UIImageView *image = [[UIImageView alloc] init];
    
        image.frame = CGRectMake(17, 65+432, 9, 9);
    
    
    image.image = [UIImage imageNamed:@"fpower_selectered"];
    [self.bgScroll addSubview:image];
    
    NSInteger use = [_model.use_ele_way integerValue];
    if (use==0) {
        self.isQuan = YES;
    }else{
        self.isQuan = NO;
    }
    
    if (_isQuan) {
        UILabel *oneLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(22, 65+430, (KWidth-40)/4, 13)];
        oneLabel1.text = @"全额上网";
        oneLabel1.textColor = [UIColor blackColor];
        oneLabel1.font = [UIFont systemFontOfSize:11];
        oneLabel1.textAlignment = NSTextAlignmentCenter;
        [self.bgScroll addSubview:oneLabel1];
        
        for (int i=0; i<self.dataArr.count; i++) {
            UILabel *secondLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-50, 65+18*i+430, (KWidth-40)/4+40, 13)];
            secondLabel1.text = self.dataArr[i];
            secondLabel1.textColor = [UIColor blackColor];
            secondLabel1.font = [UIFont systemFontOfSize:11];
            secondLabel1.textAlignment = NSTextAlignmentCenter;
            [self.bgScroll addSubview:secondLabel1];
            
        }
        for (int i=0; i<self.yearArr.count; i++) {
            UILabel *thiredLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-80, 65+18*i+430, (KWidth-40)/4, 13)];
            thiredLabel1.text = self.yearArr[i];
            thiredLabel1.textColor = [UIColor blackColor];
            thiredLabel1.font = [UIFont systemFontOfSize:11];
            thiredLabel1.textAlignment = NSTextAlignmentCenter;
            [self.bgScroll addSubview:thiredLabel1];
        }
        
        //    UILabel *thiredLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-80, 83, (KWidth-40)/4, 13)];
        //    thiredLabel1.text = @"20年";
        //    thiredLabel1.textColor = [UIColor blackColor];
        //    thiredLabel1.font = [UIFont systemFontOfSize:11];
        //    thiredLabel1.textAlignment = NSTextAlignmentCenter;
        //    [bgImage addSubview:thiredLabel1];
    }else{
   
    
    UILabel *oneLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(22, 65+430, (KWidth-40)/4, 13)];
    oneLabel2.text = @"自发自用";
    oneLabel2.textColor = [UIColor blackColor];
    oneLabel2.font = [UIFont systemFontOfSize:11];
    oneLabel2.textAlignment = NSTextAlignmentCenter;
    [self.bgScroll addSubview:oneLabel2];
    
    for (int i=0; i<1; i++) {
        UILabel *secondLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-60, 65+18*i+430, (KWidth-40)/4+60, 13)];
        secondLabel3.text = @"自用电价:同时段国网电价";
        secondLabel3.textColor = [UIColor blackColor];
        secondLabel3.font = [UIFont systemFontOfSize:11];
        secondLabel3.textAlignment = NSTextAlignmentCenter;
        [self.bgScroll addSubview:secondLabel3];
        
    }
    for (int i=0; i<1; i++) {
        UILabel *thiredLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-80, 65+18*i+430, (KWidth-40)/4, 13)];
        thiredLabel1.text = @"";
        thiredLabel1.textColor = [UIColor blackColor];
        thiredLabel1.font = [UIFont systemFontOfSize:11];
        thiredLabel1.textAlignment = NSTextAlignmentCenter;
        [self.bgScroll addSubview:thiredLabel1];
    }
    
    UILabel *oneLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(22, 65+20*1+430, (KWidth-40)/4, 13)];
    oneLabel3.text = @"余电上网";
    oneLabel3.textColor = [UIColor blackColor];
    oneLabel3.font = [UIFont systemFontOfSize:11];
    oneLabel3.textAlignment = NSTextAlignmentCenter;
    [self.bgScroll addSubview:oneLabel3];
    
    for (int i=0; i<self.dataArr1.count; i++) {
        UILabel *secondLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-60, 65+20*1+18*i+430, (KWidth-40)/4+60, 13)];
        secondLabel4.text = self.dataArr1[i];
        secondLabel4.textColor = [UIColor blackColor];
        secondLabel4.font = [UIFont systemFontOfSize:11];
        secondLabel4.textAlignment = NSTextAlignmentCenter;
        [self.bgScroll addSubview:secondLabel4];
    }
    
    for (int i=0; i<self.yearArr1.count; i++) {
        UILabel *thiredLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-80, 65+20*1+18*i+430, (KWidth-40)/4, 13)];
        thiredLabel2.text = self.yearArr1[i];
        thiredLabel2.textColor = [UIColor blackColor];
        thiredLabel2.font = [UIFont systemFontOfSize:11];
        thiredLabel2.textAlignment = NSTextAlignmentCenter;
        [self.bgScroll addSubview:thiredLabel2];
        
    }
    }
    
    UIView *garyLineView = [[UIView alloc] init];
    garyLineView.frame = CGRectMake(25, 75+20*1+18*self.dataArr.count+430, KWidth-50, 1);
    garyLineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgScroll addSubview:garyLineView];
    
//    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 65+20*self.dataArr.count+20*1+18*self.dataArr.count+6+430, 300, 13)];
//    tipLabel.text = @"例:全额上网 发电100度 收益=100*0.98+100*0.1";
//    tipLabel.textColor = [UIColor darkGrayColor];
//    tipLabel.font = [UIFont systemFontOfSize:10];
//    tipLabel.textAlignment = NSTextAlignmentLeft;
//    [self.bgScroll addSubview:tipLabel];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)requestfadian{
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
        NSString *dianjia = [NSString stringWithFormat:@"标杆电价:%@元/度",responseObject[@"content"][@"benchmark_price"]];
        NSString *guo = [NSString stringWithFormat:@"补贴:%@元/度(国家)",responseObject[@"content"][@"state_subsidies"]];
        NSString *sheng = [NSString stringWithFormat:@"补贴:%@元/度(省财)",responseObject[@"content"][@"province_subsidies"]];
        NSString *city = [NSString stringWithFormat:@"补贴:%@元/度(城市)",responseObject[@"content"][@"city_subsidies"]];
        NSString *town = [NSString stringWithFormat:@"补贴:%@元/度(区镇)",responseObject[@"content"][@"town_subsidies"]];
        
        NSString *dianjia1 = [NSString stringWithFormat:@"上网电价:%@元/度",responseObject[@"content"][@"surplus_ele_tariff"]];
        [_dataArr addObject:dianjia];
        [_dataArr1 addObject:dianjia1];
        if (![guo isEqualToString:@"补贴:0元/度(国家)"]) {
            [_dataArr addObject:guo];
            [_dataArr1 addObject:guo];
        }
        if (![sheng isEqualToString:@"补贴:0元/度(省财)"]) {
            [_dataArr addObject:sheng];
            [_dataArr1 addObject:sheng];
        }
        if (![city isEqualToString:@"补贴:0元/度(城市)"]) {
            [_dataArr addObject:city];
            [_dataArr1 addObject:city];
        }
        if (![town isEqualToString:@"补贴:0元/度(区镇)"]) {
            [_dataArr addObject:town];
            [_dataArr1 addObject:town];
        }
        
        NSString *dianyear = @"";
        NSString *guoyear = [NSString stringWithFormat:@"%@年",responseObject[@"content"][@"deadline"]];
        NSString *shengyear = [NSString stringWithFormat:@"%@年",responseObject[@"content"][@"province_deadline"]];
        NSString *cityyear = [NSString stringWithFormat:@"%@年",responseObject[@"content"][@"city_deadline"]];
        NSString *townyear = [NSString stringWithFormat:@"%@年",responseObject[@"content"][@"town_deadline"]];
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
        
        
        [self setfadian];
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
}

- (void)requestyongdian{
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
        
        NSArray *Arr = responseObject[@"content"];
        NSDictionary *dic1 = Arr[0];
        NSDictionary *dic2 = Arr[1];
        NSDictionary *dic3 = Arr[2];
        self.twoLabel1.text = [NSString stringWithFormat:@"%@≤%@",dic1[@"start_cap"],dic1[@"end_cap"]];
        self.twoLabel2.text = [NSString stringWithFormat:@"%@≤%@",dic2[@"start_cap"],dic1[@"end_cap"]];
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
            CGFloat med_price = [dic1[@"med_price"] floatValue];
            self.fourLabel3.text = [NSString stringWithFormat:@"峰:%.3f",med_price];
        }
        if (dic2[@"low_price"] ==0) {
            self.fourLabel4.text = [NSString stringWithFormat:@"谷:--"];
        }else{
            CGFloat low_price = [dic1[@"low_price"] floatValue];
            self.fourLabel4.text = [NSString stringWithFormat:@"谷:%.3f",low_price];
        }
        if (dic3[@"med_price"] ==0) {
            self.fourLabel5.text = [NSString stringWithFormat:@"峰:--"];
        }else{
            CGFloat med_price = [dic1[@"med_price"] floatValue];
            self.fourLabel5.text = [NSString stringWithFormat:@"峰:%.3f",med_price];
        }
        if (dic3[@"low_price"] ==0) {
            self.fourLabel6.text = [NSString stringWithFormat:@"谷:--"];
        }else{
            CGFloat low_price = [dic1[@"low_price"] floatValue];
            self.fourLabel6.text = [NSString stringWithFormat:@"谷:%.3f",low_price];
        }
        
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
