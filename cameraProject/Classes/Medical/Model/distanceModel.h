//
//  distanceModel.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/2/8.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface distanceModel : NSObject
@property (nonatomic, copy  ) NSString *actual_distance;
@property (nonatomic, copy  ) NSString *city;
//@property (nonatomic, copy  ) NSString *from_registration_id;
@property (nonatomic, copy  ) NSString *straight_line_distance;
//@property (nonatomic, copy  ) NSString *to_registration_id;
@property (nonatomic, copy  ) NSString *bid;
@property (nonatomic, copy  ) NSString *name;
@property (nonatomic, copy  ) NSString *phone;
@property (nonatomic, copy  ) NSString *type;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
