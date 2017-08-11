//
//  ContactsTableViewCell.m
//  cameraProject
//
//  Created by Zhouhoo on 16/12/21.
//  Copyright © 2016年 ziHou. All rights reserved.
//

#import "ContactsTableViewCell.h"
#import "MBProgressHUD.h"
@implementation ContactsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:NO];

    // Configure the view for the selected state
}
- (IBAction)leftBtnClick:(id)sender {
     MyLog(@"接收");
    [self requestYes];
}
- (IBAction)rightBtnClick:(id)sender {
    if (self.isHelpTable) {
        MyLog(@"添加 删除");
        [self requestAdd];
    }else{
        MyLog(@"拒绝");
        [self requestNo];
    }
}
//添加
- (void)requestAdd{
    NSString *URL = [NSString stringWithFormat:@"%@/app/users/user/application/apply",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.textLabel1.text forKey:@"phone"];
    [parameters setValue:self.nameLabel.text forKey:@"helper_name"];
    [parameters setValue:self.bid forKey:@"bid"];
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"添加%@",responseObject);
        if (!responseObject[@"result"][@"success"]&&![responseObject[@"result"][@"errorCode"] isEqualToString:@"41111"]) {
            NSString *str = responseObject[@"result"][@"errorMsg"];
            [MBProgressHUD showText:str];
        }

        [self.rightBtn setTitle:@"已发送" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.rightBtn.enabled = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
    }];

}

//接收
- (void)requestYes{
    NSString *URL = [NSString stringWithFormat:@"%@/app/users/user/application/%@/accept",kUrl,self.ID];
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
        NSLog(@"接收%@",responseObject);
//        self.leftBtn.titleLabel.text = @"已接受";
        [self.leftBtn setTitle:@"已接受" forState:UIControlStateNormal];
        self.leftBtn.titleLabel.textColor = [UIColor redColor];
        self.leftBtn.enabled = NO;
        self.rightBtn.enabled = NO;

    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];

}
//拒绝
- (void)requestNo{
    NSString *URL = [NSString stringWithFormat:@"%@/app/users/user/application/%@/reject",kUrl,self.ID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
//    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    manager.requestSerializer = requestSerializer;
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    //    NSLog(@"token is :%@",token);
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"拒绝%@",responseObject);
//        self.rightBtn.titleLabel.text = @"已拒绝";
        [self.rightBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
        self.rightBtn.titleLabel.textColor = [UIColor redColor];
        self.rightBtn.enabled = NO;
        self.leftBtn.enabled = NO;
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    

}

@end
