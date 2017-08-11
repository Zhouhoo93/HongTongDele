//
//  AdministrationModel.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/1/19.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdministrationModel : NSObject
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *defaul;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *position;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
