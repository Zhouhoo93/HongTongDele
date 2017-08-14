//
//  AppDelegate.m
//  cameraProject
//
//  Created by Zhouhoo on 16/12/19.
//  Copyright © 2016年 ziHou. All rights reserved.
//

#import "AppDelegate.h"
#import "OneLoginViewController.h"
#import "GFTabBarController.h"
#import "ZHTabBarController.h"
#import "HSingleGlobalData.h"
#import "helpModel.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#define NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>

// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import "HSingleGlobalData.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <RongIMKit/RongIMKit.h>
#import "GLCore.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#define WX_APP           (@"wxe39a73e26dcf1b36")
#define Weibo_APP        (@"971559106")
@interface AppDelegate ()<JPUSHRegisterDelegate,RCIMUserInfoDataSource,RCIMGroupInfoDataSource,WXApiDelegate, WeiboSDKDelegate>
@property (nonatomic,strong) helpModel *help;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *straight_line_distance;//直线距离
@property (nonatomic,copy)NSString *actual_distance;//实际距离
@property (nonatomic) BOOL isLaunchedByNotification;
@property (nonatomic,assign) BOOL isYingJian;
@property(nullable, nonatomic,copy) NSString *alertBody;
@property(nullable, nonatomic,copy) NSDate *fireDate;
@property(nullable, nonatomic,copy) NSString *reasonTitle;
@property(nullable,nonatomic,copy) NSArray<UILocalNotification *> *scheduledLocalNotifications;
@end

@implementation AppDelegate
/* 极光 jpush
Appkey: ac68fb4cc264a43ea3cfade3  db51e2680913e83c3fb67115
token:1158633cf85b83c71613b704bee572081ed2a4584285e0c251cae76959f246ba
advertisingIdentifier: 120ba82b-3d93-4b2f-b2fb-3205f7fd8e1f
2017-01-11 16:30:03.942934 cameraProject[1867:5471398]  | JIGUANG | I - [JIGUANGRegistration]
----- register result -----
uid: 8185008743
registrationID:161a3797c808ccc2564
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [AMapServices sharedServices].apiKey = @"322889309382bf9f89dd6116afed6d6b";
    self.isYingJian = NO;

    //Required
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    UILocalNotification *localNotifi = [UILocalNotification new];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotifi];
    NSLog(@"launchOptions:%@",launchOptions);
    // 处理退出后通知的点击，程序启动后获取通知对象，如果是首次启动还没有发送通知，那第一次通知对象为空，没必要去处理通知（如跳转到指定页面）
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        UILocalNotification *localNotifi = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
        [self changeLocalNotifi:localNotifi];
    }
//    UILocalNotification *noti = [[UILocalNotification alloc] init];
//    noti.repeatInterval = 3;
//    noti.soundName=@"xwx.wav";
//    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
  
       if ([application
         
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        //注册推送, iOS 8
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  
                                                                  UIUserNotificationTypeSound |
                                                                  
                                                                  UIUserNotificationTypeAlert)
                                                
                                                categories:nil];
        
        [application registerUserNotificationSettings:settings];
        
    } else {
        
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        
        UIRemoteNotificationTypeAlert |
        
        UIRemoteNotificationTypeSound;
        
        [application registerForRemoteNotificationTypes:myTypes];
        
    }
    //融云即时通讯
    
    [[NSNotificationCenter defaultCenter]
     
     addObserver:self
     
     selector:@selector(didReceiveMessageNotification:)
     
     name:RCKitDispatchMessageNotification
     
     object:nil];
    
  
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSInteger topnum = [user valueForKey:@"fadianguzhang"];
    NSInteger downnum = [user valueForKey:@"yongdianguzhang"];
    if (!topnum){
        [user setInteger:0 forKey:@"fadianguzhang"];
    }
    if (!downnum){
        [user setInteger:0 forKey:@"yongdianguzhang"];
    }
    
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
        //可以添加自定义categories
        
        [JPUSHService registerForRemoteNotificationTypes:(
                                                          
                                                          UIUserNotificationTypeBadge |
                                                          
                                                          UIUserNotificationTypeSound |
                                                          
                                                          UIUserNotificationTypeAlert) categories:nil];

    }else{
        //categories 必须为nil
        
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          
                                                          UIRemoteNotificationTypeSound |
                                                          
                                                          UIRemoteNotificationTypeAlert) categories:nil];

    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    // apn 内容获取：
    NSDictionary *userInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"userInfo:%@",userInfo);
    if ([userInfo[@"tip"] isEqualToString:@"HelpAlert"]) {
        self.help.city = userInfo[@"city"];
        self.help.latitude = userInfo[@"latitude"];
        self.help.longitude = userInfo[@"longitude"];
        self.help.bid = userInfo[@"bid"];
        
        NSLog(@"%@",self.help.latitude);
        [HSingleGlobalData sharedInstance].loc = [self.help.longitude doubleValue];
        [HSingleGlobalData sharedInstance].lat = [self.help.latitude doubleValue];
        self.help.helper_id = userInfo[@"id"];
        NSLog(@"%@",_help);
        //            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"请注意" message:@"有人向您求助!" delegate:self cancelButtonTitle:@"接受" otherButtonTitles: @"拒绝", nil];
        
        //            [alter show];
        //            [_player play];
        
        // 加判断 接收通知后跳转到哪个界面
        //            NSNotification *notice = [NSNotification notificationWithName:@"PresentView" object:nil];
        //            [[NSNotificationCenter defaultCenter] postNotification:notice];
        
    }else if ([userInfo[@"tip"] isEqualToString:@"HelpGps"]) {
        //            self.help.city = userInfo[@"city"];
        //            // self.help.city = @"义务市";
        //            self.help.latitude = userInfo[@"latitude"];
        //            // self.help.latitude = @"29.3055613255";
        //            self.help.longitude = userInfo[@"longitude"];
        //            //self.help.longitude = @"119.9707031250";
        //            [HSingleGlobalData sharedInstance].loc = [self.help.longitude doubleValue];
        //            [HSingleGlobalData sharedInstance].lat = [self.help.latitude doubleValue];
        //            self.help.helper_id = userInfo[@"id"];
        //            NSLog(@"%@",_help);
        //            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"请注意" message:@"有人向您求助!" delegate:self cancelButtonTitle:@"接受" otherButtonTitles: @"拒绝", nil];
        //
        //            [alter show];
        //            [_player play];
        
        // 加判断 接收通知后跳转到哪个界面
        //            NSNotification *notice = [NSNotification notificationWithName:@"PresentView" object:nil];
        //            [[NSNotificationCenter defaultCenter] postNotification:notice];
        
    }else if ([userInfo[@"tip"] isEqualToString:@"FaultAlert"]) {
        // 加判断 接收通知后跳转到哪个界面
        //故障
        NSNotification *notice = [NSNotification notificationWithName:@"PresentErrView" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notice];
        
    }else if ([userInfo[@"tip"] isEqualToString:@"ExceptionAlert"]) {
        NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notice];
        //漏电推送
    }else if ([userInfo[@"tip"] isEqualToString:@"UseLeakCurrentFaultAlert"]) {
        //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
        //            [[NSNotificationCenter defaultCenter] postNotification:notice];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //            BOOL loudian = [userDefaults valueForKey:@"loudian"];
        //            if (loudian) {
        //                self.reasonTitle = userInfo[@"reason"];
        //                [self createLocalNotification];
        //            }else{
        //
        //            }
        //            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        int downnum = [userDefaults integerForKey:@"yongdianguzhang"];
        int jia = 1;
        int newdownnum = downnum + jia;
        [userDefaults setInteger:newdownnum forKey:@"yongdianguzhang"];
        NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
        // 3.通过 通知中心 发送 通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        NSLog(@"UseLeakCurrentFaultAlert");
    }else if ([userInfo[@"tip"] isEqualToString:@"UseUnderVFaultAlert"]) {
        //过流
        //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
        //            [[NSNotificationCenter defaultCenter] postNotification:notice];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        int downnum = [user integerForKey:@"yongdianguzhang"];
        int jia = 1;
        int newdownnum = downnum + jia;
        [user setInteger:newdownnum forKey:@"yongdianguzhang"];
        //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        //                self.reasonTitle = userInfo[@"reason"];
        //                [self createLocalNotification];
        NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
        // 3.通过 通知中心 发送 通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        NSLog(@"UseUnderVFaultAlert");
    }else if ([userInfo[@"tip"] isEqualToString:@"UseOverVFaultAlert"]) {
        //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
        //            [[NSNotificationCenter defaultCenter] postNotification:notice];
        //过压
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        int downnum = [user integerForKey:@"yongdianguzhang"];
        int jia = 1;
        int newdownnum = downnum + jia;
        [user setInteger:newdownnum forKey:@"yongdianguzhang"];
        //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //            BOOL guozai = [user valueForKey:@"guozai"];
        //            if (guozai) {
        //                self.reasonTitle = userInfo[@"reason"];
        //                [self createLocalNotification];
        //            }else{
        //
        //            }
        NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
        // 3.通过 通知中心 发送 通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        NSLog(@"UseOverVFaultAlert");
    }else if ([userInfo[@"tip"] isEqualToString:@"UseUnderVFaultAlert"]) {
        //欠压
        //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
        //            [[NSNotificationCenter defaultCenter] postNotification:notice];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        int downnum = [user integerForKey:@"yongdianguzhang"];
        int jia = 1;
        int newdownnum = downnum + jia;
        [user setInteger:newdownnum forKey:@"yongdianguzhang"];
        //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        //                self.reasonTitle = userInfo[@"reason"];
        //                [self createLocalNotification];
        
        NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
        // 3.通过 通知中心 发送 通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        NSLog(@"UseUnderVFaultAlert");
    }else if ([userInfo[@"tip"] isEqualToString:@"GenInverterAlert"]) {
        //逆变器报警
        //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
        //            [[NSNotificationCenter defaultCenter] postNotification:notice];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        int downnum = [user integerForKey:@"fadianguzhang"];
        int jia = 1;
        int newdownnum = downnum + jia;
        [user setInteger:newdownnum forKey:@"fadianguzhang"];
        //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //                self.reasonTitle = userInfo[@"reason"];
        //                [self createLocalNotification];
        
        NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
        // 3.通过 通知中心 发送 通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        NSLog(@"GenInverterAlert");
    
     }

    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    //*****************************************
   /* appKey
    填写管理Portal上创建应用后自动生成的AppKey值。请确保应用内配置的 AppKey 与 Portal 上创建应用后生成的 AppKey 一致。
    channel
    指明应用程序包的下载渠道，为方便分渠道统计，具体值由你自行定义，如：App Store。
    apsForProduction
    1.3.1版本新增，用于标识当前应用所使用的APNs证书环境。
    0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用。
    注：此字段的值要与Build Settings的Code Signing配置的证书环境一致。
    advertisingIdentifier
    */
    [JPUSHService setupWithOption:launchOptions appKey:@"db51e2680913e83c3fb67115"
                          channel:@"App Store"
                 apsForProduction:@"0"
            advertisingIdentifier:advertisingId];
    
    //通知获取registerID
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
    
    //-------------亲加直播------------
    [GLCore registerWithAppKey:@"de8b955b8b634fe2826e13ce077b26e2"
                  accessSecret:@"77d7262d8c7e4676a5e7b1b333169d29"
                     companyId:@"a002ab3fda3544fbabfd839dc119776f"];
    [WXApi registerApp:WX_APP];
    [WeiboSDK registerApp:Weibo_APP];
    [WeiboSDK enableDebugMode:YES];

    
    //判断是否登陆
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *passName = [userDefaults valueForKey:@"passName"];
    NSString *passWord =[userDefaults valueForKey:@"passWord"];
    [userDefaults setBool:YES forKey:@"loudian"];
    [userDefaults setBool:YES forKey:@"guozai"];
    
    
    
    if (passName.length>0) {
        [HSingleGlobalData sharedInstance].passName = passName;
        [HSingleGlobalData sharedInstance].passWord =passWord;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ZHTabBarController *baseNaviVC = [storyboard instantiateViewControllerWithIdentifier:@"Main"];
        self.window.rootViewController = baseNaviVC;
    }else{
        OneLoginViewController *loginViewController = [[OneLoginViewController alloc] initWithNibName:@"OneLoginViewController" bundle:nil];
        UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:loginViewController];
        
        self.window.rootViewController = navigationController;
    }
    [JPUSHService resetBadge];
    [JPUSHService setBadge:0];
    application.applicationIconBadgeNumber = 0;
    [self.window makeKeyAndVisible];
    
    /**获取程序的版本号*/
    NSString *version = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *url = [NSString stringWithFormat:@"%@/xapi/update-info",kUrl];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]];
    [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"版本更新%@",responseObject);
        
            NSString *ios = responseObject[@"content"][@"ios"];
            if ([ios floatValue] > [version floatValue]) {//判断版本大小了
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil] ;
                alert.delegate = self;
                alert.tag = 99;
                [alert show];
                
            }
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                NSLog(@"未知网络");
                break;
            case 0:
                NSLog(@"网络不可达");
                break;
            case 1:
                NSLog(@"GPRS网络");
                break;
            case 2:
                NSLog(@"wifi网络");
                break;
            default:
                break;
        }
        if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            NSLog(@"有网");
        }else
        {
            NSLog(@"没有网");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络失去连接" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            alert.delegate = self;
            [alert show];
        }
    }];
    
    return YES;
}



- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
     NSString* dvsToken =[deviceToken description];
    NSString *str1 = [dvsToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSString *token = [str2 stringByReplacingOccurrencesOfString:@">" withString:@""];
     MyLog(@"My dvsToken is %@",token);
    NSString *token1 =
    
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
       
                                                           withString:@""]
      
      stringByReplacingOccurrencesOfString:@">"
      
      withString:@""]
     
     stringByReplacingOccurrencesOfString:@" "
     
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token1];
}
//注册APNs失败接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    
}

#pragma mark- JPUSHRegisterDelegate
//添加处理APNs通知回调方法
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;

    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    NSMutableArray *attachments = [[NSMutableArray alloc] initWithCapacity:0];
    NSLog(@"%@",notification);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        if ([userInfo[@"tip"] isEqualToString:@"HelpAlert"]) {
            self.help.city = userInfo[@"city"];
            self.help.latitude = userInfo[@"latitude"];
            self.help.longitude = userInfo[@"longitude"];
            self.help.bid = userInfo[@"bid"];
            
            NSLog(@"%@",self.help.latitude);
            [HSingleGlobalData sharedInstance].loc = [self.help.longitude doubleValue];
            [HSingleGlobalData sharedInstance].lat = [self.help.latitude doubleValue];
            self.help.helper_id = userInfo[@"id"];
            NSLog(@"%@",_help);
//            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"请注意" message:@"有人向您求助!" delegate:self cancelButtonTitle:@"接受" otherButtonTitles: @"拒绝", nil];
            
//            [alter show];
//            [_player play];

                        // 加判断 接收通知后跳转到哪个界面
//            NSNotification *notice = [NSNotification notificationWithName:@"PresentView" object:nil];
//            [[NSNotificationCenter defaultCenter] postNotification:notice];

        }else if ([userInfo[@"tip"] isEqualToString:@"HelpGps"]) {
//            self.help.city = userInfo[@"city"];
//            // self.help.city = @"义务市";
//            self.help.latitude = userInfo[@"latitude"];
//            // self.help.latitude = @"29.3055613255";
//            self.help.longitude = userInfo[@"longitude"];
//            //self.help.longitude = @"119.9707031250";
//            [HSingleGlobalData sharedInstance].loc = [self.help.longitude doubleValue];
//            [HSingleGlobalData sharedInstance].lat = [self.help.latitude doubleValue];
//            self.help.helper_id = userInfo[@"id"];
//            NSLog(@"%@",_help);
//            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"请注意" message:@"有人向您求助!" delegate:self cancelButtonTitle:@"接受" otherButtonTitles: @"拒绝", nil];
//            
//            [alter show];
//            [_player play];
            
            // 加判断 接收通知后跳转到哪个界面
//            NSNotification *notice = [NSNotification notificationWithName:@"PresentView" object:nil];
//            [[NSNotificationCenter defaultCenter] postNotification:notice];
            
        }else if ([userInfo[@"tip"] isEqualToString:@"FaultAlert"]) {
            // 加判断 接收通知后跳转到哪个界面
            //故障
                        NSNotification *notice = [NSNotification notificationWithName:@"PresentErrView" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotification:notice];
            
        }else if ([userInfo[@"tip"] isEqualToString:@"ExceptionAlert"]) {
            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notice];
            //漏电推送
        }else if ([userInfo[@"tip"] isEqualToString:@"UseLeakCurrentFaultAlert"]) {
//            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
//            [[NSNotificationCenter defaultCenter] postNotification:notice];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            BOOL loudian = [userDefaults valueForKey:@"loudian"];
//            if (loudian) {
//                self.reasonTitle = userInfo[@"reason"];
//                [self createLocalNotification];
//            }else{
//            
//            }
//            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            int downnum = [userDefaults integerForKey:@"yongdianguzhang"];
            int jia = 1;
            int newdownnum = downnum + jia;
            [userDefaults setInteger:newdownnum forKey:@"yongdianguzhang"];
            NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
            // 3.通过 通知中心 发送 通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            NSLog(@"UseLeakCurrentFaultAlert");
        }else if ([userInfo[@"tip"] isEqualToString:@"UseUnderVFaultAlert"]) {
            //过流
            //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
            //            [[NSNotificationCenter defaultCenter] postNotification:notice];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            int downnum = [user integerForKey:@"yongdianguzhang"];
            int jia = 1;
            int newdownnum = downnum + jia;
            [user setInteger:newdownnum forKey:@"yongdianguzhang"];
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

//                self.reasonTitle = userInfo[@"reason"];
//                [self createLocalNotification];
            NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
            // 3.通过 通知中心 发送 通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            NSLog(@"UseUnderVFaultAlert");
        }else if ([userInfo[@"tip"] isEqualToString:@"UseOverVFaultAlert"]) {
            //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
            //            [[NSNotificationCenter defaultCenter] postNotification:notice];
            //过压
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            int downnum = [user integerForKey:@"yongdianguzhang"];
            int jia = 1;
            int newdownnum = downnum + jia;
            [user setInteger:newdownnum forKey:@"yongdianguzhang"];
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            BOOL guozai = [user valueForKey:@"guozai"];
//            if (guozai) {
//                self.reasonTitle = userInfo[@"reason"];
//                [self createLocalNotification];
//            }else{
//                
//            }
            NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
            // 3.通过 通知中心 发送 通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            NSLog(@"UseOverVFaultAlert");
        }else if ([userInfo[@"tip"] isEqualToString:@"UseUnderVFaultAlert"]) {
            //欠压
            //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
            //            [[NSNotificationCenter defaultCenter] postNotification:notice];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            int downnum = [user integerForKey:@"yongdianguzhang"];
            int jia = 1;
            int newdownnum = downnum + jia;
            [user setInteger:newdownnum forKey:@"yongdianguzhang"];
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
 
//                self.reasonTitle = userInfo[@"reason"];
//                [self createLocalNotification];

            NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
            // 3.通过 通知中心 发送 通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            NSLog(@"UseUnderVFaultAlert");
        }else if ([userInfo[@"tip"] isEqualToString:@"GenInverterAlert"]) {
            //逆变器报警
            //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
            //            [[NSNotificationCenter defaultCenter] postNotification:notice];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            int downnum = [user integerForKey:@"fadianguzhang"];
            int jia = 1;
            int newdownnum = downnum + jia;
            [user setInteger:newdownnum forKey:@"fadianguzhang"];
            //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                self.reasonTitle = userInfo[@"reason"];
//                [self createLocalNotification];

            NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
            // 3.通过 通知中心 发送 通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            NSLog(@"GenInverterAlert");
        }






        }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

//提示框点击
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex

{//前往跟新地址
    if (alertView.tag==99) {
        if (buttonIndex == 0) {
 
            NSLog(@"拒绝");
            return;

        }else if(buttonIndex == 1){
            
            NSLog(@"接受");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/id1219905047?l=zh&ls=1&mt=8"]];
            
        }

    }else if(alertView.tag == 10001){
    
    }else{
    if (buttonIndex == 0) {
//        [_player stop];
//        NSNotification *notice = [NSNotification notificationWithName:@"jieshou" object:nil];
//                [[NSNotificationCenter defaultCenter] postNotification:notice];
        NSLog(@"接受");
        
//        return;
    }else if(buttonIndex == 1){
//        [_player stop];
        NSLog(@"拒绝");
        return;
    }
    }
}



- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}




// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {

    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
//        [rootViewController addNotificationCount];
        //判断app是不是在前台运行，有三个状态(如果不进行判断处理，当你的app在前台运行时，收到推送时，通知栏不会弹出提示的)
        // UIApplicationStateActive, 在前台运行
        // UIApplicationStateInactive,未启动app
        //UIApplicationStateBackground    app在后台
        
        if([UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
        {  //此时app在前台运行，我的做法是弹出一个alert，告诉用户有一条推送，用户可以选择查看或者忽略
            NSLog(@"应用未打开");;
            if ([userInfo[@"tip"] isEqualToString:@"ExceptionAlert"]) {
                NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notice];
                //漏电推送
            }else if ([userInfo[@"tip"] isEqualToString:@"UseLeakCurrentFaultAlert"]) {
                //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
                //            [[NSNotificationCenter defaultCenter] postNotification:notice];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //            BOOL loudian = [userDefaults valueForKey:@"loudian"];
                //            if (loudian) {
                //                self.reasonTitle = userInfo[@"reason"];
                //                [self createLocalNotification];
                //            }else{
                //
                //            }
                //            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                int downnum = [userDefaults integerForKey:@"yongdianguzhang"];
                int jia = 1;
                int newdownnum = downnum + jia;
                [userDefaults setInteger:newdownnum forKey:@"yongdianguzhang"];
                NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
                // 3.通过 通知中心 发送 通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                NSLog(@"UseLeakCurrentFaultAlert");
            }else if ([userInfo[@"tip"] isEqualToString:@"UseUnderVFaultAlert"]) {
                //过流
                //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
                //            [[NSNotificationCenter defaultCenter] postNotification:notice];
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                int downnum = [user integerForKey:@"yongdianguzhang"];
                int jia = 1;
                int newdownnum = downnum + jia;
                [user setInteger:newdownnum forKey:@"yongdianguzhang"];
                //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                //                self.reasonTitle = userInfo[@"reason"];
                //                [self createLocalNotification];
                NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
                // 3.通过 通知中心 发送 通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                NSLog(@"UseUnderVFaultAlert");
            }else if ([userInfo[@"tip"] isEqualToString:@"UseOverVFaultAlert"]) {
                //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
                //            [[NSNotificationCenter defaultCenter] postNotification:notice];
                //过压
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                int downnum = [user integerForKey:@"yongdianguzhang"];
                int jia = 1;
                int newdownnum = downnum + jia;
                [user setInteger:newdownnum forKey:@"yongdianguzhang"];
                //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //            BOOL guozai = [user valueForKey:@"guozai"];
                //            if (guozai) {
                //                self.reasonTitle = userInfo[@"reason"];
                //                [self createLocalNotification];
                //            }else{
                //
                //            }
                NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
                // 3.通过 通知中心 发送 通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                NSLog(@"UseOverVFaultAlert");
            }else if ([userInfo[@"tip"] isEqualToString:@"UseUnderVFaultAlert"]) {
                //欠压
                //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
                //            [[NSNotificationCenter defaultCenter] postNotification:notice];
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                int downnum = [user integerForKey:@"yongdianguzhang"];
                int jia = 1;
                int newdownnum = downnum + jia;
                [user setInteger:newdownnum forKey:@"yongdianguzhang"];
                //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                //                self.reasonTitle = userInfo[@"reason"];
                //                [self createLocalNotification];
                
                NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
                // 3.通过 通知中心 发送 通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                NSLog(@"UseUnderVFaultAlert");
            }else if ([userInfo[@"tip"] isEqualToString:@"GenInverterAlert"]) {
                //逆变器报警
                //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
                //            [[NSNotificationCenter defaultCenter] postNotification:notice];
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                int downnum = [user integerForKey:@"fadianguzhang"];
                int jia = 1;
                int newdownnum = downnum + jia;
                [user setInteger:newdownnum forKey:@"fadianguzhang"];
                //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //                self.reasonTitle = userInfo[@"reason"];
                //                [self createLocalNotification];
                
                NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
                // 3.通过 通知中心 发送 通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                NSLog(@"GenInverterAlert");
            }

            
        } else {
            //这里是app未运行或者在后台，通过点击手机通知栏的推送消息打开app时可以在这里进行处理，比如，拿到推送里的内容或者附加      字段(假设，推送里附加了一个url为 www.baidu.com)，那么你就可以拿到这个url，然后进行跳转到相应店web页，当然，不一定必须是web页，也可以是你app里的任意一个controll，跳转的话用navigation或者模态视图都可以
//            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"请注意" message:@"有人向您求助!" delegate:self cancelButtonTitle:@"接受" otherButtonTitles: @"拒绝", nil];
            
//            [alter show];
//            [_player play];
            if ([userInfo[@"tip"] isEqualToString:@"ExceptionAlert"]) {
                NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notice];
                //漏电推送
            }else if ([userInfo[@"tip"] isEqualToString:@"UseLeakCurrentFaultAlert"]) {
                //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
                //            [[NSNotificationCenter defaultCenter] postNotification:notice];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //            BOOL loudian = [userDefaults valueForKey:@"loudian"];
                //            if (loudian) {
                //                self.reasonTitle = userInfo[@"reason"];
                //                [self createLocalNotification];
                //            }else{
                //
                //            }
                //            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                int downnum = [userDefaults integerForKey:@"yongdianguzhang"];
                int jia = 1;
                int newdownnum = downnum + jia;
                [userDefaults setInteger:newdownnum forKey:@"yongdianguzhang"];
                NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
                // 3.通过 通知中心 发送 通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                NSLog(@"UseLeakCurrentFaultAlert");
            }else if ([userInfo[@"tip"] isEqualToString:@"UseUnderVFaultAlert"]) {
                //过流
                //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
                //            [[NSNotificationCenter defaultCenter] postNotification:notice];
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                int downnum = [user integerForKey:@"yongdianguzhang"];
                int jia = 1;
                int newdownnum = downnum + jia;
                [user setInteger:newdownnum forKey:@"yongdianguzhang"];
                //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                //                self.reasonTitle = userInfo[@"reason"];
                //                [self createLocalNotification];
                NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
                // 3.通过 通知中心 发送 通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                NSLog(@"UseUnderVFaultAlert");
            }else if ([userInfo[@"tip"] isEqualToString:@"UseOverVFaultAlert"]) {
                //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
                //            [[NSNotificationCenter defaultCenter] postNotification:notice];
                //过压
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                int downnum = [user integerForKey:@"yongdianguzhang"];
                int jia = 1;
                int newdownnum = downnum + jia;
                [user setInteger:newdownnum forKey:@"yongdianguzhang"];
                //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //            BOOL guozai = [user valueForKey:@"guozai"];
                //            if (guozai) {
                //                self.reasonTitle = userInfo[@"reason"];
                //                [self createLocalNotification];
                //            }else{
                //
                //            }
                NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
                // 3.通过 通知中心 发送 通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                NSLog(@"UseOverVFaultAlert");
            }else if ([userInfo[@"tip"] isEqualToString:@"UseUnderVFaultAlert"]) {
                //欠压
                //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
                //            [[NSNotificationCenter defaultCenter] postNotification:notice];
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                int downnum = [user integerForKey:@"yongdianguzhang"];
                int jia = 1;
                int newdownnum = downnum + jia;
                [user setInteger:newdownnum forKey:@"yongdianguzhang"];
                //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
                //                self.reasonTitle = userInfo[@"reason"];
                //                [self createLocalNotification];
                
                NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
                // 3.通过 通知中心 发送 通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                NSLog(@"UseUnderVFaultAlert");
            }else if ([userInfo[@"tip"] isEqualToString:@"GenInverterAlert"]) {
                //逆变器报警
                //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
                //            [[NSNotificationCenter defaultCenter] postNotification:notice];
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                int downnum = [user integerForKey:@"fadianguzhang"];
                int jia = 1;
                int newdownnum = downnum + jia;
                [user setInteger:newdownnum forKey:@"fadianguzhang"];
                //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                //                self.reasonTitle = userInfo[@"reason"];
                //                [self createLocalNotification];
                
                NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
                // 3.通过 通知中心 发送 通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                NSLog(@"GenInverterAlert");
            }

        }

    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法

}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    [self changeLocalNotifi:notification];
    self.isLaunchedByNotification = YES;
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"didReceiveRemoteNotification%@",userInfo);
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得Extras字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field  =[%@]",content,badge,sound,customizeField1);
    
    // iOS 10 以下 Required
    [JPUSHService handleRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
    // 打印到日志 textView 中
    NSLog(@"********** iOS7.0之后 background **********");
    // 取得 APNs 标准信息内容
    BOOL isActive;
    if (application.applicationState == UIApplicationStateActive) {
        isActive = YES;
        NSLog(@"程序正在运动状态");
    } else {
        isActive = NO;
        NSLog(@"程序在后台运行");
        if ([userInfo[@"tip"] isEqualToString:@"ExceptionAlert"]) {
            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notice];
            //漏电推送
        }else if ([userInfo[@"tip"] isEqualToString:@"UseLeakCurrentFaultAlert"]) {
            //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
            //            [[NSNotificationCenter defaultCenter] postNotification:notice];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //            BOOL loudian = [userDefaults valueForKey:@"loudian"];
            //            if (loudian) {
            //                self.reasonTitle = userInfo[@"reason"];
            //                [self createLocalNotification];
            //            }else{
            //
            //            }
            //            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            int downnum = [userDefaults integerForKey:@"yongdianguzhang"];
            int jia = 1;
            int newdownnum = downnum + jia;
            [userDefaults setInteger:newdownnum forKey:@"yongdianguzhang"];
            NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
            // 3.通过 通知中心 发送 通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            NSLog(@"UseLeakCurrentFaultAlert");
        }else if ([userInfo[@"tip"] isEqualToString:@"UseUnderVFaultAlert"]) {
            //过流
            //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
            //            [[NSNotificationCenter defaultCenter] postNotification:notice];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            int downnum = [user integerForKey:@"yongdianguzhang"];
            int jia = 1;
            int newdownnum = downnum + jia;
            [user setInteger:newdownnum forKey:@"yongdianguzhang"];
            //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            //                self.reasonTitle = userInfo[@"reason"];
            //                [self createLocalNotification];
            NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
            // 3.通过 通知中心 发送 通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            NSLog(@"UseUnderVFaultAlert");
        }else if ([userInfo[@"tip"] isEqualToString:@"UseOverVFaultAlert"]) {
            //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
            //            [[NSNotificationCenter defaultCenter] postNotification:notice];
            //过压
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            int downnum = [user integerForKey:@"yongdianguzhang"];
            int jia = 1;
            int newdownnum = downnum + jia;
            [user setInteger:newdownnum forKey:@"yongdianguzhang"];
            //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //            BOOL guozai = [user valueForKey:@"guozai"];
            //            if (guozai) {
            //                self.reasonTitle = userInfo[@"reason"];
            //                [self createLocalNotification];
            //            }else{
            //
            //            }
            NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
            // 3.通过 通知中心 发送 通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            NSLog(@"UseOverVFaultAlert");
        }else if ([userInfo[@"tip"] isEqualToString:@"UseUnderVFaultAlert"]) {
            //欠压
            //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
            //            [[NSNotificationCenter defaultCenter] postNotification:notice];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            int downnum = [user integerForKey:@"yongdianguzhang"];
            int jia = 1;
            int newdownnum = downnum + jia;
            [user setInteger:newdownnum forKey:@"yongdianguzhang"];
            //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            //                self.reasonTitle = userInfo[@"reason"];
            //                [self createLocalNotification];
            
            NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
            // 3.通过 通知中心 发送 通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            NSLog(@"UseUnderVFaultAlert");
        }else if ([userInfo[@"tip"] isEqualToString:@"GenInverterAlert"]) {
            //逆变器报警
            //            NSNotification *notice = [NSNotification notificationWithName:@"Message" object:nil];
            //            [[NSNotificationCenter defaultCenter] postNotification:notice];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            int downnum = [user integerForKey:@"fadianguzhang"];
            int jia = 1;
            int newdownnum = downnum + jia;
            [user setInteger:newdownnum forKey:@"fadianguzhang"];
            //            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            //                self.reasonTitle = userInfo[@"reason"];
            //                [self createLocalNotification];
            
            NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
            // 3.通过 通知中心 发送 通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            NSLog(@"GenInverterAlert");
        }

    }
    if (isActive == YES)
    {
        // 不操作
    }
    else
    {
        // 操作
    }
    //判断app是不是在前台运行，有三个状态(如果不进行判断处理，当你的app在前台运行时，收到推送时，通知栏不会弹出提示的)
    // UIApplicationStateActive, 在前台运行
    // UIApplicationStateInactive,未启动app
    //UIApplicationStateBackground    app在后台
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {  //此时app在前台运行，我的做法是弹出一个alert，告诉用户有一条推送，用户可以选择查看或者忽略
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"推送消息"
                                                         message:@"您有一条新的推送消息!"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"查看",nil];
        [alert show];
        
    
    
} else {
    //这里是app未运行或者在后台，通过点击手机通知栏的推送消息打开app时可以在这里进行处理，比如，拿到推送里的内容或者附加      字段(假设，推送里附加了一个url为 www.baidu.com)，那么你就可以拿到这个url，然后进行跳转到相应店web页，当然，不一定必须是web页，也可以是你app里的任意一个controll，跳转的话用navigation或者模态视图都可以
}

//这里设置app的图片的角标为0，红色但角标就会消失
//     [UIApplication sharedApplication].  applicationIconBadgeNumber  =  0;
//completionHandler(UIBackgroundFetchResultNewData);
}


//}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得Extras字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeExtras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field  =[%@]",content,badge,sound,customizeField1);
    
    // iOS 10 以下 Required
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"didReceiveRemoteNotification%@",userInfo);
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [JPUSHService setBadge:0];
    application.applicationIconBadgeNumber = 0;
}

/*
 JPush SDK 相关事件监听
 
 建议开发者加上API里面提供的以下类型的通知：
 extern NSString *const kJPFNetworkIsConnectingNotification; // 正在连接中
 extern NSString * const kJPFNetworkDidSetupNotification; // 建立连接
 extern NSString * const kJPFNetworkDidCloseNotification; // 关闭连接
 extern NSString * const kJPFNetworkDidRegisterNotification; // 注册成功
 extern NSString *const kJPFNetworkFailedRegisterNotification; //注册失败
 extern NSString * const kJPFNetworkDidLoginNotification; // 登录成功
 温馨提示：
 Registration id 需要添加注册kJPFNetworkDidLoginNotification通知的方法里获取，也可以调用[registrationIDCompletionHandler:]方法，通过completionHandler获取
 extern NSString * const kJPFNetworkDidReceiveMessageNotification; // 收到自定义消息(非APNs)
 其中，kJPFNetworkDidReceiveMessageNotification传递的数据可以通过NSNotification中的userInfo方法获取，包括标题、内容、extras信息等
 */

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
- (void)changeLocalNotifi:(UILocalNotification *)localNotifi{
    // 如果在前台直接返回
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        return;
    }
    // 获取通知信息
    NSString *selectIndex = localNotifi.userInfo[@"selectIndex"];
    // 获取根控制器TabBarController
    UITabBarController *rootController = (UITabBarController *)self.window.rootViewController;
    // 跳转到指定控制器
    rootController.selectedIndex = [selectIndex intValue];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"--进入前台-applicationDidBecomeActive----");
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"jinru" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    // 进入前台
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)networkDidLogin:(NSNotification *)notification {
    
    NSLog(@"已登录");
    if ([JPUSHService registrationID]) {
        
        //下面是我拿到registeID,发送给服务器的代码，可以根据你需求来处理
        NSString *registerid = [JPUSHService registrationID];
        NSLog(@"APPDelegate开始上传rgeisterID");
        [HSingleGlobalData sharedInstance].registerid = registerid;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:registerid forKey:@"registerid"];
        [userDefaults synchronize];
        MyLog(@"*******get RegistrationID = %@ ",[JPUSHService registrationID]);
//    }
    //设置jPUsh 别名
//    NSString *userID = [HSingleGlobalData sharedInstance].passName;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JPUSHService setTags:nil alias:registerid fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            NSLog(@"%d----%@---",iResCode,iAlias);
        
        }];
        [JPUSHService setAlias:registerid callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:nil];
//    });
    NSLog(@"设置别名:%@",registerid);
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kJPFNetworkDidLoginNotification
                                                  object:nil];
    }
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    NSLog(@"自定义通知 内容content%@",content);
    NSLog(@"自定义通知customizeField1%@",customizeField1);
}

-(helpModel *)help{
    if (!_help) {
        _help = [[helpModel alloc] init];
    }
    return _help;
}
-(void)createLocalNotification {
    // 创建一个本地推送
    
    UILocalNotification *notification = [[UILocalNotification alloc] init] ;
    
    //设置10秒之后
    
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:1];
    
    if (notification != nil) {
        
        // 设置推送时间
        
        
        notification.fireDate = pushDate;
        
        
        // 设置时区
        
        
        notification.timeZone = [NSTimeZone defaultTimeZone];
        
        
        // 设置重复间隔
        
        
        notification.repeatInterval = kCFCalendarUnitDay;
        
        
        // 推送声音
        
        
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        
        // 推送内容
        
        
        notification.alertBody = self.reasonTitle;
        
        
        //显示在icon上的红色圈中的数子
        
        
        notification.applicationIconBadgeNumber = 1;
        
        
        //设置userinfo 方便在之后需要撤销的时候使用
        
        
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"name"forKey:@"key"];
        
        
        notification.userInfo = info;
        
        
        //添加推送到UIApplication       
        
        
        UIApplication *app = [UIApplication sharedApplication];
        
        
        [app scheduleLocalNotification:notification]; 
        
    }
}

@end
