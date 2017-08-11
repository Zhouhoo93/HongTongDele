//
//  ContactsViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 16/12/21.
//  Copyright © 2016年 ziHou. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsTableViewCell.h"
#import "MJRefresh.h"
#import "ContactModel.h"
#import "PeopleModel.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
static const CGFloat MJDuration = 0.5;
@interface ContactsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *helpPeopleBtn;
@property (weak, nonatomic) IBOutlet UIButton *beHelpPeopleBtn;
@property (weak, nonatomic) IBOutlet UIView *blueLine;
@property(nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) UITableView *helpTableView;
@property (nonatomic,strong) UITableView *beHelpTableView;
@property (nonatomic,strong) ContactModel * model;
@property (nonatomic,strong) NSMutableArray * listArr;
@property (nonatomic,strong) UIImageView *noData;
@property (nonatomic,strong) UIImageView *noDataTwo;
@property (nonatomic,strong) NSString *next_page_url;
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"紧急联系人设置";
    [self setScroll];
    [self setNavigationController];
    [self addChildViewController];
    [self setHidesBottomBarWhenPushed:YES];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToHome) name:@"backToHome" object:nil];
//    [self.navigationItem.leftBarButtonItem setAction:@selector(pop)];
    // Do any additional setup after loading the view, typically from a nib.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}

- (void)setNavigationController {
    //    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:self.tableView.contentOffset.y / 100]] forBarMetrics:UIBarMetricsDefault];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setScroll{
    _scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 108, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _scrollView.contentSize =CGSizeMake(2*[UIScreen mainScreen].bounds.size.width, 0);
    _scrollView.delegate =self;
    _scrollView.bounces =NO;
    _scrollView.pagingEnabled =YES;
    [self.view addSubview:_scrollView];
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
        [self requestList];
        // 设置header
        _beHelpTableView.mj_header = header;
    }
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.beHelpTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        if (![_beHelpTableView.mj_header isRefreshing]) {
            [footer beginRefreshing];
            // 设置header
            [self requestNext];
            _beHelpTableView.mj_footer = footer;
        }
        
    }];

}


//-------下拉刷新的请求
- (void)loadNewData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.helpTableView.mj_header isRefreshing]) {
            [self.helpTableView.mj_header endRefreshing];
        }
        if ([self.beHelpTableView.mj_header isRefreshing]) {
            [self.beHelpTableView.mj_header endRefreshing];
        }
    });
    
}

-(void)loadMoreData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.beHelpTableView.mj_footer isRefreshing]) {
            [self requestNext];
            [self.beHelpTableView.mj_footer endRefreshing];
        }
    });
    
}


- (void)addChildViewController{
    _helpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-108 ) style:UITableViewStylePlain];
    _helpTableView.delegate = self;
    _helpTableView.dataSource = self;
    _helpTableView.backgroundColor = [UIColor whiteColor];
    _helpTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _helpTableView.tableFooterView = [[UIView alloc] init];
//    _noData = [[UIImageView alloc] init];
//    _noData.image = [UIImage imageNamed:@"暂无求助人"];
//    _noData.frame = _helpTableView.frame;
//    [_helpTableView addSubview:_noData];
//    [self.helpTableView registerClass:[ContactsTableViewCell class] forCellReuseIdentifier:ContactsTableViewCell];
    [self setRefreshLeft];
    [_scrollView addSubview:_helpTableView];
    
    _beHelpTableView = [[UITableView alloc] initWithFrame:CGRectMake(KWidth, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    _beHelpTableView.delegate = self;
    _beHelpTableView.dataSource = self;
    _beHelpTableView.backgroundColor = [UIColor whiteColor];
    _beHelpTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _noDataTwo = [[UIImageView alloc] init];
    _noDataTwo.image = [UIImage imageNamed:@"暂无求助人"];
    _noDataTwo.frame = _helpTableView.frame;
    [_beHelpTableView addSubview:_noDataTwo];
    _beHelpTableView.tableFooterView = [[UIView alloc] init];
    [_scrollView addSubview:_beHelpTableView];
    [self setRefreshRight];
}

- (IBAction)helpPeopleBtnClick:(id)sender {
    [_helpPeopleBtn setTitleColor:RGBColor(0, 128, 255) forState:UIControlStateNormal];
    [_beHelpPeopleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset =CGPointMake(0, 0);
    }];
    [_helpTableView reloadData];

}
- (IBAction)beHelpPeopleBtnClick:(id)sender {
    [_helpPeopleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_beHelpPeopleBtn setTitleColor:RGBColor(0, 128, 255) forState:UIControlStateNormal];    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset =CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
    }];
    [_beHelpTableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)requestList{
    NSString *URL = [NSString stringWithFormat:@"%@/app/users/user/get-accept-list",kUrl];
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
        NSLog(@"申请列表%@",responseObject);
        self.next_page_url = responseObject[@"next_page_url"];
//        if (responseObject[@"result"][@"success"]&&![responseObject[@"result"][@"errorMsg"] isEqualToString:@"token error"]) {
//            NSString *str = responseObject[@"result"][@"errorMsg"];
//            [MBProgressHUD showText:str];
//        }
        [self.listArr removeAllObjects];
        if ([responseObject[@"result"][@"errorCode"] isEqualToString:@"41111"])  {
            [self newLogin];
        }else if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
            [self newLoginTwo];
            

        }else{
        for (NSDictionary *dic in responseObject[@"content"][@"data"]) {
            self.model = [[ContactModel alloc] initWithDictionary:dic];
            [self.listArr addObject:_model];
            NSLog(@"%@",self.model);
        }
            if (self.listArr.count>0) {
                _noDataTwo.hidden = YES;
            }else{
                _noDataTwo.hidden = NO;
            }
        NSLog(@"%lu",(unsigned long)self.listArr.count);
        [_beHelpTableView reloadData];
        if ([_beHelpTableView.mj_header isRefreshing]) {
            [_beHelpTableView.mj_header endRefreshing];
        }
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
                ContactModel *model = [[ContactModel alloc] initWithDictionary:goodsDic];
                    [self.listArr addObject:model];
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



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        NSUInteger index =scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
        if (index == 0) {
            [self helpPeopleBtnClick:nil];
        }else{
            [self beHelpPeopleBtnClick:nil];
        }
    }
}
#pragma mark - scrollView监听
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        CGPoint point =scrollView.contentOffset;
        _blueLine.center = CGPointMake(point.x/2 + [UIScreen mainScreen].bounds.size.width/4, _blueLine.center.y);
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == _scrollView) {
        NSInteger x = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
        if (x) {
            [_helpPeopleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [_beHelpPeopleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }else{
            [_helpPeopleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_beHelpPeopleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
        
    }
}

#pragma mark - 数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _helpTableView) {
        return [self.sortedArrForArrays count]?[self.sortedArrForArrays count]:1;
    }else{
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _helpTableView) {
        return [[self.sortedArrForArrays objectAtIndex:section] count]?[[self.sortedArrForArrays objectAtIndex:section] count]:0;
        
    }else{
        return _listArr.count ? _listArr.count : 0;
    }
}
//侧边栏
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == _helpTableView){
      return self.tableHeaderArray;
    }
    return nil;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [self.tableHeaderArray objectAtIndex:section];
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _helpTableView) {
        
        static NSString *ID = @"ContactsTableViewCell";
        // 2.从缓存池中取出cell
        ContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 3.如果缓存池中没有cell
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ContactsTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
            cell.backgroundColor = [UIColor clearColor];
            cell.touImage.layer.masksToBounds = YES;
            cell.touImage.layer.cornerRadius = 20;
//            cell.nameLabel.text = @"111";
            cell.leftBtn.hidden = YES;
            cell.midView.hidden = YES;
            [cell.rightBtn setTitle:@"添加" forState:UIControlStateNormal];
            [cell.rightBtn setTitleColor:RGBColor(100, 194, 102) forState:UIControlStateNormal];
//            cell.textLabel1.text = @"1111111111111";
            cell.isHelpTable = YES;
            cell.bid = self.bid;
            if(self.sortedArrForArrays.count > indexPath.section){
                NSArray *array = [self.sortedArrForArrays objectAtIndex:indexPath.section];
                if (array.count > indexPath.row) {
                    PeopleModel *linkManModel = [array objectAtIndex:indexPath.row];
                    cell.nameLabel.text = linkManModel.name;
                    if (linkManModel.phones.count == 0) {
                        return cell;
                    }
                    NSArray *array = [linkManModel.phones objectAtIndex:0];
                    cell.textLabel1.text = [NSString stringWithFormat:@"%@", [array objectAtIndex:1]];
//                    cell.headImageView.image = [UIImage imageWithData:linkManModel.headImage];
//                    if (!linkManModel.headImage) {
//                        cell.headImageView.image = [UIImage imageNamed:@"headImage"];
//                    }

                }
            }
        }
        return cell;
    }else{
        static NSString *ID = @"beHelpTableViewCell";
        // 2.从缓存池中取出cell
        ContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 3.如果缓存池中没有cell
        if (cell == nil) {
            ContactModel *model = [[ContactModel alloc] init];
            model = _listArr[indexPath.row];
            
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ContactsTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
            cell.backgroundColor = [UIColor clearColor];
            cell.touImage.layer.masksToBounds = YES;
            cell.touImage.layer.cornerRadius = 20;
            UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.from_headimgurl]]];
            cell.touImage.image = image;
            cell.nameLabel.text = model.from_tel?model.from_tel:@"---";
            
            cell.ID = model.ID;
            cell.from_id = model.from_id;
            cell.isHelpTable = NO;
            if ([model.status isEqualToString:@"0"]) {
                [cell.leftBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [cell.rightBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
                cell.leftBtn.enabled = NO;
                cell.rightBtn.enabled = NO;
            }else if ([model.status isEqualToString:@"1"]) {
                [cell.rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [cell.leftBtn setTitle:@"已接受" forState:UIControlStateNormal];
                cell.leftBtn.enabled = NO;
                cell.rightBtn.enabled = NO;
            }else if ([model.status isEqualToString:@"2"]) {
                cell.leftBtn.enabled = YES;
                cell.rightBtn.enabled = YES;
            }else{
                [cell.leftBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [cell.rightBtn setTitle:@"待同步" forState:UIControlStateNormal];
                cell.leftBtn.enabled = NO;
                cell.rightBtn.enabled = NO;
            }
        }
        return cell;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}

-(ContactModel *)model{
    if (!_model) {
        _model = [[ContactModel alloc] init];
    }
    return _model;
}

-(NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _listArr;
}

- (NSMutableArray *)linkManArray{
    if (_linkManArray == nil) {
        _linkManArray = [[NSMutableArray alloc] init];
    }
    return _linkManArray;
}
- (NSMutableArray *)tableHeaderArray{
    if (_tableHeaderArray == nil) {
        _tableHeaderArray = [[NSMutableArray alloc] init];
    }
    return _tableHeaderArray;
}
- (NSMutableArray *)sortedArrForArrays{
    if (_sortedArrForArrays == nil) {
        _sortedArrForArrays = [[NSMutableArray alloc] init];
    }
    return _sortedArrForArrays;
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
    [userDefaults setValue:nil forKey:@"registerid"];
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
