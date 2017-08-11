//
//  Relation ViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/5/29.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "RelationViewController.h"
#import "RelationTableViewCell.h"
#import "EditUserViewController.h"
#import "AddViewController.h"
#import "NamePeopleModel.h"
@interface RelationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *noDataImage;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NamePeopleModel *model;
@end

@implementation RelationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关联账户";
    [self requestData];
    [self setTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(edit) name:@"Edit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"SendTijiao" object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)reloadTable{
    [self requestData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)edit{
    [self requestData];
//    [self.table reloadData];
}
- (IBAction)add:(id)sender {
    AddViewController *vc = [[AddViewController alloc] initWithNibName:@"AddViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setTableView{
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, KWidth, KHeight-150) style:UITableViewStyleGrouped];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.table];
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
// 返回行数
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

// 设置cell
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"RelationCell";
    RelationTableViewCell *cell = (RelationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell= (RelationTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"RelationTableViewCell" owner:self options:nil]  lastObject];
        cell.removeBtn.tag = indexPath.row;
        NamePeopleModel *people = self.dataArr[indexPath.section];
        cell.nameTextField.text = people.nickname;
        cell.phoneTextField.text = people.phone;
        cell.cellTag = [NSString stringWithFormat:@"%@",people.ID];
    }
    // 自己的一些设置
    
    return (UITableViewCell *)cell;
}

#pragma mark - 代理方法
/**
 *  设置行高
 */
- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 81;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.11111;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)requestData{
    NSString *URL = [NSString stringWithFormat:@"%@/app/users/user/get-intimate-relation-list",kUrl];
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
        NSLog(@"成员列表%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            [self.dataArr removeAllObjects];
            for (NSDictionary *goodsDic in responseObject[@"content"]) {
                _model =[[NamePeopleModel alloc] initWithDictionary:goodsDic];
                [self.dataArr addObject:_model];
            }
                if (self.dataArr.count>0) {
                    _noDataImage.hidden = YES;
                    _table.hidden = NO;
                }else{
                    _noDataImage.hidden = NO;
                    _table.hidden = YES;
                }
            if (self.table) {
                [self.table reloadData];
            }
           
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];

  
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}

-(NamePeopleModel *)model{
    if(!_model){
        _model = [[NamePeopleModel alloc] init];
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
