//
//  dayFeeModel.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/4/24.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dayFeeModel : NSObject
@property (nonatomic,copy) NSString *bid;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *day;
@property (nonatomic,copy) NSString *use_ele;
@property (nonatomic,copy) NSString *use_fee;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *peak_valley_fee;
@property (nonatomic,copy) NSString *med;
@property (nonatomic,copy) NSString *low;
@property (nonatomic,copy) NSString *use_self;
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *month;
@property (nonatomic,copy) NSString *year;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
