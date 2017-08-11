//
//  helpModel.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/2/7.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "helpModel.h"

@implementation helpModel
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
