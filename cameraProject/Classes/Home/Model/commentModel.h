//
//  commentModel.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/7/18.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface commentModel : NSObject
@property (nonatomic,copy)NSString *article_id;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *updated_at;
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *num;
@property (nonatomic,copy)NSString *user;
@property (nonatomic,copy)NSString *user_id;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
