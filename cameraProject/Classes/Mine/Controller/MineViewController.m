//
//  MineViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 16/12/21.
//  Copyright © 2016年 ziHou. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "OneLoginViewController.h"
#import "HSingleGlobalData.h"
#import "ContactsViewController.h"
#import "UILabel+LeftTopAlign.h"
#import "PersonalViewController.h"
#import "MineModel.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"
#import "SystemViewController.h"
#import "AdministrationViewController.h"
#import "RelationViewController.h"
#import "ChatListViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "RongModel.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,touxiangDelegate,RCIMUserInfoDataSource,RCIMGroupInfoDataSource>
@property (nonatomic,strong)UILabel *addressLabel;
@property (nonatomic,strong)UIImageView *touImage;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)MineModel *model;
@property (nonatomic,assign) BOOL isIntimate;
@property (nonatomic,strong)RongModel *rongmodel;
@property (nonatomic,copy)NSString *rongID;
@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_model.headimgurl]];
//    _touImage.image = [UIImage imageWithData:data];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isIntimate = NO;
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"center_background"] forBarMetrics:UIBarMetricsDefault];
    UIColor * color = [UIColor whiteColor];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController setNavigationBarHidden:YES];
    [self setHeaderView];
    [self setTableView];
    [self requestHeaderImg];
    [self requestSend];
    

}
- (void)requestHeaderImg{
    NSString *URL = [NSString stringWithFormat:@"%@/app/users/user/1",kUrl];
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
        NSLog(@"获取头像%@",responseObject);
        NSNumber *code = responseObject[@"result"][@"errorCode"];
        NSString *errorcode = [NSString stringWithFormat:@"%@",code];
        if ([errorcode isEqualToString:@"41111"])  {
                        [self newLogin];
        }
        NSNumber *Intimate = responseObject[@"content"][@"Intimate"];
        NSString *right = [NSString stringWithFormat:@"%@",Intimate];
        if ([right isEqualToString:@"0"]) {
            self.isIntimate = YES;
        }else{
            self.isIntimate = NO;
        }
            _model = [MineModel mj_objectWithKeyValues:responseObject[@"content"]];
        _model.ID = responseObject[@"content"][@"id"];
        //首先得拿到照片的路径，也就是下边的string参数，转换为NSData型。
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_model.headimgurl]];
        
        //然后就是添加照片语句，这次不是`imageWithName`了，是 imageWithData。
       if (data.length > 0) {
            _touImage.image = [UIImage imageWithData:data];
       }else{
           
           _touImage.image = [UIImage imageNamed:@"moren"];
       }
        if (_model.name.length>0) {
            _nameLabel.text = _model.name;
        }else{
            _nameLabel.text = @"未设定昵称";
        }

    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];

}

- (void)newLogin{
    [MBProgressHUD showText:@"请重新登录"];
    [self performSelector:@selector(backTo) withObject: nil afterDelay:2.0f];
}

-(void)backTo{
    [self clearLocalData];
    OneLoginViewController *VC =[[OneLoginViewController alloc] init];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setHeaderView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 64)];
    imageView.image = [UIImage imageNamed:@"center_background"];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, KWidth,64 )];
    label.text = @"个人中心";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:label];
    
    _touImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 39, 60, 60)];
    _touImage.backgroundColor = [UIColor lightGrayColor];
    _touImage.layer.masksToBounds = YES;
    _touImage.layer.cornerRadius = 30;
    _touImage.image = [UIImage imageNamed:@"moren"];
    //首先得拿到照片的路径，也就是下边的string参数，转换为NSData型。
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_model.headimgurl]];
    if (data.length >0){
        //然后就是添加照片语句，这次不是`imageWithName`了，是 imageWithData。
        _touImage.image = [UIImage imageWithData:data];
    }
    
    [self.view addSubview:_touImage];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 68, 100, 18)];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (_model.name.length>0) {
        _nameLabel.text = _model.nickname;
    }else{
        _nameLabel.text = @"未设定昵称";
    }
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_nameLabel];
   
//    UIImageView *location = [[UIImageView alloc] initWithFrame:CGRectMake(105, 90, 9, 13)];
//    location.image = [UIImage imageNamed:@"center_location"];
//    [self.view addSubview:location];
//    
//    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 90,KWidth-140, 15)];
//    _addressLabel.numberOfLines = 0;
//    _addressLabel.text = @"定位中";
//    _addressLabel.font = [UIFont systemFontOfSize:10];
//    [self.view addSubview:_addressLabel];

}

- (void)requestSend{
    NSString *URL = [NSString stringWithFormat:@"%@/app/chats/chat/get-token",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
 
//    NSLog(@"文章ID:%@",parameters);
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"融云%@",responseObject);
//        _rongmodel.manage_headimg = responseObject[@"content"][@"manage_headimg"];
//        _rongmodel.manage_id = responseObject[@"content"][@"manage_id"];
        self.rongID = responseObject[@"content"][@"manage_id"];
//        _rongmodel.manage_name = responseObject[@"content"][@"manage_name"];
//        _rongmodel.rong_token = responseObject[@"content"][@"rong_token"];
        _rongmodel = [[RongModel alloc] initWithDictionary:responseObject[@"content"]];
        //融云初始化
        [[RCIM sharedRCIM] initWithAppKey:@"82hegw5u8kimx"];
        [[RCIM sharedRCIM] connectWithToken:responseObject[@"content"][@"rong_token"]     success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            // 设置当前用户信息
            [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:[NSString stringWithFormat:@"user_%@",_model.ID] name:_model.name portrait:_model.headimgurl];
            [[RCIM sharedRCIM] setUserInfoDataSource:self];
            [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
            [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
            [[RCIM sharedRCIM] setGroupInfoDataSource:self];
            RCUserInfo *info = [[RCUserInfo alloc] initWithUserId:[NSString stringWithFormat:@"user_%@",_model.ID] name:_model.name portrait:_model.headimgurl];
            [[RCIM sharedRCIM]refreshUserInfoCache:info withUserId:[NSString stringWithFormat:@"user_%@",_model.ID]];
            NSLog(@"%@,%@,%@",_model.ID,_model.name,_model.headimgurl);
            NSLog(@"%@,%@,%@",_rongmodel.manage_name,_rongmodel.manage_id,_rongmodel.manage_headimg);
            [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
            //        self.userID = responseObject[@"content"][@"id"];

        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%d", status);
        } tokenIncorrect:^{
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            NSLog(@"token错误");
        }];
        
        
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
              NSLog(@"%@",error);  //这里打印错误信息
          }];
    
}
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    if ([userId isEqualToString:self.rongID]) {
        NSLog(@"%@对方用户信息:%@",userId,completion);
        return completion([[RCUserInfo alloc] initWithUserId:self.rongID name:self.rongmodel.manage_name portrait:self.rongmodel.manage_headimg]);
        
    }else
    {
        NSLog(@"%@自己用户信息:%@",userId,completion);
        return completion([[RCUserInfo alloc] initWithUserId:self.model.ID name:self.model.name portrait:self.model.headimgurl]);
        
    }
}


- (void)setTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, KWidth, KHeight-120)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.scrollEnabled = NO;
    [self.view addSubview:tableView];

}

#pragma mark - tableView数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    
    return KHeight-120-5*44;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = RGBColor(243, 243, 243);
    return footView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ID = @"MineTableViewCell";
    // 2.从缓存池中取出cell
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3.如果缓存池中没有cell
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MineTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.backgroundColor = [UIColor clearColor];
        cell.nameLabel.font = [UIFont systemFontOfSize:14];
        switch (indexPath.row) {
            case 0:
                cell.nameLabel.text = @"安全中心";
                cell.noteLabel.text = @"修改资料";
                cell.leftImage.image = [UIImage imageNamed:@"center_account"];
                cell.rightImage.image = [UIImage imageNamed:@"center_left"];
                break;
            case 1:
                cell.nameLabel.text = @"系统设置";
                cell.noteLabel.text = @"";
                cell.leftImage.image = [UIImage imageNamed:@"center_setting_iv"];
                cell.rightImage.image = [UIImage imageNamed:@"center_left"];
                break;

            case 2:
                
                cell.nameLabel.text = @"添加成员";
                cell.noteLabel.text = @"";
                cell.rightImage.image = [UIImage imageNamed:@"center_left"];
                cell.leftImage.image = [UIImage imageNamed:@"center_contact_iv"];

                break;
            case 3:
                cell.nameLabel.text = @"我的客服";
                cell.noteLabel.text = @"";
                cell.rightImage.image = [UIImage imageNamed:@"center_left"];
                cell.leftImage.image = [UIImage imageNamed:@"center_out"];
                break;
            case 4:
                cell.nameLabel.text = @"退出登录";
                cell.noteLabel.text = @"";
                cell.leftImage.image = [UIImage imageNamed:@"center_out"];
                break;
            default:
                break;
        }
    }
    return cell;

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
    if (indexPath.row == 3) {
//        ChatListViewController *vc = [[ChatListViewController alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
        RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
        conversationVC.conversationType = 1;
        conversationVC.targetId = self.rongID;
        conversationVC.title = @"客服代理";
        conversationVC.hidesBottomBarWhenPushed = YES;
        [IQKeyboardManager sharedManager].enable = NO;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }else if(indexPath.row == 1){
        SystemViewController *vc = [[SystemViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 0){
        PersonalViewController *vc = [[PersonalViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.name = _model.nickname;
        vc.sex = _model.sex;
        vc.headimgurl = _model.headimgurl;
        vc.myDelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        if (self.isIntimate) {
            RelationViewController *vc = [[RelationViewController alloc] initWithNibName:@"RelationViewController" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [MBProgressHUD showText:@"无权限设置关联"];
        }
       
//        Relation_ViewController *vc = [[Relation_ViewController alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 4){
        [self logOutAction];
    }

}

-(void)genggai{
    [self requestHeaderImg];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *name  = [user valueForKey:@"name"];
    self.nameLabel.text = name;
}

- (void)logOutAction{
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定退出登录吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self clearLocalData];
        OneLoginViewController *VC =[[OneLoginViewController alloc] init];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


-(MineModel *)model{
    if (!_model) {
        _model = [[MineModel alloc] init];
    }
    return _model;
}
-(RongModel *)rongmodel{
    if (!_rongmodel) {
        _rongmodel = [[RongModel alloc] init];
    }
    return _rongmodel;
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
