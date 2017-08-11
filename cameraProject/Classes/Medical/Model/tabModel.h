//
//  tabModel.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/2/9.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface tabModel : NSObject
@property (nonatomic, copy) NSString *bid;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *deleted_at;
@property (nonatomic, copy) NSString *from_headimgurl;
@property (nonatomic, copy) NSString *from_id;
@property (nonatomic, copy) NSString *helper_name;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *method;//
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,copy) NSString *to_id; //
@property (nonatomic,copy) NSString *type; //
@property (nonatomic,copy) NSString *updated_at;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
