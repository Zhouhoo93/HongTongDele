//
//  AddBurglarViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/1/19.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "AddBurglarViewController.h"
#import "AddBurglarTableViewCell.h"
#import "BurglarViewController.h"
#import "HSingleGlobalData.h"
#import "MBProgressHUD.h"
#import "OneLoginViewController.h"
@interface AddBurglarViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,copy) NSString *selfName; //设备名称
@property (nonatomic,copy) NSString *address; //地址
@property (nonatomic,copy) NSString *bid; //地址
@property (nonatomic,copy) NSString *house; //住宅
@property (nonatomic,strong) UISwitch *aswitch;
@property (nonatomic,strong)NSMutableArray *listArr;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,assign) BOOL two;
@property (nonatomic,assign) BOOL three;
@property (nonatomic,assign) BOOL four;
@end

@implementation AddBurglarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(241, 241, 241);
    [self requestAll];
    self.two = NO;
    self.three = NO;
    self.four = NO;
    self.title = @"添加报警点";
    UILabel *tip = [[UILabel alloc] init];
    tip.frame = CGRectMake(40, 64*5, KWidth-80, 20);
    tip.text = @"注:在设置完成前请勿中途退出!";
    tip.textColor = [UIColor redColor];
    tip.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:tip];
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(30, 64*6+60, KWidth-69, 44)];
//    [self.button setBackgroundImage:[UIImage imageNamed:@"login_login"] forState:UIControlStateNormal];
    self.button.backgroundColor = [UIColor grayColor];

    self.button.enabled = NO;
    [self.button setTitle:@"保存" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(requestSave) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
}

-(void)viewWillAppear:(BOOL)animated{
    [_tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setTableView{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,64, KWidth, 4*64)];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = [UIColor whiteColor];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableview.scrollEnabled = NO;
    [self.view addSubview:_tableview];
    
}


#pragma mark - tableView数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"AddBuaglarTableViewCell";
    // 2.从缓存池中取出cell
    AddBurglarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3.如果缓存池中没有cell
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"AddBurglarTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.backgroundColor = [UIColor whiteColor];
//        cell.leftLabel.font = [UIFont systemFontOfSize:14];
        switch (indexPath.row) {
            case 0:
                cell.leftLabel.text = @"设备名称:";
                cell.noteLabel.textColor = [UIColor grayColor];
                if(self.selfName){
                  cell.noteLabel.text = self.selfName;
                }else{
                    cell.noteLabel.text = [NSString stringWithFormat:@"默认名称%lu",self.list.count+1];
                }
                cell.starLabel.hidden = YES;
                [cell.noteLabel addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
//                cell.leftImage.image = [UIImage imageNamed:@"center_account"];
//                cell.rightImage.image = [UIImage imageNamed:@"center_left"];
                break;
            case 1:
                cell.leftLabel.text = @"地址名称:";
                cell.noteLabel.textColor = [UIColor grayColor];
                if ([HSingleGlobalData sharedInstance].address) {
                    self.two = YES;
                }else{
                    self.button.enabled = NO;
//                    [self.button setBackgroundImage:[UIImage imageNamed:@"login_login"] forState:UIControlStateNormal];
                    self.button.backgroundColor = [UIColor grayColor];

                }
                if (self.two&&self.three&&self.four) {
                    self.button.enabled = YES;
//                    [self.button setBackgroundImage:[UIImage imageNamed:@"login_background"] forState:UIControlStateNormal];
                    self.button.backgroundColor = RGBColor(0, 128, 255);
                }else{
                    self.button.enabled = NO;
                    self.button.backgroundColor = [UIColor grayColor];

//                    [self.button setBackgroundImage:[UIImage imageNamed:@"login_login"] forState:UIControlStateNormal];
                }

                cell.noteLabel.text = [HSingleGlobalData sharedInstance].address ? [HSingleGlobalData sharedInstance].address : @"";
                if (cell.noteLabel.text.length >0) {
                    cell.noteLabel.hidden = NO;
                }else{
                    cell.noteLabel.hidden = YES;
                }
                [cell.noteLabel addTarget:self action:@selector(passConTextTwo:) forControlEvents:UIControlEventEditingDidEnd];
//                cell.noteLabel.text = @"手机号";
//                cell.leftImage.image = [UIImage imageNamed:@"center_security_iv"];
                cell.rightImage.image = [UIImage imageNamed:@"center_left"];
                break;
            case 2:
                cell.leftLabel.text = @"详细地址:";
                cell.noteLabel.textColor = [UIColor grayColor];
                cell.noteLabel.text = self.address?self.address:@"";
//                cell.leftImage.image = [UIImage imageNamed:@"center_contact_iv"];
                cell.rightImage.image = [UIImage imageNamed:@"fpower_selectered2"];
                cell.rightImage.frame = CGRectMake(KWidth-12, 25, 6, 6);

                if (cell.noteLabel.text.length>0) {
                    cell.rightImage.hidden = NO;
                }else{
                    cell.rightImage.hidden = YES;
                }
                [cell.noteLabel addTarget:self action:@selector(passConTextExit:) forControlEvents:UIControlEventEditingDidEnd];
                break;
            case 3:
                cell.leftLabel.text = @"楼层门牌号:";
                cell.noteLabel.textColor = [UIColor grayColor];
                cell.noteLabel.text = self.house?self.house:@"";
//                cell.leftImage.image = [UIImage imageNamed:@"center_setting_iv"];
                cell.rightImage.image = [UIImage imageNamed:@"fpower_selectered2"];
                cell.rightImage.frame = CGRectMake(KWidth-12, 25, 6, 6);

                if (cell.noteLabel.text.length>0) {
                    cell.rightImage.hidden = NO;
                }else{
                    cell.rightImage.hidden = YES;
                }
                [cell.noteLabel addTarget:self action:@selector(passConTextDone:) forControlEvents:UIControlEventEditingDidEnd];
            
                break;
            default:
                break;
        }
    }
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  64;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        BurglarViewController *vc = [[BurglarViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
       [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void)requestSave{
    if (self.address&&self.house) {
        NSString *URL = [NSString stringWithFormat:@"%@/app/alertors/alertor/%@",kUrl,[HSingleGlobalData sharedInstance].BID];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.requestSerializer = requestSerializer;
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefaults valueForKey:@"token"];
        [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        //    int y = (arc4random() % 10000000000000);
        //    NSString *str = [NSString stringWithFormat:@"%d",y];
        [parameters setValue:[HSingleGlobalData sharedInstance].BID forKey:@"bid"];
        [parameters setValue:self.selfName?self.selfName:[NSString stringWithFormat:@"默认名称%lu",self.list.count+1] forKey:@"name"];
        [parameters setValue:[HSingleGlobalData sharedInstance].city forKey:@"city"];
        [parameters setValue:[HSingleGlobalData sharedInstance].address forKey:@"address"];
        [parameters setValue:[HSingleGlobalData sharedInstance].position forKey:@"position"];
        [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"新增报警器:%@",responseObject);
            if (!responseObject[@"result"][@"success"]) {
                NSString *str = responseObject[@"result"][@"errorMsg"];
                [MBProgressHUD showText:str];
            }
            NSString *errorcode = [responseObject[@"result"][@"errorCode"] stringValue];
            if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
                [self newLoginTwo];
            
            }else{
                HomeViewController *vc = [[HomeViewController alloc] init];
                vc.hidesBottomBarWhenPushed = NO;
                [self.navigationController popToRootViewControllerAnimated:YES];
//                [self.navigationController pushViewController:vc animated:YES];
//                [vc.tabBarController setSelectedIndex:0];
//                self.hidesBottomBarWhenPushed = NO;
//                vc.tabBarController.hidesBottomBarWhenPushed = NO;
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];

    }else{
        [MBProgressHUD showText:@"未填写完成"];
    }
    
}

- (void)requestAll{
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
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取所有紧急报警器%@",responseObject);
        if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
            [self newLoginTwo];
            

        }else{
            
            self.listArr =responseObject[@"content"];
            [self setTableView];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}


-(void)passConTextChange:(id)sender{
    UITextField* target=(UITextField*)sender;
    NSLog(@"%@",target.text);
    self.selfName = target.text;
}

-(void)passConTextExit:(id)sender{
    UITextField* target=(UITextField*)sender;
    NSLog(@"%@",target.text);
    self.address = target.text;
    if (self.address.length>0) {
        self.three = YES;
        if (self.two&&self.three&&self.four) {
            self.button.enabled = YES;
//            [self.button setBackgroundImage:[UIImage imageNamed:@"login_background"] forState:UIControlStateNormal];
            self.button.backgroundColor = RGBColor(0, 128, 255);

        }else{
            self.button.enabled = NO;
//            [self.button setBackgroundImage:[UIImage imageNamed:@"login_login"] forState:UIControlStateNormal];
            self.button.backgroundColor = [UIColor grayColor];

        }
    }else{
//        [self.button setBackgroundImage:[UIImage imageNamed:@"login_login"] forState:UIControlStateNormal];
        self.button.backgroundColor = [UIColor grayColor];

        self.three = NO;
        self.button.enabled = NO;
    }
    [self.tableview reloadData];
}
-(void)passConTextTwo:(id)sender{
    UITextField* target=(UITextField*)sender;
    NSLog(@"%@",target.text);
    if (target.text.length>0) {
        self.two = YES;
        if (self.two&&self.three&&self.four) {
            self.button.enabled = YES;
//            [self.button setBackgroundImage:[UIImage imageNamed:@"login_background"] forState:UIControlStateNormal];
            self.button.backgroundColor = RGBColor(0, 128, 255);

        }else{
            self.button.enabled = NO;
//            [self.button setBackgroundImage:[UIImage imageNamed:@"login_login"] forState:UIControlStateNormal];
            self.button.backgroundColor = [UIColor grayColor];

        }
    }else{
//        [self.button setBackgroundImage:[UIImage imageNamed:@"login_login"] forState:UIControlStateNormal];
        self.button.backgroundColor = [UIColor grayColor];

        self.two = NO;
        self.button.enabled = NO;
    }
    [self.tableview reloadData];
}


-(void)passConTextDone:(id)sender{
    UITextField* target=(UITextField*)sender;
    NSLog(@"%@",target.text);
    self.house = target.text;
    if (self.house.length>0) {
        self.four = YES;
        if (self.two&&self.three&&self.four) {
            self.button.enabled = YES;
//            [self.button setBackgroundImage:[UIImage imageNamed:@"login_background"] forState:UIControlStateNormal];
            self.button.backgroundColor = RGBColor(0, 128, 255);

        }else{
            self.button.enabled = NO;
//            [self.button setBackgroundImage:[UIImage imageNamed:@"login_login"] forState:UIControlStateNormal];
            self.button.backgroundColor = [UIColor grayColor];

        }
    }else{
//        [self.button setBackgroundImage:[UIImage imageNamed:@"login_login"] forState:UIControlStateNormal];
        self.button.backgroundColor = [UIColor grayColor];

        self.four = NO;
        self.button.enabled = NO;
    }
    [self.tableview reloadData];
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

@end
