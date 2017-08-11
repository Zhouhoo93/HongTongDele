//
//  MineModel.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/2/15.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineModel : NSObject
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *headimgurl; //
@property (nonatomic,copy) NSString *ID; //
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *remember_token;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *token;


- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
