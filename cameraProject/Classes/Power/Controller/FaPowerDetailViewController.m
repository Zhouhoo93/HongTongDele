//
//  FaPowerDetailViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/4/25.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "FaPowerDetailViewController.h"
#import "JHTableChart.h"
#import "fadianModel.h"
#import "LoginViewController.h"
@interface FaPowerDetailViewController ()
@property(nonatomic,strong)  fadianModel *model;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation FaPowerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"发电故障列表";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    [self requestFaDian];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI{
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10+64, 15, 13)];
    //    lineView.backgroundColor = RGBColor(57, 162, 255);
    lineView.image = [UIImage imageNamed:@"列表"];
    [self.view addSubview:lineView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 10+64, 120, 13)];
    textLabel.text = @"发电故障列表";
    textLabel.textColor = RGBColor(22, 69, 132);
    textLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:textLabel];
}

- (void)setTable{
    UIScrollView *Table = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 90, KWidth, KHeight-211)];
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
    table.colTitleArr = @[@"类型|时间",@"性质",@"状态",@"原因"];
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

- (void)requestFaDian{
    NSString *URL = [NSString stringWithFormat:@"%@/app/gens/gen/get-gen-alert",kUrl];
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
        NSLog(@"发电故障详情%@",responseObject);
        NSNumber *code = responseObject[@"result"][@"errorCode"];
        NSString *errorcode = [NSString stringWithFormat:@"%@",code];
        if ([errorcode isEqualToString:@"41111"])  {
            [self newLogin];
        }else if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
            [self newLoginTwo];
            
            
        }else{

        
        for (NSDictionary *goodsDic in responseObject[@"content"]) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
            _model =[[fadianModel alloc] initWithDictionary:goodsDic];
            [array addObject:_model.EventTime];
//            [array addObject:_model.INVERTER_ERRORCODE];
//            [array addObject:_model.INVERTER_STATUS];
            [array addObject:_model.property];
            [array addObject:_model.reason];
            [array addObject:_model.detail];
            [self.dataArray addObject:array];
        }
            

        [self setTable];
    }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
}

-(fadianModel *)model{
    if (!_model) {
        _model = [[fadianModel alloc] init];
    }
    return _model;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
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
