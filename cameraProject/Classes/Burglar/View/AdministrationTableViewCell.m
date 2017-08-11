//
//  AdministrationTableViewCell.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/1/19.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "AdministrationTableViewCell.h"

@implementation AdministrationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)editBtnClick:(id)sender {
    if (self.editBtn.selected) {
        self.editBtn.selected = NO;
        self.nameLabel.enabled = NO;
        self.addressLabel.enabled = NO;
//        NSString *pid = [[NSString alloc] initWithFormat:@"%@",self.editBtn.tag];
//        NSLog(@"编辑按钮点击%@",pid);
        NSString *url = [NSString stringWithFormat:@"%@/app/alertors/alertor/%@",kUrl,self.bid];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.requestSerializer = requestSerializer;
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [userDefaults valueForKey:@"token"];
        [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:self.name? self.name : self.nameLabel.text forKey:@"name"];
        [parameters setValue:self.address? self.address : self.addressLabel.text forKey:@"address"];
        [manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];


    }else{
        self.editBtn.selected = YES;
        self.nameLabel.enabled = YES;
        self.addressLabel.enabled = YES;
        [self.nameLabel becomeFirstResponder];
    }
}

- (IBAction)leftBtnClick:(id)sender {
    if (self.leftBtn.selected) {
        self.leftBtn.selected = NO;
        [self requestMoren];
    }else{
        self.leftBtn.selected = YES;
        [self requestMoren];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//添加输入改变的方法

- (void)textFieldEditChanged:(UITextField *)textField
{
    if (textField.tag == 100001) {
        self.name = [NSString stringWithFormat:@"%@",textField.text];
    }else if(textField.tag == 100002){
        self.address = [NSString stringWithFormat:@"%@",textField.text];
    }
    //    NSLog(@"textfield text %@",textField.text);
    //    _nameText.text = [NSString stringWithFormat:@"%@",textField.text];
}

- (void)requestMoren{

    NSString *url = [NSString stringWithFormat:@"%@/app/alertors/alertor/%@",kUrl,self.bid];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.name? self.name : self.nameLabel.text forKey:@"name"];
    [parameters setValue:self.address? self.address : self.addressLabel.text forKey:@"address"];
    if (self.leftBtn.selected) {
        [parameters setValue:@"1" forKey:@"default"];
    }else{
        [parameters setValue:@"0" forKey:@"default"];
    }
    [manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}

@end
