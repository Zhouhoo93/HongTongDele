//
//  NamePeopleModel.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/5/30.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NamePeopleModel : NSObject
@property (nonatomic,copy)NSString *nickname;
@property (nonatomic,copy)NSString *phone;
@property (nonatomic,copy)NSString *ID;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
