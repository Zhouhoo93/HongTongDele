//
//  RHSocketConfig.h
//  socket
//
//  Created by Zhouhoo on 2017/1/17.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#ifndef RHSocketDemo_RHSocketConfig_h
#define RHSocketDemo_RHSocketConfig_h

#ifdef DEBUG
#define RHSocketDebug
#endif

#ifdef RHSocketDebug
#define RHSocketLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define RHSocketLog(format, ...)
#endif

#endif


#import <Foundation/Foundation.h>
@interface RHSocketConfig : NSObject

@end
