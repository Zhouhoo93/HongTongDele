//
//  NamePeopleModel.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/5/30.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "NamePeopleModel.h"

@implementation NamePeopleModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if ([super init]) {
        //KVC赋值
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
