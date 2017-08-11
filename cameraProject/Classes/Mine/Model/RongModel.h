//
//  RongModel.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/7/21.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RongModel : NSObject
@property (nonatomic,copy) NSString *manage_headimg;
@property (nonatomic,copy) NSString *manage_id;
@property (nonatomic,copy) NSString *manage_name;
@property (nonatomic,copy) NSString *rong_token;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
