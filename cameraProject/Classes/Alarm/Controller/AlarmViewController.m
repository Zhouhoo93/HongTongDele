//
//  AlarmViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/1/4.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "AlarmViewController.h"
#import "AlarmTableViewCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import "AlarmModel.h"
static const CGFloat MJDuration = 0.5;
@interface AlarmViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UITableView *undervoltageTableView;
@property (nonatomic,strong) UITableView *overvoltageTableView;
@property (nonatomic,strong) UITableView *flowTableView;
@property (nonatomic,strong) UITableView *electricleakageTableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *zeroArr;
@property (nonatomic,strong) NSMutableArray *oneArr;
@property (nonatomic,strong) NSMutableArray *twoArr;
@property (nonatomic,strong) NSMutableArray *threeArr;
@property (nonatomic,strong) AlarmModel *model;
@property (nonatomic,strong) NSString *useNext_page_url;
@property (nonatomic,strong) NSString *next_page_url;
@property (nonatomic,strong) UIImageView *noData;
@property (nonatomic,strong) UIImageView *noDataTwo;
@property (nonatomic,strong) UIImageView *noDataThree;
@property (nonatomic,strong) UIImageView *noDataFour;
@end

@implementation AlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"报警详情";
    if (self.isUse) {
        [self requestUsePower];
    }else{
        [self requestPower];
    }
    [self setScroll];
    [self addChildViewController];
    [_line setFrame:CGRectMake((KWidth/4-62)/2, 103, 62, 3)];
}

- (void)setScroll{
    _scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 108, [UIScreen mainScreen].bounds.size.width, KHeight)];
    _scrollView.contentSize =CGSizeMake(4*[UIScreen mainScreen].bounds.size.width, KHeight-108);
    _scrollView.delegate =self;
    _scrollView.bounces =NO;
    _scrollView.pagingEnabled =YES;
    [self.view addSubview:_scrollView];
}

- (void)addChildViewController{
    _undervoltageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height ) style:UITableViewStylePlain];
    _undervoltageTableView.delegate = self;
    _undervoltageTableView.dataSource = self;
    _undervoltageTableView.backgroundColor = [UIColor whiteColor];
    _undervoltageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _noData = [[UIImageView alloc] init];
    _noData.image = [UIImage imageNamed:@"暂无报警消息"];
    _noData.frame = _undervoltageTableView.frame;
    [_undervoltageTableView addSubview:_noData];
    [_scrollView addSubview:_undervoltageTableView];
    [self setRefreshOne];
    _overvoltageTableView = [[UITableView alloc] initWithFrame:CGRectMake(KWidth, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    _overvoltageTableView.delegate = self;
    _overvoltageTableView.dataSource = self;
    _overvoltageTableView.backgroundColor = [UIColor whiteColor];
    _overvoltageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _noDataTwo = [[UIImageView alloc] init];
    _noDataTwo.image = [UIImage imageNamed:@"暂无报警消息"];
    _noDataTwo.frame = _undervoltageTableView.frame;
    [_overvoltageTableView addSubview:_noDataTwo];
    [_scrollView addSubview:_overvoltageTableView];
    [self setRefreshTwo];
    _flowTableView = [[UITableView alloc] initWithFrame:CGRectMake(KWidth*2, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    _flowTableView.delegate = self;
    _flowTableView.dataSource = self;
    _flowTableView.backgroundColor = [UIColor whiteColor];
    _flowTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _noDataThree = [[UIImageView alloc] init];
    _noDataThree.image = [UIImage imageNamed:@"暂无报警消息"];
    _noDataThree.frame = _undervoltageTableView.frame;
    [_flowTableView addSubview:_noDataThree];
    [_scrollView addSubview:_flowTableView];
    [self setRefreshThree];
    
    _electricleakageTableView = [[UITableView alloc] initWithFrame:CGRectMake(KWidth*3, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    _electricleakageTableView.delegate = self;
    _electricleakageTableView.dataSource = self;
    _electricleakageTableView.backgroundColor = [UIColor whiteColor];
    _electricleakageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _noDataFour = [[UIImageView alloc] init];
    _noDataFour.image = [UIImage imageNamed:@"暂无报警消息"];
    _noDataFour.frame = _undervoltageTableView.frame;
    [_electricleakageTableView addSubview:_noDataFour];
    [_scrollView addSubview:_electricleakageTableView];
    [self setRefreshFour];
}

-(void)setRefreshOne{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 马上进入刷新状态
    //    [header beginRefreshing];
    
    // 设置header
    if (![_undervoltageTableView.mj_header isRefreshing]) {
        [header beginRefreshing];
        // 设置header
        _undervoltageTableView.mj_header = header;
    }
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.undervoltageTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [footer beginRefreshing];
        _undervoltageTableView.mj_footer = footer;
    }];

    
}

-(void)setRefreshTwo{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 马上进入刷新状态
    //    [header beginRefreshing];
    
    if (![_overvoltageTableView.mj_header isRefreshing]) {
        [header beginRefreshing];
        // 设置header
        _overvoltageTableView.mj_header = header;
    }
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.overvoltageTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [footer beginRefreshing];
        _overvoltageTableView.mj_footer = footer;

    }];
    
}

-(void)setRefreshThree{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 马上进入刷新状态
    //    [header beginRefreshing];
    
    if (![_flowTableView.mj_header isRefreshing]) {
        [header beginRefreshing];
        // 设置header
        _flowTableView.mj_header = header;
    }
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.flowTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [footer beginRefreshing];
        _flowTableView.mj_footer = footer;
    }];
    
}

-(void)setRefreshFour{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 马上进入刷新状态
    //    [header beginRefreshing];
    
    if (![_electricleakageTableView.mj_header isRefreshing]) {
        [header beginRefreshing];
        // 设置header
        _electricleakageTableView.mj_header = header;
    }
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.electricleakageTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [footer beginRefreshing];
        // 设置header
//        [self requestNext];
        _electricleakageTableView.mj_footer = footer;
    }];
    
}


//-------下拉刷新的请求
- (void)loadNewData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.undervoltageTableView.mj_header isRefreshing]) {
            [self.undervoltageTableView.mj_header endRefreshing];
        }
        if ([self.overvoltageTableView.mj_header isRefreshing]) {
            [self.overvoltageTableView.mj_header endRefreshing];
        }
        if ([self.flowTableView.mj_header isRefreshing]) {
            [self.flowTableView.mj_header endRefreshing];
        }
        if ([self.electricleakageTableView.mj_header isRefreshing]) {
            [self.electricleakageTableView.mj_header endRefreshing];
        }
    });
    
}

-(void)loadMoreData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.undervoltageTableView.mj_footer isRefreshing]) {
            if (self.isUse) {
                [self requesrUsePowerNext];
            }else{
                [self requestPowerNext];
            }
            [self.undervoltageTableView.mj_footer endRefreshing];
        }
        if ([self.overvoltageTableView.mj_footer isRefreshing]) {
            if (self.isUse) {
                [self requesrUsePowerNext];
            }else{
                [self requestPowerNext];
            }

            [self.overvoltageTableView.mj_footer endRefreshing];
        }
        if ([self.flowTableView.mj_footer isRefreshing]) {
            if (self.isUse) {
                [self requesrUsePowerNext];
            }else{
                [self requestPowerNext];
            }

            [self.flowTableView.mj_footer endRefreshing];
        }
        if ([self.electricleakageTableView.mj_footer isRefreshing]) {
            if (self.isUse) {
                [self requesrUsePowerNext];
            }else{
                [self requestPowerNext];
            }

            [self.electricleakageTableView.mj_footer endRefreshing];
        }
    });
    
}


//欠压按钮点击
- (IBAction)UndervoltageBtnClick:(id)sender {
    [_oneBtn setTitleColor:RGBColor(0, 128, 255) forState:UIControlStateNormal];
    [_twoBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_threeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_fourBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset =CGPointMake(0, 0);
    }];
    [_undervoltageTableView reloadData];
}
//过压按钮点击
- (IBAction)OvervoltageBtnClick:(id)sender {
    [_threeBtn setTitleColor:RGBColor(0, 128, 255) forState:UIControlStateNormal];
    [_oneBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_twoBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_fourBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset =CGPointMake(KWidth, 0);
    }];
    [_overvoltageTableView reloadData];
}
//过流按钮点击
- (IBAction)FlowBtnClick:(id)sender {
    [_twoBtn setTitleColor:RGBColor(0, 128, 255) forState:UIControlStateNormal];
    [_threeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_oneBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_fourBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset =CGPointMake(KWidth*2, 0);
    }];
    [_flowTableView reloadData];
}
//漏电按钮点击
- (IBAction)ElectricleakageBtnClick:(id)sender {
    [_fourBtn setTitleColor:RGBColor(0, 128, 255) forState:UIControlStateNormal];
    [_twoBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_threeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_oneBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset =CGPointMake(KWidth*3, 0);
    }];
    [_electricleakageTableView reloadData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        NSUInteger index =scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
        if (index ==0) {
            [self UndervoltageBtnClick:nil];
        }else if(index ==1){
            [self OvervoltageBtnClick:nil];
        }else if (index ==2){
            [self FlowBtnClick:nil];
        }else{
            [self ElectricleakageBtnClick:nil];
        }
    }
}
#pragma mark - scrollView监听
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        CGPoint point =scrollView.contentOffset;
        _line.center = CGPointMake((point.x/KWidth)*(KWidth/4)+KWidth/8, _line.center.y);
    }
    
}

#pragma mark - 数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _undervoltageTableView) {
        return _zeroArr.count;
        
    }else if(tableView == _overvoltageTableView){
        return _oneArr.count;
    }else if (tableView == _flowTableView){
        return _twoArr.count;
    }else{
        return _threeArr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _undervoltageTableView) {
        
        static NSString *ID = @"undervoltageTableView";
        // 2.从缓存池中取出cell
        AlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 3.如果缓存池中没有cell
        if (cell == nil) {
            
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"AlarmTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
            cell.backgroundColor = [UIColor whiteColor];
            AlarmModel *model = _zeroArr[indexPath.row];
            NSString * string = model.created_at;
            string = [string substringToIndex:10];//截取掉下标7之后的字符串
            string = [string substringFromIndex:5];//截取掉下标2之前的字符串
            cell.dataLabel.text = string;
            cell.reasonLabel.text = model.reason;
            cell.valueLabel.text = model.value;
            if ([model.result isEqualToString:@"1"]) {
                cell.resultLabel.text = @"解决";
            }else{
                cell.resultLabel.text = @"解决";
            }
     }
        return cell;
    }else if(tableView == _overvoltageTableView){
        static NSString *ID = @"overvoltageTableView";
        // 2.从缓存池中取出cell
        AlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 3.如果缓存池中没有cell
        if (cell == nil) {
            
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"AlarmTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
            cell.backgroundColor = [UIColor whiteColor];
            AlarmModel *model = _oneArr[indexPath.row];
            NSString * string = model.created_at;
            string = [string substringToIndex:10];//截取掉下标7之后的字符串
            string = [string substringFromIndex:5];//截取掉下标2之前的字符串
            cell.dataLabel.text = string;
            cell.reasonLabel.text = model.reason;
            cell.valueLabel.text = model.value;
            if ([model.result isEqualToString:@"1"]) {
                cell.resultLabel.text = @"解决";
            }else{
                cell.resultLabel.text = @"解决";
            }

        }
        return cell;
    }else if (tableView == _flowTableView){
        static NSString *ID = @"flowTableView";
        // 2.从缓存池中取出cell
        AlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 3.如果缓存池中没有cell
        if (cell == nil) {
            
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"AlarmTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
            cell.backgroundColor = [UIColor whiteColor];
            AlarmModel *model = _twoArr[indexPath.row];
            NSString * string = model.created_at;
            string = [string substringToIndex:10];//截取掉下标7之后的字符串
            string = [string substringFromIndex:5];//截取掉下标2之前的字符串
            cell.dataLabel.text = string;
            cell.reasonLabel.text = model.reason;
            cell.valueLabel.text = model.value;
            if ([model.result isEqualToString:@"1"]) {
                cell.resultLabel.text = @"解决";
            }else{
                cell.resultLabel.text = @"解决";
            }

        }
        return cell;

    }else{
        static NSString *ID = @"electricleakageTableView";
        // 2.从缓存池中取出cell
        AlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 3.如果缓存池中没有cell
        if (cell == nil) {
            
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"AlarmTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
            cell.backgroundColor = [UIColor whiteColor];
            AlarmModel *model = _threeArr[indexPath.row];
            NSString * string = model.created_at;
            string = [string substringToIndex:10];//截取掉下标7之后的字符串
            string = [string substringFromIndex:5];//截取掉下标2之前的字符串
            cell.dataLabel.text = string;
            cell.reasonLabel.text = model.reason;
            cell.valueLabel.text = model.value;
            if ([model.result isEqualToString:@"1"]) {
                cell.resultLabel.text = @"解决";
            }else{
                cell.resultLabel.text = @"解决";
            }

        }
        return cell;

    }
}

- (void)requestPower{
    NSString *URL = [NSString stringWithFormat:@"%@/app/gens/gen/get-alert-list",kUrl];
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
    [parameters setObject:@"1" forKey:@"type"];
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发电报警%@",responseObject);
        NSNumber *code = responseObject[@"result"][@"errorCode"];
        NSString *errorcode = [NSString stringWithFormat:@"%@",code];
        if (!responseObject[@"result"][@"success"]&&![errorcode isEqualToString:@"41111"]) {
                    NSString *str = responseObject[@"result"][@"errorMsg"];
                    [MBProgressHUD showText:str];
                }
        
        if ([errorcode isEqualToString:@"41111"])   {
            [self newLogin];
        }else if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
            [self newLoginTwo];
            

        }else{
            if (!responseObject[@"result"][@"success"]&&![responseObject[@"result"][@"errorCode"] isEqualToString:@"41111"]) {
                NSString *str = responseObject[@"result"][@"errorMsg"];
                [MBProgressHUD showText:str];
            }
            
            if ([responseObject[@"result"][@"errorCode"] isEqualToString:@"41111"])  {
                [self newLogin];
            }else if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
                [self newLoginTwo];
                

            }else{
                 self.next_page_url = responseObject[@"next_page_url"];
                [self.dataArr removeAllObjects];
                for (NSDictionary *goodsDic in responseObject[@"content"][@"data"]) {
                    _model = [[AlarmModel alloc] initWithDictionary:goodsDic];
                    if ([_model.type isEqualToString:@"1"]) {
                        [self.zeroArr addObject:_model];
                    }else if ([_model.type isEqualToString:@"2"]){
                        [self.oneArr addObject:_model];
                    }else if ([_model.type isEqualToString:@"3"]){
                        [self.twoArr addObject:_model];
                    }else if ([_model.type isEqualToString:@"4"]){
                        [self.threeArr addObject:_model];
                    }
                    //                [self.dataArr addObject:_model];
                }
                if (self.zeroArr.count>0) {
                    _noData.hidden = YES;
                }else{
                    _noData.hidden = NO;
                }
                if (self.oneArr.count>0) {
                    _noDataTwo.hidden = YES;
                }else{
                    _noDataTwo.hidden = NO;
                }
                if (self.twoArr.count>0) {
                    _noDataThree.hidden = YES;
                }else{
                    _noDataThree.hidden = NO;
                }
                if (self.threeArr.count>0) {
                    _noDataFour.hidden = YES;
                }else{
                    _noDataFour.hidden = NO;
                }

                [_undervoltageTableView reloadData];
                [_overvoltageTableView reloadData];
                [_flowTableView reloadData];
                [_electricleakageTableView reloadData];
            }

        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];

}

- (void)requestPowerNext{
    if (self.next_page_url) {
        NSString *URL = self.next_page_url;
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
        [parameters setObject:@"1" forKey:@"type"];
        [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"发电报警%@",responseObject);
            if (!responseObject[@"result"][@"success"]&&![responseObject[@"result"][@"errorCode"] isEqualToString:@"41111"]) {
                NSString *str = responseObject[@"result"][@"errorMsg"];
                [MBProgressHUD showText:str];
            }
            
            if ([responseObject[@"result"][@"errorCode"] isEqualToString:@"41111"])  {
                [self newLogin];
            }else if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
                [self newLoginTwo];
                

            }else{
                if (!responseObject[@"result"][@"success"]&&![responseObject[@"result"][@"errorCode"] isEqualToString:@"41111"]) {
                    NSString *str = responseObject[@"result"][@"errorMsg"];
                    [MBProgressHUD showText:str];
                }
                
                if ([responseObject[@"result"][@"errorCode"] isEqualToString:@"41111"])  {
                    [self newLogin];
                }else if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
                    [self newLoginTwo];
                    

                }else{
                    self.next_page_url = responseObject[@"next_page_url"];
                    [self.dataArr removeAllObjects];
                    for (NSDictionary *goodsDic in responseObject[@"content"][@"data"]) {
                        _model = [[AlarmModel alloc] initWithDictionary:goodsDic];
                        if ([_model.type isEqualToString:@"1"]) {
                            [self.zeroArr addObject:_model];
                        }else if ([_model.type isEqualToString:@"2"]){
                            [self.oneArr addObject:_model];
                        }else if ([_model.type isEqualToString:@"3"]){
                            [self.twoArr addObject:_model];
                        }else if ([_model.type isEqualToString:@"4"]){
                            [self.threeArr addObject:_model];
                        }
                        //                [self.dataArr addObject:_model];
                    }
                    

                    [_undervoltageTableView reloadData];
                    [_overvoltageTableView reloadData];
                    [_flowTableView reloadData];
                    [_electricleakageTableView reloadData];
                }
                
            }
        }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
                 NSLog(@"%@",error);  //这里打印错误信息
             }];
        
    }else{
        return;
    }
    
}


- (void)requestUsePower{
    NSString *URL = [NSString stringWithFormat:@"%@/app/expens/expen/get-alert-list",kUrl];
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
        NSLog(@"用电报警%@",responseObject);
        if (!responseObject[@"result"][@"success"]&&![responseObject[@"result"][@"errorCode"] isEqualToString:@"41111"]) {
            NSString *str = responseObject[@"result"][@"errorMsg"];
            [MBProgressHUD showText:str];
        }
        
        if ([responseObject[@"result"][@"errorCode"] isEqualToString:@"41111"])  {
            [self newLogin];
        }else if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
            [self newLoginTwo];
            

        }else{
             self.useNext_page_url = responseObject[@"next_page_url"];
            [self.dataArr removeAllObjects];
            for (NSDictionary *goodsDic in responseObject[@"content"][@"data"]) {
                _model = [[AlarmModel alloc] initWithDictionary:goodsDic];
                if ([_model.type isEqualToString:@"1"]) {
                    [self.zeroArr addObject:_model];
                }else if ([_model.type isEqualToString:@"2"]){
                    [self.oneArr addObject:_model];
                }else if ([_model.type isEqualToString:@"3"]){
                    [self.twoArr addObject:_model];
                }else if ([_model.type isEqualToString:@"4"]){
                    [self.threeArr addObject:_model];
                }
//                [self.dataArr addObject:_model];
            }
            if (self.zeroArr.count>0) {
                _noData.hidden = YES;
            }else{
                _noData.hidden = NO;
            }
            if (self.oneArr.count>0) {
                _noDataTwo.hidden = YES;
            }else{
                _noDataTwo.hidden = NO;
            }
            if (self.twoArr.count>0) {
                _noDataThree.hidden = YES;
            }else{
                _noDataThree.hidden = NO;
            }
            if (self.threeArr.count>0) {
                _noDataFour.hidden = YES;
            }else{
                _noDataFour.hidden = NO;
            }

            [_undervoltageTableView reloadData];
            [_overvoltageTableView reloadData];
            [_flowTableView reloadData];
            [_electricleakageTableView reloadData];
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];

}

- (void)requesrUsePowerNext{
    if (self.useNext_page_url) {
        NSString *URL = self.useNext_page_url;
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
            NSLog(@"用电报警%@",responseObject);
            if (!responseObject[@"result"][@"success"]&&![responseObject[@"result"][@"errorCode"] isEqualToString:@"41111"]) {
                NSString *str = responseObject[@"result"][@"errorMsg"];
                [MBProgressHUD showText:str];
            }
            
            if ([responseObject[@"result"][@"errorCode"] isEqualToString:@"41111"])  {
                [self newLogin];
            }else if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
                [self newLoginTwo];
                

            }else{
                self.useNext_page_url = responseObject[@"next_page_url"];
                [self.dataArr removeAllObjects];
                for (NSDictionary *goodsDic in responseObject[@"content"][@"data"]) {
                    _model = [[AlarmModel alloc] initWithDictionary:goodsDic];
                    if ([_model.type isEqualToString:@"1"]) {
                        [self.zeroArr addObject:_model];
                    }else if ([_model.type isEqualToString:@"2"]){
                        [self.oneArr addObject:_model];
                    }else if ([_model.type isEqualToString:@"3"]){
                        [self.twoArr addObject:_model];
                    }else if ([_model.type isEqualToString:@"4"]){
                        [self.threeArr addObject:_model];
                    }
                    //                [self.dataArr addObject:_model];
                }
                [_undervoltageTableView reloadData];
                [_overvoltageTableView reloadData];
                [_flowTableView reloadData];
                [_electricleakageTableView reloadData];
            }
        }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
                 NSLog(@"%@",error);  //这里打印错误信息
             }];
        
    }else{
        return;
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 22)];
    UILabel *one = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, (KWidth-44)/5, 22)];
    one.text = @"日 期";
    one.font = [UIFont systemFontOfSize:11];
    one.textColor = [UIColor lightGrayColor];
    [header addSubview:one];
    
    UILabel *two = [[UILabel alloc] initWithFrame:CGRectMake(32+(KWidth-44)/5, 0, (KWidth-44)/5, 22)];
    two.text = @"原 因";
    two.font = [UIFont systemFontOfSize:11];
    two.textColor = [UIColor lightGrayColor];
    [header addSubview:two];
    
    UILabel *three = [[UILabel alloc] initWithFrame:CGRectMake(32+(KWidth-44)/5*2, 0, (KWidth-44)/5, 22)];
    three.text = @"漏电量";
    three.font = [UIFont systemFontOfSize:11];
    three.textColor = [UIColor lightGrayColor];
    [header addSubview:three];
    
    UILabel *four = [[UILabel alloc] initWithFrame:CGRectMake(32+(KWidth-44)/5*3, 0, (KWidth-44)/5, 22)];
    four.text = @"处理结果";
    four.font = [UIFont systemFontOfSize:11];
    four.textColor = [UIColor lightGrayColor];
    [header addSubview:four];
    
    UILabel *five = [[UILabel alloc] initWithFrame:CGRectMake(32+(KWidth-44)/5*4, 0, (KWidth-44)/5, 22)];
    five.text = @"查看详情";
    five.font = [UIFont systemFontOfSize:11];
    five.textColor = [UIColor lightGrayColor];
    [header addSubview:five];

    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22;
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

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}

-(NSMutableArray *)oneArr{
    if (!_oneArr) {
        _oneArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _oneArr;
}
-(NSMutableArray *)twoArr{
    if (!_twoArr) {
        _twoArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _twoArr;
}
-(NSMutableArray *)threeArr{
    if (!_threeArr) {
        _threeArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _threeArr;
}
-(NSMutableArray *)zeroArr{
    if (!_zeroArr) {
        _zeroArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _zeroArr;
}
-(AlarmModel *)model{
    if (!_model) {
        _model = [[AlarmModel alloc] init];
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

@end
