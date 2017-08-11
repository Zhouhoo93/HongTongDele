//
//  AlarmModel.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/2/15.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmModel : NSObject
@property (nonatomic, strong) NSString *bid; //总发电费用
@property (nonatomic, strong) NSString *degree; //总发电量
@property (nonatomic, strong) NSString *ID; //天发电费用
@property (nonatomic, strong) NSString *pid;  //天发电量
@property (nonatomic, strong) NSString *result; //月发电费用
@property (nonatomic, strong) NSString *status; //月发电量
@property (nonatomic, strong) NSString *type; //年发电费用
@property (nonatomic, strong) NSString *user_id; //年发电量
@property (nonatomic,strong) NSString *value;
@property (nonatomic,copy) NSString *reason; //电站名称
@property (nonatomic,copy) NSString *created_at; //电站名称
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
