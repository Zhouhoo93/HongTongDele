//
//  ConnectViewController.h
//  cameraProject
//
//  Created by Zhouhoo on 2017/1/17.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"
@interface ConnectViewController : UIViewController
@property (nonatomic,copy) NSString *wifiName;
@property (nonatomic,copy) NSString *bid;
@property (nonatomic,strong)UITextField *password;
@property (nonatomic, strong) GCDAsyncSocket *socket;       // socket
@property (nonatomic,retain)NSTimer * heartTimer;   // 心跳计时器
@property (nonatomic,assign)BOOL isFirst;//是否是第一次返回+OK
@property (nonatomic,strong)NSString *time;
@property (nonatomic,assign)NSInteger tag;//第几次发送请求
@property (nonatomic,copy)NSString *myselfWifi;
@property (nonatomic,copy)NSString *nowWifi;

@end
