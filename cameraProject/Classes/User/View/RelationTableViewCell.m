//
//  RelationTableViewCell.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/5/29.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "RelationTableViewCell.h"
#import "HSingleGlobalData.h"
@implementation RelationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)EditBtnClick:(id)sender {
    NSString *URL = [NSString stringWithFormat:@"%@/app/users/user/del-intimate-user?Intimate_id=%@",kUrl,self.cellTag];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters setValue:self.cellTag forKey:@"Intimate_id"];
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"删除%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            NSNotification *notification =[NSNotification notificationWithName:@"Edit" object:nil userInfo:nil];
            // 3.通过 通知中心 发送 通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
        }else{
            [MBProgressHUD showText:@"删除失败"];
        }
    }
     
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
              NSLog(@"%@",error);  //这里打印错误信息
          }];
}

@end
