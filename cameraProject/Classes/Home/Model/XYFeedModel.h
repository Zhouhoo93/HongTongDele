//
//  XYFeedModel.h
//  Demo
//
//  Created by wuw on 16/6/15.
//  Copyright © 2016年 fifyrio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYFeedModel : NSObject
@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *user_pic;
@property (nonatomic, copy) NSString *isSelect;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
