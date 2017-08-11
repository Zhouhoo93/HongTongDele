//
//  dayGenModel.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/4/24.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dayGenModel : NSObject
@property (nonatomic,copy) NSString *bid;
@property (nonatomic,copy) NSString *cash_income;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *economize_price;
@property (nonatomic,copy) NSString *gen;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *gen_income;
@property (nonatomic,copy) NSString *month;
@property (nonatomic,copy) NSString *day;
@property (nonatomic,copy) NSString *year;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
