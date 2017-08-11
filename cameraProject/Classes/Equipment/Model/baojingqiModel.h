//
//  baojingqiModel.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/5/11.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface baojingqiModel : NSObject
@property (nonatomic, copy  ) NSString *bid;
@property (nonatomic, copy  ) NSString *num;
@property (nonatomic, copy  ) NSString *position;
@property (nonatomic, copy  ) NSString *product_model;
@property (nonatomic, copy  ) NSString *ID;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
