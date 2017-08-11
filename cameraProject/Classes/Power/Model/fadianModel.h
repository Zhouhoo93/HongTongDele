//
//  fadianModel.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/4/26.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface fadianModel : NSObject
@property (nonatomic,copy) NSString *EventTime;
@property (nonatomic,copy) NSString *INVERTER_ERRORCODE;
@property (nonatomic,copy) NSString *INVERTER_STATUS;
@property (nonatomic,copy) NSString *reason;
@property (nonatomic,copy) NSString *property;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *detail;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
