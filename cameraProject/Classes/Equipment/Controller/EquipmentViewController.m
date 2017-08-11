//
//  EquipmentViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/5/10.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "EquipmentViewController.h"
#import "EquipmentTableViewCell.h"
#import "ListShebeiViewController.h"
#import "NibianqiViewController.h"
#import "BaojingqiViewController.h"
#import "ListShebeiModel.h"
#import "baojingqiModel.h"
#import "nibianqiModel.h"
#import "ScanViewController.h"
#import "sendViewController.h"
@interface EquipmentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *bgTableView;
@property (nonatomic,strong)EquipmentTableViewCell *cell;
@property (nonatomic,assign)NSIndexPath *indexPath;
@property (nonatomic,strong)UITableView *smallTableView;
@property (nonatomic,strong)UITableView *smallTableView1;
@property (nonatomic,strong)UITableView *smallTableView2;
@property (nonatomic,strong)NSMutableArray *nibianqiArr;
@property (nonatomic,strong)NSMutableArray *fayongdianArr;
@property (nonatomic,strong)NSMutableArray *baojingqiArr;
@property (nonatomic,strong)ListShebeiModel *listModel;
@property (nonatomic,strong)baojingqiModel *baojingqiModel;
@property (nonatomic,strong)nibianqiModel *nibianqiModel;
@end

@implementation EquipmentViewController


- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
    // Do any additional setup after loading the view.
//    self.title = @"设备列表";
    [self.navigationController setNavigationBarHidden:YES];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    [self setTableView];
    [self requestShebeiList];
}

-(void)setTableView{

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
    
    self.bgTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height ) style:UITableViewStyleGrouped];
    self.bgTableView.delegate = self;
    self.bgTableView.dataSource = self;
    self.bgTableView.backgroundColor = [UIColor whiteColor];
    self.bgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:self.bgTableView];

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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.bgTableView) {
        return 3;
    }else if(tableView==self.smallTableView1){
        return _fayongdianArr.count;
    }else if (tableView==self.smallTableView){
        return _nibianqiArr.count;
    }else{
        return _baojingqiArr.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_bgTableView) {
        static NSString *ID = @"bgTableView";
        // 2.从缓存池中取出cell
        self.cell = [tableView dequeueReusableCellWithIdentifier:ID];
        // 3.如果缓存池中没有cell
        if (self.cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"EquipmentTableViewCell" owner:nil options:nil];
            self.cell = [nibs lastObject];
            if (indexPath.row==0) {
                self.cell.NameLabel.text = @"逆变器";
                self.smallTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-60, self.nibianqiArr.count*22 ) style:UITableViewStylePlain];
                self.smallTableView.delegate = self;
                self.smallTableView.dataSource = self;
                self.smallTableView.bounces=NO;
                self.smallTableView.backgroundColor = [UIColor whiteColor];
                self.smallTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                //            self.automaticallyAdjustsScrollViewInsets = NO;
                [self.cell.SmallBg addSubview:self.smallTableView];
                self.cell.SmallBg.userInteractionEnabled = YES;
                self.cell.SmallBg.hidden = YES;

            }else if(indexPath.row==1){
                self.cell.NameLabel.text = @"发用电监测设备";
                self.smallTableView1 = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-60, self.fayongdianArr.count*22 ) style:UITableViewStylePlain];
                self.smallTableView1.delegate = self;
                self.smallTableView1.dataSource = self;
                self.smallTableView1.bounces=NO;
                self.smallTableView1.backgroundColor = [UIColor whiteColor];
                self.smallTableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
                //            self.automaticallyAdjustsScrollViewInsets = NO;
                [self.cell.SmallBg addSubview:self.smallTableView1];
                self.cell.SmallBg.userInteractionEnabled = YES;
                self.cell.SmallBg.hidden = YES;

            }else{
                self.cell.NameLabel.text = @"紧急报警器";
                self.smallTableView2 = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-60, self.baojingqiArr.count*22) style:UITableViewStylePlain];
                self.smallTableView2.delegate = self;
                self.smallTableView2.dataSource = self;
                self.smallTableView2.bounces=NO;
                self.smallTableView2.backgroundColor = [UIColor whiteColor];
                self.smallTableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
                //            self.automaticallyAdjustsScrollViewInsets = NO;
                [self.cell.SmallBg addSubview:self.smallTableView2];
                self.cell.SmallBg.userInteractionEnabled = YES;
                self.cell.SmallBg.hidden = YES;

            }
        }
        if (self.indexPath==indexPath) {
            self.cell.rightImage.image = [UIImage imageNamed:@"减"];
            self.cell.SmallBg.hidden = NO;
        }
        return self.cell;

    }else{
        static NSString *CellIdentifier =@"Cell";
        //定义cell的复用性当处理大量数据时减少内存开销
        UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell ==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
            
            NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:0 inSection:0];
            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
            NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:0];
            if (self.indexPath == indexPath0) {
                cell.textLabel.text = [NSString stringWithFormat:@"逆变器%ld",indexPath.row+1];
            }else if (self.indexPath == indexPath1){
               cell.textLabel.text = [NSString stringWithFormat:@"发用电监测设备%ld",indexPath.row+1];
            }else{
               cell.textLabel.text = [NSString stringWithFormat:@"紧急报警器%ld",indexPath.row+1];
                
            }
            cell.textLabel.font = [UIFont systemFontOfSize:13];
        }
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_bgTableView) {
        if (indexPath == self.indexPath) {
//            return 200;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
            NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:0];
            if(self.indexPath==indexPath){
                return self.nibianqiArr.count*22+73;
            }else if (self.indexPath==indexPath1){
                return self.fayongdianArr.count*22+73;
            }else{
                return self.baojingqiArr.count*22+73;
            }
            self.indexPath = nil;
        }else{
            return 73;
        }

    }else{
        return 22;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
    
    if (tableView==_bgTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        //    self.cell.rightImage.image = [UIImage imageNamed:@"减"];
        if (self.indexPath==indexPath) {
            self.indexPath = nil;
        }else{
            self.indexPath = indexPath;
        }
        [self.bgTableView reloadData];
    }else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:0];
        if (self.indexPath == indexPath) {
            NibianqiViewController *vc = [[NibianqiViewController alloc] initWithNibName:@"NibianqiViewController" bundle:nil];
            vc.model = self.nibianqiArr[indexPath.row];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (self.indexPath == indexPath1){
            ListShebeiViewController *vc = [[ListShebeiViewController alloc] initWithNibName:@"ListShebeiViewController" bundle:nil];
            vc.model = self.fayongdianArr[indexPath.row];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }else{
            BaojingqiViewController *vc = [[BaojingqiViewController alloc] initWithNibName:@"BaojingqiViewController" bundle:nil];
            vc.model = self.baojingqiArr[indexPath.row];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }
       
    }
   
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
        for (NSDictionary *goodsDic in responseObject[@"content"][@"roof"]) {
            _listModel =[[ListShebeiModel alloc] init];
            _listModel.installed_capacity = [goodsDic[@"installed_capacity"]stringValue];
            _listModel.product_model = goodsDic[@"product_model"] ;
            _listModel.bid = goodsDic[@"bi"] ;
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
            [self.nibianqiArr addObject:_nibianqiModel];
        }

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
