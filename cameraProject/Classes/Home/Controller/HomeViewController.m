//
//  HomeViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 16/12/19.
//  Copyright © 2016年 ziHou. All rights reserved.
//

#import "HomeViewController.h"
#import "OneLoginViewController.h"
#import "MedicalViewController.h"
#import "ScanViewController.h"
#import "HomeHeader.h"
#import "AlarmViewController.h"
#import "MessageCenterViewController.h"
#import "PopoverView.h"
#import "SDCycleScrollView.h"
#import "AdministrationViewController.h"
#import "MBProgressHUD.h"
#import "AddBurglarViewController.h"
#import "ElectricityViewController.h"
#import "UsePowerViewController.h"
#import "PowerViewController.h"
#import "PowerDetailViewController.h"
#import "EquipmentViewController.h"
#import "FindTableViewCell.h"
#import "MJRefresh.h"
#import "DisViewController.h"
#import "disModel.h"
#import "SDWebImageManager.h"
#define IOS8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >=8.0 ? YES : NO)

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,HomeHeaderDelegate>
@property (nonatomic,strong)UITableView *mainTableView;
@property (nonatomic,strong)UIView *mainView;
@property (nonatomic,strong)UICollectionView *collectionView;
//@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,strong)NSArray *dataArr1;
@property (nonatomic,assign)BOOL isNewMessage;
@property (nonatomic,strong) HomeHeader *headView;
@property (nonatomic,strong)UITableView *table;
@property (nonatomic,strong)disModel *model;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,assign)int page;
@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
//    [self.navigationItem.leftBarButtonItem setAction:@selector(pop)];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"center_background"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIColor * color = [UIColor whiteColor];
     NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
   
    self.isNewMessage = NO;
}



- (void)viewWillDisappear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    self.page = 1;
    self.isNewMessage = NO;
    [self requestData];
//    self.dataArr = @[@"中国光伏企业东进 分布式光伏发电前景被看好",@"你知道光伏发电的历史起源吗",@"政策和市场决定太阳能光伏发电的前景"];
//    self.dataArr1 = @[@"长期以来,融资难一直是困扰我国光伏发电的...",@"1839年,19岁的法国贝勒尔做物理实验...",@"太阳能发电系统早在很多年前就开始使用..."];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];

}

-(void)pop{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}

-(disModel *)model{
    if (!_model) {
        _model = [[disModel alloc] init];
    }
    return _model;
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    
    self.hidesBottomBarWhenPushed = YES;
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    
    self.hidesBottomBarWhenPushed = NO;
    
}

-(void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/select-article",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"5" forKey:@"limit"];
    //    [parameters setValue:@"文章id" forKey:@"id"];
    NSString *page = [NSString stringWithFormat:@"%d",self.page];
    [parameters setValue:page forKey:@"page"];
    
    NSLog(@"%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"获取文章正确%@",responseObject);
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSString *str = responseObject[@"result"][@"errorMsg"];
            [MBProgressHUD showText:str];
        }else{
            if (self.page<2) {
                [self.dataArr removeAllObjects];
            }
            NSArray *arr = responseObject[@"content"];
            if (arr.count>0) {
                
            }else{
                self.page--;
            }
            for (NSDictionary *dic in responseObject[@"content"]) {
                _model = [[disModel alloc] initWithDictionary:dic];
                [self.dataArr addObject:_model];
            }
            [self.table reloadData];
            if (self.table) {
                [self.table.mj_header endRefreshing];
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
    
}



- (void)setUpUI{
    
    self.headView =[[[NSBundle mainBundle] loadNibNamed:@"HomeHeader" owner:self options:nil] objectAtIndex:0];
    self.headView.frame =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,226);
    self.headView.delegate = self;
    self.headView.isNewMessage = self.isNewMessage;
    [self.view addSubview:self.headView];

//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, self.headView.bounds.size.height-40, 100, 30)];
//    label.text = @"芯芸科技";
//    label.textColor = [UIColor whiteColor];
//    [self.headView addSubview:label];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0,226 , KWidth, KHeight-226) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    // 隐藏时间
    //    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    //    header.stateLabel.hidden = YES;
    self.table.mj_header = header;
    self.table.mj_header.ignoredScrollViewContentInsetTop = self.table.contentInset.top;
    
    //上拉加载
    self.table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //在刷新数据覆盖不显示数据的 cell 的分割线,如果不设置,则会显示 cell 的分割线
    UIView *footView = [UIView new];
    self.table.tableFooterView = footView;

}
- (void)refresh{
    [self requestData];
    
}

- (void)loadMoreData {
//    //1, 获取数据源
//    for (int i = 0; i < 5; i++) {
//        NSString *string = [NSString stringWithFormat:@"+++山本%d", arc4random_uniform(1000)];
//        [self.dataSource addObject:string];
//    }
//    //2,刷新数据
//    [self.tableView reloadData];
//    //3,关闭刷新
//    [self.tableView.mj_footer endRefreshing];
    self.page++;
    [self requestData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier =@"Cell";
    FindTableViewCell *cell = (FindTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell ==nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"FindTableViewCell" owner:nil options:nil];
        _model = self.dataArr[indexPath.row];
        cell = [nibs lastObject];
        cell.tipLabel.text = _model.title;
        cell.detailLabel.text = _model.subtitle;
        NSString *string = [_model.updated_at substringToIndex:10];
        cell.dateLabel.text = string;
            cell.rightImage.image = [UIImage imageNamed:@"i1"];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_model.thumbnail]];
            
            //然后就是添加照片语句，这次不是`imageWithName`了，是 imageWithData。
            if (data.length > 0) {
                cell.rightImage.image = [UIImage imageWithData:data];
            }else{
                cell.rightImage.image = [UIImage imageNamed:@"moren"];
            }

    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DisViewController *vc = [[DisViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    _model = _dataArr[indexPath.row];
    vc.ID = _model.ID;
    vc.article_id = _model.ID;
    vc.title1 = _model.title;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", index);
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
