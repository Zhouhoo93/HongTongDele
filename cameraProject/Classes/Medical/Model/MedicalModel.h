//
//  MedicalModel.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/2/5.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MedicalModel : NSObject
@property (nonatomic, copy) NSString *address; 
@property (nonatomic, copy) NSString *headimgurl;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *no;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *registration_id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *updated_at;
@property (nonatomic,strong) NSString *created_at;
@property (nonatomic,strong) NSString *deleted_at;
@property (nonatomic,strong) NSString *helper_id;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
