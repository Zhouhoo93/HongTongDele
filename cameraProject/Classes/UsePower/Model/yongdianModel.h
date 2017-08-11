//
//  yongdianModel.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/4/26.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface yongdianModel : NSObject
@property (nonatomic,copy) NSString *EventTime;
@property (nonatomic,copy) NSString *bid;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *details;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *property;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *value;
@property (nonatomic,copy) NSString *reason;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
