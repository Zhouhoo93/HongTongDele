//
//  AdministrationViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/1/19.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "AdministrationViewController.h"
#import "AdministrationTableViewCell.h"
#import "AddBurglarViewController.h"
#import "AdministrationModel.h"
#import "MJRefresh.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
static const CGFloat MJDuration = 0.5;
@interface AdministrationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *listArr;
@property (nonatomic,strong)AdministrationModel *model;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIImageView *noData;
@end

@implementation AdministrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"报警点管理";
    [self setTableView];
    self.view.backgroundColor = RGBColor(241, 241, 241);
    [self setHeader];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSLog(@"viewWillAppear");
//    [self requestAll];
}


-(void)setHeader{
//    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 10+64, KWidth, 44)];
//    header.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:header];
//    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KWidth, 44)];
//    [btn addTarget:self action:@selector(headerBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [btn setBackgroundColor:[UIColor clearColor]];
//    [header addSubview:btn];
//    
//    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 8, 27, 27)];
//    image.image = [UIImage imageNamed:@"fpower_num"];
//    [header addSubview:image];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(64, 12, 100, 20)];
//    label.text = @"新增报警点";
//    label.font = [UIFont systemFontOfSize:15];
//    [header addSubview:label];
    
    UILabel *midLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 74, KWidth, 22)];
    midLabel.text = @"我的报警点";
    midLabel.textColor = RGBColor(0, 145, 236);
    midLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:midLabel];
}

- (void)setTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, KWidth, KHeight-108)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _noData = [[UIImageView alloc] init];
    _noData.image = [UIImage imageNamed:@"暂无报警消息"];
    _noData.frame = CGRectMake(0, 0, KWidth, KHeight);
    [_tableView addSubview:_noData];
//    _tableView.scrollEnabled = NO;
    [self setRefresh];
    [self.view addSubview:_tableView];
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(void)setRefresh{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 马上进入刷新状态
    //    [header beginRefreshing];
    // 设置header
    if (![_tableView.mj_header isRefreshing]) {
        
        [header beginRefreshing];
        // 设置header
        _tableView.mj_header = header;
    }
    
    
}
//-------下拉刷新的请求
- (void)loadNewData{
    [self requestAll];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.tableView.mj_header isRefreshing]) {
            [self requestAll];
            [_tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            
        }
    });
}

//-(void)headerBtnClick{
//    AddBurglarViewController *vc = [[AddBurglarViewController alloc] init];
//    vc.list = _listArr;
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求
- (void)requestAll{
    NSString *URL = [NSString stringWithFormat:@"%@/app/alertors/alertor",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取所有紧急报警器%@",responseObject);
//        if (responseObject[@"result"][@"success"]&&![responseObject[@"result"][@"errorMsg"] isEqualToString:@"token error"]) {
//            NSString *str = responseObject[@"result"][@"errorMsg"];
//            [MBProgressHUD showText:str];
//        }
        NSNumber *code = responseObject[@"result"][@"errorCode"];
        NSString *errorcode = [NSString stringWithFormat:@"%@",code];
        if ([errorcode isEqualToString:@"41111"])  {
            [self newLogin];
        }else if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
            [self newLoginTwo];
            

        }else{

            self.listArr =responseObject[@"content"];
            if(self.listArr.count>0){
                _noData.hidden = YES;
            }else{
                _noData.hidden = NO;
            }
        for (NSDictionary *goodsDic in _listArr) {
            _model =[[AdministrationModel alloc] initWithDictionary:goodsDic];
            _model.defaul = goodsDic[@"default"];
            [self.dataArr addObject:_model];
            [self.tableView reloadData];
            if ([_tableView.mj_header isRefreshing]) {
                [_tableView.mj_header endRefreshing];
            }
        }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}

#pragma mark - tableView数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _listArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"AdministrationTableViewCell";
    // 2.从缓存池中取出cell
    AdministrationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3.如果缓存池中没有cell
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"AdministrationTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        AdministrationModel *model1 = _dataArr[indexPath.section];
        cell.editBtn.tag = [model1.bid integerValue];
        cell.bid = model1.bid;
        cell.city = model1.city;
        cell.address = model1.address;
        cell.position = model1.position;
        cell.nameLabel.text = model1.name;
        cell.addressLabel.text = model1.address;
        cell.backgroundColor = [UIColor whiteColor];
        cell.nameLabel.enabled = NO;
        cell.addressLabel.enabled = NO;
        if ([model1.defaul isEqualToString:@"0"]) {
            cell.leftBtn.selected = NO;
        }else{
            cell.leftBtn.selected = YES;
        }
    }
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  88;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = RGBColor(241, 241, 241);
    return footView;
}

#pragma mark - 懒加载
-(NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr =[NSMutableArray arrayWithCapacity:0];
    }
    return _listArr;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr =[NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}

-(AdministrationModel *)model{
    if (!_model) {
        _model =[[AdministrationModel alloc] init];
    }
    return _model;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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


@end
