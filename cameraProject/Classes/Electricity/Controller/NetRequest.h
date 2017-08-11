//
//  NetRequest.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/5/19.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetRequest : NSObject
//get
+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters sucess:(void (^)(id responseObject))sucess failure:(void(^)(NSError *error))failure;

//post
+ (void)POST:(NSString *)url parameters:(NSDictionary *)parameters sucess:(void (^)(id responseObject))sucess failure:(void(^)(NSError *error))failure;

@end
