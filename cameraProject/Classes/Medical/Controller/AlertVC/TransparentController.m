//
//  TransparentController.m
//
//
//  Created by jordan on 16/7/22.
//  Copyright © 2016年 MD313. All rights reserved.
//

#import "TransparentController.h"
#import "SmallTableViewCell.h"
#import "SmallModel.h"
#import "MBProgressHUD.h"
@interface TransparentController ()<UITableViewDelegate,UITableViewDataSource,MycellDelegate>
@property (nonatomic,weak) IBOutlet UILabel * uiContentLabel;
@property (nonatomic,weak) IBOutlet UILabel * uiContentLabel2;
@property (weak, nonatomic) IBOutlet UIView *smallview;
@property (nonatomic,strong) NSMutableArray *listArr;
@property (nonatomic,strong) SmallModel *model;
@property (nonatomic,strong) UITableView *tab;
@property (nonatomic,strong) NSMutableArray *selectArr;
@property (nonatomic,strong) NSMutableArray *requestArr;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) NSTimer *myTimer;

@end

@implementation TransparentController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    [self request];
    self.tab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 295, 175) style:UITableViewCellStyleDefault];
    _tab.delegate = self;
    _tab.dataSource = self;
    [self.smallview addSubview:_tab];
}

-(IBAction)buttonClick:(id)sender
{
    [self.requestArr removeAllObjects];
    for (int i=0; i<_selectArr.count; i++) {
        SmallModel *model = _selectArr[i];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:model.bid forKey:@"bid"];
        [dic setValue:model.name forKey:@"name"];
        [dic setValue:model.to_id forKey:@"to_id"];
        [dic setValue:model.phone forKey:@"phone"];
        [dic setValue:model.type forKey:@"type"];
        [dic setValue:model.ID forKey:@"id"];
        [self.requestArr addObject:dic];
    }
    NSString *URL = [NSString stringWithFormat:@"%@/app/helpers/helper/app-synchronize-with-equipment",kUrl];
    // 获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    // 设置请求格式
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    //[session.requestSerializer requestWithMethod:@"POST" URLString:URL parameters:_selectArr error:nil];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [session.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
//    [session POST:@"" parameters:@"" progress:nil success:nil failure:nil];
    NSData *data=[NSJSONSerialization dataWithJSONObject:_requestArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonStr];
    NSRange range = {0,jsonStr.length};
    [mutStr replaceOccurrencesOfString:@" "withString:@""options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n"withString:@""options:NSLiteralSearch range:range2];
    NSMutableString *responseString = [NSMutableString stringWithString:mutStr];
    NSString *character = nil;
    for (int i = 0; i < responseString.length; i ++) {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\\"])
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.bid forKey:@"bid"];
    [parameters setValue:responseString forKey:@"helpers"];

    [session POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传json%@",responseObject);
         [self performSelector:@selector(requestGet) withObject:@"Grand Central Dispatch" afterDelay:20.0];
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                   target:self
                                                 selector:@selector(download)
                                                 userInfo:nil
                                                  repeats:YES];
        //进度条的创建
        _progressView =[[UIProgressView alloc]init];
        //进度条的位置大小设置
        //进度条的高度是不可以变化的，这里的40是不起任何作用的系统默认
        _progressView.frame=CGRectMake(10, KHeight-100, KWidth-20, 140);
        //甚至进度条的风格颜色值，默认是蓝色的
        _progressView.progressTintColor=[UIColor blackColor];
        //表示进度条未完成的，剩余的轨迹颜色,默认是灰色
        _progressView.trackTintColor =[UIColor whiteColor];
        //设置进度条的进度值
        //范围从0~1，最小值为0，最大值为1.
        //0.8-->进度的80%
        _progressView.progress=0;
        //置进度条的风格特征
        //    _progressView.progressViewStyle=UIProgressViewStyleBar;
        _progressView.progressViewStyle=UIProgressViewStyleDefault;
        [self.view addSubview:_progressView];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"同步中...";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:20];
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}
- (void)download{
    _progressView.progress += 0.05; // 设定步进长度
    if (_progressView.progress == 1.0) {// 如果进度条到头了
        // 终止定时器
        [_myTimer invalidate];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.delegate popreload];
    }
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
            [MBProgressHUD showText:@"同步失败"];
        }else{
        }
       
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    

}

-(void)requestJson{
    

}
- (IBAction)cancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [_selectArr removeAllObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)request{
    NSString *URL = [NSString stringWithFormat:@"%@/app/helpers/helper/keep-data-list?bid=%@",kUrl,self.bid];
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
        NSLog(@"小窗口同步人列表%@",responseObject);
        [self.listArr removeAllObjects];
        for (NSDictionary *goodsDic in responseObject[@"content"]) {
            _model =[[SmallModel alloc] initWithDictionary:goodsDic];
            [self.listArr addObject:_model];
        }
        [self.tab reloadData];
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArr.count?_listArr.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SmallModel *model = _listArr[indexPath.row];
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    SmallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"SmallTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.nameLabel.text = model.phone;
        cell.rightBtn.tag = indexPath.row;
        cell.model = model;
        cell.delegate = self;
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(SmallModel *)model{
    if (!_model) {
        _model = [[SmallModel alloc] init];
    }
    return _model;
}

-(NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _listArr;
}

-(void)didClickButton:(UIButton *)button
{
    SmallModel *model = _listArr[button.tag];
    [self.selectArr addObject:model];
    NSLog(@"%@",_selectArr);
}
-(void)disselectButton:(UIButton *)button{
    SmallModel *model = _listArr[button.tag];
    for (int i = _selectArr.count - 1; i >= 0; i--) {
        SmallModel *obj = _selectArr[i];
        if ([obj isEqual:model]) {
            [_selectArr removeObject:obj];
        }
    }
    NSLog(@"%@",_selectArr);
}

-(NSMutableArray *)selectArr{
    if (!_selectArr) {
        _selectArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _selectArr;
}

-(NSMutableArray *)requestArr{
    if (!_requestArr) {
        _requestArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _requestArr;
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
