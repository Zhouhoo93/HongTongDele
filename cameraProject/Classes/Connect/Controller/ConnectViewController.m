//
//  ConnectViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/1/17.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "ConnectViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>
#import "RHSocketConnection.h"
#import "MBProgressHUD.h"
#import "HSingleGlobalData.h"
#import "AddBurglarViewController.h"
#import "sendViewController.h"
@interface ConnectViewController()<RHSocketConnectionDelegate>
{
    NSString *_serverHost;
    int _serverPort;
    RHSocketConnection *_connection;
    //HUD（Head-Up Display，意思是抬头显示的意思）
    MBProgressHUD *HUD;
}
@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"绑定报警器";
    self.view.backgroundColor = RGBColor(240, 240, 240);
    self.myselfWifi = [self getWifiName];
    [self setUI];
    [self setwifi];
//    [self getWifiName];
//    self.myselfWifi = [self getWifiName];
    [self getIPAddress];
    self.isFirst = NO;
    self.tag = 0;
    self.time = @"第一次";
    // 状态栏是由当前app控制的，首先获取当前app
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    int type = 0;
    for (id child in children) {
        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    
    NSString *stateString = @"wifi";
    
    switch (type) {
        case 0:
            stateString = @"notReachable";
            [MBProgressHUD showText:@"请开启网络并重新扫描二维码"];
            break;
            
        case 1:
            stateString = @"2G";
            [MBProgressHUD showText:@"请连接至wifi网络并重新扫描二维码"];
            break;
            
        case 2:
            stateString = @"3G";
            [MBProgressHUD showText:@"请连接至wifi网络并重新扫描二维码"];
            break;
            
        case 3:
            stateString = @"4G";
            [MBProgressHUD showText:@"请连接至wifi网络并重新扫描二维码"];
            break;
            
        case 4:
            stateString = @"LTE";
            [MBProgressHUD showText:@"请连接至wifi网络并重新扫描二维码"];
            break;
            
        case 5:
            stateString = @"wifi";
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUI{

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 170, KWidth-40, 20)];
    label.text = @"注:连接前请将无线网络切换至报警器wifi";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    
    UIButton *connectBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, KWidth/2-40, 50)];
    [connectBtn setTitle:@"切换网络" forState:UIControlStateNormal];
    [connectBtn setBackgroundImage:[UIImage imageNamed:@"butter"] forState:UIControlStateNormal];
    [connectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [connectBtn setBackgroundColor:RGBColor(0, 128, 255)];
    [connectBtn addTarget:self action:@selector(goToChange) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:connectBtn];
    
    UIButton *lianJieBtn = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/2+20, 200, KWidth/2-40, 50)];
    [lianJieBtn setTitle:@"连接" forState:UIControlStateNormal];
//    [lianJieBtn setBackgroundColor:RGBColor(0, 128, 255)];
    [lianJieBtn setBackgroundImage:[UIImage imageNamed:@"butter"] forState:UIControlStateNormal];
    [lianJieBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lianJieBtn addTarget:self action:@selector(lianJie) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lianJieBtn];
}

- (void)goToChange{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        
        NSURL * url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];         [[UIApplication sharedApplication] openURL:url];
        
    }
}

- (void)lianJie{
//        [self getWifiName];
    self.nowWifi = [self getWifiName];
    if ([self.nowWifi isEqual:self.myselfWifi]){
        [MBProgressHUD showText:@"请先切换wifi"];
    }else{
        //初始化进度框，置于当前的View当中
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        //如果设置此属性则当前的view置于后台
        HUD.dimBackground = YES;
        //设置对话框文字
        HUD.labelText = @"请稍等";
        //显示对话框
        [HUD showAnimated:YES whileExecutingBlock:^{
            //对话框显示时需要执行的操作
            sleep(15);
        } completionBlock:^{
            //操作执行完后取消对话框
            [HUD removeFromSuperview];
            HUD = nil;
        }];

        
        _serverHost = @"10.10.100.254";
        _serverPort = 8899;
        [self openConnection];
        [self performSelector:@selector(sendBID) withObject:nil afterDelay:0.0];
    }

}
- (void)sendBID{
    NSString *message = @"BID?";
//    NSString *message = [NSString stringWithFormat:@"%@",[HSingleGlobalData sharedInstance].BID];
    NSData *Data = [message dataUsingEncoding:NSUTF8StringEncoding];
//    self.time = @"已发送BID";
    //    [socketServe sendSSid:message];
    [_connection writeData:Data timeout:1 tag:1];
}

- (void)setwifi{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, KWidth-40, 20)];
    label.text = [NSString stringWithFormat:@"您要绑定的wifi:%@",_myselfWifi];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
    
    UIImageView *textBG = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, KWidth-20, 60)];
    textBG.userInteractionEnabled = YES;
    textBG.image = [UIImage imageNamed:@"圆角矩形-6"];
    [self.view addSubview:textBG];
    UILabel *tiplabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    tiplabel.text = @"WIFI密码:";
    tiplabel.font = [UIFont systemFontOfSize:15];
    tiplabel.textColor = [UIColor grayColor];
    tiplabel.textAlignment = NSTextAlignmentCenter;
    [textBG addSubview:tiplabel];
    
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, KWidth-120, 60)];
//    _password.placeholder = @"输入wifi密码";
    _password.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    _password.layer.borderWidth = 0.0; // set borderWidth as you want.
    [textBG addSubview:_password];
    
    UIButton *connect = [[UIButton alloc] initWithFrame:CGRectMake(50, 330, 250, 20)];
//    [connect setTitle:@"确定" forState:UIControlStateNormal];
//    [connect setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [connect addTarget:self action:@selector(clickConnect) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:connect];
}
//
////- (void)clickConnect{
//    [self getWifiName];
//    [self openConnection];
//    NSString *message = [NSString stringWithFormat:@"\1\"%@\"\1\"%@\"\1",self.myselfWifi,self.password.text];
//    NSData *Data = [message dataUsingEncoding:NSUTF8StringEncoding];
////        [socketServe sendSSid:message];
//    [_connection writeData:Data timeout:1 tag:1];
//}

- (NSString *)getWifiName
{
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    CFRelease(wifiInterfaces);
    NSLog(@"wifi:%@",wifiName);
//    self.myselfWifi = wifiName;
    return wifiName;
}

- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    NSLog(@"%@",address);
    return address;
    
}

#pragma mark RHSocketConnection method

- (void)openConnection
{
    [self closeConnection];
    _connection = [[RHSocketConnection alloc] init];
    _connection.delegate = self;
    [_connection connectWithHost:_serverHost port:_serverPort];
    //通过定时器不断发送消息，来检测长连接
//    self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(checkLongConnectByServe) userInfo:nil repeats:YES];
//    [self.heartTimer fire];
}
// 心跳连接
-(void)checkLongConnectByServe{
    // 向服务器发送固定可是的消息，来检测长连接
    NSString *longConnect = @"connect is here";
    NSData   *data  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    [_connection writeData:data timeout:1 tag:1];
}
- (void)closeConnection
{
    if (_connection) {
        _connection.delegate = nil;
        [_connection disconnect];
        _connection = nil;
    }
}

#pragma mark -
#pragma mark RHSocketConnectionDelegate method

- (void)didDisconnectWithError:(NSError *)error
{
    NSLog(@"连接失败...");
    [MBProgressHUD showText:@"连接失败"];
}

- (void)didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"连接成功...");
}

- (void)didReceiveData:(NSData *)data tag:(long)tag
{
    
    NSLog(@"接收数据...");
    NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    NSLog(@"返回数据:%@",result);
    NSString *bid = [NSString stringWithFormat:@"BID:%@",[HSingleGlobalData sharedInstance].BID];
    if ([result isEqualToString:bid]){
//        if ([self.time isEqualToString:@"第一次"]) {
            [self performSelector:@selector(sendSSID) withObject:nil afterDelay:2.0];
//            self.time = @"已发送SSID";
//        }else if([self.time isEqualToString:@"已发送BID"]){
//            
//        }

    }else{
//        [MBProgressHUD showText:@"BID不匹配,连接断开"];
//        [self closeConnection];
    }
    if ([result isEqualToString:@"+ok\r\n"]) {

            if ([self.time isEqualToString:@"已发送SSID"]) {
                [self performSelector:@selector(sendPassWord) withObject:nil afterDelay:2.0];
//                self.time = @"已发送passWord";
            }else {
                NSLog(@"连接结束,可断开");
                [self closeConnection];
                [self performSelector:@selector(goNextController) withObject:nil afterDelay:2.0];
            }
            
        

    }else{
//        if ([self.time isEqualToString:@"第一次"]) {
//            [self performSelector:@selector(sendSSID) withObject:nil afterDelay:1.0];
//            self.time = @"已发送BID";
//        }else if([self.time isEqualToString:@"已发送BID"]){
//            [self closeConnection];
//
//        }
    }
}

- (void)goNextController{
    sendViewController *vc = [[sendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)sendSSID{
    
    NSString *message = [NSString stringWithFormat:@"SSID:%@",self.myselfWifi];
//    SSID:xinyuntec.com
    NSLog(@"%@",message);
    NSData *Data = [message dataUsingEncoding:NSUTF8StringEncoding];
    //        [socketServe sendSSid:message];
    [_connection writeData:Data timeout:1 tag:1];
    self.time = @"已发送SSID";
}
-(void)sendPassWord{
    
    NSString *message = [NSString stringWithFormat:@"PASSWORD:%@",self.password.text];
    //    SSID:xinyuntec.com
    NSLog(@"%@",message);
    NSData *Data = [message dataUsingEncoding:NSUTF8StringEncoding];
    //        [socketServe sendSSid:message];
    [_connection writeData:Data timeout:1 tag:1];
    self.time = @"已发送PassWord";
}
@end
