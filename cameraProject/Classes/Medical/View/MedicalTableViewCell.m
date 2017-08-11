//
//  MedicalTableViewCell.m
//  cameraProject
//
//  Created by Zhouhoo on 16/12/20.
//  Copyright © 2016年 ziHou. All rights reserved.
//

#import "MedicalTableViewCell.h"
#import "distanceModel.h"
@implementation MedicalTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (IBAction)deleBtnClick:(UIButton *)sender {
    NSLog(@"删除cell");
    [self.daohangDelegate deleCell:sender];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:NO];

    // Configure the view for the selected state
}
- (IBAction)smallBtnClick:(id)sender {
    if (!self.isHelpTable) {
        MyLog(@"导航开始");
        [self.daohangDelegate daohang];
    }
}
//- (IBAction)callBtnClick:(id)sender {
//    }
- (IBAction)RightBtnClick:(UIButton *)sender {
    if (sender.selected) {
        MyLog(@"取消呼叫");
        [self requestQuXiao];
    }else{
        if(self.isHelpTable){
            MyLog(@"呼叫");
            if (self.isTongYi == YES) {
                [self requestCall];
            }else{
                [MBProgressHUD showText:@"请开启求助功能"];
            }
            
        }else{
            MyLog(@"响应");
            
            if (self.isTongYi) {
                [self.rightBtn setSelected:YES];
                [self.rightBtn setTitle:@"已响应" forState:UIControlStateNormal];
                self.rightBtn.enabled = NO;
                self.isCall = YES;
                [self.daohangDelegate XiangYingBtnClick:self.helper_id:self.bid];
            }else{
                [MBProgressHUD showText:@"请开启求助功能"];
            }
            
        }

    }
}


- (void)requestQuXiao{
    NSString *URL = [NSString stringWithFormat:@"%@/api/alert/calcel-app-alert",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.helper_id forKey:@"id"];
    [parameters setValue:self.name forKey:@"name"];
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"取消呼叫%@",responseObject);
        NSString *success = responseObject[@"result"][@"success"];
        if ([success integerValue]) {
            [self.rightBtn setSelected:NO];
            self.dongHuaImage.hidden = YES;
            self.isCall = NO;
            
        }else{
            [MBProgressHUD showText:@"取消呼叫失败"];
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
}


- (void)requestCall{
        NSString *URL = [NSString stringWithFormat:@"%@/api/alert/start-alert",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.longitude forKey:@"longitude"];
    [parameters setValue:self.name forKey:@"name"];
    [parameters setValue:self.latitude forKey:@"latitude"];
    [parameters setValue:self.city forKey:@"city"];
//    [parameters setValue:self.registration_id forKey:@"to_registration_id"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [parameters setValue:self.helper_id forKey:@"id"];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"%@",token);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"呼叫%@",responseObject);
//        NSDictionary *dic = responseObject[@"result"];
        NSInteger *success = [responseObject[@"result"][@"success"] integerValue];
        if (success) {
            self.dongHuaImage.hidden = NO;
            
            NSMutableArray  *arrayM=[NSMutableArray array];
            for (int i=0; i<3; i++) {
                [arrayM addObject:[UIImage imageNamed:[NSString stringWithFormat:@"app_loading_%zd",i+1]]];
            }
            //设置动画数组
            [self.dongHuaImage setAnimationImages:arrayM];
            //设置动画播放次数
            [self.dongHuaImage setAnimationRepeatCount:0];
            //设置动画播放时间
            [self.dongHuaImage setAnimationDuration:6*0.075];
            //开始动画
            [self.dongHuaImage startAnimating];
            

            [self requestTime];
            [self.rightBtn setSelected:YES];
            self.isCall = YES;

        }else{
            [MBProgressHUD showText:@"呼叫失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];

}

- (void)requestTime{
    self.count = 0;
//    dispatch_time_t timer = dispatch_time(DISPATCH_TIME_NOW,5.0 * NSEC_PER_SEC);
    
//    dispatch_after(timer, dispatch_get_main_queue(), ^(void){
    
        //0.创建队列
        dispatch_queue_t queue = dispatch_get_main_queue();
        //1.创建GCD中的定时器
        /*
         第一个参数:创建source的类型 DISPATCH_SOURCE_TYPE_TIMER:定时器
         第二个参数:0
         第三个参数:0
         第四个参数:队列
         */
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        
        //2.设置时间等
        /*
         第一个参数:定时器对象
         第二个参数:DISPATCH_TIME_NOW 表示从现在开始计时
         第三个参数:间隔时间 GCD里面的时间最小单位为 纳秒
         第四个参数:精准度(表示允许的误差,0表示绝对精准)
         */
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 20.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        
        //3.要调用的任务
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
            NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
//            [parameter setValue:[HSingleGlobalData sharedInstance].registerid forKey:@"from_registration_id"];
            [parameter setValue:self.helper_id forKey:@"id"];
            [manager GET:URL parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
                
            }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                self.count ++;
                NSLog(@"是否有值%@",responseObject);
                NSString *content = responseObject[@"content"];
                NSLog(@"%@",content);
                if ([content isKindOfClass:[NSNull class]]||[content isEqual:NULL]) {
                    NSLog(@"空的!");
                    if (self.count>5) {
                        self.dongHuaImage.hidden = YES;
                        dispatch_cancel(self.timer);
                        //                    NSLog(@"取消定时器");
                        self.count = 0;
                    }

                }else{
                    NSLog(@"将距离替换");
                    for (NSDictionary *goodsDic in responseObject[@"content"]) {
                        if ([goodsDic[@"actual_distance"] isEqualToString:@"-1"]||[goodsDic[@"straight_line_distance"] isEqualToString:@"-1"]) {
                            if (!self.lianXuhujiao) {
                                [MBProgressHUD showText:@"不能连续呼叫"];
                                self.lianXuhujiao = YES;
                            }
                        }else{
                            NSInteger name = [self.helper_id integerValue];
                            NSInteger ID = [goodsDic[@"id"] integerValue];
                            if(ID == name){
                            self.model.actual_distance = goodsDic[@"actual_distance"]?goodsDic[@"actual_distance"]:@"0";
                            self.model.city = goodsDic[@"city"]?goodsDic[@"city"]:@"";
//                            self.model.from_registration_id = goodsDic[@"from_registration_id"];
                            self.model.straight_line_distance = goodsDic[@"straight_line_distance"]?goodsDic[@"straight_line_distance"]:@"0";
//                            self.model.to_registration_id = goodsDic[@"to_registration_id"];
                                self.straight_line_distance = self.model.straight_line_distance;
                                self.actual_distance = self.model.actual_distance;
                            self.model.bid = goodsDic[@"bid"];
                            }
                            if(self.model.bid.length>0){
                                NSLog(@"硬件呼叫");
                            }else{
                                NSLog(@"软件呼叫");
                            }
                            NSInteger actual = [self.model.actual_distance integerValue];
                            
                            self.actualLabel.text = [NSString stringWithFormat:@"%zd",actual];
                            NSInteger straight = [self.model.straight_line_distance integerValue];
                            self.lineLabel.text = [NSString stringWithFormat:@"%zd",straight];
                            //                    [HSingleGlobalData sharedInstance].isHave = YES;
                            self.smallBtn.enabled = YES;
                            if (![self.model.straight_line_distance isEqualToString:@""]&&![self.model.straight_line_distance isEqualToString:@"0"]&&self.model.straight_line_distance) {
                                [self.smallBtn setTitle:@"已响应" forState:UIControlStateNormal];
                        }
                    }

                    
                    }
                    
                }
                //2分钟后还是无响应内容,再推送一条
                if (_count % 12 == 0 &&[self.model.actual_distance isEqualToString:@""]) {
                    NSString *URL = [NSString stringWithFormat:@"%@/api/alert/start-alert",kUrl];
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                    [parameters setValue:self.name forKey:@"name"];
                    [parameters setValue:self.longitude forKey:@"longitude"];
                    [parameters setValue:self.latitude forKey:@"latitude"];
                    [parameters setValue:self.city forKey:@"city"];
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [parameters setValue:self.helper_id forKey:@"id"];
                    NSString *token = [userDefaults valueForKey:@"token"];
                    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
                    
                    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        MyLog(@"无响应内容,第二次呼叫%@",responseObject);
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        MyLog(@"%@",error);
                        //        [MBProgressHUD showText:@"%@",error[@"error"]];
                    }];

                }
                NSInteger dis = [self.model.straight_line_distance integerValue];
                if (dis!=0) {
                    if(_count==600){
//                        self.dongHuaImage.hidden = YES;
                        dispatch_cancel(self.timer);
                        //                    NSLog(@"取消定时器");
                        self.count = 0;
                    }

                }
                            }
                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
                     NSLog(@"%@",error);  //这里打印错误信息
                 }];

        });
        
        //4.开始执行
        dispatch_resume(timer);
        
        //
        self.timer = timer;

        
//    });
}

-(distanceModel *)model{
    if (!_model) {
        _model = [[distanceModel alloc] init];
    }
    return  _model;
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

@end
