//
//  StatusModel.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/4/21.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "StatusModel.h"

@implementation StatusModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if ([super init]) {
        //KVC赋值
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
