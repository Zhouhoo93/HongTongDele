//
//  PowerDetailViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/4/19.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "PowerDetailViewController.h"
#import "JHTableChart.h"
#import "yongdianModel.h"
#import "OneLoginViewController.h"
@interface PowerDetailViewController ()
@property(nonatomic,strong)  yongdianModel *model;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIButton *leftBtn1;
@property (nonatomic,strong) UIButton *leftBtn2;
@property (nonatomic,strong) UIButton *rightBtn1;
@property (nonatomic,strong) UIButton *rightBtn2;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *overV;
@property (nonatomic,copy) NSString *leakCurrent;
@end

@implementation PowerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"用电故障列表";
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self requestyongDian];
    [self requestStatus];
}

- (void)setupUI{
    UIView *bgLine = [[UIView alloc] initWithFrame:CGRectMake(10, 70, KWidth-20, 35)];
    bgLine.backgroundColor = RGBColor(236, 250, 255);
    [self.view addSubview:bgLine];
    
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 20, 18)];
    leftImg.image = [UIImage imageNamed:@"t1"];
    [bgLine addSubview:leftImg];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 9, 40, 18)];
    leftLabel.text = @"漏电";
    leftLabel.font = [UIFont systemFontOfSize:14];
    leftLabel.textColor = RGBColor(0, 0, 113);
    [bgLine addSubview:leftLabel];
    
    
    self.leftBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(74, 9, 35, 18)];
    [self.leftBtn1 setBackgroundImage:[UIImage imageNamed:@"推送"] forState:UIControlStateNormal];
    [self.leftBtn1 setTitle:@"推送" forState:UIControlStateNormal];
    self.leftBtn1.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.leftBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.leftBtn1 addTarget:self action:@selector(loudiantuisong) forControlEvents:UIControlEventTouchUpInside];
    [bgLine addSubview:self.leftBtn1];
    
    self.leftBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(115, 9, 35, 18)];
    [self.leftBtn2 setBackgroundImage:[UIImage imageNamed:@"推送"] forState:UIControlStateNormal];
    [self.leftBtn2 setTitle:@"禁止" forState:UIControlStateNormal];
    self.leftBtn2.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.leftBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.leftBtn2 addTarget:self action:@selector(loudianjingzhi) forControlEvents:UIControlEventTouchUpInside];
    [bgLine addSubview:self.leftBtn2];
    
    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth/2, 9, 20, 18)];
    rightImg.image = [UIImage imageNamed:@"t2"];
    [bgLine addSubview:rightImg];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2+26, 9, 40, 18)];
    rightLabel.text = @"过载";
    rightLabel.font = [UIFont systemFontOfSize:14];
    rightLabel.textColor = RGBColor(0, 0, 113);
    [bgLine addSubview:rightLabel];
    
    self.rightBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/2+64, 9, 35, 18)];
    [self.rightBtn1 setBackgroundImage:[UIImage imageNamed:@"推送"] forState:UIControlStateNormal];
    [self.rightBtn1 setTitle:@"推送" forState:UIControlStateNormal];
    self.rightBtn1.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.rightBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rightBtn1 addTarget:self action:@selector(guozaituisong) forControlEvents:UIControlEventTouchUpInside];
    [bgLine addSubview:self.rightBtn1];
    
    self.rightBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/2+105, 9, 35, 18)];
    [self.rightBtn2 setBackgroundImage:[UIImage imageNamed:@"推送"] forState:UIControlStateNormal];
    [self.rightBtn2 setTitle:@"禁止" forState:UIControlStateNormal];
    self.rightBtn2.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.rightBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rightBtn2 addTarget:self action:@selector(guozaijingzhi) forControlEvents:UIControlEventTouchUpInside];
    [bgLine addSubview:self.rightBtn2];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL loudian = [userDefaults valueForKey:@"loudian"];
    if (loudian) {
        [self.leftBtn1 setBackgroundImage:[UIImage imageNamed:@"圆角矩形-2"] forState:UIControlStateNormal];
        [self.leftBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [self.leftBtn2 setBackgroundImage:[UIImage imageNamed:@"圆角矩形-2"] forState:UIControlStateNormal];
        [self.leftBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    BOOL guozai = [userDefaults valueForKey:@"guozai"];
    if (guozai) {
        [self.rightBtn1 setBackgroundImage:[UIImage imageNamed:@"圆角矩形-2"] forState:UIControlStateNormal];
        [self.rightBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [self.rightBtn2 setBackgroundImage:[UIImage imageNamed:@"圆角矩形-2"] forState:UIControlStateNormal];
        [self.rightBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 52+64, 15, 13)];
    //    lineView.backgroundColor = RGBColor(57, 162, 255);
    lineView.image = [UIImage imageNamed:@"列表"];
    [self.view addSubview:lineView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 52+64, 120, 13)];
    textLabel.text = @"用电故障列表";
    textLabel.textColor = RGBColor(22, 69, 132);
    textLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:textLabel];

}

- (void)setTable{
    UIScrollView *Table = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 140, KWidth, KHeight-211)];
    Table.bounces = NO;
    [self.view addSubview:Table];
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, KWidth-30, 34)];
    blueView.backgroundColor = RGBColor(10, 68, 132);
    [Table addSubview:blueView];
    
    JHTableChart *table = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, 35)];
    table.typeCount = 7;
    table.lineColor = [UIColor blackColor];
    /*       Table name         */
    //    table.tableTitleString = @"全选jeep自由光";
    /*        Each column of the statement, one of the first to show if the rows and columns that can use the vertical segmentation of rows and columns         */
    table.tableTitleFont = [UIFont systemFontOfSize:12];
    //    table.xDescTextFontSize =  (CGFloat)13;
    //    table.yDescTextFontSize =  (CGFloat)13;
    table.colTitleArr = @[@"类型|时间",@"性质",@"原因",@"详情"];
    /*        The width of the column array, starting with the first column         */
//    table.colWidthArr = @[@100.0,@100.0,@160,@100];
        table.colWidthArr = @[@80.0,@30.0,@70,@50];
    //    table.beginSpace = 30;
    /*        Text color of the table body         */
    table.bodyTextColor = [UIColor whiteColor];
    /*        Minimum grid height         */
    table.minHeightItems = 35;
    /*        Table line color         */
    table.lineColor = [UIColor whiteColor];
    
    table.backgroundColor = [UIColor clearColor];
    /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
//    table.dataArr = self.dataArray;
    /*        show   */
//    Table.contentSize = CGSizeMake(KWidth, 35*(table.dataArr.count+1));
     Table.contentSize = CGSizeMake(KWidth, 35);
    [table showAnimation];
    [Table addSubview:table];
    /*        Automatic calculation table height        */
    table.frame = CGRectMake(0, 0, KWidth, [table heightFromThisDataSource]);

    UIScrollView *Table1= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, KWidth, KHeight-246)];
    Table1.bounces = NO;
    [Table addSubview:Table1];
    
   
    
    JHTableChart *table1 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight-246)];
    table1.typeCount = 6;
    table1.lineColor = [UIColor blackColor];
    /*       Table name         */
    //    table.tableTitleString = @"全选jeep自由光";
    /*        Each column of the statement, one of the first to show if the rows and columns that can use the vertical segmentation of rows and columns         */
    table1.tableTitleFont = [UIFont systemFontOfSize:12];
    //    table.xDescTextFontSize =  (CGFloat)13;
    //    table.yDescTextFontSize =  (CGFloat)13;
    table1.colTitleArr = self.dataArray[0];
    /*        The width of the column array, starting with the first column         */
    //    table.colWidthArr = @[@100.0,@100.0,@160,@100];
    table1.colWidthArr = @[@80.0,@30.0,@70,@50];
    //    table.beginSpace = 30;
    /*        Text color of the table body         */
    table1.bodyTextColor = [UIColor whiteColor];
    /*        Minimum grid height         */
    table1.minHeightItems = 35;
    /*        Table line color         */
    table1.lineColor = [UIColor whiteColor];
    
    table1.backgroundColor = [UIColor clearColor];
    /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
    NSMutableArray *day11 = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<self.dataArray.count; i++) {
        if (i>0) {
            [day11 addObject:self.dataArray[i]];
        }
    }

        table1.dataArr = day11;
    /*        show   */
        Table1.contentSize = CGSizeMake(KWidth, 35*(table1.dataArr.count+1));
//    Table1.contentSize = CGSizeMake(KWidth, 35*(self.dataArray.count+1));
    [table1 showAnimation];
    [Table1 addSubview:table1];
    /*        Automatic calculation table height        */
    table1.frame = CGRectMake(0, 0, KWidth, [table1 heightFromThisDataSource]);

    
    
}

- (void)requestyongDian{
    NSString *URL = [NSString stringWithFormat:@"%@/app/uses/use/get-use-alert",kUrl];
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
        NSLog(@"用电故障详情%@",responseObject);
        NSNumber *errorcode = responseObject[@"result"][@"errorCode"] ;
        if (errorcode ==41111)  {
            [self newLogin];
        }else if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
            [self newLoginTwo];
            
            
        }else{
        for (NSDictionary *goodsDic in responseObject[@"content"]) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
            _model =[[yongdianModel alloc] initWithDictionary:goodsDic];
            [array addObject:_model.date];
            [array addObject:_model.property?_model.property:@""];
            [array addObject:_model.reason?_model.reason:@""];
            [array addObject:_model.details?_model.details:@""];
            [self.dataArray addObject:array];
        }
        
        [self setTable];
    }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
}
//允许推送
- (void)requestPushStatusON{
    NSString *URL = [NSString stringWithFormat:@"%@/app/uses/use/unlock-send-alert",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.type forKey:@"type"];
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"推送开关%@",responseObject);
        NSNumber *errorcode = responseObject[@"result"][@"errorCode"] ;
        if (errorcode ==41111)  {
            [self newLogin];
        }else if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
            [self newLoginTwo];
            
            
        }else{
            NSNumber *Result = responseObject[@"result"][@"success"];
            if (Result ) {
                [MBProgressHUD showText:@"设置完成"];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                if ([self.type isEqualToString:@"leakCurrent"]) {
                    [userDefaults setBool:YES forKey:@"loudian"];
                    [userDefaults synchronize];
                }else{
//                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setBool:YES forKey:@"guozai"];
                [userDefaults synchronize];
                }
            }else{
                [MBProgressHUD showText:@"设置失败"];
            }
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    

}

//禁止推送
- (void)requestPushStatusOff{
    NSString *URL = [NSString stringWithFormat:@"%@/app/uses/use/lock-send-alert",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.type forKey:@"type"];
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"推送开关%@",responseObject);
        NSNumber *code = responseObject[@"result"][@"errorCode"];
        
        NSString *errorcode = [NSString stringWithFormat:@"%@",code];
        if ([errorcode isEqualToString:@"41111"])  {
            [self newLogin];
        }else if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
            [self newLoginTwo];
            
            
        }else{
            NSNumber *Result = responseObject[@"result"][@"success"] ;
            if ([Result integerValue] ==1) {
                [MBProgressHUD showText:@"设置完成"];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                if ([self.type isEqualToString:@"leakCurrent"]) {
                [userDefaults setBool:NO forKey:@"loudian"];
                [userDefaults synchronize];
                }else{
//                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setBool:NO forKey:@"guozai"];
                [userDefaults synchronize];
                }
            }else{
                [MBProgressHUD showText:@"设置失败"];
            }
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
    
}

//禁止推送
- (void)requestStatus{
    NSString *URL = [NSString stringWithFormat:@"%@/app/uses/use/get-push-status",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters setValue:self.type forKey:@"type"];
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"推送开关状态%@",responseObject);
        self.overV = responseObject[@"content"][@"overV"];
        self.leakCurrent = responseObject[@"content"][@"leakCurrent"];
        if ([self.overV integerValue] ==0) {
            [self.rightBtn1 setBackgroundImage:[UIImage imageNamed:@"圆角矩形-2"] forState:UIControlStateNormal];
            [self.rightBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.rightBtn2 setBackgroundImage:[UIImage imageNamed:@"推送"] forState:UIControlStateNormal];
            [self.rightBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        }else{
            [self.rightBtn2 setBackgroundImage:[UIImage imageNamed:@"圆角矩形-2"] forState:UIControlStateNormal];
            [self.rightBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.rightBtn1 setBackgroundImage:[UIImage imageNamed:@"推送"] forState:UIControlStateNormal];
            [self.rightBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        }
        if ([self.leakCurrent integerValue]==0) {
            [self.leftBtn1 setBackgroundImage:[UIImage imageNamed:@"圆角矩形-2"] forState:UIControlStateNormal];
            [self.leftBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.leftBtn2 setBackgroundImage:[UIImage imageNamed:@"推送"] forState:UIControlStateNormal];
            [self.leftBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            [self.leftBtn2 setBackgroundImage:[UIImage imageNamed:@"圆角矩形-2"] forState:UIControlStateNormal];
            [self.leftBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.leftBtn1 setBackgroundImage:[UIImage imageNamed:@"推送"] forState:UIControlStateNormal];
            [self.leftBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        }
        

//        NSNumber *code = responseObject[@"result"][@"errorCode"];
//        
//        NSString *errorcode = [NSString stringWithFormat:@"%@",code];
//        if ([errorcode isEqualToString:@"41111"])  {
//            [self newLogin];
//        }else if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
//            [self newLoginTwo];
//            
//            
//        }else{
//            NSNumber *Result = responseObject[@"result"][@"success"] ;
//            if ([Result integerValue] ==1) {
//                [MBProgressHUD showText:@"设置完成"];
//                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                if ([self.type isEqualToString:@"leakCurrent"]) {
//                    [userDefaults setBool:NO forKey:@"loudian"];
//                    [userDefaults synchronize];
//                }else{
//                    //                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                    [userDefaults setBool:NO forKey:@"guozai"];
//                    [userDefaults synchronize];
//                }
//            }else{
//                [MBProgressHUD showText:@"设置失败"];
//            }
//        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
    
}


- (void )loudiantuisong{
    self.type = @"leakCurrent";
    [self requestPushStatusON];
    [self.leftBtn1 setBackgroundImage:[UIImage imageNamed:@"圆角矩形-2"] forState:UIControlStateNormal];
    [self.leftBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.leftBtn2 setBackgroundImage:[UIImage imageNamed:@"推送"] forState:UIControlStateNormal];
    [self.leftBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
- (void )loudianjingzhi{
    self.type = @"leakCurrent";
    [self requestPushStatusOff];
    
    [self.leftBtn2 setBackgroundImage:[UIImage imageNamed:@"圆角矩形-2"] forState:UIControlStateNormal];
    [self.leftBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.leftBtn1 setBackgroundImage:[UIImage imageNamed:@"推送"] forState:UIControlStateNormal];
    [self.leftBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
- (void )guozaituisong{
    self.type = @"overV";
    [self requestPushStatusON];

    [self.rightBtn1 setBackgroundImage:[UIImage imageNamed:@"圆角矩形-2"] forState:UIControlStateNormal];
    [self.rightBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightBtn2 setBackgroundImage:[UIImage imageNamed:@"推送"] forState:UIControlStateNormal];
    [self.rightBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
- (void )guozaijingzhi{
     self.type = @"overV";
    [self requestPushStatusOff];
    
    [self.rightBtn2 setBackgroundImage:[UIImage imageNamed:@"圆角矩形-2"] forState:UIControlStateNormal];
    [self.rightBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightBtn1 setBackgroundImage:[UIImage imageNamed:@"推送"] forState:UIControlStateNormal];
    [self.rightBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

-(yongdianModel *)model{
    if (!_model) {
        _model = [[yongdianModel alloc] init];
    }
    return _model;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
