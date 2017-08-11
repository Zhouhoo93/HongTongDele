//
//  MedicalViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 16/12/20.
//  Copyright © 2016年 ziHou. All rights reserved.
//

#import "MedicalViewController.h"
#import "MedicalTableViewCell.h"
#import "ContactsViewController.h"
#import "MJRefresh.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ICPinyinGroup.h"
#import "MedicalModel.h"
#import "PeopleModel.h"
#import "tabTableViewCell.h"
#import "tabModel.h"
#import "TransparentController.h"
#import "PopoverView.h"
#import "AdministrationModel.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import "MJExtension.h"
static const CGFloat MJDuration = 2.0;

@interface MedicalViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,ABPeoplePickerNavigationControllerDelegate,daohangDelegate,reloadDelegate>
@property(nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) UITableView *helpTableView;
@property (nonatomic,strong) UITableView *beHelpTableView;
@property (nonatomic,strong) UITableView *tab;
@property (weak, nonatomic) IBOutlet UIButton *helpPeopleBtn;
@property (weak, nonatomic) IBOutlet UIButton *beHelpPeopleBtn;
@property (weak, nonatomic) IBOutlet UIView *blueLine;
@property (nonatomic,strong) UIButton *quanXuanBtn;
@property (nonatomic,assign)BOOL isQuanXuan;
@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString *latitude;
@property (nonatomic,copy) NSString *straight_line_distance;
@property (nonatomic,copy) NSString *helpstraight_line_distance;
@property (nonatomic,strong) NSMutableArray *straight_line_distanceArr;
@property (nonatomic,copy) NSString *actual_distance;
@property (nonatomic,copy) NSString *helpactual_distance;
@property (nonatomic,strong) NSMutableArray *actual_distanceArr;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,strong)NSMutableArray *nameArr;
@property (nonatomic,strong)NSMutableArray *beHelpArr;
@property (nonatomic,strong) MedicalModel * AllModel;
@property (nonatomic,strong)NSMutableArray *tabArr;
@property (nonatomic,strong)NSMutableArray *statusArr;
@property (nonatomic,strong)tabModel *tabmodel;
@property (nonatomic,strong) NSMutableArray *linkManArray;
@property (nonatomic,strong) NSMutableArray *tableHeaderArray;
@property (nonatomic,strong) NSMutableArray *sortedArrForArrays;
@property (nonatomic,strong) NSMutableArray *shebeiArr;
@property (nonatomic,strong) AdministrationModel *adminModel;
@property (nonatomic,copy) NSString *bid;
@property (nonatomic,copy) NSString *helpid;
@property (nonatomic,strong) NSMutableArray *quanXuanArr;
@property (nonatomic,strong) UIImageView *noData;
@property (nonatomic,strong) UIImageView *noDataTwo;
@property (nonatomic,strong) distanceModel *model;
@property (nonatomic,assign) NSInteger counti;
@property (nonatomic,assign)BOOL isXiangYin;
@property (nonatomic,assign)BOOL isFirstComing;
@property (nonatomic ,strong)dispatch_source_t timer;//  注意:此处应该使用强引用 strong
@property (nonatomic,strong) NSTimer *myTimer;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) UIButton *callButton;
@property (nonatomic,assign) BOOL isYingJian;
@property (nonatomic,strong) NSMutableArray *hujiaoResult;
@property (nonatomic,strong) NSMutableArray *contentArr;
@property (nonatomic,assign) BOOL isTongYi;
@end

@implementation MedicalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isXiangYin = NO;
    [self setScroll];
    [self loadPresion];
    self.isTongYi = YES;
    self.isFirstComing = YES;
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"医疗救助";
    [self setNavigationController];
    self.delegate = self;
    [self addChildViewController];
    [self setHidesBottomBarWhenPushed:YES];
    // Do any additional setup after loading the view, typically from a nib.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]
                                 initWithTitle:@""
                                 style:UIBarButtonItemStyleBordered
                                 target:self
                                 action:@selector(backView)];
    rightBtn.image = [UIImage imageNamed:@"medicalhelper_setting"];
    //    UIBarButtonItem *righttwoBtn = [[UIBarButtonItem alloc]
    //                                 initWithTitle:@""
    //                                 style:UIBarButtonItemStyleBordered
    //                                 target:self
    //                                    action:@selector(popView:)];
    //    righttwoBtn.image = [UIImage imageNamed:@"medicalhelper_setting"];
    //    NSArray *buttonArray = [[NSArray alloc]initWithObjects:rightBtn,righttwoBtn, nil];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.isQuanXuan = NO;
//        [self stopSerialLocation];
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self requestSheBeiList];
    
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoJieshou) name:@"jieshou" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}

-(void)gotoJieshou{
    
    self.count = 0;
    dispatch_queue_t queue = dispatch_get_main_queue();

    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 20.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);

    dispatch_source_set_event_handler(timer, ^{
        self.count++;
        [self requestBeHelpList];
        NSInteger dis = [self.straight_line_distance integerValue];
        if (dis>0) {
            if(_count==600){
                dispatch_cancel(self.timer);
                //                    NSLog(@"取消定时器");
            }

        }
        
    });
    
    //4.开始执行
    dispatch_resume(timer);
    
    //
    self.timer = timer;

    self.isXiangYin = YES;
    [self.beHelpTableView reloadData];
}
//上传距离
-(void)requestAddress{
    [HSingleGlobalData sharedInstance].actual_distance = self.actual_distance;
    [HSingleGlobalData sharedInstance].straight_line_distance = self.straight_line_distance;
    
    NSString *URL = [NSString stringWithFormat:@"%@/api/alert/upload-data-about-app-alert",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //    [parameters setValue:[HSingleGlobalData sharedInstance].registerid forKey:@"from_registration_id"];
    [parameters setValue:self.helpid forKey:@"id"];
    [parameters setValue:self.city forKey:@"city"];
    if (!self.actual_distance||[self.actual_distance isEqualToString:@""]) {
        [parameters setValue:@"0" forKey:@"actual_distance"];
    }else{
        [parameters setValue:self.actual_distance forKey:@"actual_distance"];
    }
    
    [parameters setValue:self.straight_line_distance forKey:@"straight_line_distance"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    NSLog(@"%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"距离上传正确%@",responseObject);
        NSNotification *notice = [NSNotification notificationWithName:@"jieshou" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notice];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
        [MBProgressHUD showText:@"响应失败,请重新响应"];
    }];
    
}

-(void)requestAddressYingJian{
    [HSingleGlobalData sharedInstance].actual_distance = self.actual_distance;
    [HSingleGlobalData sharedInstance].straight_line_distance = self.straight_line_distance;
    
    NSString *URL = [NSString stringWithFormat:@"%@/api/alert/upload-data-about-equipment-app-alert",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //    [parameters setValue:[HSingleGlobalData sharedInstance].registerid forKey:@"from_registration_id"];
    [parameters setValue:self.helpid forKey:@"id"];
//     [parameters setValue:self.city forKey:@"city"];
    if (!self.actual_distance||[self.actual_distance isEqualToString:@""]) {
        [parameters setValue:@"0" forKey:@"actual_distance"];
    }else{
        [parameters setValue:self.actual_distance forKey:@"actual_distance"];
    }
    
    [parameters setValue:self.straight_line_distance?self.straight_line_distance:@"" forKey:@"straight_line_distance"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    NSLog(@"%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"距离上传正确%@",responseObject);
        NSNotification *notice = [NSNotification notificationWithName:@"jieshou" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notice];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        [MBProgressHUD showText:@"响应失败,请重新响应"];
    }];
    
}



- (void)backView{
    ContactsViewController *VC = [[ContactsViewController alloc] initWithNibName:@"ContactsViewController" bundle:nil];
    VC.linkManArray = self.linkManArray;
    VC.tableHeaderArray = self.tableHeaderArray;
    VC.sortedArrForArrays = self.sortedArrForArrays;
    VC.bid = self.bid;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)popView:(UIButton *)button{
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.showShade = YES; // 显示阴影背景
    [popoverView showToView:button withActions:[self QQActions]];
}
//获取设备列表
- (NSArray<PopoverAction *> *)QQActions {
    // 发起多人聊天 action
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *name = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<_shebeiArr.count; i++) {
        AdministrationModel *model = _shebeiArr[i];
        [name addObject:model.name];
        PopoverAction *multichatAction = [PopoverAction actionWithImage:nil title:[NSString stringWithFormat:@"%@",name[i]] handler:^(PopoverAction *action) {
#pragma mark - 该Block不会导致内存泄露, Block内代码无需刻意去设置弱引用.
            //        _noticeLabel.text = action.title;
            self.bid =model.bid;
            [self.delegate pushSheBei];
        }];
        [list addObject:multichatAction];
    }
    
    return list;
}

-(void)pushSheBei{
    NSLog(@"切换设备");
    
    [self.tab reloadData];
    [_helpTableView reloadData];
    [_beHelpTableView reloadData];
}

- (void)setNavigationController {
    //    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:self.tableView.contentOffset.y / 100]] forBarMetrics:UIBarMetricsDefault];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"center_background"];
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 0)];
    [_scrollView addSubview:view];
    _helpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-108 ) style:UITableViewStyleGrouped];
    _helpTableView.delegate = self;
    _helpTableView.dataSource = self;
    _helpTableView.backgroundColor = [UIColor whiteColor];
    _helpTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _noData = [[UIImageView alloc] init];
    _noData.image = [UIImage imageNamed:@"暂无求助请求"];
    _noData.frame = _helpTableView.frame;
    [_helpTableView addSubview:_noData];
    [_scrollView addSubview:_helpTableView];
    [self setRefreshLeft];
    
    _beHelpTableView = [[UITableView alloc] initWithFrame:CGRectMake(KWidth, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-108) style:UITableViewStylePlain];
    _beHelpTableView.delegate = self;
    _beHelpTableView.dataSource = self;
    _beHelpTableView.backgroundColor = [UIColor whiteColor];
    _beHelpTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _noDataTwo = [[UIImageView alloc] init];
    _noDataTwo.image = [UIImage imageNamed:@"暂无求助请求"];
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
        //        [header beginRefreshing];
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
        //        [header beginRefreshing];
        // 设置header
        _beHelpTableView.mj_header = header;
    }
}


//-------下拉刷新的请求
- (void)loadNewData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.helpTableView.mj_header isRefreshing]) {
            [self requestHelpList];
            [self requestSmallList];
            [self.helpTableView.mj_header endRefreshing];
        }
        if ([self.beHelpTableView.mj_header isRefreshing]) {
            [self requestBeHelpList];
            [self.beHelpTableView.mj_header endRefreshing];
        }
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)HelpPeopleBtnClick:(id)sender {
    [_helpPeopleBtn setTitleColor:RGBColor(0, 128, 255) forState:UIControlStateNormal];
    [_beHelpPeopleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset =CGPointMake(0, 0);
    }];
    //    [_helpTableView reloadData];
}
- (IBAction)BeHelpPeopleBtnClick:(id)sender {
    [_helpPeopleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_beHelpPeopleBtn setTitleColor:RGBColor(0, 128, 255) forState:UIControlStateNormal];
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset =CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
    }];
    //    [_beHelpTableView reloadData];
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
            //            [_helpPeopleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [_beHelpPeopleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }else{
            [_helpPeopleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            //            [_beHelpPeopleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _helpTableView) {
        return _nameArr.count?_nameArr.count:0;
        
    }else if(tableView == _beHelpTableView){
        return _beHelpArr.count?_beHelpArr.count:0;
    }else{
        return _tabArr.count?_tabArr.count:0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _helpTableView) {
        MedicalModel *model = _nameArr[indexPath.row];
        static NSString *ID = @"helpTableViewCell";
        // 2.从缓存池中取出cell
        MedicalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 3.如果缓存池中没有cell
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MedicalTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
            cell.backgroundColor = [UIColor clearColor];
            cell.isTongYi = self.isTongYi;
            [cell.rightBtn setTitle:@"呼叫" forState:UIControlStateNormal];
            cell.rightLabel.text = @"状态";
            cell.touImage.layer.masksToBounds = YES;
            cell.touImage.layer.cornerRadius = 20;
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.headimgurl]];
            //然后就是添加照片语句，这次不是`imageWithName`了，是 imageWithData。
            cell.touImage.image = [UIImage imageWithData:data];
            cell.longitude = self.longitude;
            cell.latitude = self.latitude;
            cell.city = self.city;
            cell.name = model.name;
            cell.isHelpTable = YES;
            cell.nameLabel.text = model.name?model.name:@"--";
            cell.registration_id = model.registration_id?model.registration_id:@"";
            cell.addressLabel.text = model.phone?[NSString stringWithFormat:@"电话:%@",model.phone]:@"----";
            cell.dongHuaImage.hidden = YES;
            cell.lianXuhujiao = NO;
            if (![self.straight_line_distance isEqualToString:@""]&&![self.straight_line_distance isEqualToString:@"-1"]) {
                cell.rightBtn.selected = YES;
                cell.dongHuaImage.hidden = NO;
            }
            cell.helper_id = model.helper_id;
            cell.xiangYingLabel.text = @"软件呼叫";
//            cell.xiangYingLabel.hidden= YES;
            
        }
        if (self.straight_line_distance&&self.straight_line_distance.length>0&&![self.straight_line_distance isEqualToString:@"-1"]) {
            cell.lineLabel.text = self.straight_line_distance;
            cell.actualLabel.text = self.actual_distance;
            //            [cell.rightBtn setTitle:@"响应" forState:UIControlStateNormal];
            cell.rightBtn.selected = YES;
            cell.dongHuaImage.hidden = NO;
            NSMutableArray  *arrayM=[NSMutableArray array];
            for (int i=0; i<3; i++) {
                [arrayM addObject:[UIImage imageNamed:[NSString stringWithFormat:@"app_loading_%zd",i+1]]];
            }
            //设置动画数组
            [cell.dongHuaImage setAnimationImages:arrayM];
            //设置动画播放次数
            [cell.dongHuaImage setAnimationRepeatCount:0];
            //设置动画播放时间
            [cell.dongHuaImage setAnimationDuration:6*0.075];
            //开始动画
            [cell.dongHuaImage startAnimating];
            [cell.smallBtn setTitle:@"已响应" forState:UIControlStateNormal];

        }else{
            
        }
        if (self.actual_distance&&self.actual_distance.length>0) {
            cell.actualLabel.text = self.actual_distance;
        }
        if (self.straight_line_distance&&self.straight_line_distance.length>0) {
            cell.lineLabel.text = self.straight_line_distance;
        }
        cell.daohangDelegate = self;
        cell.deleBtn.tag = indexPath.row;
        if(self.isQuanXuan&&![self.straight_line_distance isEqualToString:@"-1"]&&![self.straight_line_distance isEqualToString:@""]){
            cell.rightBtn.selected = YES;
            cell.dongHuaImage.hidden = NO;
            NSMutableArray  *arrayM=[NSMutableArray array];
            for (int i=0; i<3; i++) {
                [arrayM addObject:[UIImage imageNamed:[NSString stringWithFormat:@"app_loading_%zd",i+1]]];
            }
            //设置动画数组
            [cell.dongHuaImage setAnimationImages:arrayM];
            //设置动画播放次数
            [cell.dongHuaImage setAnimationRepeatCount:0];
            //设置动画播放时间
            [cell.dongHuaImage setAnimationDuration:6*0.075];
            //开始动画
            [cell.dongHuaImage startAnimating];
            [cell.smallBtn setTitle:@"未响应" forState:UIControlStateNormal];

//            [cell.rightBtn setTitle:@"取消" forState:UIControlStateNormal];
        }else{
            cell.rightBtn.selected = NO;
            [cell.rightBtn setTitle:@"呼叫" forState:UIControlStateNormal];
        }
        if (self.straight_line_distance.length>0) {
            [cell.smallBtn setTitle:@"已响应" forState:UIControlStateNormal];
        }
        if ([self.straight_line_distance isEqualToString:@""]) {
            [cell.smallBtn setTitle:@"未响应" forState:UIControlStateNormal];

        }

            if (self.hujiaoResult.count>0) {
                cell.rightBtn.selected = YES;
                cell.dongHuaImage.hidden = NO;
                NSMutableArray  *arrayM=[NSMutableArray array];
                for (int i=0; i<3; i++) {
                    [arrayM addObject:[UIImage imageNamed:[NSString stringWithFormat:@"app_loading_%zd",i+1]]];
                }
                //设置动画数组
                [cell.dongHuaImage setAnimationImages:arrayM];
                //设置动画播放次数
                [cell.dongHuaImage setAnimationRepeatCount:0];
                //设置动画播放时间
                [cell.dongHuaImage setAnimationDuration:6*0.075];
                //开始动画
                [cell.dongHuaImage startAnimating];

        }
        
        if ([self.actual_distance isEqualToString:@"-1"]) {
            cell.rightBtn.selected = NO;
            cell.dongHuaImage.hidden = YES;
            cell.actualLabel.text = @"--";
            cell.lineLabel.text = @"--";
            [cell.smallBtn setTitle:@"已取消" forState:UIControlStateNormal];
        }
        if(self.contentArr.count>0){
            for (int i =0; i<self.contentArr.count; i++) {
                NSString *phone = [cell.addressLabel.text substringFromIndex:3];
                if ([self.contentArr[i][@"phone"] isEqualToString:phone]) {
                    cell.lineLabel.text = self.contentArr[i][@"straight_line_distance"];
                    cell.actualLabel.text = self.contentArr[i][@"actual_distance"];
                    if (cell.lineLabel.text.length>0) {
                        [cell.smallBtn setTitle:@"已响应" forState:UIControlStateNormal];
                    }
                    if ([self.contentArr[i][@"straight_line_distance"] isEqualToString:@"-1"]) {
                        cell.rightBtn.selected = NO;
                        cell.dongHuaImage.hidden = YES;
                        cell.actualLabel.text = @"--";
                        cell.lineLabel.text = @"--";
                        [cell.smallBtn setTitle:@"已取消" forState:UIControlStateNormal];
                    }
                }
            }
        }


        return cell;
    }else if(tableView == _beHelpTableView){
        MedicalModel *model = self.beHelpArr[indexPath.row];
        distanceModel *model1 = self.straight_line_distanceArr[indexPath.row];
        static NSString *ID = @"beHelpTableViewCell";
        // 2.从缓存池中取出cell
        MedicalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 3.如果缓存池中没有cell
        cell.isTongYi = self.isTongYi;
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MedicalTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
            cell.backgroundColor = [UIColor clearColor];
            cell.daohangDelegate = self;
            [cell.rightBtn setTitle:@"响应" forState:UIControlStateNormal];
            
            cell.rightLabel.text = @"导航";
            [cell.smallBtn setTitle:@"" forState:UIControlStateNormal];
            [cell.smallBtn setImage:[UIImage imageNamed:@"medicalhelper_other_daohang"] forState:UIControlStateNormal];
            cell.smallBtn.enabled = YES;
            cell.touImage.layer.masksToBounds = YES;
            cell.touImage.layer.cornerRadius = 20;
            cell.deleimg.hidden = YES;
            //首先得拿到照片的路径，也就是下边的string参数，转换为NSData型。
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.headimgurl]];
            
            //然后就是添加照片语句，这次不是`imageWithName`了，是 imageWithData。
            cell.touImage.image = [UIImage imageWithData:data];
            cell.nameLabel.text = model.name?[NSString stringWithFormat:@"名字:%@",model.name]:@"对方未设定昵称";
            cell.addressLabel.text = model.phone?[NSString stringWithFormat:@"电话:%@",model.phone]:@"--";
            cell.city = self.city;
            cell.registration_id = model.registration_id;
            cell.isHelpTable = NO;
            cell.deleBtn.hidden = YES;
            cell.bid = model1.bid;
            cell.helper_id = model.ID;
            if (model1.straight_line_distance) {
                if([model1.straight_line_distance isEqualToString:@""]){
                    cell.lineLabel.text  = @"--";
                }else{
                    cell.lineLabel.text = model1.straight_line_distance;
                }
                    
            }else{
               cell.lineLabel.text  = @"--";
            }
            if (model1.actual_distance) {
                if([model1.actual_distance isEqualToString:@""]){
                    cell.actualLabel.text  = @"--";
                }else{
                    cell.actualLabel.text = model1.actual_distance;
                }
                
            }else{
                cell.actualLabel.text  = @"--";
            }
            cell.dongHuaImage.hidden = YES;
            cell.daohangDelegate = self;
            cell.deleBtn.tag = indexPath.row+100;
            if ([HSingleGlobalData sharedInstance].straight_line_distance) {
                cell.smallBtn.enabled = YES;
            }
            if (cell.isCall) {
                cell.rightBtn.selected = YES;
                cell.rightBtn.backgroundColor = [UIColor grayColor];
                cell.dongHuaImage.hidden = NO;
            }else{
                cell.rightBtn.selected = NO;
                cell.rightBtn.backgroundColor = [UIColor clearColor];
                cell.dongHuaImage.hidden = YES;
            }
            if (model1.straight_line_distance&&![model1.straight_line_distance isEqualToString:@"-1"]&&model1.straight_line_distance.length>0) {
                cell.dongHuaImage.hidden = NO;
                
                NSMutableArray  *arrayM=[NSMutableArray array];
                for (int i=0; i<3; i++) {
                    [arrayM addObject:[UIImage imageNamed:[NSString stringWithFormat:@"app_loading_%zd",i+1]]];
                }
                //设置动画数组
                [cell.dongHuaImage setAnimationImages:arrayM];
                //设置动画播放次数
                [cell.dongHuaImage setAnimationRepeatCount:0];
                //设置动画播放时间
                [cell.dongHuaImage setAnimationDuration:6*0.075];
                //开始动画
                [cell.dongHuaImage startAnimating];
                [cell.rightBtn setTitle:@"已响应" forState:UIControlStateNormal];
                [cell.rightBtn setBackgroundColor:[UIColor grayColor]];
            }else{
                cell.dongHuaImage.hidden = YES;
                [cell.rightBtn setTitle:@"响应" forState:UIControlStateNormal];
                cell.actualLabel.text = @"--";
                cell.lineLabel.text = @"--";
//                cell.isCall = NO;
            }
            if(model1.bid){
                cell.xiangYingLabel.hidden = NO;
                if(model1.bid.length>0){
                    if ([model1.type isEqualToString:@"110"]) {
                        cell.xiangYingLabel.text = @"硬件110呼叫";
                    }else if([model1.type isEqualToString:@"120"]){
                        cell.xiangYingLabel.text = @"硬件120呼叫";
                    }else{
                        cell.xiangYingLabel.text = @"硬件呼叫";
                    }
                    
                }else{
                    cell.xiangYingLabel.text = @"软件呼叫";
                }
            }else{
                cell.xiangYingLabel.hidden = YES;
            }

        }
        if([model1.actual_distance isEqualToString:@"-1"]||[model1.straight_line_distance isEqualToString:@"-1"]){
           cell.lineLabel.text = @"取消呼叫";
            cell.actualLabel.text = @"取消呼叫";
        }
        if (self.isTongYi == YES) {
            cell.rightBtn.hidden = NO;
        }else{
            cell.rightBtn.hidden = YES;
        }

        return cell;
    }else{
        tabModel *model = _tabArr.count>0 ? _tabArr[indexPath.row] : nil;
        static NSString *ID = @"tabTableViewCell";
        // 2.从缓存池中取出cell
        tabTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 3.如果缓存池中没有cell
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"tabTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
            cell.backgroundColor = [UIColor whiteColor];
            if ([model.helper_name isKindOfClass:[NSNull class]]) {
                cell.nameLabel.text = @" ";
            }else{
                cell.nameLabel.text = model.helper_name;
                
            }
            //            cell.nameLabel.text = model.name?model.name:@" ";
            cell.telLabel.text = model.phone?model.phone:@" ";
            if([model.status isEqualToString:@"4"]){
                cell.statusLabel.text = @"待同步";
                cell.statusLabel.textColor = [UIColor greenColor];
            }else if ([model.status isEqualToString:@"2"]){
                cell.statusLabel.text = @"已申请";
                cell.statusLabel.textColor = [UIColor blueColor];
            }
        }
        return cell;
    }
}

-(void)daohang{
    //导航按钮点击的代理方法
 
}
- (void)XiangYingBtnClick:(NSString *)ID:(NSString *)bid{
    self.isFirstComing = NO;
    self.helpid = ID;
    self.bid = bid;
    NSString *URL = [NSString stringWithFormat:@"%@/api/alert/get-destination-result",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"响应后获取数据%@",responseObject);
        if ([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token error"])  {
            //                [self newLogin];
        }else{
            NSMutableArray *array = responseObject[@"content"];
            for (int i =0; i<array.count; i++) {
                NSDictionary *dic = array[i];
                                NSString *bid = dic[@"bid"];
                if (self.bid.length>0) {
                    NSLog(@"硬件响应");
                    self.isYingJian = YES;
                    self.count = 0;
                    //0.创建队列
                    dispatch_queue_t queue = dispatch_get_main_queue();
                    
                    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                    
                    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 20.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
                    
                    //3.要调用的任务
                    dispatch_source_set_event_handler(timer, ^{
                        NSLog(@"GCD-----%@",[NSThread currentThread]);
                        self.count++;
                        NSInteger dis = [self.straight_line_distance integerValue];
                        if(_count==600){
                            dispatch_cancel(self.timer);
                            //                    NSLog(@"取消定时器");
                        }
                    });
                    
                    //4.开始执行
                    dispatch_resume(timer);
                    
                    //
                    self.timer = timer;
                    
                }else{
                    NSLog(@"软件响应");
                    self.isYingJian = NO;
                    self.count = 0;
                    //0.创建队列
                    dispatch_queue_t queue = dispatch_get_main_queue();
                    
                    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                    
                    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 20.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
                    
                    //3.要调用的任务
                    dispatch_source_set_event_handler(timer, ^{
                        NSLog(@"GCD-----%@",[NSThread currentThread]);
                        self.count++;
                        NSInteger dis = [self.straight_line_distance integerValue];
                        if(_count==600){
                            dispatch_cancel(self.timer);
                            //                    NSLog(@"取消定时器");
                        }
                    });
                    
                    //4.开始执行
                    dispatch_resume(timer);
                    self.timer = timer;
                }
            }
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tab){
        return 24;
    }else{
        return 135;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _helpTableView) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 150)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 100, 15)];
        label.text = @"待同步:";
        label.font = [UIFont systemFontOfSize:13];
        [view addSubview:label];
        
        UIButton *list = [[UIButton alloc] initWithFrame:CGRectMake(KWidth-100, 10, 70, 15)];
        [list setBackgroundColor:RGBColor(0, 128, 255)];
        [list setTitle:@"设备列表" forState:UIControlStateNormal];
        list.titleLabel.font = [UIFont systemFontOfSize:13];
        [list setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [list addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
        if(self.shebeiArr.count>0){
            list.hidden = NO;
        }else{
            //            list.enabled = NO;
            list.hidden = YES;
        }
        [view addSubview:list];
        
        self.tab = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, 150-20-40 ) style:UITableViewStylePlain];
        _tab.delegate = self;
        _tab.dataSource = self;
        _tab.backgroundColor = [UIColor whiteColor];
        _tab.separatorStyle = UITableViewCellSeparatorStyleNone;
        [view addSubview:_tab];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(KWidth-100, 130, 75, 15)];
//        [button setTitle:@"同  步"forState:UIControlStateNormal];
//        [button setTitleColor:RGBColor(0, 128, 255) forState:UIControlStateNormal];
        // 创建imageview
        UIImage *image = [UIImage imageNamed:@"medical_tongbu"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,0,15,15)];
        [imageView setImage:image];
        // 创建label
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(30,0,60,15)];
        [label2 setText:@"同  步"];
        label2.font = [UIFont systemFontOfSize:14];
        label2.textColor = [UIColor whiteColor];
        // 添加到button中
        [button addSubview:label2];
        [button addSubview:imageView];
        [button setImage:[UIImage imageNamed:@"medical_helper_tongbu"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(tongBU) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [view addSubview:button];
        if(_tabArr.count>0){
            button.hidden = NO;
            _tab.hidden = NO;
        }else{
            button.hidden = YES;
            _tab.hidden = YES;
        }
        UIButton *buttonLeft = [[UIButton alloc] init];
//        buttonLeft.selected = YES;
        if (_tabArr.count>0) {
            buttonLeft.frame = CGRectMake(10, 130, 200, 15);
        }else{
            buttonLeft.frame = CGRectMake(10, 40, 200, 15);
        }
        [buttonLeft setImage:[UIImage imageNamed:@"fpower_selectered"] forState:UIControlStateSelected];
        [buttonLeft setImage:[UIImage imageNamed:@"fpower_selecter"] forState:UIControlStateNormal];
        [buttonLeft setTitle:@"同意开启求助功能共享位置" forState:UIControlStateNormal];
        [buttonLeft setTitle:@"同意开启求助功能共享位置" forState:UIControlStateSelected];
        buttonLeft.selected = YES;
        buttonLeft.titleLabel.font = [UIFont systemFontOfSize:13];
        [buttonLeft setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [buttonLeft setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [buttonLeft addTarget:self action:@selector(tongyi:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:buttonLeft];
        if (self.isTongYi ==YES) {
            buttonLeft.selected = YES;
        }else{
            buttonLeft.selected =NO;
        }
        //        [cell.contentView addSubview:view];
        return view;
    }else{
        return nil;
    }
}

- (void)tongyi:(UIButton *)sender{
    if (sender.selected) {
        sender.selected = NO;
        self.isTongYi = NO;
        [self.helpTableView reloadData];
        [self.beHelpTableView reloadData];
//        for (int i =0; i<self.nameArr.count; i++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//            [self.helpTableView rectForRowAtIndexPath:indexPath];
//        }
//        for (int i =0; i<self.beHelpArr.count; i++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//            [self.beHelpTableView rectForRowAtIndexPath:indexPath];
//        }
    }else{
        sender.selected = YES;
        self.isTongYi = YES;
        [self.helpTableView reloadData];
        [self.beHelpTableView reloadData];
//        for (int i =0; i<self.nameArr.count; i++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//            [self.helpTableView rectForRowAtIndexPath:indexPath];
//        }
//        for (int i =0; i<self.beHelpArr.count; i++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//            [self.beHelpTableView rectForRowAtIndexPath:indexPath];
//        }

    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == _helpTableView) {
        static NSString *ID = @"footCell";
        // 2.从缓存池中取出cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"footCell"];//自定义cell
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 33)];
        
        _quanXuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _quanXuanBtn.frame = CGRectMake(0, 0, 100, 22);
        [_quanXuanBtn setContentMode:UIViewContentModeScaleAspectFit];
        [_quanXuanBtn setImage:[UIImage imageNamed:@"fpower_selecter"] forState:UIControlStateNormal];
        [_quanXuanBtn setImage:[UIImage imageNamed:@"fpower_selectered"] forState:UIControlStateSelected];
        _quanXuanBtn.contentEdgeInsets = UIEdgeInsetsMake(-20, -20, -20, -20);
        [_quanXuanBtn setTitle:@"  全选" forState:UIControlStateNormal];
        [_quanXuanBtn setTitle:@"  全选" forState:UIControlStateSelected];
        
        [_quanXuanBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _quanXuanBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_quanXuanBtn addTarget:self action:@selector(quanXuanBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _callButton.frame = CGRectMake(100, 0, KWidth-110, 22);
        [_callButton setBackgroundImage:[UIImage imageNamed:@"medical_call_all"] forState:UIControlStateNormal];
        if (self.isQuanXuan) {
            [_callButton setTitle:@"已呼叫" forState:UIControlStateNormal];

        }else{
            [_callButton setTitle:@"呼叫" forState:UIControlStateNormal];
        }
        [_callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _callButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _callButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_callButton addTarget:self action:@selector(quanHuBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_quanXuanBtn];
        [view addSubview:_callButton];
        
        [cell.contentView addSubview:view];
        return cell;
        
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == _helpTableView) {
        return 33;
        
    }else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _helpTableView){
        if (_tabArr.count>0) {
            return 150;
        }else{
            return 50;
        }
        return 150;
    }else{
        return 0;
    }
}

-(void)quanXuanBtnClick{
    if (!_isQuanXuan) {
        MyLog(@"全选");
        [_quanXuanArr removeAllObjects];
        _quanXuanBtn.selected = YES;
        [_helpTableView setEditing:YES animated:YES];
        for (int i=0; i<_nameArr.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [_helpTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
            MedicalModel *model = _nameArr[i];
            [self.quanXuanArr addObject:model.registration_id];
        }
        self.isQuanXuan = YES;
    }else{
        [_quanXuanArr removeAllObjects];
        _quanXuanBtn.selected = NO;
        MyLog(@"取消全选");
        [_helpTableView setEditing:NO animated:YES];
        self.isQuanXuan = NO;
    }
}

- (void)quanHuBtnClick{
//    [_quanXuanArr removeAllObjects];
    if (self.isTongYi) {
        _quanXuanBtn.selected = NO;
        self.isQuanXuan = YES;
        MyLog(@"取消全选");
        [_helpTableView setEditing:NO animated:YES];
        //    for (int i = 0 ;i<_quanXuanArr.count;i++){
        //        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
        //
        //        [_helpTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        //    }
        //    [_helpTableView reloadData];
        [_callButton setTitle:@"已呼叫" forState:UIControlStateNormal];
        NSLog(@"全选呼叫");
        [self requestFinish];
        self.counti = 0;
        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 20.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^{
            NSLog(@"GCD-----%@",[NSThread currentThread]);
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *URL = [NSString stringWithFormat:@"%@/api/alert/get-origin-result",kUrl];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
            manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            manager.requestSerializer = requestSerializer;
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            NSString *token = [userDefaults valueForKey:@"token"];
            [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
            [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *success = responseObject[@"result"][@"success"];
                if ([success integerValue]==0) {
                    [MBProgressHUD showText:@"暂未定位成功"];
                    dispatch_cancel(timer);
                    //                    NSLog(@"取消定时器");
                    self.counti = 0;
                }else{
                    self.counti ++;
                    self.contentArr = responseObject[@"content"];
                    NSLog(@"%@",self.contentArr);
                    for (int i = 0; i<self.contentArr.count; i++) {
                        NSLog(@"将距离替换");
                        //                        self.actual_distance = self.contentArr[i][@"actual_distance"];
                        //                        self.straight_line_distance = self.contentArr[i][@"straight_line_distance"];
                        //                        NSIndexPath *refreshCell = [NSIndexPath indexPathForRow:i inSection:0];
                        //                        [cell.smallBtn setTitle:@"响应" forState:UIControlStateNormal];
                        //                    [self.helpTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:refreshCell,nil] withRowAnimation:UITableViewRowAnimationNone];
                        [self.helpTableView reloadData];
                        
                    }
                    //                 [self.contentArr removeAllObjects];
                    //
                    //
                    //            }
                    if(self.counti > 100){
                        dispatch_cancel(timer);
                        //                    NSLog(@"取消定时器");
                        self.counti = 0;
                    }
                }
            }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
                     NSLog(@"%@",error);  //这里打印错误信息
                 }];
            
        });
        dispatch_resume(timer);
        self.isQuanXuan = NO;

    }else{
        [MBProgressHUD showText:@"请开启求助功能"];
    }
    }

- (void)requestFinish{
    NSString *URL = [NSString stringWithFormat:@"%@/api/alert/start-all-alert",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.longitude forKey:@"longitude"];
    [parameters setValue:self.latitude forKey:@"latitude"];
    [parameters setValue:self.city forKey:@"city"];
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"全选呼叫结果%@",responseObject);
        self.hujiaoResult = responseObject[@"content"][@"success"];
        NSMutableArray *falses = responseObject[@"content"][@"falses"];
        NSLog(@"falses%@",falses);
        NSMutableString *mString = [NSMutableString stringWithFormat:@"%@",falses];
        [mString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [mString deleteCharactersInRange:NSMakeRange(0, 1)];
        [mString deleteCharactersInRange:NSMakeRange(mString.length-1, 1)];
        NSString *fale = [NSString stringWithFormat:@"%@呼叫失败",mString];
        if(falses&&falses.count>0){
//            [MBProgressHUD showText:fale];
        }
       

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"全选呼叫结果%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];

}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleInsert;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)requestHelpList{
    //    NSString *URL = [NSString stringWithFormat:@"%@/app/helpers/helper/1?bid=022017010719170501",kUrl];
    NSString *URL = [NSString stringWithFormat:@"%@/app/helpers/helper/1?bid=%@",kUrl,self.bid];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    //    NSDictionary *dict = @{ @"bid":@"022017010719170501"};
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"求助人列表%@",responseObject);
        if (!responseObject[@"result"][@"success"]&&![responseObject[@"result"][@"errorMsg"] isEqualToString:@"token error"]) {
            NSString *str = responseObject[@"result"][@"errorMsg"];
            [MBProgressHUD showText:str];
        }
        
        if ([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token error"])  {
            //            [self newLogin];
        }else{
            [self.nameArr removeAllObjects];
            for (NSDictionary *goodsDic in responseObject[@"content"]) {
                _AllModel =[[MedicalModel alloc] initWithDictionary:goodsDic];
                [self.nameArr addObject:_AllModel];
            }
            if (self.nameArr.count>0) {
                _noData.hidden = YES;
            }else{
                _noData.hidden = NO;
            }
            
            [self.helpTableView reloadData];
            if ([_helpTableView.mj_header isRefreshing]) {
                [_helpTableView.mj_header endRefreshing];
            }
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
    
}

-(void)requestBeHelpList{
    NSString *URL = [NSString stringWithFormat:@"%@/api/alert/get-destination-result",kUrl];
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
        NSLog(@"被求助人列表%@",responseObject);
        if ([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token error"])  {
            //            [self newLogin];
        }else{
            [self.beHelpArr removeAllObjects];
            [self.straight_line_distanceArr removeAllObjects];
            for (NSDictionary *goodsDic in responseObject[@"content"]) {
                _AllModel =[[MedicalModel alloc] initWithDictionary:goodsDic];
                [self.beHelpArr addObject:_AllModel];
                distanceModel *model = [[distanceModel alloc] initWithDictionary:goodsDic];
                [self.straight_line_distanceArr addObject:model];
            }
            
            if (self.beHelpArr.count>0) {
                _noDataTwo.hidden = YES;
            }else{
                _noDataTwo.hidden = NO;
            }
            
            [self.beHelpTableView reloadData];
            if ([_helpTableView.mj_header isRefreshing]) {
                [_helpTableView.mj_header endRefreshing];
            }
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
    
}

- (void)requestSmallList{
    NSString *URL = [NSString stringWithFormat:@"%@/app/users/user/get-status-apply-list?bid=%@",kUrl,self.bid];
    //    NSString *URL = [NSString stringWithFormat:@"%@/app/helpers/helper/get-app-synchronize-with-equipment-result%d?bid=%@",kUrl,4,self.bid];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    //   NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    //  [parameter setValue:self.bid forKey:@"bid"];
    NSLog(@"token is :%@",token);
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"同步人列表%@",responseObject);
        if (!responseObject[@"result"][@"success"]&&![responseObject[@"result"][@"errorMsg"] isEqualToString:@"token error"]) {
            NSString *str = responseObject[@"result"][@"errorMsg"];
            [MBProgressHUD showText:str];
        }
        
        if ([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token error"])  {
                        [self newLogin];
        }else{
            [self.tabArr removeAllObjects];
            for (NSDictionary *goodsDic in responseObject[@"content"]) {
                tabModel *model =[[tabModel alloc] initWithDictionary:goodsDic];
                [self.tabArr addObject:model];
                //待同步状态的放入statusArr
                if ([model.status isEqualToString:@"4"]) {
                    [self.statusArr addObject:model];
                }
            }
            
            [self.tab reloadData];
            [self.helpTableView reloadData];
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
}

- (void)requestSheBeiList{
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
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"设备列表%@",responseObject);
        //        if (responseObject[@"result"][@"success"]&&![responseObject[@"result"][@"errorMsg"] isEqualToString:@"token error"]) {
        //            NSString *str = responseObject[@"result"][@"errorMsg"];
        //            [MBProgressHUD showText:str];
        //        }
        
        
        if ([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token error"])  {
            [self newLogin];
        }else if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
            [self newLoginTwo];
            

        }else{
            [self.shebeiArr removeAllObjects];
            for (NSDictionary *goodsDic in responseObject[@"content"]) {
                _adminModel =[[AdministrationModel alloc] initWithDictionary:goodsDic];
                [self.shebeiArr addObject:_adminModel];
            }
            NSLog(@"设备列表%@",self.shebeiArr);
            if (_shebeiArr.count>0) {
                AdministrationModel *model = _shebeiArr[0];
                self.bid = model.bid;
                
            }
            
            [self requestSmallList];
            [self requestHelpList];
            [self requestBeHelpList];
            //        [self.tab reloadData];
            //        if ([_tab.mj_header isRefreshing]) {
            //            [_tab.mj_header endRefreshing];
            //        }
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
}
//响应后请求数据
- (void)requestXiangYing{
        NSString *URL = [NSString stringWithFormat:@"%@/api/alert/get-destination-result",kUrl];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.requestSerializer = requestSerializer;
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefaults valueForKey:@"token"];
        [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
        [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"响应后获取数据%@",responseObject);
            if ([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token error"])  {
                //                [self newLogin];
            }else{
                NSString *bid = responseObject[@"bid"];
                if (bid.length>0) {
                    NSLog(@"硬件响应");
                }else{
                    NSLog(@"软件响应");
                }
                for (NSDictionary *goodsDic in responseObject[@"content"]) {
                    self.straight_line_distanceArr = goodsDic[@"straight_line_distance"];
                    self.actual_distance = goodsDic[@"actual_distance"];
                }
                for (int i = 0; i<_beHelpArr.count; i++) {
                    self.straight_line_distanceArr[i] = responseObject[@"content"][@"straight_line_distance"];
                    self.actual_distanceArr[i] = responseObject[@"content"][@"actual_distance"];
                }


                [self.beHelpTableView reloadData];
            }
        }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
                 NSLog(@"%@",error);  //这里打印错误信息
             }];
}


//同步按钮点击方法
- (void)tongBU{
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请打开报警器" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TransparentController * transparentVC = [[TransparentController alloc] initWithNibName:@"TransparentController" bundle:nil];
        transparentVC.bid = self.bid;
        transparentVC.delegate= self;
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            transparentVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        }else{
            self.modalPresentationStyle=UIModalPresentationOverFullScreen;
        }
        [self presentViewController:transparentVC animated:YES completion:nil];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)deleCell:(UIButton *)sender{
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请打开报警器" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sender.tag-99>0) {
                        
        }else{
            NSString *URL = [NSString stringWithFormat:@"%@/app/helpers/helper/del-helpers",kUrl];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
            manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            manager.requestSerializer = requestSerializer;
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *token = [userDefaults valueForKey:@"token"];
            [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
            MedicalModel *model = [[MedicalModel alloc] init];
            model = _nameArr[sender.tag];
            [parameters setValue:self.bid forKey:@"bid"];
            [parameters setValue:model.ID forKey:@"id"];
            [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                
            }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"删除cell%@",responseObject);
                
                if ([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token error"])  {
                    [self newLogin];
                }else if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
                    [self newLoginTwo];
                    
                    
                }else{
                    if(responseObject[@"result"][@"success"])
                    {
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"同步中,请稍等...";
                        hud.margin = 10.f;
                        hud.yOffset = 150.f;
                        hud.removeFromSuperViewOnHide = YES;  
                        [hud hide:YES afterDelay:20];
                        
                        [self performSelector:@selector(requestGet) withObject:@"Grand Central Dispatch" afterDelay:20.0];
                        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                        target:self
                                                                      selector:@selector(download)
                                                                      userInfo:nil
                                                                       repeats:YES];
                        [_nameArr removeObjectAtIndex:sender.tag];  //删除_data数组里的数据
                        //                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
                        //                [_beHelpTableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
                    }else{
                        NSString *text = responseObject[@"result"][@"errorMsg"];
                        [MBProgressHUD showText:text];
                    }
                    
                    
                }
                
            }
             
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
                      NSLog(@"%@",error);  //这里打印错误信息
                  }];
            
        }

        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)download{
    
        // 终止定时器
        [_myTimer invalidate];
        [self popreload];

}

- (void)popreload{
    [self requestSmallList];
    [self requestHelpList];
    [self requestBeHelpList];
    [self.helpTableView reloadData];
}

-(void)requestGet{
    NSString *URL = [NSString stringWithFormat:@"%@/app/helpers/helper/get-app-synchronize-with-equipment-result?bid=%@",kUrl,self.bid];
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
        NSLog(@"同步后查询是否成功%@",responseObject);
        if(!responseObject[@"result"][@"success"]){
            [MBProgressHUD showText:@"删除失败"];
        }else{
           [self.helpTableView reloadData];
        }
        
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
    
}

-(NSMutableArray *)nameArr{
    if (!_nameArr) {
        _nameArr =[NSMutableArray arrayWithCapacity:0];
    }
    return _nameArr;
    
}
-(NSMutableArray *)beHelpArr{
    if (!_beHelpArr) {
        _beHelpArr =[NSMutableArray arrayWithCapacity:0];
    }
    return _beHelpArr;
    
}
-(MedicalModel *)AllModel{
    if (!_AllModel) {
        _AllModel =[[MedicalModel alloc] init];
    }
    return _AllModel;
}

-(tabModel *)tabmodel{
    if (!_tabmodel) {
        _tabmodel = [[tabModel alloc] init];
    }
    return _tabmodel;
}

-(NSMutableArray *)tabArr{
    if (!_tabArr) {
        _tabArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _tabArr;
}
-(NSMutableArray *)shebeiArr{
    if (!_shebeiArr) {
        _shebeiArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _shebeiArr;
    
}
-(AdministrationModel *)adminModel{
    if (!_adminModel) {
        _adminModel = [[AdministrationModel alloc] init];
    }
    return _adminModel;
}

-(NSMutableArray *)quanXuanArr{
    if (!_quanXuanArr) {
        _quanXuanArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _quanXuanArr;
}

-(NSMutableArray *)contentArr{
    if (!_contentArr) {
        _contentArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _contentArr;
}
-(NSMutableArray *)statusArr{
    if (!_statusArr) {
        _statusArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _statusArr;
}

-(distanceModel *)model{
    if (!_model) {
        _model = [[distanceModel alloc] init];
    }
    return _model;
}

-(NSMutableArray *)hujiaoResult{
    if (!_hujiaoResult) {
        _hujiaoResult = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _hujiaoResult;

}

-(NSMutableArray *)actual_distanceArr{
    if (!_actual_distanceArr) {
        _actual_distanceArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _actual_distanceArr;

}

-(NSMutableArray *)straight_line_distanceArr{
    if (!_straight_line_distanceArr) {
        _straight_line_distanceArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _straight_line_distanceArr;
    
}
//获取通讯录内容
//查看是否已经获取通讯录权限
- (void)loadPresion{
    ABAddressBookRef addressBookref = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookref, ^(bool granted, CFErrorRef error) {
            CFErrorRef *error1 = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
            [self copyAddressBook:addressBook];
        });
    }else if(ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        CFErrorRef *error1 = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
        [self copyAddressBook:addressBook];
        
    }else{
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有获取通讯录权限" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.delegate = self;
        [alert show];
    }
}

- (void)copyAddressBook:(ABAddressBookRef)addressBook{
    //获取联系人个数
    CFIndex numberOfPeoples = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef peoples = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSLog(@"有%ld个联系人", numberOfPeoples);
    //循环获取联系人
    for (int i = 0; i < numberOfPeoples; i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(peoples, i);
        PeopleModel *linkMan = [[PeopleModel alloc] init];
        linkMan.firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        linkMan.lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        linkMan.nickName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonNicknameProperty);
        linkMan.organiztion = (__bridge NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
        linkMan.headImage = (__bridge NSData*)ABPersonCopyImageData(person);
        
        
        if (linkMan.firstName && linkMan.lastName) {
            linkMan.name = [NSString stringWithFormat:@"%@%@",linkMan.lastName, linkMan.firstName];
        }else if(!linkMan.firstName){
            linkMan.name = linkMan.lastName;
        }else{
            linkMan.name = linkMan.firstName;
        }
        if (!linkMan.name) {
            linkMan.name = linkMan.organiztion;
        }
        if (linkMan.nickName) {
            linkMan.name =[NSString stringWithFormat:@"%@", linkMan.nickName];
        }
        
        //读取电话多值
        NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取电话Label
            NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            //获取該Label下的电话值
            NSString * tempstr = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            NSArray *array = [NSArray arrayWithObjects:personPhoneLabel, tempstr, nil];
            [phoneArray addObject:array];
        }
        linkMan.phones = phoneArray;
        [self.linkManArray addObject:linkMan];
    }
    NSDictionary *dict = [ICPinyinGroup group:self.linkManArray  key:@"name"];
    
    self.tableHeaderArray = [dict objectForKey:LEOPinyinGroupCharKey];
    self.sortedArrForArrays = [dict objectForKey:LEOPinyinGroupResultKey];
    
    
    //    [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
}

//- (void)reloadTable{
//    [self.helpTableView reloadData];
//
//}
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




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(id)naviPresentedViewController {
    return self;
}

@end
