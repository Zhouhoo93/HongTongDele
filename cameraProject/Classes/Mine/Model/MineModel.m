//
//  MineModel.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/2/15.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "MineModel.h"

@implementation MineModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if ([super init]) {
        //KVC赋值
        if (dic)
            [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
