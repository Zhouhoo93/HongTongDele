//
//  ListShebeiModel.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/5/11.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListShebeiModel : NSObject
@property (nonatomic, copy  ) NSString *bid;
@property (nonatomic, copy  ) NSString *installed_capacity;
@property (nonatomic, copy  ) NSString *product_model;
@property (nonatomic, copy  ) NSString *rated_current;
@property (nonatomic, copy  ) NSString *status;
@property (nonatomic, copy  ) NSString *access_way;
@property (nonatomic, copy  ) NSString *use_ele_way;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
