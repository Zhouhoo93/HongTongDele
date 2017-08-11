//
//  StatusModel.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/4/21.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusModel : NSObject
@property (nonatomic,strong) NSArray *compare_result;
@property (nonatomic,strong) NSArray *net_ele;
@property (nonatomic,strong) NSArray *today_gen;
@property (nonatomic,strong) NSArray *today_gen_use_self;
@property (nonatomic,strong) NSArray *today_use;
@property (nonatomic,strong) NSArray *up_net_ele;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
