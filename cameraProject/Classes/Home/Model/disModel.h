//
//  disModel.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/7/18.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface disModel : NSObject
@property (nonatomic,copy)NSString *author;
@property (nonatomic,copy)NSString *desc;
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *subtitle;
@property (nonatomic,copy)NSString *thumbnail;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *updated_at;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
