//
//  TransparentController.h
//  swjsq
//
//  Created by jordan on 16/7/22.
//  Copyright © 2016年 MD313. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol reloadDelegate <NSObject>
@required
- (void)popreload;
@end
@interface TransparentController : UIViewController
@property (nonatomic,copy) NSString *bid;
@property (nonatomic, assign) id <reloadDelegate> delegate;
@end
