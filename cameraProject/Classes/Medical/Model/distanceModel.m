//
//  distanceModel.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/2/8.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "distanceModel.h"

@implementation distanceModel
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
