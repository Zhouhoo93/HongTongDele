//
//  ShebeiViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/6/10.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "ShebeiViewController.h"
#import "ListShebeiModel.h"
#import "baojingqiModel.h"
#import "nibianqiModel.h"
#import "EquipmentTableViewCell.h"
#import "ListShebeiViewController.h"
#import "NibianqiViewController.h"
#import "ScanViewController.h"
#import "MJRefresh.h"
@interface ShebeiViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *blueLine;
@property (nonatomic,strong) UILabel *leftLabel;
@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic,strong) UITableView *leftTableView;
@property (nonatomic,strong) UITableView *rightTableView;
@property (nonatomic,strong)NSMutableArray *nibianqiArr;
@property (nonatomic,strong)NSMutableArray *fayongdianArr;
@property (nonatomic,strong)NSMutableArray *baojingqiArr;
@property (nonatomic,strong)ListShebeiModel *listModel;
@property (nonatomic,strong)baojingqiModel *baojingqiModel;
@property (nonatomic,strong)nibianqiModel *nibianqiModel;
@property (nonatomic,strong)UIImageView *noData;
@property (nonatomic,strong)UIImageView *noData1;
@end

@implementation ShebeiViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    //    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_model.headimgurl]];
    //    _touImage.image = [UIImage imageWithData:data];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"设备列表";
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    [self requestShebeiList];
    [self setUI];
    [self setScroll];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)saoyisao{
    ScanViewController *sao = [[ScanViewController alloc] init];
    sao.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sao animated:YES];
}
- (void)setUI{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 64)];
    topView.backgroundColor = RGBColor(58, 169, 255);
    [self.view addSubview:topView];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-50, 30, 100, 20)];
    topLabel.text = @"设备列表";
    topLabel.textColor = [UIColor whiteColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:topLabel];
    
    UIButton *sao = [[UIButton alloc] initWithFrame:CGRectMake(KWidth-50, 20, 40, 40)];
    [sao setImage:[UIImage imageNamed:@"图层-17"] forState:UIControlStateNormal];
    [sao addTarget:self action:@selector(saoyisao) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:sao];

    
    UIView * kuangView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, KWidth, 44)];
    kuangView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:kuangView];
    
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KWidth/2, 44)];
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    self.leftLabel.font = [UIFont systemFontOfSize:16];
    self.leftLabel.textColor = RGBColor(0, 119, 255);
    self.leftLabel.text = @"逆变器";
    [kuangView addSubview:self.leftLabel];
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KWidth/2, 44)];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [kuangView addSubview:leftBtn];
    
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2, 0, KWidth/2, 44)];
    self.rightLabel.textAlignment = NSTextAlignmentCenter;
    self.rightLabel.font = [UIFont systemFontOfSize:16];
    self.rightLabel.textColor = [UIColor darkGrayColor];
    self.rightLabel.text = @"发用电监测设备";
    [kuangView addSubview:self.rightLabel];
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/2, 0, KWidth/2, 44)];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [kuangView addSubview:rightBtn];

    self.blueLine = [[UIView alloc] initWithFrame:CGRectMake(50, 42, KWidth/2-100, 2)];
    self.blueLine.backgroundColor = RGBColor(0, 119, 255);
    [kuangView addSubview:self.blueLine];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(KWidth/2-1, 10, 2, 44-20)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [kuangView addSubview:line];
}

-(void)leftBtnClick{
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset =CGPointMake(0, 0);
        _blueLine.frame = CGRectMake(50, 42, KWidth/2-100, 2);
        _leftLabel.textColor = RGBColor(0, 119, 255);
        _rightLabel.textColor = [UIColor darkGrayColor];

    }];
}

- (void)rightBtnClick{
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset =CGPointMake(KWidth, 0);
         _blueLine.frame = CGRectMake(KWidth/2+50, 42, KWidth/2-100, 2);
        _leftLabel.textColor = [UIColor darkGrayColor];
        _rightLabel.textColor = RGBColor(0, 119, 255);

    }];
}

- (void)setScroll{
    _scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+44, KWidth, KHeight-64-44)];
    _scrollView.contentSize =CGSizeMake(2*KWidth, 0);
    _scrollView.delegate =self;
    _scrollView.bounces =NO;
    _scrollView.pagingEnabled =YES;
    [self.view addSubview:_scrollView];
    
}
- (void)addChildViewController{
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight-64-44-49) style:UITableViewStylePlain];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
//    _leftTableView.backgroundColor = RGBColor(246, 246, 246);
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _leftTableView.noDataLabel.text = @"暂无未配送清单";
    [_scrollView addSubview:_leftTableView];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    // 隐藏时间
    //    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    //    header.stateLabel.hidden = YES;
    self.leftTableView.mj_header = header;
    self.leftTableView.mj_header.ignoredScrollViewContentInsetTop = self.leftTableView.contentInset.top;

    
    
    self.noData = [[UIImageView alloc] initWithFrame:CGRectMake(0, -2, KWidth, KHeight-64-44-47)];
    self.noData.image = [UIImage imageNamed:@"ip设备列表空"];
    [_scrollView addSubview:self.noData];
    
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(KWidth, 0, KWidth, KHeight-64-44-49) style:UITableViewStylePlain];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
//    _rightTableView.backgroundColor = RGBColor(246, 246, 246);
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _rightTableView.noDataLabel.text = @"暂无未补货清单";
    [_scrollView addSubview:_rightTableView];
    MJRefreshNormalHeader *header1 = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    // 隐藏时间
    //    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    //    header.stateLabel.hidden = YES;
    self.rightTableView.mj_header = header1;
    self.rightTableView.mj_header.ignoredScrollViewContentInsetTop = self.rightTableView.contentInset.top;

    self.noData1 = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth, -2, KWidth, KHeight-64-44-47)];
    self.noData1.image = [UIImage imageNamed:@"ip设备列表空"];
    [_scrollView addSubview:self.noData1];

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        NSUInteger index =scrollView.contentOffset.x/KWidth;
        if (index == 0) {
            [self leftBtnClick];
        }else{
            [self rightBtnClick];
        }
    }
}

- (void)refresh{
    [self requestShebeiList];
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
    [self.leftTableView.mj_header endRefreshing];
    [self.rightTableView.mj_header endRefreshing];
}

- (void)requestShebeiList{
    NSString *URL = [NSString stringWithFormat:@"%@/app/users/user/get-equipment-list",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"设备列表%@",responseObject);
        //        self.fayongdianArr = responseObject[@"content"][@"roof"];
        [self.fayongdianArr removeAllObjects];
        [self.baojingqiArr removeAllObjects];
        [self.nibianqiArr removeAllObjects];
        for (NSDictionary *goodsDic in responseObject[@"content"][@"roof"]) {
            _listModel =[[ListShebeiModel alloc] init];
            _listModel.installed_capacity = [goodsDic[@"installed_capacity"]stringValue];
            _listModel.product_model = goodsDic[@"product_model"] ;
            _listModel.bid = goodsDic[@"bid"] ;
            _listModel.status = goodsDic[@"status"] ;
            _listModel.access_way = goodsDic[@"access_way"] ;
            NSString *str = [NSString stringWithFormat:@"%@",goodsDic[@"rated_current"]];
            if (str.length>0) {
                _listModel.rated_current = str;
            }else{
                _listModel.rated_current = @"";
            }
            
            [self.fayongdianArr addObject:_listModel];
        }
        for (NSDictionary *goodsDic in responseObject[@"content"][@"equipment"]) {
            _baojingqiModel =[[baojingqiModel alloc] initWithDictionary:goodsDic];
            [self.baojingqiArr addObject:_baojingqiModel];
        }
        for (NSDictionary *goodsDic in responseObject[@"content"][@"inverter"]) {
            _nibianqiModel =[[nibianqiModel alloc] init];
            _nibianqiModel.brand = goodsDic[@"brand"];
            _nibianqiModel.power_rating = [goodsDic[@"power_rating"] stringValue];
            _nibianqiModel.product_model = goodsDic[@"product_model"];
            _nibianqiModel.status = goodsDic[@"status"];
            [self.nibianqiArr addObject:_nibianqiModel];
        }
        [self addChildViewController];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"设备列表%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    
}

-(NSMutableArray *)nibianqiArr{
    if (!_nibianqiArr) {
        _nibianqiArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _nibianqiArr;
}
-(NSMutableArray *)fayongdianArr{
    if (!_fayongdianArr) {
        _fayongdianArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _fayongdianArr;
}
-(NSMutableArray *)baojingqiArr{
    if (!_baojingqiArr) {
        _baojingqiArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _baojingqiArr;
}

-(ListShebeiModel *)listModel{
    if (!_listModel) {
        _listModel = [[ListShebeiModel alloc] init];
    }
    return _listModel;
}
-(baojingqiModel *)baojingqiModel{
    if (!_baojingqiModel) {
        _baojingqiModel = [[baojingqiModel alloc] init];
    }
    return _baojingqiModel;
    
}
-(nibianqiModel *)nibianqiModel{
    if (!_nibianqiModel) {
        _nibianqiModel = [[nibianqiModel alloc] init];
    }
    return _nibianqiModel;
    
}


#pragma mark - scrollView监听
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        CGPoint point =scrollView.contentOffset;
        _blueLine.center = CGPointMake(point.x/2 + KWidth/4, _blueLine.center.y);
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == _scrollView) {
        NSInteger x = scrollView.contentOffset.x/KWidth;
        if (x) {
            _leftLabel.textColor = [UIColor darkGrayColor];
            _rightLabel.textColor = RGBColor(0, 119, 255);
        }else{

            _leftLabel.textColor = RGBColor(0, 119, 255);
            _rightLabel.textColor = [UIColor darkGrayColor];

        }
        
    }
}

#pragma mark - 数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView==_leftTableView){
        if (_nibianqiArr.count==0) {
            self.noData.hidden = NO;
        }else{
           self.noData.hidden = YES;
        }
        return _nibianqiArr.count;
    }else{
        if (_fayongdianArr.count==0) {
            self.noData1.hidden = NO;
        }else{
            self.noData1.hidden = YES;
        }
        return _fayongdianArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_leftTableView) {
        static NSString *ID = @"leftTableView";
        // 2.从缓存池中取出cell
        EquipmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 3.如果缓存池中没有cell
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"EquipmentTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
            cell.NameLabel.text = [NSString stringWithFormat:@"逆变器%ld",indexPath.row+1];
            cell.leftImage.image = [UIImage imageNamed:@"图层-6"];
        }
        return cell;
        
    }else{
        static NSString *CellIdentifier =@"rightTableView";
        //定义cell的复用性当处理大量数据时减少内存开销
        EquipmentTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell ==nil)
        {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"EquipmentTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
            cell.NameLabel.text = [NSString stringWithFormat:@"发用电监测设备%ld",indexPath.row+1];
            cell.leftImage.image = [UIImage imageNamed:@"图层-5"];
        }
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
    
    if (tableView==_leftTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        NibianqiViewController *vc = [[NibianqiViewController alloc] initWithNibName:@"NibianqiViewController" bundle:nil];
        vc.model = self.nibianqiArr[indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
       [tableView deselectRowAtIndexPath:indexPath animated:NO];
        ListShebeiViewController *vc = [[ListShebeiViewController alloc] init];
        vc.model = self.fayongdianArr[indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    
    }
    
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
