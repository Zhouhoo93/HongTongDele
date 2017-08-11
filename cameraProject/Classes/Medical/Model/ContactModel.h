//
//  ContactModel.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/1/21.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject
@property (nonatomic,copy)NSString *from_id; //请求人ID
@property (nonatomic,copy)NSString *helper_name; //请求人名称
@property (nonatomic,copy)NSString *ID; //id
@property (nonatomic,copy)NSString *phone; //请求人电话
@property (nonatomic,copy)NSString *to_id; //被请求人id
@property (nonatomic,copy)NSString *type; //类型
@property (nonatomic,copy)NSString *from_headimgurl; //添加人头像
@property (nonatomic,copy)NSString *current_page;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *from_tel;
@property (nonatomic,copy)NSString *bid;
@property (nonatomic,copy)NSString *method;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
