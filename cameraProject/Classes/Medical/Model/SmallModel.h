//
//  SmallModel.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/2/9.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmallModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *to_id;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *type;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
