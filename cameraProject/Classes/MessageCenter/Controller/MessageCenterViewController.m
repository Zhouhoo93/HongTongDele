//
//  MessageCenterViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/1/5.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "MessageCenterTableViewCell.h"
#import "MJRefresh.h"
#import "AlarmModel.h"
#import "DetailsViewController.h"
#import "LoginViewController.h"
static const CGFloat MJDuration = 2.0;
@interface MessageCenterViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CallDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property(nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) UITableView *helpTableView;
@property (nonatomic,strong) UITableView *beHelpTableView;
@property (nonatomic,strong) NSMutableArray *guzhangArr;
@property (nonatomic,strong) NSMutableArray *yichangArr;
@property (nonatomic,strong) NSMutableArray *yiduArr;
@property (nonatomic,strong) NSMutableArray *weiduArr;
@property (nonatomic,strong) NSString *next_page_url;
@property (nonatomic,strong) UIImageView *noData;
@property (nonatomic,strong) UIImageView *noDataTwo;
@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"消息中心";
    [self request];
    [self setScroll];
    [self addChildViewController];
}

- (void)request{
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
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setValue:@"0" forKey:@"degree"];
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!responseObject[@"result"][@"success"]&&![responseObject[@"result"][@"errorMsg"] isEqualToString:@"token error"]) {
            NSString *str = responseObject[@"result"][@"errorMsg"];
            [MBProgressHUD showText:str];
        }
        
        if ([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token error"])  {
            [self newLogin];
        }else{

        NSLog(@"消息中心%@",responseObject);
        self.next_page_url = responseObject[@"next_page_url"];
        [_yiduArr removeAllObjects];
        [_weiduArr removeAllObjects];
        [_yichangArr removeAllObjects];
        [_guzhangArr removeAllObjects];
        for (NSDictionary *goodsDic in responseObject[@"content"][@"data"]) {
            AlarmModel *model = [[AlarmModel alloc] initWithDictionary:goodsDic];
            if ([model.degree isEqualToString:@"0"]) {
                [self.yichangArr addObject:model];
                if ([model.status isEqualToString:@"0"]) {
                    [self.weiduArr addObject:model];
                }

            }else{
                [self.guzhangArr addObject:model];
                if ([model.status isEqualToString:@"0"]) {
                    [self.weiduArr addObject:model];
                }
            }
            
            //                [self.dataArr addObject:_model];
        }
        if (self.guzhangArr.count>0) {
            _noData.hidden = YES;
        }else{
            _noData.hidden = NO;
        }

        if (self.yichangArr.count>0) {
            _noDataTwo.hidden = YES;
        }else{
            _noDataTwo.hidden = NO;
        }
//        [self setSmallBtn];
        [_helpTableView reloadData];
        [_beHelpTableView reloadData];
        }
    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];

}
- (void)requestNext{
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
        //    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        //    [dic setValue:@"0" forKey:@"degree"];
        [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"消息中心加载更多%@",responseObject);
            self.next_page_url = responseObject[@"next_page_url"];
            for (NSDictionary *goodsDic in responseObject[@"content"][@"data"]) {
                AlarmModel *model = [[AlarmModel alloc] initWithDictionary:goodsDic];
                if ([model.degree isEqualToString:@"0"]) {
                    [self.yichangArr addObject:model];
                    if ([model.status isEqualToString:@"0"]) {
                        [self.weiduArr addObject:model];
                    }
                    
                }else{
                    [self.guzhangArr addObject:model];
                    if ([model.status isEqualToString:@"0"]) {
                        [self.weiduArr addObject:model];
                    }
                }
                
                //                [self.dataArr addObject:_model];
            }
            [_helpTableView reloadData];
            [_beHelpTableView reloadData];
        }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
                 NSLog(@"%@",error);  //这里打印错误信息
             }];

    }else{
        return;
    }
    
}

-(void)setSmallBtn{
    UIButton *left = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/4+15, 10, 16, 14)];
    [left setBackgroundColor:RGBColor(229, 118, 98)];
    [left setTitle:[NSString stringWithFormat:@"%d",_yiduArr.count?_yiduArr.count:0] forState:UIControlStateNormal];
    [left setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    left.titleLabel.font = [UIFont systemFontOfSize:11];
    left.layer.masksToBounds = YES;
    left.layer.cornerRadius = 5;
    [_headerView addSubview:left];
    
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/4*3+15, 10, 16, 14)];
    [right setBackgroundColor:RGBColor(229, 118, 98)];
    [right setTitle:[NSString stringWithFormat:@"%d",_weiduArr.count?_weiduArr.count:0] forState:UIControlStateNormal];
    [right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:11];
    right.layer.masksToBounds = YES;
    right.layer.cornerRadius = 5;
    [_headerView addSubview:right];

}


- (void)setScroll{
    _scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 108, [UIScreen mainScreen].bounds.size.width, KHeight-108)];
    _scrollView.contentSize =CGSizeMake(2*[UIScreen mainScreen].bounds.size.width, KHeight-108);
    _scrollView.delegate =self;
    _scrollView.bounces =NO;
    _scrollView.pagingEnabled =YES;
    [self.view addSubview:_scrollView];
}

- (void)addChildViewController{
    _helpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-108 ) style:UITableViewStylePlain];
    _helpTableView.delegate = self;
    _helpTableView.dataSource = self;
    _helpTableView.backgroundColor = [UIColor whiteColor];
    _helpTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _helpTableView.backgroundColor = RGBColor(245, 245, 245);
    _noData = [[UIImageView alloc] init];
    _noData.image = [UIImage imageNamed:@"暂无报警消息"];
    _noData.frame = _helpTableView.frame;
    [_helpTableView addSubview:_noData];
    [_scrollView addSubview:_helpTableView];
    [self setRefreshLeft];
    
    _beHelpTableView = [[UITableView alloc] initWithFrame:CGRectMake(KWidth, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-108) style:UITableViewStylePlain];
    _beHelpTableView.delegate = self;
    _beHelpTableView.dataSource = self;
    _beHelpTableView.backgroundColor = [UIColor whiteColor];
    _beHelpTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _beHelpTableView.backgroundColor = RGBColor(245, 245, 245);
    _noDataTwo = [[UIImageView alloc] init];
    _noDataTwo.image = [UIImage imageNamed:@"暂无报警消息"];
    _noDataTwo.frame = _helpTableView.frame;
    [_beHelpTableView addSubview:_noDataTwo];
    [_scrollView addSubview:_beHelpTableView];
    [self setRefreshRight];
}

-(void)setRefreshLeft{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 马上进入刷新状态
    //    [header beginRefreshing];
    // 设置header
    if (![_helpTableView.mj_header isRefreshing]) {
        [header beginRefreshing];
        // 设置header
        _helpTableView.mj_header = header;
    }
    
     MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.helpTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        if (![_helpTableView.mj_header isRefreshing]) {
            [footer beginRefreshing];
            // 设置header
            [self requestNext];
            _helpTableView.mj_footer = footer;
        }

    }];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
   
    
}

-(void)setRefreshRight{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 马上进入刷新状态
    //    [header beginRefreshing];
    if (![_beHelpTableView.mj_header isRefreshing]) {
        [header beginRefreshing];
        // 设置header
        _beHelpTableView.mj_header = header;
    }
    self.beHelpTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.beHelpTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

}

//-------下拉刷新的请求
- (void)loadNewData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.helpTableView.mj_header isRefreshing]) {
            [self request];
            [self.helpTableView.mj_header endRefreshing];
        }
        if ([self.beHelpTableView.mj_header isRefreshing]) {
            [self request];
            [self.beHelpTableView.mj_header endRefreshing];
        }
    });
}

-(void)loadMoreData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.helpTableView.mj_footer isRefreshing]) {
            [self requestNext];
            [self.helpTableView.mj_footer endRefreshing];
        }
        if ([self.beHelpTableView.mj_footer isRefreshing]) {
            [self requestNext];
            [self.beHelpTableView.mj_footer endRefreshing];
        }
    });

}



- (IBAction)HelpPeopleBtnClick:(id)sender {
    [_leftBtn setTitleColor:RGBColor(0, 128, 255) forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset =CGPointMake(0, 0);
    }];
    [_helpTableView reloadData];
}

- (IBAction)BeHelpPeopleBtnClick:(id)sender {
    [_leftBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:RGBColor(0, 128, 255) forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset =CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
    }];
    [_beHelpTableView reloadData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        NSUInteger index =scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
        if (index == 0) {
            [self HelpPeopleBtnClick:nil];
        }else{
            [self BeHelpPeopleBtnClick:nil];
        }
    }
}

- (void)Call{
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否拨打客服电话" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"18868808245"];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _helpTableView) {
        return _guzhangArr.count?_guzhangArr.count:0;
        
    }else{
        return _yichangArr.count?_yichangArr.count:0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _helpTableView) {
        AlarmModel *model = _guzhangArr[indexPath.row];
        static NSString *ID = @"leftTableViewCell";
        // 2.从缓存池中取出cell
        MessageCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 3.如果缓存池中没有cell
        if (cell == nil) {
            
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MessageCenterTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
            cell.delegate = self;
            cell.backgroundColor = [UIColor clearColor];
            NSString * string = model.created_at;
            string = [string substringToIndex:10];//截取掉下标7之后的字符串
            string = [string substringFromIndex:5];
            cell.dateLabel.text = string;
            cell.reasonLabel.text = model.reason;
            if ([model.result isEqualToString:@"1"]) {
                cell.resultLabel.text = @"解决";
            }else{
                cell.resultLabel.text = @"解决";
            }
            cell.valueLabel.text = model.value;
            
        }
        return cell;
    }else{
        AlarmModel *model = _yichangArr[indexPath.row];
        static NSString *ID = @"rightTableViewCell";
        // 2.从缓存池中取出cell
        MessageCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 3.如果缓存池中没有cell
        if (cell == nil) {
            
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MessageCenterTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
            cell.delegate = self;
            cell.backgroundColor = [UIColor clearColor];
            NSString * string = model.created_at;
            string = [string substringToIndex:10];//截取掉下标7之后的字符串
            string = [string substringFromIndex:5];
            cell.dateLabel.text = string;
            cell.reasonLabel.text = model.reason;
            if ([model.result isEqualToString:@"1"]) {
                cell.resultLabel.text = @"解决";
            }else{
                cell.resultLabel.text = @"解决";
            }
            
            cell.valueLabel.text = model.value;
        }
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 22)];
    UILabel *one = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, (KWidth-44)/5-20, 22)];
    one.text = @"日 期";
    one.font = [UIFont systemFontOfSize:11];
    one.textColor = [UIColor lightGrayColor];
    one.textAlignment = NSTextAlignmentLeft;
    [header addSubview:one];
    
    UILabel *two = [[UILabel alloc] initWithFrame:CGRectMake(32+(KWidth-44)/5-20, 0, (KWidth-44)/5, 22)];
    two.text = @"故障原因";
    two.font = [UIFont systemFontOfSize:11];
    two.textColor = [UIColor lightGrayColor];
    two.textAlignment = NSTextAlignmentLeft;
    [header addSubview:two];
    
    UILabel *three = [[UILabel alloc] initWithFrame:CGRectMake(32+(KWidth-44)/5*2-20, 0, (KWidth-44)/5+20, 22)];
    three.text = @"漏电/气/水量";
    three.font = [UIFont systemFontOfSize:11];
    three.textColor = [UIColor lightGrayColor];
    three.textAlignment = NSTextAlignmentCenter;
    [header addSubview:three];
    
    UILabel *four = [[UILabel alloc] initWithFrame:CGRectMake(32+(KWidth-44)/5*3, 0, (KWidth-44)/5, 22)];
    four.text = @"处理结果";
    four.font = [UIFont systemFontOfSize:11];
    four.textColor = [UIColor lightGrayColor];
    four.textAlignment = NSTextAlignmentCenter;
    [header addSubview:four];
    
    UILabel *five = [[UILabel alloc] initWithFrame:CGRectMake(32+(KWidth-44)/5*4, 0, (KWidth-44)/5, 22)];
    five.text = @"解决方式";
    five.font = [UIFont systemFontOfSize:11];
    five.textColor = [UIColor lightGrayColor];
    five.textAlignment = NSTextAlignmentCenter;
    [header addSubview:five];
    
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _helpTableView) {
        DetailsViewController *VC = [[DetailsViewController alloc] init];
        AlarmModel *model = _guzhangArr[indexPath.row];
        VC.pid = model.pid;
        VC.ID = model.ID;
        VC.text = model.reason;
        [self.navigationController pushViewController:VC animated:YES];

    }else{
        DetailsViewController *VC = [[DetailsViewController alloc] init];
        AlarmModel *model = _yichangArr[indexPath.row];
        VC.pid = model.pid;
        VC.ID = model.ID;
        VC.text = model.reason;
        [self.navigationController pushViewController:VC animated:YES];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)guzhangArr{
    if (!_guzhangArr) {
        _guzhangArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _guzhangArr;
}

-(NSMutableArray *)yichangArr{
    if (!_yichangArr) {
        _yichangArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _yichangArr;
}

-(NSMutableArray *)yiduArr{
    if (!_yiduArr) {
        _yiduArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _yiduArr;
}
-(NSMutableArray *)weiduArr{
    if (!_weiduArr) {
        _weiduArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _weiduArr;
}

- (void)newLogin{
    [MBProgressHUD showText:@"请重新登录"];
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
