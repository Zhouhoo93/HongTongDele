//
//  XYFeedModel.m
//  Demo
//
//  Created by wuw on 16/6/15.
//  Copyright © 2016年 fifyrio. All rights reserved.
//

#import "XYFeedModel.h"

@implementation XYFeedModel
- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = super.init;
    if (self) {
        _article_id = dictionary[@"article_id"];
        _content = dictionary[@"content"];
        _updated_at = dictionary[@"created_at"];
        _ID = dictionary[@"id"];
        _num = dictionary[@"num"];
        _user = dictionary[@"user"];
        _user_id = dictionary[@"user_id"];
        _user_name = dictionary[@"user_name"];
        _user_pic = dictionary[@"user_pic"];
        _isSelect = dictionary[@"zan"];
        
    }
    return self;
}
@end
