//
//  nibianqiModel.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/5/11.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface nibianqiModel : NSObject
@property (nonatomic, copy  ) NSString *brand;
@property (nonatomic, copy  ) NSString *ID;
@property (nonatomic, copy  ) NSString *num;
@property (nonatomic, copy  ) NSString *power_rating;
@property (nonatomic, copy  ) NSString *product_model;
@property (nonatomic, copy  ) NSString *status;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
