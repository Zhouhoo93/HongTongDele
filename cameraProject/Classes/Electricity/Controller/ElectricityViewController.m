//
//  ElectricityViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/4/11.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "ElectricityViewController.h"
#import "HistogramView.h"
#import "JHChartHeader.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioSession.h>
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlyMSC.h"
#import "OneLoginViewController.h"
#import "JPUSHService.h"
#import "StatusModel.h"
#import "dayGenModel.h"
#import "dayFeeModel.h"
#import "PowerDetailViewController.h"
#import "UsePowerViewController.h"
#import "PowerViewController.h"
#import "FaPowerDetailViewController.h"
#import "MJRefresh.h"
#import "fadianModel.h"
#import "yongdianModel.h"
#define k_MainBoundsWidth [UIScreen mainScreen].bounds.size.width
#define k_MainBoundsHeight [UIScreen mainScreen].bounds.size.height
@interface ElectricityViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSString * currentCity; //当前城市
    
}
@property (assign, nonatomic) int count;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timer1;
@property (nonatomic,strong) UIImageView *bgimage1;
@property (nonatomic,strong) UIImageView *bgimage2;
@property (nonatomic,strong) UITableView *bgTable;
@property (nonatomic,strong) UIImageView *labaImage;
@property (strong, nonatomic) UIScrollView *bgScrollerView;
@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UILabel *rightLabel;
@property (strong, nonatomic) UILabel *duLabel;
@property (strong, nonatomic) UILabel *gangLabel;
@property (strong, nonatomic) UILabel *yuanLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *temperatureLabel;
@property (strong, nonatomic) UILabel *weatherLabel;
@property (strong, nonatomic) UIImageView *weatherImage;
@property (strong, nonatomic) UIImageView *leftImage;
@property (strong, nonatomic) UIImageView *rightImage;
@property (strong, nonatomic) UIImageView *xiaorenImage;
@property (nonatomic,assign) BOOL faDianBtnClick;
@property (nonatomic,assign) BOOL yongdianDianBtnClick;
@property (nonatomic,copy) NSString *topStatus;
@property (nonatomic,copy) NSString *downStatus;
@property (nonatomic,copy) NSString *yuyinText;
@property (nonatomic,strong) NSMutableArray *statusArr;
@property (nonatomic,strong) NSMutableArray *FirstChartgenArr;
@property (nonatomic,strong) NSMutableArray *FirstChartuseArr;
@property (nonatomic,strong) NSMutableArray *blueArr;
@property (nonatomic,strong) NSMutableArray *greenArr;
@property (nonatomic,strong) NSMutableArray *redArr;
@property (nonatomic,strong) NSMutableArray *yellowArr;
@property (nonatomic,strong) NSMutableArray *dayGenArr;
@property (nonatomic,strong) NSMutableArray *MonthGenArr;
@property (nonatomic,strong) NSMutableArray *YearGenArr;
@property (nonatomic,strong) NSMutableArray *dayFeeArr;
@property (nonatomic,strong) NSMutableArray *MonthFeeArr;
@property (nonatomic,strong) NSMutableArray *YearFeeArr;
@property (nonatomic,strong) NSMutableArray *ReddayGenArr;
@property (nonatomic,strong) NSMutableArray *RedMonthGenArr;
@property (nonatomic,strong) NSMutableArray *RedYearGenArr;
@property (nonatomic,strong) NSMutableArray *ReddayFeeArr;
@property (nonatomic,strong) NSMutableArray *RedMonthFeeArr;
@property (nonatomic,strong) NSMutableArray *RedYearFeeArr;
@property (nonatomic,strong) NSMutableArray *TbaleTipArr1;
@property (nonatomic,strong) NSMutableArray *TbaleTipArr2;
@property (nonatomic,strong) NSMutableArray *TbaleTipArr3;
@property (nonatomic,strong) NSMutableArray *TbaleTipArr4;
@property (nonatomic,strong) NSMutableArray *TbaleTipArr5;
@property (nonatomic,strong) NSMutableArray *TbaleTipArr6;
@property (nonatomic,strong) NSMutableArray *RedTbaleTipArr1;
@property (nonatomic,strong) NSMutableArray *RedTbaleTipArr2;
@property (nonatomic,strong) NSMutableArray *RedTbaleTipArr3;
@property (nonatomic,strong) NSMutableArray *RedTbaleTipArr4;
@property (nonatomic,strong) NSMutableArray *RedTbaleTipArr5;
@property (nonatomic,strong) NSMutableArray *RedTbaleTipArr6;
@property (nonatomic,strong) StatusModel *statusModel;
@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UILabel *textLabel1;
@property (nonatomic,strong) UILabel *nianfadian;
@property (nonatomic,strong) UILabel *yuefadian;
@property (nonatomic,strong) UILabel *nianyongdian;
@property (nonatomic,strong) UILabel *yueyongdian;
@property (nonatomic,copy) NSString *zhuangjirongliang;
@property (nonatomic,copy) NSString *bingwangshijian;
@property (nonatomic,copy) NSString *bingwangfangshi;
@property (nonatomic,copy) NSString *edingdianliu;
@property (nonatomic,copy) NSString *anzhuangshijian;
@property (nonatomic,copy) NSString *dianjialeibie;
@property (nonatomic,copy) NSString *yuyinString;
@property (nonatomic,assign) NSInteger maxAll;
@property (nonatomic,strong) dayGenModel *dayGenmodel;
@property (nonatomic,strong) dayFeeModel *dayFeemodel;
@property (nonatomic,copy) NSString *month;
@property (nonatomic,copy) NSString *year;
@property (nonatomic,strong) UILabel *greenLabel;
@property (nonatomic,assign) BOOL isSpeaking;
@property (nonatomic,assign) int hight1;
@property (nonatomic,assign) int hight2;
@property (nonatomic,assign) int hight3;
@property (nonatomic,assign) int hight4;
@property (nonatomic,assign) int hight5;
@property (nonatomic,assign) int hight6;
@property (nonatomic,assign) CGFloat tableHeight;
@property (nonatomic,copy) NSString *fastring;
@property (nonatomic,copy) NSString *useString;
@property (nonatomic,assign)float maxNumber;
@property (nonatomic,assign)BOOL popViewHidden;
@property (nonatomic,strong)UILabel *refresh;
@property (nonatomic,strong) UIImageView *topSmallBall;
@property (nonatomic,strong) UIImageView *downSmallBall;
@property (nonatomic,assign) BOOL isFirst;
@property (nonatomic,strong) UIButton *oneBtn;
@property (nonatomic,strong) UIButton *twoBtn;
@property (nonatomic,strong) UIButton *threeBtn;
@property (nonatomic,strong) UIButton *oneBtn1;
@property (nonatomic,strong) UIButton *twoBtn1;
@property (nonatomic,strong) UIButton *threeBtn1;
@property (nonatomic,strong) JHLineChart *lineChart;
@property (nonatomic,strong) JHLineChart *lineChart2;
@property (nonatomic,strong) JHLineChart *lineChart1;
@property (nonatomic,strong) HistogramView *zhuView;
@property (nonatomic,strong)JHTableChart *table1;
@property (nonatomic,strong)JHTableChart *table2;
@property (nonatomic,strong)JHTableChart *table3;
@property (nonatomic,strong)JHTableChart *table4;
@property (nonatomic,strong)JHTableChart *table5;
@property (nonatomic,strong)JHTableChart *table6;
@property (nonatomic,strong)JHTableChart *table11;
@property (nonatomic,strong)JHTableChart *table22;
@property (nonatomic,strong)JHTableChart *table33;
@property (nonatomic,strong)JHTableChart *table44;
@property (nonatomic,strong)JHTableChart *table55;
@property (nonatomic,strong)JHTableChart *table66;
@property (nonatomic,strong)JHTableChart *Redtable1;
@property (nonatomic,strong)JHTableChart *Redtable2;
@property (nonatomic,strong)JHTableChart *Redtable3;
@property (nonatomic,strong)JHTableChart *Redtable4;
@property (nonatomic,strong)JHTableChart *Redtable5;
@property (nonatomic,strong)JHTableChart *Redtable6;
@property (nonatomic,strong)JHTableChart *Redtable11;
@property (nonatomic,strong)JHTableChart *Redtable22;
@property (nonatomic,strong)JHTableChart *Redtable33;
@property (nonatomic,strong)JHTableChart *Redtable44;
@property (nonatomic,strong)JHTableChart *Redtable55;
@property (nonatomic,strong)JHTableChart *Redtable66;
@property (nonatomic,strong)UIScrollView *chartView;
@property (nonatomic,assign)int page;
@property (nonatomic,strong)UIScrollView *tableScroll;
@property (nonatomic,strong)UIScrollView *tableScroll1;
@property (nonatomic,strong)UIScrollView *titleScroll;
@property (nonatomic,strong)UIScrollView *titleScroll1;
@property (nonatomic,strong) UIImageView *clickView;
@property (nonatomic,strong) UIVisualEffectView *visualEffectView;
@property (nonatomic,assign)NSInteger alert_gen_num;
@property (nonatomic,assign)NSInteger alert_use_num;
@property (nonatomic,copy)NSString *isOnline;
@end

@implementation ElectricityViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.popViewHidden = YES;
    self.tableHeight = KHeight-180/3;
    self.faDianBtnClick = NO;
    self.yongdianDianBtnClick = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    self.isFirst = YES;
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    //设置对话框文字
    HUD.labelText = @"请稍等";
    //显示对话框
    [HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(3);
    } completionBlock:^{
        //操作执行完后取消对话框
        [HUD removeFromSuperview];
        //        HUD = nil;
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jinru:) name:@"jinru" object:nil];
    self.count = 1;
    
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view from its nib.
    //    [self requestWeather];
    self.isSpeaking = NO;
    
    //    [self setUI];
    //    [self requestFirstChart];
    //    [self requestSecondChart];
    [self requestStatus];
    [self requestMessage];
    [self requestText];
    [self requestGenDay];
    [self requestGenMonth];
    [self requestGenYear];
    [self requestFeeDay];
    [self requestFeeMonth];
    [self requestFeeYear];
    [self performSelector:@selector(requestFirstChart) withObject:nil/*可传任意类型参数*/ afterDelay:0.0];
    [self performSelector:@selector(requestSecondChart) withObject:nil/*可传任意类型参数*/ afterDelay:0.0];
    //    [self performSelector:@selector(requestWeather) withObject:nil/*可传任意类型参数*/ afterDelay:0.0];
    [self performSelector:@selector(setUI) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    
    [self performSelector:@selector(setFirstChart) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    [self performSelector:@selector(setSecondChart) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    [self performSelector:@selector(setFirstTable) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    [self performSelector:@selector(setSecondTable) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    [self performSelector:@selector(setThirdTable) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    [self performSelector:@selector(setFourTable) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    [self performSelector:@selector(setFiveTable) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    [self performSelector:@selector(setSixTable) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    [self performSelector:@selector(requestWeather) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    [self creatKeDa];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"InfoNotification" object:nil];
    
    self.timer1 = [NSTimer timerWithTimeInterval:600 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer1 forMode:NSRunLoopCommonModes];
}
- (void)InfoNotificationAction:(NSNotification *)notification{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(15,15), NO, 0);
    UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,15,15)];
    [[UIColor redColor] setFill];
    [p fill];
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    /*---------------------------------*/
    self.topSmallBall = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-20,KHeight/667*158, 15, 15)];
    [self.topSmallBall setImage:im];
    UILabel *numberLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSInteger topnum = [user integerForKey:@"fadianguzhang"];
    NSLog(@"topnum:%d",topnum);
    if (self.alert_gen_num>0) {
        numberLabel.text = [NSString stringWithFormat:@"%d",self.alert_gen_num];
        [self refresh];
    }else{
        self.topSmallBall.hidden = YES;
        [self refresh];
    }
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.font = [UIFont systemFontOfSize:12];
    [self.topSmallBall addSubview:numberLabel];
    [self.bgScrollerView addSubview:self.topSmallBall];
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(15,15), NO, 0);
    UIBezierPath* p1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,15,15)];
    [[UIColor redColor] setFill];
    [p1 fill];
    UIImage* im1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    /*---------------------------------*/
    self.downSmallBall = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-20,KHeight/667*195, 15, 15)];
    [self.downSmallBall setImage:im1];
    UILabel *numberLabel1= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    NSInteger downnum = [user integerForKey:@"yongdianguzhang"];
    NSLog(@"downnum:%d",downnum);
    if (self.alert_use_num>0) {
        numberLabel1.text = [NSString stringWithFormat:@"%d",self.alert_use_num];
        [self refresh];
    }else{
        self.downSmallBall.hidden = YES;
        [self refresh];
    }
    //    numberLabel1.text = @"1";
    numberLabel1.textAlignment = NSTextAlignmentCenter;
    numberLabel1.textColor = [UIColor whiteColor];
    numberLabel1.font = [UIFont systemFontOfSize:12];
    [self.downSmallBall addSubview:numberLabel1];
    [self.bgScrollerView addSubview:self.downSmallBall];
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
//    [self refresh];
    
}



- (void)jinru:(NSNotification *)text{
    [self refresh];
}

- (void)requestWeather{
    NSString *URL = [NSString stringWithFormat:@"https://api.seniverse.com/v3/weather/now.json"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:@"vmraf8swm5lscbx2" forKey:@"key"];
    [parameters setValue:currentCity forKey:@"location"];
    //    NSDictionary *dict = @{ @"bid":@"022017010719170501"};
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"天气%@",responseObject);
        NSArray *arr = responseObject[@"results"];
        NSDictionary *dic = arr[0][@"now"];
        self.weatherLabel.text = dic[@"text"];
        NSString *weather = dic[@"temperature"];
        self.temperatureLabel.text = [NSString stringWithFormat:@"%@℃",weather];
        NSNumber *code= dic[@"code"];
        NSString *imageName = [NSString stringWithFormat:@"%@",code];
        self.weatherImage.image = [UIImage imageNamed:imageName];
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
    
}

-(void)creatKeDa{
    
    
    //------科大讯飞语音 初始化
    //通过appid连接讯飞语音服务器，把@"53b5560a"换成你申请的appid
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"58f485d4"];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    
    //创建合成对象，为单例模式
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    _iFlySpeechSynthesizer.delegate = self;
    
    //设置语音合成的参数
    //合成的语速,取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];
    //合成的音量;取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"100" forKey:[IFlySpeechConstant VOLUME]];
    //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个性化发音人列表
    [_iFlySpeechSynthesizer setParameter:@"nannan" forKey:[IFlySpeechConstant VOICE_NAME]];
    //音频采样率,目前支持的采样率有 16000 和 8000
    [_iFlySpeechSynthesizer setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    ////asr_audio_path保存录音文件路径，如不再需要，设置value为nil表示取消，默认目录是documents
    [_iFlySpeechSynthesizer setParameter:@"tts.pcm" forKey:[IFlySpeechConstant TTS_AUDIO_PATH]];
    
    //隐藏键盘，点击空白处
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr

{
    [self.content resignFirstResponder];
    
}
//播放语音
-(void)StartPlayVoice{
    if (_isSpeaking) {
        [MBProgressHUD showText:@"语音播报停止.."];
        [_iFlySpeechSynthesizer pauseSpeaking];
        self.isSpeaking = NO;
    }else{
        [MBProgressHUD showText:@"语音播报缓冲中.."];
        [_iFlySpeechSynthesizer
         startSpeaking:self.content.text];
        self.isSpeaking = YES;
    }
    
    
    
}


- (void)changeImage{
    
    
    if (theTimer == nil){
        float theInterval = 10;//1秒执行30次
        theTimer = [NSTimer scheduledTimerWithTimeInterval:theInterval target:self selector:@selector(delayMethod) userInfo:nil repeats:YES];
    }
}


- (void)delayMethod{
    switch (self.count) {
        case 0:
            self.leftImage.image = [UIImage imageNamed:@"top1"];
            self.rightImage.image = [UIImage imageNamed:@"right1"];
            if (self.statusArr.count>0) {
                NSArray *array = self.statusArr[2];
                float left = [array[0] floatValue];
                self.leftLabel.text = [NSString stringWithFormat:@"%.2f",left];
                float right = [array[1] floatValue];
                self.rightLabel.text = [NSString stringWithFormat:@"%.2f",right];
                self.leftLabel.hidden = NO;
                self.duLabel.hidden = NO;
                self.gangLabel.hidden = NO;
                self.yuanLabel.hidden = NO;
                self.rightLabel.hidden = NO;
                self.leftLabel.textColor = RGBColor(219, 98, 32);
                self.rightLabel.textColor = RGBColor(219, 98, 32);
                self.duLabel.textColor = RGBColor(219, 98, 32);
                self.gangLabel.textColor = RGBColor(219, 98, 32);
                self.yuanLabel.textColor = RGBColor(219, 98, 32);
                self.greenLabel.hidden = YES;
            }
            self.count = 1;
            break;
        case 1:
            self.leftImage.image = [UIImage imageNamed:@"top2"];
            self.rightImage.image = [UIImage imageNamed:@"right2"];
            if (self.statusArr.count>0) {
                NSArray *array = self.statusArr[5];
                float left = [array[0] floatValue];
                self.leftLabel.text = [NSString stringWithFormat:@"%.2f",left];
                float right = [array[1] floatValue];
                self.rightLabel.text = [NSString stringWithFormat:@"%.2f",right];
                self.leftLabel.hidden = NO;
                self.duLabel.hidden = NO;
                self.gangLabel.hidden = NO;
                self.yuanLabel.hidden = NO;
                self.rightLabel.hidden = NO;
                self.leftLabel.textColor = RGBColor(253, 198, 81);
                self.rightLabel.textColor = RGBColor(253, 198, 81);
                self.duLabel.textColor = RGBColor(253, 198, 81);
                self.gangLabel.textColor = RGBColor(253, 198, 81);
                self.yuanLabel.textColor = RGBColor(253, 198, 81);
                self.greenLabel.hidden = YES;
            }
            self.count = 2;
            break;
        case 2:
            self.leftImage.image = [UIImage imageNamed:@"top3"];
            self.rightImage.image = [UIImage imageNamed:@"right3"];
            if (self.statusArr.count>0) {
                NSArray *array = self.statusArr[4];
                float left = [array[0] floatValue];
                self.leftLabel.text = [NSString stringWithFormat:@"%.2f",left];
                float right = [array[1] floatValue];
                self.rightLabel.text = [NSString stringWithFormat:@"%.2f",right];
                self.leftLabel.hidden = NO;
                self.duLabel.hidden = NO;
                self.gangLabel.hidden = NO;
                self.yuanLabel.hidden = NO;
                self.rightLabel.hidden = NO;
                self.leftLabel.textColor = RGBColor(162, 0, 133);
                self.rightLabel.textColor = RGBColor(162, 0, 133);
                self.duLabel.textColor = RGBColor(162, 0, 133);
                self.gangLabel.textColor = RGBColor(162, 0, 133);
                self.yuanLabel.textColor = RGBColor(162, 0, 133);
                self.greenLabel.hidden = YES;
            }
            self.count = 3;
            break;
        case 3:
            self.leftImage.image = [UIImage imageNamed:@"top4"];
            self.rightImage.image = [UIImage imageNamed:@"right4"];
            if (self.statusArr.count>0) {
                NSArray *array = self.statusArr[1];
                float left = [array[0] floatValue];
                self.leftLabel.text = [NSString stringWithFormat:@"%.2f",left];
                float right = [array[1] floatValue];
                self.rightLabel.text = [NSString stringWithFormat:@"%.2f",right];
                self.leftLabel.hidden = NO;
                self.duLabel.hidden = NO;
                self.gangLabel.hidden = NO;
                self.yuanLabel.hidden = NO;
                self.rightLabel.hidden = NO;
                self.leftLabel.textColor = RGBColor(44, 112, 224);
                self.rightLabel.textColor = RGBColor(44, 112, 224);
                self.duLabel.textColor = RGBColor(44, 112, 224);
                self.gangLabel.textColor = RGBColor(44, 112, 224);
                self.yuanLabel.textColor = RGBColor(44, 112, 224);
                self.greenLabel.hidden = YES;
            }
            self.count = 4;
            break;
        case 4:
            self.leftImage.image = [UIImage imageNamed:@"top5"];
            self.rightImage.image = [UIImage imageNamed:@"right5"];
            if (self.statusArr.count>0) {
                NSArray *array = self.statusArr[3];
                float left = [array[0] floatValue];
                self.leftLabel.text = [NSString stringWithFormat:@"%.2f",left];
                float right = [array[1] floatValue];
                self.rightLabel.text = [NSString stringWithFormat:@"%.2f",right];
                self.leftLabel.hidden = NO;
                self.duLabel.hidden = NO;
                self.gangLabel.hidden = NO;
                self.yuanLabel.hidden = NO;
                self.rightLabel.hidden = NO;
                self.leftLabel.textColor = RGBColor(209, 37, 38);
                self.rightLabel.textColor = RGBColor(209, 37, 38);
                self.duLabel.textColor = RGBColor(209, 37, 38);
                self.gangLabel.textColor = RGBColor(209, 37, 38);
                self.yuanLabel.textColor = RGBColor(209, 37, 38);
                self.greenLabel.hidden = YES;
            }
            self.count = 5;
            break;
        case 5:
            self.leftImage.image = [UIImage imageNamed:@"top6"];
            self.rightImage.image = [UIImage imageNamed:@"right6"];
            self.count = 0;
            if (self.statusArr.count>0) {
                NSArray *array = self.statusArr[0];
                self.leftLabel.hidden = YES;
                self.duLabel.hidden = YES;
                self.gangLabel.hidden = YES;
                self.rightLabel.hidden = YES;
                self.yuanLabel.hidden = YES;
                //                float left = [array[0] floatValue];
                //                NSString *string = [NSString stringWithFormat:@"%.2f",left];
                //                self.rightLabel.text = string;
                self.leftLabel.textColor = RGBColor(0, 115, 8);
                self.rightLabel.textColor = RGBColor(0, 115, 8);
                self.duLabel.textColor = RGBColor(0, 115, 8);
                self.gangLabel.textColor = RGBColor(0, 115, 8);
                self.yuanLabel.textColor = RGBColor(0, 115, 8);
                self.greenLabel.hidden = NO;
                self.greenLabel.textColor = RGBColor(0, 115, 8);
            }
            self.count = 0;
            
        default:
            break;
    }
}

- (void)setUI{
    
    UIImageView *bgimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, KWidth, KHeight+20)];
    bgimage.image = [UIImage imageNamed:@"bg1111"];
    [self.view addSubview:bgimage];
    
    _bgTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight) style:UITableViewStylePlain];
//        _bgTable.bounces = NO;
    _bgTable.backgroundColor = [UIColor clearColor];
    _bgTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_bgTable];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    // 隐藏时间
        header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    //    header.stateLabel.hidden = YES;
    self.bgTable.mj_header = header;
    self.bgTable.mj_header.ignoredScrollViewContentInsetTop = self.bgTable.contentInset.top;
    
    self.bgScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
    self.bgScrollerView.delegate = self;
    self.bgScrollerView.pagingEnabled = YES;
    _bgScrollerView.contentSize = CGSizeMake(KWidth, KHeight*3);
    _bgScrollerView.bounces = NO;
    self.bgScrollerView.backgroundColor = [UIColor clearColor];
    [_bgTable addSubview:self.bgScrollerView];
    
    
    
    NSDate  *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    
    NSInteger year=[components year];
    NSInteger month=[components month];
    NSInteger day=[components day];
    NSLog(@"currentDate = %@ ,year = %ld ,month=%ld, day=%ld",currentDate,year,month,day);
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/375*22,KHeight/664*28,KWidth/375*100,KHeight/664*20)];
    self.dateLabel.text = [NSString stringWithFormat:@"%ld.%ld.%ld",year,month,day];
    self.dateLabel.font = [UIFont systemFontOfSize:14];
    self.dateLabel.textColor = RGBColor(2, 28, 106);
    [self.bgScrollerView addSubview:self.dateLabel];
    self.temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-57,KHeight/664*28,KWidth/375*40,KHeight/664*10)];
    self.temperatureLabel.text = @"21℃";
    self.temperatureLabel.textColor = RGBColor(2, 28, 106);
    self.temperatureLabel.font = [UIFont systemFontOfSize:14];
    [self.bgScrollerView addSubview:self.temperatureLabel];
    
    self.weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-115,KHeight/664*28,KWidth/375*60, KHeight/667*10)];
    self.weatherLabel.text = @"晴";
    self.weatherLabel.textColor = RGBColor(2, 28, 106);
    self.weatherLabel.textAlignment = NSTextAlignmentCenter;
    self.weatherLabel.font = [UIFont systemFontOfSize:14];
    [self.bgScrollerView addSubview:self.weatherLabel];
    
    self.weatherImage = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-138, KHeight/667*25, KWidth/375*15, KHeight/667*15)];
    self.weatherImage.image = [UIImage imageNamed:@"晴"];
    [self.bgScrollerView addSubview:self.weatherImage];
    
    self.leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth/375*25, KHeight/667*50, KWidth/375*125, KHeight/667*190)];
    self.leftImage.image = [UIImage imageNamed:@"top1"];
    [self.bgScrollerView addSubview:self.leftImage];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/375*25, KHeight/667*50, KWidth/375*125, KHeight/667*190)];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollerView addSubview:leftBtn];
    
    self.rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth/2-12, KHeight/667*65, KWidth/2, KHeight/667*75)];
    self.rightImage.image = [UIImage imageNamed:@"right1"];
    [self.bgScrollerView addSubview:self.rightImage];
    
    self.greenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, KHeight/667*40, KWidth/2, KHeight/667*20)];
    if(self.statusArr.count>0){
        NSArray *array = self.statusArr[2];
        float right = [array[1] floatValue];
        NSArray *array1 = self.statusArr[4];
        float right1 = [array1[1] floatValue];
        self.greenLabel.font = [UIFont systemFontOfSize:18];
        self.greenLabel.text = [NSString stringWithFormat:@"%.2f-%.2f/ %.2f 元",right,right1,right-right1];
        
    }
    self.greenLabel.textColor = [UIColor greenColor];
    self.greenLabel.textAlignment = NSTextAlignmentCenter;
    [self.rightImage addSubview:self.greenLabel];
    self.greenLabel.hidden = YES;
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, KHeight/667*40, KWidth/375*60, KHeight/667*15)];
    //        self.leftLabel.text = @"22.3";
    //    [self.leftLabel sizeToFit];
    self.leftLabel.textAlignment = NSTextAlignmentRight;
    self.leftLabel.textColor = RGBColor(219, 98, 32);
    self.leftLabel.font = [UIFont systemFontOfSize:18];
    [self.rightImage addSubview:self.leftLabel];
    
    self.duLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/375*60,KHeight/667*42, KWidth/375*15, KHeight/667*10)];
    self.duLabel.text = @"度";
    self.duLabel.textColor = RGBColor(219, 98, 32);
    self.duLabel.font = [UIFont systemFontOfSize:12];
    [self.rightImage addSubview:self.duLabel];
    
    self.gangLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/375*80,KHeight/667*28, KWidth/375*30, KHeight/667*40)];
    self.gangLabel.text = @"/";
    self.gangLabel.textColor = RGBColor(219, 98, 32);
    self.gangLabel.font = [UIFont systemFontOfSize:30];
    [self.rightImage addSubview:self.gangLabel];
    
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/375*98, KHeight/667*40, KWidth/375*70, KHeight/667*15)];
    //        self.rightLabel.text = @"25.36";
    self.rightLabel.textColor = RGBColor(219, 98, 32);
    self.rightLabel.font = [UIFont systemFontOfSize:20];
    [self.rightImage addSubview:self.rightLabel];
    if (self.statusArr.count>0) {
        NSArray *array3 = self.statusArr[5];
        float left = [array3[0] floatValue];
        self.leftLabel.text = [NSString stringWithFormat:@"%.2f",left];
        float right3 = [array3[1] floatValue];
        self.rightLabel.text = [NSString stringWithFormat:@"%.2f",right3];
    }
    if (_statusArr.count>0) {
        NSArray *array111 = _statusArr[2];
        float left = [array111[0] floatValue];
        self.leftLabel.text = [NSString stringWithFormat:@"%.2f",left];
        float right = [array111[1] floatValue];
        self.rightLabel.text = [NSString stringWithFormat:@"%.2f",right];
    }
   
    
    self.yuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/375*155, KHeight/667*43, KWidth/375*15, KHeight/667*10)];
    self.yuanLabel.text = @"元";
    self.yuanLabel.textColor = RGBColor(219, 98, 32);
    self.yuanLabel.font = [UIFont systemFontOfSize:16];
    [self.rightImage addSubview:self.yuanLabel];
    
    UIImageView *downBigImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth/2-12, KHeight/667*155, KWidth/2, KHeight/667*70)];
    if ([self.isOnline isEqualToString:@"online"]) {
        downBigImg.image = [UIImage imageNamed:@"组-1"];
    }else{
        downBigImg.image = [UIImage imageNamed:@"grey"];
    }
    
    downBigImg.userInteractionEnabled = YES;
    [self.bgScrollerView addSubview:downBigImg];
    
    UIImageView *topImg = [[UIImageView alloc] initWithFrame:CGRectMake(2, 1, KWidth/2, KHeight/667*35)];
    //    topImg.image = [UIImage imageNamed:@"发用电状态bg"];
    topImg.userInteractionEnabled = YES;
    [downBigImg addSubview:topImg];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, KWidth/4-5, KHeight/667*35)];
    label1.text = @"发电设备:";
    label1.font = [UIFont systemFontOfSize:13];
    label1.textColor = [UIColor whiteColor];
    [topImg addSubview:label1];
    
    UIImageView *btnBg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth/375*70,KHeight/667*5,KWidth/375*110,KHeight/667*23)];
    btnBg.image = [UIImage imageNamed:@"yongdianzhuangtai"];
    [topImg addSubview:btnBg];
    
    self.oneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KWidth/375*110/3,KHeight/667*24)];
    [self.oneBtn setBackgroundImage:[UIImage imageNamed:@"zhengchang"] forState:UIControlStateNormal];
    [self.oneBtn setTitle:@"正常" forState:UIControlStateNormal];
    self.oneBtn.font = [UIFont systemFontOfSize:10];
    [btnBg addSubview:self.oneBtn];
    
    self.twoBtn = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/375*110/3, 0, KWidth/375*110/3,KHeight/667*24)];
    [self.twoBtn setBackgroundImage:[UIImage imageNamed:@"yichang"] forState:UIControlStateNormal];
    [self.twoBtn setTitle:@"异常" forState:UIControlStateNormal];
    self.twoBtn.font = [UIFont systemFontOfSize:10];
    [btnBg addSubview:self.twoBtn];
    
    self.threeBtn = [[UIButton alloc] initWithFrame:CGRectMake((KWidth/375*110/3)*2, 0, KWidth/375*110/3, KHeight/667*24)];
    [self.threeBtn setBackgroundImage:[UIImage imageNamed:@"guzhang"] forState:UIControlStateNormal];
    [self.threeBtn setTitle:@"故障" forState:UIControlStateNormal];
    self.threeBtn.font = [UIFont systemFontOfSize:10];
    [btnBg addSubview:self.threeBtn];
    
    //--------判断按钮状态-----
    if ([self.topStatus isEqualToString:@"normal"]) {
        [self.twoBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.twoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.threeBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.threeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.oneBtn setBackgroundImage:[UIImage imageNamed:@"zhengchang"] forState:UIControlStateNormal];
        [self.oneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if ([self.topStatus isEqualToString:@"abnormal"]){
        [self.oneBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.oneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.threeBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.threeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.twoBtn setBackgroundImage:[UIImage imageNamed:@"yichang"] forState:UIControlStateNormal];
        [self.twoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else {
        [self.oneBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.oneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.threeBtn setBackgroundImage:[UIImage imageNamed:@"guzhang"] forState:UIControlStateNormal];
        [self.threeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.twoBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.twoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    UIButton *fadianguzhang = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KWidth/2,KHeight/667*35)];
    [fadianguzhang addTarget:self action:@selector(fadianguzhang) forControlEvents:UIControlEventTouchUpInside];
    [topImg addSubview:fadianguzhang];
    
    UIImageView *downImg = [[UIImageView alloc] initWithFrame:CGRectMake(2, KHeight/667*35, KWidth/2, KHeight/667*35)];
    //    downImg.image = [UIImage imageNamed:@"发用电状态bg"];
    downImg.userInteractionEnabled = YES;
    [downBigImg addSubview:downImg];
    
    UIImageView *btnBg1 = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth/375*70,KHeight/667*7,KWidth/375*110,KHeight/667*23)];
    btnBg1.image = [UIImage imageNamed:@"yongdianzhuangtai"];
    [downImg addSubview:btnBg1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, KWidth/4-5, KHeight/667*35)];
    label2.text = @"用电设备:";
    label2.font = [UIFont systemFontOfSize:13];
    label2.textColor = [UIColor whiteColor];
    [downImg addSubview:label2];
    
    self.oneBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KWidth/375*110/3, KHeight/667*23)];
    [self.oneBtn1 setBackgroundImage:[UIImage imageNamed:@"zhengchang"] forState:UIControlStateNormal];
    [self.oneBtn1 setTitle:@"正常" forState:UIControlStateNormal];
    self.oneBtn1.font = [UIFont systemFontOfSize:10];
    [btnBg1 addSubview:self.oneBtn1];
    
    self.twoBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(KWidth/375*110/3, 0, KWidth/375*110/3, KHeight/667*23)];
    [self.twoBtn1 setBackgroundImage:[UIImage imageNamed:@"yichang"] forState:UIControlStateNormal];
    [self.twoBtn1 setTitle:@"隐患" forState:UIControlStateNormal];
    self.twoBtn1.font = [UIFont systemFontOfSize:10];
    [btnBg1 addSubview:self.twoBtn1];
    
    self.threeBtn1 = [[UIButton alloc] initWithFrame:CGRectMake((KWidth/375*110/3*2), 0, KWidth/375*110/3, KHeight/667*23)];
    [self.threeBtn1 setBackgroundImage:[UIImage imageNamed:@"guzhang"] forState:UIControlStateNormal];
    [self.threeBtn1 setTitle:@"危险" forState:UIControlStateNormal];
    self.threeBtn1.font = [UIFont systemFontOfSize:10];
    [btnBg1 addSubview:self.threeBtn1];
    
    
    //-----------判断按钮状态------
    if ([self.downStatus isEqualToString:@"normal"]) {
        [self.twoBtn1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.twoBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.threeBtn1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.threeBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.oneBtn1 setBackgroundImage:[UIImage imageNamed:@"zhengchang"] forState:UIControlStateNormal];
        [self.oneBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if ([self.downStatus isEqualToString:@"abnormal"]){
        [self.oneBtn1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.oneBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.threeBtn1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.threeBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.twoBtn1 setBackgroundImage:[UIImage imageNamed:@"yichang"] forState:UIControlStateNormal];
        [self.twoBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [self.oneBtn1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.oneBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.threeBtn1 setBackgroundImage:[UIImage imageNamed:@"guzhang"] forState:UIControlStateNormal];
        [self.threeBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.twoBtn1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.twoBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(15,15), NO, 0);
    UIBezierPath* p = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,15,15)];
    [[UIColor redColor] setFill];
    [p fill];
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    /*---------------------------------*/
    self.topSmallBall = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-20, KHeight/667*158, 15, 15)];
    [self.topSmallBall setImage:im];
    UILabel *numberLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSInteger topnum = [user integerForKey:@"fadianguzhang"];
    if (self.alert_gen_num>0) {
        numberLabel.text = [NSString stringWithFormat:@"%d",self.alert_gen_num];
    }else{
        self.topSmallBall.hidden = YES;
    }
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.font = [UIFont systemFontOfSize:12];
    [self.topSmallBall addSubview:numberLabel];
    [self.bgScrollerView addSubview:self.topSmallBall];
    
    
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(15,15), NO, 0);
    UIBezierPath* p1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0,15,15)];
    [[UIColor redColor] setFill];
    [p1 fill];
    UIImage* im1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    /*---------------------------------*/
    self.downSmallBall = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-20, KHeight/667*195, 15, 15)];
    [self.downSmallBall setImage:im1];
    UILabel *numberLabel1= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    NSInteger downnum = [user integerForKey:@"yongdianguzhang"];
    if (self.alert_use_num>0) {
        NSString *num = [NSString stringWithFormat:@"%ld",self.alert_use_num];
        numberLabel1.text = num;
    }else{
        self.downSmallBall.hidden = YES;
    }
    //    numberLabel1.text = @"1";
    numberLabel1.textAlignment = NSTextAlignmentCenter;
    numberLabel1.textColor = [UIColor whiteColor];
    numberLabel1.font = [UIFont systemFontOfSize:12];
    [self.downSmallBall addSubview:numberLabel1];
    [self.bgScrollerView addSubview:self.downSmallBall];
    //    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    
    
    UIButton *yongdianguzhang = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KWidth/2, KHeight/667*30)];
    [yongdianguzhang addTarget:self action:@selector(yongdianguzhang) forControlEvents:UIControlEventTouchUpInside];
    [downImg addSubview:yongdianguzhang];
    
    
    [self changeImage];
    
}

- (void)setFirstChart{
    self.chartView = [[UIScrollView alloc] initWithFrame:CGRectMake(7,KHeight/667* 252, KWidth-14,KHeight/667*211)];
    self.chartView.contentSize = CGSizeMake((KWidth-14)*2, 211);
    self.page = 0;
    self.chartView.pagingEnabled = YES;
    self.chartView.delegate = self;
    [self.bgScrollerView addSubview:self.chartView];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWidth-14, KHeight/667*211)];
    bg.image = [UIImage imageNamed:@"biaogebg"];
    [self.chartView addSubview:bg];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-105, 10, 250, 20)];
    titleLabel.text = @"今日发、用电功率曲线图";
    titleLabel.textColor = RGBColor(2, 28, 106);
    titleLabel.font = [UIFont systemFontOfSize:16];
    [bg addSubview:titleLabel];
    
    UILabel *waLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 25, 10)];
    waLabel.text = @"(kW)";
    waLabel.textColor = RGBColor(0, 60, 255);
    waLabel.font = [UIFont systemFontOfSize:11];
    [bg addSubview:waLabel];
    UILabel *waLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-38, 25, 25, 10)];
    waLabel1.text = @"(kW)";
    waLabel1.textColor = RGBColor(255, 0, 0);
    waLabel1.font = [UIFont systemFontOfSize:11];
    [bg addSubview:waLabel1];
    UILabel *shiLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-30,KHeight/667*190, 15, 10)];
    shiLabel.text = @"(h)";
    shiLabel.textColor = [UIColor darkGrayColor];
    shiLabel.font = [UIFont systemFontOfSize:11];
    [bg addSubview:shiLabel];
    
    UILabel *rightTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-77, 10, 50, 20)];
    rightTopLabel.text = @"发电功率";
    rightTopLabel.font = [UIFont systemFontOfSize:8];
    [bg addSubview:rightTopLabel];
    UIImageView *topImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-90, 15, 10, 10)];
    topImg.image = [UIImage imageNamed:@"椭圆-6"];
    [bg addSubview:topImg];
    
    UILabel *rightDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-77, 25, 50, 20)];
    rightDownLabel.text = @"用电功率";
    rightDownLabel.font = [UIFont systemFontOfSize:8];
    [bg addSubview:rightDownLabel];
    UIImageView *downImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-90, 30, 10, 10)];
    downImg.image = [UIImage imageNamed:@"xiaohongdian"];
    [bg addSubview:downImg];
    
    NSInteger count = 1;
    for (int i=0; i<self.FirstChartgenArr.count; i++) {
        if (i>0) {
            if (self.FirstChartgenArr[i]>=0) {
                if (self.FirstChartgenArr[i-1]<0) {
                    count++;
                }
            }
        }
    }
    NSMutableArray *genArr1 = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<self.FirstChartgenArr.count; i++) {
        if (i>0) {
            if (self.FirstChartgenArr[i]>=0) {
                if (self.FirstChartgenArr[i-1]<0) {
                    [genArr1 addObject:self.FirstChartgenArr[i]];
                }
            }else{
            
            }
        }
    }

    
    
    self.lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(0,KHeight/667*30, KWidth-14, KHeight/667*180) andLineChartType:JHChartLineValueNotForEveryX];
    self.lineChart.isShowRight = NO;
    self.lineChart.xLineDataArr = @[@"0",@"2",@"4",@"6",@"8",@"10",@"12",@"14",@"16",@"18",@"20",@"22",@"24"];
    self.lineChart.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    
    self.lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    //用电数据
    self.lineChart.valueArr = @[self.FirstChartgenArr];
//    self.lineChart.valueArr = @[@1,@1,@1,[NSNull null],@1,@1,@1];
    self.lineChart.showYLevelLine = YES;
    self.lineChart.showYLine = YES;
    self.lineChart.isShowLeft = NO;
    self.lineChart.isKw = YES;
    self.lineChart.isShowRight = YES;
    self.lineChart.showValueLeadingLine = NO;
    self.lineChart.valueFontSize = 0.0;
    self.lineChart.backgroundColor = [UIColor clearColor];
    /* Line Chart colors */
    self.lineChart.valueLineColorArr =@[ RGBColor(255, 0, 0)];
    /* Colors for every line chart*/
    //    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    /* color for XY axis */
    self.lineChart.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    self.lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    /* Dotted line color of the coordinate point */
    self.lineChart.positionLineColorArr = @[[UIColor clearColor],[UIColor clearColor]];
    /*        Set whether to fill the content, the default is False         */
    //    lineChart.contentFill = YES;
    /*        Set whether the curve path         */
    self.lineChart.pathCurve = YES;
    /*        Set fill color array         */
    //    lineChart.contentFillColorArr = @[[UIColor colorWithRed:0 green:1 blue:0 alpha:0.468],[UIColor colorWithRed:1 green:0 blue:0 alpha:0.468]];
    [bg addSubview:self.lineChart];
    CGFloat maxUse = 0;
    for (int i=0; i<_FirstChartgenArr.count; i++) {
        CGFloat num = [_FirstChartgenArr[i] floatValue];
        if (num > maxUse) {
            maxUse = num;
        }
    }
    CGFloat maxGen = 0;
    for (int i=0; i<_FirstChartuseArr.count; i++) {
        CGFloat num = [_FirstChartuseArr[i] floatValue];
        if (num > maxGen) {
            maxGen = num;
        }
    }
    CGFloat bei = maxGen/maxUse;
    CGFloat da = maxUse-maxGen;
    if (maxUse==0) {
        NSString *str1 = [NSString stringWithFormat:@"%.2f",maxUse];
        NSString *str2 = [NSString stringWithFormat:@"%.2f",maxUse*2];
        NSString *str3 = [NSString stringWithFormat:@"%.2f",maxUse*3];
        NSString *str4 = [NSString stringWithFormat:@"%.2f",maxUse*4];
        NSString *str5 = [NSString stringWithFormat:@"%.2f",maxUse*5];
        NSString *str6 = [NSString stringWithFormat:@"%.2f",maxUse*6];
        self.lineChart.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
    }else{
        if (bei>6) {
            NSString *str1 = [NSString stringWithFormat:@"%.2f",maxUse];
            NSString *str2 = [NSString stringWithFormat:@"%.2f",maxUse*2];
            NSString *str3 = [NSString stringWithFormat:@"%.2f",maxUse*3];
            NSString *str4 = [NSString stringWithFormat:@"%.2f",maxUse*4];
            NSString *str5 = [NSString stringWithFormat:@"%.2f",maxUse*5];
            NSString *str6 = [NSString stringWithFormat:@"%.2f",maxUse*6];
            self.lineChart.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
        }else{
            if (da>0) {
                NSString *str1 = [NSString stringWithFormat:@"%.2f",maxUse/6];
                NSString *str2 = [NSString stringWithFormat:@"%.2f",maxUse/6*2];
                NSString *str3 = [NSString stringWithFormat:@"%.2f",maxUse/6*3];
                NSString *str4 = [NSString stringWithFormat:@"%.2f",maxUse/6*4];
                NSString *str5 = [NSString stringWithFormat:@"%.2f",maxUse/6*5];
                NSString *str6 = [NSString stringWithFormat:@"%.2f",maxUse];
                self.lineChart.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
            }else{
                NSString *str1 = [NSString stringWithFormat:@"%.2f",maxGen/6];
                NSString *str2 = [NSString stringWithFormat:@"%.2f",maxGen/6*2];
                NSString *str3 = [NSString stringWithFormat:@"%.2f",maxGen/6*3];
                NSString *str4 = [NSString stringWithFormat:@"%.2f",maxGen/6*4];
                NSString *str5 = [NSString stringWithFormat:@"%.2f",maxGen/6*5];
                NSString *str6 = [NSString stringWithFormat:@"%.2f",maxGen];
                self.lineChart.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
            }
        }
    }
    /*       Start animation        */
    [self.lineChart showAnimation];
    
    self.lineChart2 = [[JHLineChart alloc] initWithFrame:CGRectMake(0,KHeight/667*30, KWidth-14, KHeight/667*180) andLineChartType:JHChartLineValueNotForEveryX];
    self.lineChart2.isShowRight = NO;
    self.lineChart2.isShowLeft = YES;
    self.lineChart2.isKw = YES;
    self.lineChart2.xLineDataArr = @[@"0",@"2",@"4",@"6",@"8",@"10",@"12",@"14",@"16",@"18",@"20",@"22",@"24"];
    
    self.lineChart2.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    
    self.lineChart2.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    //用电数据
    self.lineChart2.valueArr = @[self.FirstChartuseArr];

    self.lineChart2.showYLevelLine = NO;
    self.lineChart2.showYLine = NO;
    self.lineChart2.showValueLeadingLine = NO;
    self.lineChart2.valueFontSize = 0.0;
    self.lineChart2.backgroundColor = [UIColor clearColor];
    /* Line Chart colors */
    self.lineChart2.valueLineColorArr =@[ RGBColor(0, 60, 255)];
    /* Colors for every line chart*/
    //    lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
    /* color for XY axis */
    self.lineChart2.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    self.lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    /* Dotted line color of the coordinate point */
    self.lineChart2.positionLineColorArr = @[[UIColor clearColor],[UIColor clearColor]];
    /*        Set whether to fill the content, the default is False         */
    //    lineChart.contentFill = YES;
    /*        Set whether the curve path         */
    self.lineChart2.pathCurve = YES;
    /*        Set fill color array         */
    //    lineChart.contentFillColorArr = @[[UIColor colorWithRed:0 green:1 blue:0 alpha:0.468],[UIColor colorWithRed:1 green:0 blue:0 alpha:0.468]];
    [bg addSubview:self.lineChart2];
    /*       Start animation        */
    
    CGFloat bei1 = maxUse/maxGen;
    if (maxGen==0) {
        NSString *str1 = [NSString stringWithFormat:@"%.2f",maxGen];
        NSString *str2 = [NSString stringWithFormat:@"%.2f",maxGen*2];
        NSString *str3 = [NSString stringWithFormat:@"%.2f",maxGen*3];
        NSString *str4 = [NSString stringWithFormat:@"%.2f",maxGen*4];
        NSString *str5 = [NSString stringWithFormat:@"%.2f",maxGen*5];
        NSString *str6 = [NSString stringWithFormat:@"%.2f",maxGen*6];
        self.lineChart2.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
    }else{
        if (bei1>6) {
            NSString *str1 = [NSString stringWithFormat:@"%.2f",maxUse];
            NSString *str2 = [NSString stringWithFormat:@"%.2f",maxUse*2];
            NSString *str3 = [NSString stringWithFormat:@"%.2f",maxUse*3];
            NSString *str4 = [NSString stringWithFormat:@"%.2f",maxUse*4];
            NSString *str5 = [NSString stringWithFormat:@"%.2f",maxUse*5];
            NSString *str6 = [NSString stringWithFormat:@"%.2f",maxUse*6];
            self.lineChart2.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
        }else{
            if (da>0) {
                NSString *str1 = [NSString stringWithFormat:@"%.2f",maxUse/6];
                NSString *str2 = [NSString stringWithFormat:@"%.2f",maxUse/6*2];
                NSString *str3 = [NSString stringWithFormat:@"%.2f",maxUse/6*3];
                NSString *str4 = [NSString stringWithFormat:@"%.2f",maxUse/6*4];
                NSString *str5 = [NSString stringWithFormat:@"%.2f",maxUse/6*5];
                NSString *str6 = [NSString stringWithFormat:@"%.2f",maxUse];
                self.lineChart2.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
            }else{
                NSString *str1 = [NSString stringWithFormat:@"%.2f",maxGen/6];
                NSString *str2 = [NSString stringWithFormat:@"%.2f",maxGen/6*2];
                NSString *str3 = [NSString stringWithFormat:@"%.2f",maxGen/6*3];
                NSString *str4 = [NSString stringWithFormat:@"%.2f",maxGen/6*4];
                NSString *str5 = [NSString stringWithFormat:@"%.2f",maxGen/6*5];
                NSString *str6 = [NSString stringWithFormat:@"%.2f",maxGen];
                self.lineChart2.yLineDataArr = @[str1,str2,str3,str4,str5,str6];
            }
        }
    }
    [self.lineChart2 showAnimation];
    UIImageView *bg1 = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-14, 0, KWidth-14,KHeight/667*211)];
    bg1.image = [UIImage imageNamed:@"biaogebg"];
    [self.chartView addSubview:bg1];
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-105, 10, 250, 20)];
    secondLabel.text = @"今日发、用电量柱状图";
    secondLabel.textColor = RGBColor(2, 28, 106);
    secondLabel.font = [UIFont systemFontOfSize:16];
    [bg1 addSubview:secondLabel];
    
    UILabel *dianLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 40, 10)];
    dianLabel.text = @"(kW·h)";
    
    
    dianLabel.textColor = RGBColor(0, 60, 255);
    dianLabel.font = [UIFont systemFontOfSize:11];
    [bg1 addSubview:dianLabel];
    
    UILabel *shiLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-30,KHeight/667*190, 15, 10)];
    shiLabel1.text = @"(h)";
    shiLabel1.textColor = [UIColor darkGrayColor];
    shiLabel1.font = [UIFont systemFontOfSize:11];
    [bg1 addSubview:shiLabel1];
    
    UILabel *leftTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-95, 10, 50, 20)];
    leftTopLabel.text = @"上网";
    leftTopLabel.font = [UIFont systemFontOfSize:8];
    [bg1 addSubview:leftTopLabel];
    
    UIImageView *leftTopImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-108, 15, 10, 7)];
    leftTopImg.image = [UIImage imageNamed:@"矩形-23-拷贝"];
    [bg1 addSubview:leftTopImg];
    
    UILabel *leftDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-95, 25, 50, 20)];
    leftDownLabel.text = @"峰电";
    leftDownLabel.font = [UIFont systemFontOfSize:8];
    [bg1 addSubview:leftDownLabel];
    
    UIImageView *leftDownImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-108, 30, 10, 7)];
    leftDownImg.image = [UIImage imageNamed:@"矩形-23-拷贝-2"];
    [bg1 addSubview:leftDownImg];
    
    UILabel *rightTopLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-60, 10, 50, 20)];
    rightTopLabel1.text = @"自用";
    rightTopLabel1.font = [UIFont systemFontOfSize:8];
    [bg1 addSubview:rightTopLabel1];
    UIImageView *rightTopImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-73, 15, 10, 7)];
    rightTopImg.image = [UIImage imageNamed:@"矩形-23"];
    [bg1 addSubview:rightTopImg];
    
    UILabel *rightDownLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-60, 25, 50, 20)];
    rightDownLabel1.text = @"谷电";
    rightDownLabel1.font = [UIFont systemFontOfSize:8];
    [bg1 addSubview:rightDownLabel1];
    UIImageView *rightDownImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-73, 30, 10, 7)];
    rightDownImg.image = [UIImage imageNamed:@"矩形-23-拷贝-3"];
    [bg1 addSubview:rightDownImg];
    
    self.lineChart1 = [[JHLineChart alloc] initWithFrame:CGRectMake(0, KHeight/667*30, KWidth-14, KHeight/667*180) andLineChartType:JHChartLineValueNotForEveryX];
    self.lineChart1.isShowRight = NO;
    self.lineChart1.isShowLeft = YES;
    
    self.lineChart1.isKw = NO;
    
    self.lineChart1.xLineDataArr = @[@"0",@"2",@"4",@"6",@"8",@"10",@"12",@"14",@"16",@"18",@"20",@"22",@"24"];
    
    self.lineChart1.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    
    self.lineChart1.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    self.lineChart1.valueArr = @[];
    self.lineChart1.showYLevelLine = YES;
    self.lineChart1.showYLine = YES;
    self.lineChart1.showValueLeadingLine = NO;
    self.lineChart1.valueFontSize = 0.0;
    self.lineChart1.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    self.lineChart1.xAndYNumberColor = [UIColor darkGrayColor];
    self.lineChart1.backgroundColor = [UIColor clearColor];
    [bg1 addSubview:self.lineChart1];
    NSString *yline1 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*0];
    NSString *yline2 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*1];
    NSString *yline3 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*2];
    NSString *yline4 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*3];
    NSString *yline5 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*4];
    NSString *yline6 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*5];
    self.lineChart1.yLineDataArr = @[yline2,yline3,yline4,yline5,yline6];
    /*       Start animation        */
    [self.lineChart1 showAnimation];
    
    JHLineChart *lineChart11 = [[JHLineChart alloc] initWithFrame:CGRectMake(0, KHeight/667*30, KWidth-14, KHeight/667*180) andLineChartType:JHChartLineValueNotForEveryX];
    lineChart11.isShowRight = NO;
    lineChart11.isShowLeft = YES;
    
    lineChart11.isKw = NO;
    
    lineChart11.xLineDataArr = @[@"0",@"2",@"4",@"6",@"8",@"10",@"12",@"14",@"16",@"18",@"20",@"22",@"24"];
    
    lineChart11.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    
    lineChart11.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    lineChart11.valueArr = @[];
    lineChart11.showYLevelLine = NO;
    lineChart11.showYLine = NO;
    lineChart11.showValueLeadingLine = NO;
    lineChart11.valueFontSize = 0.0;
    lineChart11.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    lineChart11.xAndYNumberColor = [UIColor darkGrayColor];
    lineChart11.backgroundColor = [UIColor clearColor];
    [bg1 addSubview:lineChart11];
    NSString *yline11 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*0];
    NSString *yline22 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*1];
    NSString *yline33 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*2];
    NSString *yline44 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*3];
    NSString *yline55 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*4];
    NSString *yline66 = [NSString stringWithFormat:@"%.2f",_maxNumber/5*5];
    lineChart11.yLineDataArr = @[yline22,yline33,yline44,yline55,yline66];
    /*       Start animation        */
    [lineChart11 showAnimation];
    
    
    self.zhuView = [[HistogramView alloc] initWithFrame:CGRectMake(0, KHeight/667*34, KWidth-14, KHeight/667*180)];
    self.zhuView.maxNumber = self.maxNumber;
    self.zhuView.backgroundColor = [UIColor clearColor];
    self.zhuView.arr = self.redArr;
    self.zhuView.arr1 = self.yellowArr;
    self.zhuView.arr2 = self.blueArr;
    self.zhuView.arr3 = self.greenArr;
    //    self.zhuView.arr4 = self.redArr;
    //    view.arr3 = @[@10,@10,@10,@10,@10,@10,@10,@10,@10,@10,@10];
    //    view.maxAll = self.maxAll;
    [bg1 addSubview:self.zhuView];
    self.page=0;
    [self addTimer];
}

- (void)leftBtnClick{
    if (self.clickView) {
        self.visualEffectView.hidden = NO;
        self.clickView.hidden = NO;
        self.popViewHidden = NO;
    }else{
        //实现模糊效果
        UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        //毛玻璃视图
        self.visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
        self.visualEffectView.frame = CGRectMake(0, 0, KWidth, KHeight);
        self.visualEffectView.alpha = 0.9;
        [self.view addSubview:self.visualEffectView];
        UIImageView *bgimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
        bgimage.image = [UIImage imageNamed:@"blackbg"];
        [self.visualEffectView addSubview:bgimage];
        
        self.clickView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 200, KWidth-40, 230)];
        self.clickView.image = [UIImage imageNamed:@"bgk"];
        self.clickView.userInteractionEnabled = YES;
        [self.visualEffectView.contentView addSubview:self.clickView];
        
        // 单击的 Recognizer
        UITapGestureRecognizer *singleRecognizer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self.clickView addGestureRecognizer:singleRecognizer];
        
        UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, KWidth-40, 22)];
        oneLabel.font = [UIFont systemFontOfSize:16];
        oneLabel.textAlignment = NSTextAlignmentCenter;
        NSArray *array = self.statusArr[2];
        float left = [array[0] floatValue];
        float right = [array[1] floatValue];
        oneLabel.text = [NSString stringWithFormat:@"今日发电量/收益: %.2f度/ %.2f元",left,right];
        oneLabel.textColor = RGBColor(138, 245, 255);
        [self.clickView addSubview:oneLabel];
        UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 57, KWidth-40, 22)];
        twoLabel.font = [UIFont systemFontOfSize:16];
        twoLabel.textAlignment = NSTextAlignmentCenter;
        NSArray *array1 = self.statusArr[5];
        float left1 = [array1[0] floatValue];
        float right1 = [array1[1] floatValue];
        twoLabel.text = [NSString stringWithFormat:@"上网电量/现金收入: %.2f度/ %.2f元",left1,right1];
        twoLabel.textColor = RGBColor(138, 245, 255);
        [self.clickView addSubview:twoLabel];
        UILabel *threeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 89, KWidth-40, 22)];
        threeLabel.font = [UIFont systemFontOfSize:16];
        threeLabel.textAlignment = NSTextAlignmentCenter;
        NSArray *array2 = self.statusArr[4];
        float left2 = [array2[0] floatValue];
        float right2 = [array2[1] floatValue];
        threeLabel.text = [NSString stringWithFormat:@"今日用电量/电费: %.2f度/ %.2f元",left2,right2];
        threeLabel.textColor = RGBColor(138, 245, 255);
        [self.clickView addSubview:threeLabel];
        UILabel *fourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 119, KWidth-40, 22)];
        fourLabel.font = [UIFont systemFontOfSize:16];
        fourLabel.textAlignment = NSTextAlignmentCenter;
        NSArray *array3 = self.statusArr[1];
        float left3 = [array3[0] floatValue];
        float right3 = [array3[1] floatValue];
        fourLabel.text = [NSString stringWithFormat:@"网电电量/现金支出: %.2f度/ %.2f元",left3,right3];
        fourLabel.textColor = RGBColor(138, 245, 255);
        [self.clickView addSubview:fourLabel];
        UILabel *fiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 149, KWidth-40, 22)];
        fiveLabel.font = [UIFont systemFontOfSize:16];
        fiveLabel.textAlignment = NSTextAlignmentCenter;
        NSArray *array4 = self.statusArr[3];
        float left4 = [array4[0] floatValue];
        float right4 = [array4[1] floatValue];
        fiveLabel.text = [NSString stringWithFormat:@"自发自用电量/价值: %.2f度/ %.2f元",left4,right4];
        fiveLabel.textColor = RGBColor(138, 245, 255);
        [self.clickView addSubview:fiveLabel];
        UILabel *sixLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 179, KWidth-40, 22)];
        sixLabel.font = [UIFont systemFontOfSize:16];
        sixLabel.textAlignment = NSTextAlignmentCenter;
        NSArray *array5 = self.statusArr[2];
        float left5 = [array5[1] floatValue];
        NSArray *array6 = self.statusArr[4];
        float right5 = [array6[1] floatValue];
        sixLabel.text = [NSString stringWithFormat:@"收入支出比/盈亏: %.2f-%.2f=%.2f元",left5,right5,left5-right5];
        sixLabel.textColor = RGBColor(138, 245, 255);
        
        [self.clickView addSubview:sixLabel];
    }
}

- (void)handleSingleTapFrom:(UISwipeGestureRecognizer*)recognizer {
    if(self.clickView){
        self.visualEffectView.hidden = YES;
        self.clickView.hidden = YES;
        self.popViewHidden = YES;
    }
}

- (void)addTimer
{
    // scheduledTimerWithTimeInterval:每隔多少秒执行nextImage方法
    // repeats:是否重复
    self.timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    
    // 这个方法的作用是什么呢？
    // 假设在self.view中还有一个UITextView控件，UITextView控件可以拖拽显示多行文本内容，
    // 如果没有下面这句代码，在拖拽UITextView的时候，UIScrollView将不会有任何变化
    // 也就是默认情况下只能执行一个操作，有了下面这句代码，在拖拽UITextView的时候，不会影响到UIScrollView的自动轮播
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
    [self.timer1 invalidate];
    self.timer1 = nil;
}

- (void)nextImage
{
    if (self.page==0) {
        // 2.计算scrollView滚动的位置
        CGFloat offsetX = self.chartView.frame.size.width;
        CGPoint offset = CGPointMake(offsetX, 0);
        [self.chartView setContentOffset:offset animated:YES];
        self.page= 2;
    } else {
        // 2.计算scrollView滚动的位置
        //        CGFloat offsetX = self.chartView.frame.size.width;
        CGPoint offset = CGPointMake(0, 0);
        [self.chartView setContentOffset:offset animated:YES];
        self.page = 0;
    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView==self.chartView) {
        // 停止定时器(一旦定时器停止了,就不能再使用)，为什么要停止？
        // 如果不停止，我们在手动拖拽图片的时候，计时器一直在计时，当我们松手时，会一次轮播多张图片
        [self removeTimer];
    }
    
}

/**
 *  停止拖拽的时候调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView==self.chartView) {
        // 开启定时器
        [self addTimer];
    }
    
}

/**
 *  当scrollView正在滚动就会调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==self.chartView) {
        // 根据scrollView的滚动位置决定pageControl显示第几页
        CGFloat scrollW = scrollView.frame.size.width;
        int page = (scrollView.contentOffset.x + scrollW * 0.5) / scrollW;
        self.page = page;
    }
    
}
-(void)setSecondChart{
    
    
    self.xiaorenImage = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-90, KHeight/667*488,KWidth/375*80, KHeight/667*117)];
    self.xiaorenImage.image = [UIImage imageNamed:@"小人张嘴1"];
    [self.bgScrollerView addSubview:self.xiaorenImage];
    
    self.labaImage = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-110, KHeight/667*530, KWidth/375*35, KHeight/667*35)];
    self.labaImage.image = [UIImage imageNamed:@"laba"];
    [self.bgScrollerView addSubview:self.labaImage];
    
    
    UIButton *xiaorenBtn = [[UIButton alloc] initWithFrame:CGRectMake(KWidth-120, KHeight/667*488, KWidth/375*100, KHeight/667*117)];
    [xiaorenBtn addTarget:self action:@selector(StartPlayVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollerView addSubview:xiaorenBtn];
    
    UIImageView *wenziImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth/375*17, KHeight/667*488, KWidth/375*247, KHeight/667*117)];
    wenziImg.image = [UIImage imageNamed:@"圆角矩形-9"];
    wenziImg.userInteractionEnabled = YES;
    [self.bgScrollerView addSubview:wenziImg];
    
    self.content = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, KWidth/375*247-15, KHeight/667*117)];
    
    NSString *yuyin = [NSString stringWithFormat:@"%@\r\r%@",self.yuyinText,self.yuyinString];
    self.content.font = [UIFont systemFontOfSize:14];
    self.content.text = [NSString stringWithFormat:@"%@",yuyin];
    
    //        if (self.yuyinText.length>0) {
    //            self.content.text = [NSString stringWithFormat:@"%@\r\r%@",self.yuyinText,self.yuyinString];
    //        }else{
    //            self.content.text = @"";
    //        }
    
    //    }
    
    //    self.content.contentSize = CGSizeMake(KWidth-130, KHeight/664*117/4*array.count);
    self.content.textColor = [UIColor whiteColor];
    self.content.backgroundColor = [UIColor clearColor];
    self.content.editable = NO;
    [wenziImg addSubview:self.content];
}

- (void)setFirstTable{
    self.bgimage1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, KHeight, KWidth, KHeight)];
    self.bgimage1.image = [UIImage imageNamed:@"蓝色背景"];
    self.bgimage1.userInteractionEnabled = YES;
    [self.bgScrollerView addSubview:self.bgimage1];
    
    UILabel *fadianLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/375*15, KHeight/667*42, KWidth/375*150, KHeight/667*40)];
    fadianLabel.text = @"发电详情";
    fadianLabel.textColor = [UIColor whiteColor];
    fadianLabel.font = [UIFont systemFontOfSize:18];
    [self.bgimage1 addSubview:fadianLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(KWidth/375*15,KHeight/667*77, KWidth-30, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgimage1 addSubview:lineView];
    
    for (int i=0; i<3; i++) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake((KWidth-50)/3*i+10*i+15, KHeight/667*87, (KWidth-50)/3,KHeight/667*52)];
        view.userInteractionEnabled = YES;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, (KWidth-50)/3, 20)];
        UILabel *textLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(-5, KHeight/667*30, (KWidth-50)/3, KHeight/667*20)];
        textLabel.textAlignment  = NSTextAlignmentLeft;
        textLabel1.textAlignment  = NSTextAlignmentRight;
        textLabel.textColor = [UIColor whiteColor];
        textLabel1.textColor = RGBColor(12, 68, 132);
        if(i==0){
            view.image = [UIImage imageNamed:@"绿"];
            textLabel.text = @" 装机容量";
            if(self.zhuangjirongliang.length>0){
                textLabel1.text = [NSString stringWithFormat:@"%@kW ",self.zhuangjirongliang];
            }else{
                textLabel1.text = @"";
                
            }
        }else if(i==1){
            view.image = [UIImage imageNamed:@"蓝"];
            textLabel.text = @" 并网时间";
            textLabel1.text = self.bingwangshijian;
        }else if(i==2){
            view.image = [UIImage imageNamed:@"黄"];
            self.textLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(-5, KHeight/667*30, (KWidth-50)/3, KHeight/667*20)];
            self.textLabel1.textAlignment  = NSTextAlignmentRight;
            self.textLabel1.textColor = RGBColor(12, 68, 132);
            textLabel.text = @" 并网方式";
            self.textLabel1.text = self.fastring;
            self.textLabel1.font = [UIFont systemFontOfSize:16];
            [view addSubview:self.textLabel1];
            UIButton *bingwangBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (KWidth-50)/3, KHeight/667*52)];
            [bingwangBtn addTarget:self action:@selector(bingwangBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:bingwangBtn];
        }
        textLabel.font = [UIFont systemFontOfSize:13];
        textLabel1.font = [UIFont systemFontOfSize:16];
        [self.bgimage1 addSubview:view];
        [view addSubview:textLabel];
        [view addSubview:textLabel1];
        
    }
    
    self.tableScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KHeight/667*165, KWidth, KHeight/667*342)];
    self.tableScroll.delegate = self;
    self.tableScroll.pagingEnabled = YES;
    self.tableScroll.contentSize = CGSizeMake(KWidth*3, KHeight/667*332);
    self.tableScroll.backgroundColor = [UIColor clearColor];
    [self.bgimage1 addSubview:self.tableScroll];
    
    for (int i = 0; i<3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(KWidth*i, 0, KWidth, KHeight/667*30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        if (i==0) {
            label.text = @"当 月 发 电 量 及 收 益";
        }else if(i==1){
            label.text = @"当 年 发 电 量 及 收 益";
        }else{
            label.text = @"累 计 发 电 量 及 收 益";
        }
        [self.tableScroll addSubview:label];
    }
    UIScrollView *oneTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KHeight/667*30, k_MainBoundsWidth, KHeight/667*311)];
    oneTable.bounces = NO;
    [self.tableScroll addSubview:oneTable];
    
    
    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-90, KHeight+45,KWidth/375*75, KHeight/667*27)];
    rightImg.image = [UIImage imageNamed:@"fadianzhengce"];
    rightImg.userInteractionEnabled = YES;
    [self.bgScrollerView addSubview:rightImg];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KWidth/375*75, KHeight/667*27)];
    label.text = @"发电政策";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [rightImg addSubview:label];
    
    UIButton *fadianzhengce = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KWidth/375*70, KHeight/667*20)];
    [fadianzhengce addTarget:self action:@selector(fadianzhengce) forControlEvents:UIControlEventTouchUpInside];
    [rightImg addSubview:fadianzhengce];
    self.table1 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/667*71)];
    self.table1.typeCount = 0;
    self.table1.isblue = YES;
    self.table1.isRed = NO;
    self.table1.backgroundColor = [UIColor clearColor];
    self.table1.tableTitleFont = [UIFont systemFontOfSize:14];
    if([self.fastring isEqualToString:@"余电上网"]){
        self.table1.colTitleArr = @[@"类别|时间",@"发电量(度)",@"发电收益(元)",@"其中|现金收入",@"(元)|节省电费"];
    }else{
        self.table1.colTitleArr = @[@"类别|时间",@"发电量(度)",@"发电收益(元)",@"其中|现金收入",@"(元)|国家欠款"];
    }
    
    NSMutableArray *colWid = [[NSMutableArray alloc] init];
    NSString *wid1 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
    NSString *wid2 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5+10];
    NSString *wid3 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5+20];
    NSString *wid4 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
    NSString *wid5 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
    [colWid addObject:wid1];
    [colWid addObject:wid2];
    [colWid addObject:wid3];
    [colWid addObject:wid4];
    [colWid addObject:wid5];
    self.table1.colWidthArr = colWid;
    self.table1.bodyTextColor = [UIColor whiteColor];
    self.table1.minHeightItems = KHeight/667*25;
    self.table1.tableChartTitleItemsHeight = KHeight/667*46;
    self.table1.lineColor = [UIColor whiteColor];
    //    self.table1.backgroundColor = RGBColor(76, 75, 102);
    if([self.fastring isEqualToString:@"余电上网"]){
        self.table1.dataArr = self.TbaleTipArr1;
    }else{
        self.table1.dataArr = self.RedTbaleTipArr1;
    }
    
    oneTable.contentSize = CGSizeMake(KWidth, KHeight/667*35);
    [self.table1 showAnimation];
    [oneTable addSubview:self.table1];
    self.table1.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.table1 heightFromThisDataSource]);
    UIScrollView *oneTable1 = [[UIScrollView alloc] init];
    if (self.dayGenArr.count>0) {
        
        if (self.dayGenArr.count>11) {
            oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, KHeight/667*(312-71));
        }else{
            oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, KHeight/667*20*self.dayGenArr.count);
        }
        oneTable1.bounces = NO;
        [oneTable addSubview:oneTable1];
        self.table11 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/667*(312-71))];
        self.table11.typeCount = 11;
        self.table11.isblue = NO;
        self.table11.isRed = NO;
        self.table11.tableTitleFont = [UIFont systemFontOfSize:14];
        self.table11.minHeightItems = KHeight/667*20;
        self.table11.tableChartTitleItemsHeight = KHeight/667*20;
        self.table11.colTitleArr = self.dayGenArr[0];
        NSMutableArray *colWid = [[NSMutableArray alloc] init];
        NSString *wid1 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
        NSString *wid2 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5+10];
        NSString *wid3 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5+20];
        NSString *wid4 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
        NSString *wid5 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
        [colWid addObject:wid1];
        [colWid addObject:wid2];
        [colWid addObject:wid3];
        [colWid addObject:wid4];
        [colWid addObject:wid5];
        self.table11.colWidthArr = colWid;
        self.table11.bodyTextColor = [UIColor whiteColor];
        //        self.table11.minHeightItems = 35;
        self.table11.lineColor = [UIColor whiteColor];
        self.table11.backgroundColor = [UIColor clearColor];
        NSMutableArray *day11 = [[NSMutableArray alloc] initWithCapacity:0];
        if([self.fastring isEqualToString:@"余电上网"]){
            for (int i=0; i<self.dayGenArr.count; i++) {
                if (i>0) {
                    [day11 addObject:self.dayGenArr[i]];
                }
                
            }
            self.table11.dataArr = day11;
            
        }else{
            for (int i=0; i<self.ReddayGenArr.count; i++) {
                if (i>0) {
                    [day11 addObject:self.ReddayGenArr[i]];
                }
                
            }
            self.table11.dataArr = day11;
        }
        oneTable1.contentSize = CGSizeMake(KWidth, KHeight/667*20*(self.table11.dataArr.count+1)+KHeight/667*1);
        [self.table11 showAnimation];
        [oneTable1 addSubview:self.table11];
        self.table11.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.table11 heightFromThisDataSource]);
    }
    //红色
    self.Redtable1 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/667*71)];
    self.Redtable1.typeCount = 0;
    self.Redtable1.isblue = YES;
    self.Redtable1.isRed = YES;
    self.Redtable1.backgroundColor = [UIColor clearColor];
    self.Redtable1.tableTitleFont = [UIFont systemFontOfSize:14];
    if([self.fastring isEqualToString:@"余电上网"]){
        
        self.Redtable1.colTitleArr = @[@"类别|时间",@"发电量(度)",@"发电收益(元)",@"其中|现金收入",@"(元)|国家欠款"];
    }else{
        self.Redtable1.colTitleArr = @[@"类别|时间",@"发电量(度)",@"发电收益(元)",@"其中|现金收入",@"(元)|节省电费"];
    }
    
    self.Redtable1.colWidthArr = colWid;
    self.Redtable1.bodyTextColor = [UIColor whiteColor];
    self.Redtable1.minHeightItems = KHeight/667*25;
    self.Redtable1.tableChartTitleItemsHeight = KHeight/667*46;
    self.Redtable1.lineColor = [UIColor whiteColor];
    //    self.table1.backgroundColor = RGBColor(76, 75, 102);
    if([self.fastring isEqualToString:@"余电上网"]){
        self.Redtable1.dataArr = self.RedTbaleTipArr1;
    }else{
        self.Redtable1.dataArr = self.TbaleTipArr1;
    }
    
    oneTable.contentSize = CGSizeMake(KWidth, KHeight/667*35);
    [self.Redtable1 showAnimation];
    [oneTable addSubview:self.Redtable1];
    self.Redtable1.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.Redtable1 heightFromThisDataSource]);
    
    if (self.ReddayGenArr.count>0) {
        //        UIScrollView *oneTable1 = [[UIScrollView alloc] init];
        self.Redtable11 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/667*(310-71))];
        self.Redtable11.typeCount = 11;
        self.Redtable11.isblue = NO;
        self.Redtable11.isRed = YES;
        self.Redtable11.tableTitleFont = [UIFont systemFontOfSize:14];
        self.Redtable11.minHeightItems = KHeight/667*20;
        self.Redtable11.tableChartTitleItemsHeight = KHeight/667*20;
        self.Redtable11.colTitleArr = self.ReddayGenArr[0];
        self.Redtable11.colWidthArr = colWid;
        self.Redtable11.bodyTextColor = [UIColor whiteColor];
        //        self.table11.minHeightItems = 35;
        self.Redtable11.lineColor = [UIColor whiteColor];
        self.Redtable11.backgroundColor = [UIColor clearColor];
        NSMutableArray *day11 = [[NSMutableArray alloc] initWithCapacity:0];
        if([self.fastring isEqualToString:@"余电上网"]){
            for (int i=0; i<self.ReddayGenArr.count; i++) {
                if (i>0) {
                    [day11 addObject:self.ReddayGenArr[i]];
                }
                
            }
            
        }else{
            for (int i=0; i<self.dayGenArr.count; i++) {
                if (i>0) {
                    [day11 addObject:self.dayGenArr[i]];
                }
                
            }
            
        }
        self.Redtable11.dataArr = day11;
        [self.Redtable11 showAnimation];
        [oneTable1 addSubview:self.Redtable11];
        self.Redtable11.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.Redtable11 heightFromThisDataSource]);
        self.Redtable1.hidden = YES;
        self.Redtable11.hidden = YES;
    }
    
    
    
}
- (void)bingwangBtnClick{
    NSLog(@"并网按钮点击");
    if (self.faDianBtnClick) {
        self.faDianBtnClick = NO;
    }else{
        self.faDianBtnClick = YES;
    }
    if ([self.textLabel1.text isEqualToString:@"余电上网"]) {
        self.textLabel1.text = @"全额上网";
    }else{
        self.textLabel1.text = @"余电上网";
    }
    if (self.Redtable11.hidden == YES) {
        self.Redtable1.hidden = NO;
        self.Redtable11.hidden = NO;
        self.table1.hidden = YES;
        self.table11.hidden = YES;
        self.Redtable2.hidden = NO;
        self.Redtable22.hidden = NO;
        self.table2.hidden = YES;
        self.table22.hidden = YES;
        self.Redtable3.hidden = NO;
        self.Redtable33.hidden = NO;
        self.table3.hidden = YES;
        self.table33.hidden = YES;
    }else{
        self.Redtable1.hidden = YES;
        self.Redtable11.hidden = YES;
        self.table1.hidden = NO;
        self.table11.hidden = NO;
        self.Redtable2.hidden = YES;
        self.Redtable22.hidden = YES;
        self.table2.hidden = NO;
        self.table22.hidden = NO;
        self.Redtable3.hidden = YES;
        self.Redtable33.hidden = YES;
        self.table3.hidden = NO;
        self.table33.hidden = NO;
    }
    if (self.faDianBtnClick) {
        [self performSelector:@selector(changged) withObject:nil/*可传任意类型参数*/ afterDelay:15.0];
    }
    
}

- (void)changged{
    if (self.faDianBtnClick) {
        if (self.faDianBtnClick) {
            self.faDianBtnClick = NO;
        }else{
            self.faDianBtnClick = YES;
        }
        
        if ([self.textLabel1.text isEqualToString:@"余电上网"]) {
            self.textLabel1.text = @"全额上网";
        }else{
            self.textLabel1.text = @"余电上网";
        }
        if (self.Redtable11.hidden == YES) {
            self.Redtable1.hidden = NO;
            self.Redtable11.hidden = NO;
            self.table1.hidden = YES;
            self.table11.hidden = YES;
            self.Redtable2.hidden = NO;
            self.Redtable22.hidden = NO;
            self.table2.hidden = YES;
            self.table22.hidden = YES;
            self.Redtable3.hidden = NO;
            self.Redtable33.hidden = NO;
            self.table3.hidden = YES;
            self.table33.hidden = YES;
        }else{
            self.Redtable1.hidden = YES;
            self.Redtable11.hidden = YES;
            self.table1.hidden = NO;
            self.table11.hidden = NO;
            self.Redtable2.hidden = YES;
            self.Redtable22.hidden = YES;
            self.table2.hidden = NO;
            self.table22.hidden = NO;
            self.Redtable3.hidden = YES;
            self.Redtable33.hidden = YES;
            self.table3.hidden = NO;
            self.table33.hidden = NO;
        }
        
    }
    
}
- (void)setSecondTable{
    
    UIScrollView *twoTable = [[UIScrollView alloc] initWithFrame:CGRectMake(KWidth, KHeight/664*30, k_MainBoundsWidth, KHeight/664*311)];
    twoTable.bounces = NO;
    [self.tableScroll addSubview:twoTable];
    
    
    self.table2 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/664*71)];
    self.table2.typeCount = 1;
    self.table2.isblue = YES;
    if([self.fastring isEqualToString:@"余电上网"]){
        self.table2.colTitleArr = @[@"类别|时间",@"发电量(度)",@"发电收益(元)",@"其中|现金收入",@"(元)|节省电费"];
    }else{
        self.table2.colTitleArr = @[@"类别|时间",@"发电量(度)",@"发电收益(元)",@"其中|现金收入",@"(元)|国家欠款"];
    }
    
    /*        The width of the column array, starting with the first column         */
    NSMutableArray *colWid = [[NSMutableArray alloc] init];
    NSString *wid1 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
    NSString *wid2 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5+10];
    NSString *wid3 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5+20];
    NSString *wid4 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
    NSString *wid5 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
    [colWid addObject:wid1];
    [colWid addObject:wid2];
    [colWid addObject:wid3];
    [colWid addObject:wid4];
    [colWid addObject:wid5];
    self.table2.colWidthArr = colWid;
    
    //    table.colWidthArr = @[@80.0,@30.0,@70,@50,@50,@50,@50,@50,@50,@50];
    //    table.beginSpace = 30;
    /*        Text color of the table body         */
    self.table2.bodyTextColor = [UIColor whiteColor];
    /*        Minimum grid height         */
    self.table2.tableChartTitleItemsHeight = KHeight/667*46;
    self.table2.minHeightItems = KHeight/667*25;
    /*        Table line color         */
    self.table2.lineColor = [UIColor whiteColor];
    self.table2.backgroundColor = [UIColor clearColor];
    //    self.table2.backgroundColor = RGBColor(76, 75, 102);
    /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
    if([self.fastring isEqualToString:@"余电上网"]){
        self.table2.dataArr = self.TbaleTipArr2;
    }else{
        self.table2.dataArr = self.RedTbaleTipArr2;
    }
    
    twoTable.contentSize = CGSizeMake(KWidth, KHeight/664*35);
    /*        show                            */
    [self.table2 showAnimation];
    [twoTable addSubview:self.table2];
    /*        Automatic calculation table height        */
    self.table2.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.table2 heightFromThisDataSource]);
    UIScrollView *oneTable1 = [[UIScrollView alloc] init];
    if (self.MonthGenArr.count>0) {
        
        if (self.MonthGenArr.count>11) {
            oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, KHeight/667*(311-71));
        }else{
            oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, KHeight/667*20*self.MonthGenArr.count);
        }
        
        oneTable1.bounces = NO;
        [twoTable addSubview:oneTable1];
        self.table22 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/667*(310-71))];
        self.table22.typeCount = 11;
        self.table22.isblue = NO;
        self.table22.tableTitleFont = [UIFont systemFontOfSize:14];
        self.table22.colTitleArr = self.MonthGenArr[0];
        self.table22.colWidthArr = colWid;
        self.table22.bodyTextColor = [UIColor whiteColor];
        self.table22.minHeightItems = 20;
        self.table22.lineColor = [UIColor whiteColor];
        //        self.table22.backgroundColor = RGBColor(76, 75, 102);
        self.table22.backgroundColor = [UIColor clearColor];
        NSMutableArray *day11 = [[NSMutableArray alloc] initWithCapacity:0];
        if([self.fastring isEqualToString:@"余电上网"]){
            for (int i=0; i<self.MonthGenArr.count; i++) {
                if (i>0) {
                    [day11 addObject:self.MonthGenArr[i]];
                }
                
                
            }
            
        }else{
            for (int i=0; i<self.RedMonthGenArr.count; i++) {
                if (i>0) {
                    [day11 addObject:self.RedMonthGenArr[i]];
                }
                
                
            }
        }
        self.table22.dataArr = day11;
        oneTable1.contentSize = CGSizeMake(KWidth, KHeight/667*20*(self.table22.dataArr.count+1));
        [self.table22 showAnimation];
        [oneTable1 addSubview:self.table22];
        self.table22.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.table22 heightFromThisDataSource]);
    }
    //红色
    self.Redtable2 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/667*71)];
    self.Redtable2.typeCount = 1;
    self.Redtable2.isblue = YES;
    self.Redtable2.isRed = YES;
    if([self.fastring isEqualToString:@"余电上网"]){
        
        self.Redtable2.colTitleArr = @[@"类别|时间",@"发电量(度)",@"发电收益(元)",@"其中|现金收入",@"(元)|国家欠款"];
    }else{
        self.Redtable2.colTitleArr = @[@"类别|时间",@"发电量(度)",@"发电收益(元)",@"其中|现金收入",@"(元)|节省电费"];
    }
    
    /*        The width of the column array, starting with the first column         */
    self.Redtable2.colWidthArr = colWid;
    //    table.colWidthArr = @[@80.0,@30.0,@70,@50,@50,@50,@50,@50,@50,@50];
    //    table.beginSpace = 30;
    /*        Text color of the table body         */
    self.Redtable2.bodyTextColor = [UIColor whiteColor];
    /*        Minimum grid height         */
    self.Redtable2.tableChartTitleItemsHeight = KHeight/667*46;
    self.Redtable2.minHeightItems = KHeight/667*25;
    /*        Table line color         */
    self.Redtable2.lineColor = [UIColor whiteColor];
    self.Redtable2.backgroundColor = [UIColor clearColor];
    if([self.fastring isEqualToString:@"余电上网"]){
        self.Redtable2.dataArr = self.RedTbaleTipArr2;
    }else{
        self.Redtable2.dataArr = self.TbaleTipArr2;
    }
    
    /*        show                            */
    [self.Redtable2 showAnimation];
    [twoTable addSubview:self.Redtable2];
    /*        Automatic calculation table height        */
    self.Redtable2.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.Redtable2 heightFromThisDataSource]);
    
    if (self.RedMonthGenArr.count>1) {
        
        if (self.RedMonthGenArr.count>11) {
            oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, KHeight/667*(310-71));
        }else{
            oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth,KHeight/667*20*self.RedMonthGenArr.count);
        }
        
        oneTable1.bounces = NO;
        [twoTable addSubview:oneTable1];
        self.Redtable22 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/667*(310-71))];
        self.Redtable22.typeCount = 11;
        self.Redtable22.isblue = NO;
        self.Redtable22.isRed = YES;
        self.Redtable22.tableTitleFont = [UIFont systemFontOfSize:14];
        self.Redtable22.colTitleArr = self.RedMonthGenArr[0];
        self.Redtable22.colWidthArr = colWid;
        self.Redtable22.bodyTextColor = [UIColor whiteColor];
        self.Redtable22.minHeightItems = KHeight/667*20;
        self.Redtable22.lineColor = [UIColor whiteColor];
        //        self.table22.backgroundColor = RGBColor(76, 75, 102);
        self.Redtable22.backgroundColor = [UIColor clearColor];
        NSMutableArray *day11 = [[NSMutableArray alloc] initWithCapacity:0];
        if([self.fastring isEqualToString:@"余电上网"]){
            for (int i=0; i<self.RedMonthGenArr.count; i++) {
                if (i>0) {
                    [day11 addObject:self.RedMonthGenArr[i]];
                }
            }
            
        }else{
            for (int i=0; i<self.MonthGenArr.count; i++) {
                if (i>0) {
                    [day11 addObject:self.MonthGenArr[i]];
                }
            }
        }
        self.Redtable22.dataArr = day11;
        oneTable1.contentSize = CGSizeMake(KWidth, KHeight/667*20*(self.Redtable22.dataArr.count+1));
        [self.Redtable22 showAnimation];
        [oneTable1 addSubview:self.Redtable22];
        self.Redtable22.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.Redtable22 heightFromThisDataSource]);
        self.Redtable2.hidden=YES;
        self.Redtable22.hidden=YES;
    }
    
}

- (void)setThirdTable{
    //    int height33 = (self.YearGenArr.count+1)*210/6;
    //    if (height33>210) {
    //        self.hight3 = 250;
    //    }else{
    //        self.hight3 = height33+40;
    //    }
    UIScrollView *threeTable = [[UIScrollView alloc] initWithFrame:CGRectMake(KWidth*2, KHeight/664*30, k_MainBoundsWidth, KHeight/664*310)];
    threeTable.bounces = NO;
    [self.tableScroll addSubview:threeTable];
    
    
    
    self.table3 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/664*310)];
    self.table3.typeCount = 0;
    self.table3.isblue = YES;
    self.table3.isRed = NO;
    if([self.fastring isEqualToString:@"余电上网"]){
        self.table3.colTitleArr = @[@"类别|时间",@"发电量(度)",@"发电收益(元)",@"其中|现金收入",@"(元)|节省电费"];
    }else{
        self.table3.colTitleArr = @[@"类别|时间",@"发电量(度)",@"发电收益(元)",@"其中|现金收入",@"(元)|国家欠款"];
    }
    
    
    /*        The width of the column array, starting with the first column         */
    NSMutableArray *colWid = [[NSMutableArray alloc] init];
    NSString *wid1 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
    NSString *wid2 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5+10];
    NSString *wid3 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5+20];
    NSString *wid4 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
    NSString *wid5 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
    [colWid addObject:wid1];
    [colWid addObject:wid2];
    [colWid addObject:wid3];
    [colWid addObject:wid4];
    [colWid addObject:wid5];
    self.table3.colWidthArr = colWid;
    
    //    table.colWidthArr = @[@80.0,@30.0,@70,@50,@50,@50,@50,@50,@50,@50];
    //    table.beginSpace = 30;
    /*        Text color of the table body         */
    self.table3.bodyTextColor = [UIColor whiteColor];
    /*        Minimum grid height         */
    self.table3.tableChartTitleItemsHeight = KHeight/667*46;
    self.table3.minHeightItems = KHeight/667*25;
    /*        Table line color         */
    self.table3.lineColor = [UIColor whiteColor];
    self.table3.backgroundColor = [UIColor clearColor];
    //    self.table3.backgroundColor = RGBColor(76, 75, 102);
    /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
    if([self.fastring isEqualToString:@"余电上网"]){
        self.table3.dataArr = self.TbaleTipArr3;
    }else{
        self.table3.dataArr = self.RedTbaleTipArr3;
    }
    
    
    threeTable.contentSize = CGSizeMake(KWidth, 35);
    /*        show                            */
    [self.table3 showAnimation];
    [threeTable addSubview:self.table3];
    /*        Automatic calculation table height        */
    self.table3.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.table3 heightFromThisDataSource]);
    UIScrollView *oneTable1 = [[UIScrollView alloc] init];
    
    if (self.YearGenArr.count>11) {
        oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, KHeight/664*(310-71));
    }else{
        oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, 20*self.YearGenArr.count);
    }
    oneTable1.bounces = NO;
    [self.table3 addSubview:oneTable1];
    self.table33 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/664*(310-71))];
    self.table33.typeCount = 11;
    self.table33.isblue = NO;
    self.table33.isRed = NO;
    self.table33.tableTitleFont = [UIFont systemFontOfSize:14];
    if (self.YearGenArr.count>0) {
        self.table33.colTitleArr = self.YearGenArr[0];
    }
    
    self.table33.colWidthArr = colWid;
    self.table33.bodyTextColor = [UIColor whiteColor];
    self.table33.minHeightItems = 20;
    self.table33.lineColor = [UIColor whiteColor];
    self.table33.backgroundColor = [UIColor clearColor];
    //        self.table33.backgroundColor = RGBColor(76, 75, 102);
    NSMutableArray *day11 = [[NSMutableArray alloc] initWithCapacity:0];
    if([self.fastring isEqualToString:@"余电上网"]){
        for (int i=0; i<self.YearGenArr.count; i++) {
            if (i>0) {
                [day11 addObject:self.YearGenArr[i]];
            }
        }
        
    }else{
        for (int i=0; i<self.RedYearGenArr.count; i++) {
            if (i>0) {
                [day11 addObject:self.RedYearGenArr[i]];
            }
        }
    }
    self.table33.dataArr = day11;
    oneTable1.contentSize = CGSizeMake(KWidth, KHeight/667*20*(self.table33.dataArr.count+1));
    [self.table33 showAnimation];
    [oneTable1 addSubview:self.table33];
    self.table33.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.table33 heightFromThisDataSource]);
    //红色
    self.Redtable3 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/664*71)];
    self.Redtable3.typeCount = 0;
    self.Redtable3.isblue = YES;
    self.Redtable3.isRed = YES;
    if([self.fastring isEqualToString:@"余电上网"]){
        
        self.Redtable3.colTitleArr = @[@"类别|时间",@"发电量(度)",@"发电收益(元)",@"其中|现金收入",@"(元)|国家欠款"];
    }else{
        self.Redtable3.colTitleArr = @[@"类别|时间",@"发电量(度)",@"发电收益(元)",@"其中|现金收入",@"(元)|节省电费"];
    }
    
    
    /*        The width of the column array, starting with the first column         */
    self.Redtable3.colWidthArr = colWid;
    //    table.colWidthArr = @[@80.0,@30.0,@70,@50,@50,@50,@50,@50,@50,@50];
    //    table.beginSpace = 30;
    /*        Text color of the table body         */
    self.Redtable3.bodyTextColor = [UIColor whiteColor];
    /*        Minimum grid height         */
    self.Redtable3.tableChartTitleItemsHeight = KHeight/667*46;
    self.Redtable3.minHeightItems = KHeight/667*25;
    /*        Table line color         */
    self.Redtable3.lineColor = [UIColor whiteColor];
    self.Redtable3.backgroundColor = [UIColor clearColor];
    //    self.table3.backgroundColor = RGBColor(76, 75, 102);
    /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
    if([self.fastring isEqualToString:@"余电上网"]){
        self.Redtable3.dataArr = self.RedTbaleTipArr3;
    }else{
        self.Redtable3.dataArr = self.TbaleTipArr3;
    }
    
    
    threeTable.contentSize = CGSizeMake(KWidth, 35);
    /*        show                            */
    [self.Redtable3 showAnimation];
    [threeTable addSubview:self.Redtable3];
    /*        Automatic calculation table height        */
    self.Redtable3.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.Redtable3 heightFromThisDataSource]);
    if (self.RedYearGenArr.count>11) {
        oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, KHeight/667*(310-71));
    }else{
        oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, 20*self.RedYearGenArr.count);
    }
    oneTable1.bounces = NO;
    [threeTable addSubview:oneTable1];
    self.Redtable33 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/667*(310-71))];
    self.Redtable33.typeCount = 11;
    self.Redtable33.isblue = NO;
    self.Redtable33.isRed = YES;
    self.Redtable33.tableTitleFont = [UIFont systemFontOfSize:14];
    if (self.RedYearGenArr.count>0) {
        self.Redtable33.colTitleArr = self.RedYearGenArr[0];
    }
    
    self.Redtable33.colWidthArr = colWid;
    self.Redtable33.bodyTextColor = [UIColor whiteColor];
    self.Redtable33.minHeightItems = 20;
    self.Redtable33.lineColor = [UIColor whiteColor];
    self.Redtable33.backgroundColor = [UIColor clearColor];
    //        self.table33.backgroundColor = RGBColor(76, 75, 102);
    NSMutableArray *day111 = [[NSMutableArray alloc] initWithCapacity:0];
    if([self.fastring isEqualToString:@"余电上网"]){
        for (int i=0; i<self.RedYearGenArr.count; i++) {
            if (i>0) {
                [day111 addObject:self.RedYearGenArr[i]];
            }
            
        }
        
    }else{
        for (int i=0; i<self.YearGenArr.count; i++) {
            if (i>0) {
                [day111 addObject:self.YearGenArr[i]];
            }
            
        }
    }
    self.Redtable33.dataArr = day111;
    oneTable1.contentSize = CGSizeMake(KWidth, KHeight/667*20*(self.Redtable33.dataArr.count+1));
    [self.Redtable33 showAnimation];
    [oneTable1 addSubview:self.Redtable33];
    self.Redtable33.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.Redtable33 heightFromThisDataSource]);
    self.Redtable3.hidden=YES;
    self.Redtable33.hidden=YES;
    
    
}

- (void)setFourTable{
    self.bgimage2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, KHeight*2, KWidth, KHeight)];
    self.bgimage2.image = [UIImage imageNamed:@"蓝色背景"];
    self.bgimage2.userInteractionEnabled = YES;
    //    self.bgimage2.backgroundColor = [UIColor clearColor];
    [self.bgScrollerView addSubview:self.bgimage2];
    UILabel *fadianLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/375*15, KHeight/664*42, 150, KHeight/664*40)];
    fadianLabel.text = @"用电详情";
    fadianLabel.textColor = [UIColor whiteColor];
    fadianLabel.font = [UIFont systemFontOfSize:18];
    [self.bgimage2 addSubview:fadianLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(KWidth/375*15, KHeight/664*77, KWidth-30, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgimage2 addSubview:lineView];
    
    for (int i=0; i<3; i++) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake((KWidth-50)/3*i+10*i+15,KHeight/664*87, (KWidth-50)/3, KHeight/664*52)];
        view.userInteractionEnabled = YES;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, KHeight/664*7, (KWidth-50)/3, KHeight/664*20)];
        UILabel *textLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(-5, KHeight/664*30, (KWidth-50)/3, KHeight/664*20)];
        textLabel.textAlignment  = NSTextAlignmentLeft;
        textLabel1.textAlignment  = NSTextAlignmentRight;
        textLabel.textColor = [UIColor whiteColor];
        textLabel1.textColor = RGBColor(12, 68, 132);
        if(i==0){
            view.image = [UIImage imageNamed:@"绿"];
            textLabel.text = @" 额定电流";
            if (self.edingdianliu.length>0) {
                textLabel1.text = [NSString stringWithFormat:@"%@A ",self.edingdianliu];
            }else{
                textLabel1.text = @"";
            }
            
        }else if(i==1){
            view.image = [UIImage imageNamed:@"蓝"];
            textLabel.text = @" 安装时间";
            textLabel1.text = self.anzhuangshijian;
        }else if(i==2){
            view.image = [UIImage imageNamed:@"黄"];
            self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(-5, KHeight/664*30, (KWidth-50)/3, KHeight/664*20)];
            self.textLabel.textAlignment  = NSTextAlignmentRight;
            self.textLabel.textColor = RGBColor(12, 68, 132);
            self.textLabel.text = self.useString;
            self.textLabel.font = [UIFont systemFontOfSize:16];
            [view addSubview:self.textLabel];
            
            textLabel.text = @" 电价类别";
            //            textLabel1.text = self.useString;
            UIButton *dianjiaBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (KWidth-50)/3, KHeight/664*52)];
            [dianjiaBtn addTarget:self action:@selector(dianjiaBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:dianjiaBtn];
        }
        textLabel.font = [UIFont systemFontOfSize:13];
        textLabel1.font = [UIFont systemFontOfSize:16];
        
        [view addSubview:textLabel];
        [view addSubview:textLabel1];
        [self.bgimage2 addSubview:view];
    }
    
    
    
    
    self.tableScroll1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KHeight/664*165, KWidth, KHeight/664*342)];
    self.tableScroll1.delegate = self;
    self.tableScroll1.pagingEnabled = YES;
    self.tableScroll1.contentSize = CGSizeMake(KWidth*3, KHeight/664*330);
    self.tableScroll1.backgroundColor = [UIColor clearColor];
    [self.bgimage2 addSubview:self.tableScroll1];
    for (int i = 0; i<3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(KWidth*i, 0, KWidth, KHeight/664*30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        if (i==0) {
            label.text = @"当 月 用 电 量 及 现 金 支 出";
        }else if(i==1){
            label.text = @"当 年 用 电 量 及 现 金 支 出";
        }else{
            label.text = @"累 计 用 电 量 及 现 金 支 出";
        }
        [self.tableScroll1 addSubview:label];
    }
    
    UIScrollView *fourTable = [[UIScrollView alloc] initWithFrame:CGRectMake(0, KHeight/664*30, k_MainBoundsWidth, KHeight/664*311)];
    fourTable.bounces = NO;
    [self.tableScroll1 addSubview:fourTable];
    
    
    
    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-90, 45, 75, 27)];
    rightImg.image = [UIImage imageNamed:@"fadianzhengce"];
    rightImg.userInteractionEnabled = YES;
    [self.bgimage2 addSubview:rightImg];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,KWidth/375*75, KHeight/664*27)];
    label.text = @"用电政策";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [rightImg addSubview:label];
    
    UIButton *yongdianzhengce = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,KWidth/375*70, KHeight/664*25)];
    [yongdianzhengce addTarget:self action:@selector(yongdianzhengce) forControlEvents:UIControlEventTouchUpInside];
    [rightImg addSubview:yongdianzhengce];
    
    self.table4 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/664*(310-71))];
    self.table4.typeCount = 1;
    self.table4.isblue = YES;
    
    self.table4.tableTitleFont = [UIFont systemFontOfSize:14];
    //    table.xDescTextFontSize =  (CGFloat)13;
    //    table.yDescTextFontSize =  (CGFloat)13;
    self.table4.colTitleArr = @[@"类别|时间",@"用电量(度)",@"现金支出(元)",@"其中|高峰电量",@"(度)|低谷电量"];
    /*        The width of the column array, starting with the first column         */
    NSMutableArray *colWid = [[NSMutableArray alloc] init];
    NSString *wid1 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
    NSString *wid2 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5+10];
    NSString *wid3 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5+20];
    NSString *wid4 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
    NSString *wid5 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
    [colWid addObject:wid1];
    [colWid addObject:wid2];
    [colWid addObject:wid3];
    [colWid addObject:wid4];
    [colWid addObject:wid5];
    self.table4.colWidthArr = colWid;
    
    //    table.colWidthArr = @[@80.0,@30.0,@70,@50,@50,@50,@50,@50,@50,@50];
    //    table.beginSpace = 30;
    /*        Text color of the table body         */
    self.table4.bodyTextColor = [UIColor whiteColor];
    /*        Minimum grid height         */
    self.table4.minHeightItems = KHeight/667*25;
    self.table4.tableChartTitleItemsHeight = KHeight/667*46;
    /*        Table line color         */
    self.table4.lineColor = [UIColor whiteColor];
    
    self.table4.backgroundColor = [UIColor clearColor];
    /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
    if([self.useString isEqualToString:@"峰谷电价"]){
        self.table4.dataArr = self.TbaleTipArr4;
    }else{
        self.table4.dataArr = self.RedTbaleTipArr4;
    }
    
    /*        show   */
    fourTable.contentSize = CGSizeMake(KWidth, 35);
    [self.table4 showAnimation];
    [fourTable addSubview:self.table4];
    /*        Automatic calculation table height        */
    self.table4.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.table4 heightFromThisDataSource]);
    
    if (self.dayFeeArr.count>0) {
        UIScrollView *oneTable1 = [[UIScrollView alloc] init];
        if (self.dayFeeArr.count>11) {
            oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, KHeight/664*(311-71));
        }else{
            oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, KHeight/667*20*self.dayFeeArr.count);
        }
        oneTable1.bounces = NO;
        [self.table4 addSubview:oneTable1];
        self.table44 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/664*(310-51))];
        self.table44.typeCount = 11;
        self.table44.isblue = NO;
        self.table44.tableTitleFont = [UIFont systemFontOfSize:14];
        self.table44.colTitleArr = self.dayFeeArr[0];
        self.table44.colWidthArr = colWid;
        self.table44.bodyTextColor = [UIColor whiteColor];
        self.table44.minHeightItems = KHeight/667*20;
        self.table44.lineColor = [UIColor whiteColor];
        self.table44.backgroundColor = [UIColor clearColor];
        NSMutableArray *day11 = [[NSMutableArray alloc] initWithCapacity:0];
        if([self.useString isEqualToString:@"峰谷电价"]){
            for (int i=0; i<self.dayFeeArr.count; i++) {
                if (i>0) {
                    [day11 addObject:self.dayFeeArr[i]];
                }
            }
            
        }else{
            for (int i=0; i<self.ReddayFeeArr.count; i++) {
                if (i>0) {
                    [day11 addObject:self.ReddayFeeArr[i]];
                }
            }
        }
        self.table44.dataArr = day11;
        oneTable1.contentSize = CGSizeMake(KWidth, KHeight/667*(self.table44.dataArr.count+1)+KHeight/667*2);
        [self.table44 showAnimation];
        [oneTable1 addSubview:self.table44];
        self.table44.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.table44 heightFromThisDataSource]);
        self.Redtable4 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/664*310)];
        self.Redtable4.typeCount = 0;
        self.Redtable4.isblue = YES;
        self.Redtable4.isRed = YES;
        self.Redtable4.colTitleArr =  @[@"类别|时间",@"用电量(度)",@"现金支出(元)",@"其中|高峰电量",@"(度)|低谷电量"];
        /*        The width of the column array, starting with the first column         */
        self.Redtable4.colWidthArr = colWid;
        //    table.colWidthArr = @[@80.0,@30.0,@70,@50,@50,@50,@50,@50,@50,@50];
        //    table.beginSpace = 30;
        /*        Text color of the table body         */
        self.Redtable4.bodyTextColor = [UIColor whiteColor];
        /*        Minimum grid height         */
        self.Redtable4.tableChartTitleItemsHeight =KHeight/667*46;
        self.Redtable4.minHeightItems = KHeight/667*25;
        /*        Table line color         */
        self.Redtable4.lineColor = [UIColor whiteColor];
        self.Redtable4.backgroundColor = [UIColor clearColor];
        //    self.table3.backgroundColor = RGBColor(76, 75, 102);
        /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
        if([self.useString isEqualToString:@"峰谷电价"]){
            self.Redtable4.dataArr = self.RedTbaleTipArr4;
        }else{
            self.Redtable4.dataArr = self.TbaleTipArr4;
        }
        
        
        fourTable.contentSize = CGSizeMake(KWidth, 35);
        /*        show                            */
        [self.Redtable4 showAnimation];
        [fourTable addSubview:self.Redtable4];
        /*        Automatic calculation table height        */
        self.Redtable4.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.Redtable4 heightFromThisDataSource]);
        if (self.ReddayFeeArr.count>11) {
            oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, KHeight/664*(311-71));
        }else{
            oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, KHeight/667*20*self.ReddayFeeArr.count);
        }
        oneTable1.bounces = NO;
        [fourTable addSubview:oneTable1];
        self.Redtable44 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/664*(310-71))];
        self.Redtable44.typeCount = 11;
        self.Redtable44.isblue = NO;
        self.Redtable44.isRed = YES;
        self.Redtable44.tableTitleFont = [UIFont systemFontOfSize:14];
        if (self.ReddayFeeArr.count>0) {
            self.Redtable44.colTitleArr = self.ReddayFeeArr[0];
        }
        
        self.Redtable44.colWidthArr = colWid;
        self.Redtable44.bodyTextColor = [UIColor whiteColor];
        self.Redtable44.minHeightItems = KHeight/667*20;
        self.Redtable44.lineColor = [UIColor whiteColor];
        self.Redtable44.backgroundColor = [UIColor clearColor];
        //        self.table33.backgroundColor = RGBColor(76, 75, 102);
        NSMutableArray *day111 = [[NSMutableArray alloc] initWithCapacity:0];
        if([self.useString isEqualToString:@"峰谷电价"]){
            for (int i=0; i<self.ReddayFeeArr.count; i++) {
                if (i>0) {
                    [day111 addObject:self.ReddayFeeArr[i]];
                }
                
                
            }
            
        }else{
            for (int i=0; i<self.dayFeeArr.count; i++) {
                if (i>0) {
                    [day111 addObject:self.dayFeeArr[i]];
                }
                
                
            }
            
        }
        self.Redtable44.dataArr = day111;
        oneTable1.contentSize = CGSizeMake(KWidth,KHeight/667*20*(self.Redtable44.dataArr.count+1));
        [self.Redtable44 showAnimation];
        [oneTable1 addSubview:self.Redtable44];
        self.Redtable44.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.Redtable44 heightFromThisDataSource]);
    }
    self.Redtable4.hidden = YES;
    self.Redtable44.hidden = YES;
}

- (void)dianjiaBtnClick{
    NSLog(@"电价按钮点击");
    if (self.yongdianDianBtnClick) {
        self.yongdianDianBtnClick = NO;
    }else{
        self.yongdianDianBtnClick = YES;
    }
    if ([self.textLabel.text isEqualToString:@"峰谷电价"]) {
        self.textLabel.text = @"固定电价";
    }else{
        self.textLabel.text = @"峰谷电价";
    }
    if (self.Redtable44.hidden == YES) {
        self.Redtable4.hidden = NO;
        self.Redtable44.hidden = NO;
        self.table4.hidden = YES;
        self.table44.hidden = YES;
        self.Redtable5.hidden = NO;
        self.Redtable55.hidden = NO;
        self.table5.hidden = YES;
        self.table55.hidden = YES;
        self.Redtable6.hidden = NO;
        self.Redtable66.hidden = NO;
        self.table6.hidden = YES;
        self.table66.hidden = YES;
    }else{
        self.Redtable4.hidden = YES;
        self.Redtable44.hidden = YES;
        self.table4.hidden = NO;
        self.table44.hidden = NO;
        self.Redtable5.hidden = YES;
        self.Redtable55.hidden = YES;
        self.table5.hidden = NO;
        self.table55.hidden = NO;
        self.Redtable6.hidden = YES;
        self.Redtable66.hidden = YES;
        self.table6.hidden = NO;
        self.table66.hidden = NO;
    }
    if (self.yongdianDianBtnClick) {
        [self performSelector:@selector(changge) withObject:nil/*可传任意类型参数*/ afterDelay:15.0];
    }
    
}
- (void)changge{
    if (self.yongdianDianBtnClick) {
        if (self.yongdianDianBtnClick) {
            self.yongdianDianBtnClick = NO;
        }else{
            self.yongdianDianBtnClick = YES;
        }
        if ([self.textLabel.text isEqualToString:@"峰谷电价"]) {
            self.textLabel.text = @"阶梯电价";
        }else{
            self.textLabel.text = @"峰谷电价";
        }
        if (self.Redtable44.hidden == YES) {
            self.Redtable4.hidden = NO;
            self.Redtable44.hidden = NO;
            self.table4.hidden = YES;
            self.table44.hidden = YES;
            self.Redtable5.hidden = NO;
            self.Redtable55.hidden = NO;
            self.table5.hidden = YES;
            self.table55.hidden = YES;
            self.Redtable6.hidden = NO;
            self.Redtable66.hidden = NO;
            self.table6.hidden = YES;
            self.table66.hidden = YES;
        }else{
            self.Redtable4.hidden = YES;
            self.Redtable44.hidden = YES;
            self.table4.hidden = NO;
            self.table44.hidden = NO;
            self.Redtable5.hidden = YES;
            self.Redtable55.hidden = YES;
            self.table5.hidden = NO;
            self.table55.hidden = NO;
            self.Redtable6.hidden = YES;
            self.Redtable66.hidden = YES;
            self.table6.hidden = NO;
            self.table66.hidden = NO;
        }
        
    }
}

- (void)setFiveTable{
    
    UIScrollView *fiveTable = [[UIScrollView alloc] initWithFrame:CGRectMake(KWidth, KHeight/664*30, k_MainBoundsWidth, KHeight/664*310)];
    fiveTable.bounces = NO;
    [self.tableScroll1 addSubview:fiveTable];
    
    
    self.table5 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/664*310)];
    self.table5.typeCount = 1;
    self.table5.isblue = YES;
    /*       Table name         */
    //    table.tableTitleString = @"全选jeep自由光";
    /*        Each column of the statement, one of the first to show if the rows and columns that can use the vertical segmentation of rows and columns         */
    //    table.colTitleArr = @[@"属性|配置",@"外观",@"内饰",@"数量",@"",@"",@"",@"",@"",@""];
    self.table5.colTitleArr = @[@"类别|时间",@"用电量(度)",@"现金支出(元)",@"其中|高峰电量",@"(度)|低谷电量"];
    /*        The width of the column array, starting with the first column         */
    NSMutableArray *colWid = [[NSMutableArray alloc] init];
    NSString *wid1 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
    NSString *wid2 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5+10];
    NSString *wid3 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5+20];
    NSString *wid4 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
    NSString *wid5 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
    [colWid addObject:wid1];
    [colWid addObject:wid2];
    [colWid addObject:wid3];
    [colWid addObject:wid4];
    [colWid addObject:wid5];
    self.table5.colWidthArr = colWid;
    
    //    table.colWidthArr = @[@80.0,@30.0,@70,@50,@50,@50,@50,@50,@50,@50];
    //    table.beginSpace = 30;
    /*        Text color of the table body         */
    self.table5.bodyTextColor = [UIColor whiteColor];
    /*        Minimum grid height         */
    self.table5.minHeightItems = 25;
    self.table5.tableChartTitleItemsHeight = KHeight/667*46;
    /*        Table line color         */
    self.table5.lineColor = [UIColor whiteColor];
    
    self.table5.backgroundColor = [UIColor clearColor];
    /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
    if([self.useString isEqualToString:@"峰谷电价"]){
        self.table5.dataArr = self.TbaleTipArr5;
    }else{
        self.table5.dataArr = self.RedTbaleTipArr5;
    }
    
    
    fiveTable.contentSize = CGSizeMake(KWidth, 35);
    /*        show                            */
    [self.table5 showAnimation];
    [fiveTable addSubview:self.table5];
    /*        Automatic calculation table height        */
    self.table5.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.table5 heightFromThisDataSource]);
    
    if (self.MonthFeeArr.count>0) {
        UIScrollView *oneTable1 = [[UIScrollView alloc] init];
        if (self.MonthFeeArr.count>11) {
            oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, KHeight/664*(310-51));
        }else{
            oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, KHeight/667*20*self.MonthFeeArr.count);
        }
        
        oneTable1.bounces = NO;
        [fiveTable addSubview:oneTable1];
        self.table55 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/664*(310-71))];
        self.table55.typeCount = 11;
        self.table55.isblue = NO;
        self.table55.tableTitleFont = [UIFont systemFontOfSize:14];
        self.table55.colTitleArr = self.MonthFeeArr[0];
        self.table55.colWidthArr = colWid;
        self.table55.bodyTextColor = [UIColor whiteColor];
        self.table55.minHeightItems = 20;
        self.table55.lineColor = [UIColor whiteColor];
        self.table55.backgroundColor = [UIColor clearColor];
        NSMutableArray *day11 = [[NSMutableArray alloc] initWithCapacity:0];
        if([self.useString isEqualToString:@"峰谷电价"]){
            for (int i=0; i<self.MonthFeeArr.count; i++) {
                
                if (i>0) {
                    [day11 addObject:self.MonthFeeArr[i]];
                }
                
            }
            
        }else{
            for (int i=0; i<self.RedMonthFeeArr.count; i++) {
                
                if (i>0) {
                    [day11 addObject:self.RedMonthFeeArr[i]];
                }
                
            }
            
        }
        self.table55.dataArr = day11;
        oneTable1.contentSize = CGSizeMake(KWidth,KHeight/667*20*(self.table55.dataArr.count)+KHeight/667*11);
        [self.table55 showAnimation];
        [oneTable1 addSubview:self.table55];
        self.table55.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.table55 heightFromThisDataSource]);
        
        self.Redtable5 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/664*310)];
        self.Redtable5.typeCount = 0;
        self.Redtable5.isblue = YES;
        self.Redtable5.isRed = YES;
        self.Redtable5.colTitleArr =  @[@"类别|时间",@"用电量(度)",@"现金支出(元)",@"其中|高峰电量",@"(度)|低谷电量"];
        /*        The width of the column array, starting with the first column         */
        self.Redtable5.colWidthArr = colWid;
        //    table.colWidthArr = @[@80.0,@30.0,@70,@50,@50,@50,@50,@50,@50,@50];
        //    table.beginSpace = 30;
        /*        Text color of the table body         */
        self.Redtable5.bodyTextColor = [UIColor whiteColor];
        /*        Minimum grid height         */
        self.Redtable5.tableChartTitleItemsHeight = KHeight/667*46;
        self.Redtable5.minHeightItems = 25;
        /*        Table line color         */
        self.Redtable5.lineColor = [UIColor whiteColor];
        self.Redtable5.backgroundColor = [UIColor clearColor];
        //    self.table3.backgroundColor = RGBColor(76, 75, 102);
        /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
        if([self.useString isEqualToString:@"峰谷电价"]){
            self.Redtable5.dataArr = self.RedTbaleTipArr5;
        }else{
            self.Redtable5.dataArr = self.TbaleTipArr5;
        }
        
        
        fiveTable.contentSize = CGSizeMake(KWidth, 35);
        /*        show                            */
        [self.Redtable5 showAnimation];
        [fiveTable addSubview:self.Redtable5];
        /*        Automatic calculation table height        */
        self.Redtable5.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.Redtable5 heightFromThisDataSource]);
        if (self.RedMonthFeeArr.count>11) {
            oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, KHeight/664*(310-71));
        }else{
            oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, 20*self.RedMonthFeeArr.count);
        }
        oneTable1.bounces = NO;
        [fiveTable addSubview:oneTable1];
        self.Redtable55 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/664*(310-71))];
        self.Redtable55.typeCount = 11;
        self.Redtable55.isblue = NO;
        self.Redtable55.isRed = YES;
        self.Redtable55.tableTitleFont = [UIFont systemFontOfSize:14];
        if (self.RedMonthFeeArr.count>0) {
            self.Redtable55.colTitleArr = self.RedMonthFeeArr[0];
        }
        
        self.Redtable55.colWidthArr = colWid;
        self.Redtable55.bodyTextColor = [UIColor whiteColor];
        self.Redtable55.minHeightItems = KHeight/667*20;
        self.Redtable55.lineColor = [UIColor whiteColor];
        self.Redtable55.backgroundColor = [UIColor clearColor];
        //        self.table33.backgroundColor = RGBColor(76, 75, 102);
        NSMutableArray *day111 = [[NSMutableArray alloc] initWithCapacity:0];
        if([self.useString isEqualToString:@"峰谷电价"]){
            for (int i=0; i<self.RedMonthFeeArr.count; i++) {
                if (i>0) {
                    [day111 addObject:self.RedMonthFeeArr[i]];
                }
                
                
            }
            
        }else{
            for (int i=0; i<self.MonthFeeArr.count; i++) {
                if (i>0) {
                    [day111 addObject:self.MonthFeeArr[i]];
                }
                
            }
            
        }
        self.Redtable55.dataArr = day111;
        oneTable1.contentSize = CGSizeMake(KWidth, 20*(self.Redtable55.dataArr.count)+11);
        [self.Redtable55 showAnimation];
        [oneTable1 addSubview:self.Redtable55];
        self.Redtable55.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.Redtable55 heightFromThisDataSource]);
        
    }
    self.Redtable5.hidden = YES;
    self.Redtable55.hidden = YES;
}

- (void)setSixTable{
    _bgScrollerView.contentSize = CGSizeMake(KWidth, KHeight*3);
    
    UIScrollView *SixTable = [[UIScrollView alloc] initWithFrame:CGRectMake(KWidth*2, 30, k_MainBoundsWidth, KHeight/664*310)];
    SixTable.bounces = NO;
    [self.tableScroll1 addSubview:SixTable];
    
    //
    //    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(16, KHeight+230+_hight1+_hight2+_hight3+_hight4+_hight5, 130, 20)];
    //    leftImg.image = [UIImage imageNamed:@"fy_together_toptabs"];
    //    [self.bgScrollerView addSubview:leftImg];
    //
    //    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 20)];
    //    label1.text = @"总用电量及支出";
    //    label1.textColor = [UIColor whiteColor];
    //    label1.textAlignment = NSTextAlignmentCenter;
    //    label1.font = [UIFont systemFontOfSize:13];
    //    [leftImg addSubview:label1];
    
    
    self.table6 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/664*310)];
    self.table6.typeCount = 1;
    self.table6.isblue = YES;
    self.table6.colTitleArr = @[@"类别|时间",@"用电量(度)",@"现金支出(元)",@"其中|高峰电量",@"(度)|低谷电量"];
    /*        The width of the column array, starting with the first column         */
    NSMutableArray *colWid = [[NSMutableArray alloc] init];
    NSString *wid1 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
    NSString *wid2 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5+10];
    NSString *wid3 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5+20];
    NSString *wid4 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
    NSString *wid5 = [NSString stringWithFormat:@"%.2f",(KWidth-30)/5-10];
    [colWid addObject:wid1];
    [colWid addObject:wid2];
    [colWid addObject:wid3];
    [colWid addObject:wid4];
    [colWid addObject:wid5];
    self.table6.colWidthArr = colWid;
    
    //    table.colWidthArr = @[@80.0,@30.0,@70,@50,@50,@50,@50,@50,@50,@50];
    //    table.beginSpace = 30;
    /*        Text color of the table body         */
    self.table6.bodyTextColor = [UIColor whiteColor];
    /*        Minimum grid height         */
    self.table6.minHeightItems = 25;
    self.table6.tableChartTitleItemsHeight = 46;
    /*        Table line color         */
    self.table6.lineColor = [UIColor whiteColor];
    
    self.table6.backgroundColor = [UIColor clearColor];
    /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
    if([self.useString isEqualToString:@"峰谷电价"]){
        self.table6.dataArr = self.TbaleTipArr6;
    }else{
        self.table6.dataArr = self.RedTbaleTipArr6;
    }
    
    
    SixTable.contentSize = CGSizeMake(KWidth, 35);
    /*        show                            */
    [self.table6 showAnimation];
    [SixTable addSubview:self.table6];
    /*        Automatic calculation table height        */
    self.table6.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.table6 heightFromThisDataSource]);
    self.isFirst = NO;
    
    if (self.YearFeeArr.count>0) {
        UIScrollView *oneTable1 = [[UIScrollView alloc] init];
        if (self.YearFeeArr.count>11) {
            oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, KHeight/664*(310-71));
        }else{
            oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, 20*self.YearFeeArr.count);
        }
        oneTable1.bounces = NO;
        [self.table6 addSubview:oneTable1];
        self.table66 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/664*(310-71))];
        self.table66.typeCount = 11;
        self.table66.isblue = NO;
        self.table66.tableTitleFont = [UIFont systemFontOfSize:14];
        self.table66.colTitleArr = self.YearFeeArr[0];
        self.table66.colWidthArr = colWid;
        self.table66.bodyTextColor = [UIColor whiteColor];
        self.table66.minHeightItems = 20;
        self.table66.lineColor = [UIColor whiteColor];
        self.table66.backgroundColor = [UIColor clearColor];
        NSMutableArray *day11 = [[NSMutableArray alloc] initWithCapacity:0];
        if([self.useString isEqualToString:@"峰谷电价"]){
            for (int i=0; i<self.YearFeeArr.count; i++) {
                
                if (i>0) {
                    [day11 addObject:self.YearFeeArr[i]];
                    
                }
            }
            
        }else{
            for (int i=0; i<self.RedYearFeeArr.count; i++) {
                
                if (i>0) {
                    [day11 addObject:self.RedYearFeeArr[i]];
                    
                }
            }
        }
        self.table66.dataArr = day11;
        oneTable1.contentSize = CGSizeMake(KWidth, 20*(self.table66.dataArr.count)+11);
        [self.table66 showAnimation];
        [oneTable1 addSubview:self.table66];
        self.table66.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.table66 heightFromThisDataSource]);
        self.Redtable6 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/664*310)];
        self.Redtable6.typeCount = 0;
        self.Redtable6.isblue = YES;
        self.Redtable6.isRed = YES;
        self.Redtable6.colTitleArr =  @[@"类别|时间",@"用电量(度)",@"现金支出(元)",@"其中|高峰电量",@"(度)|低谷电量"];
        /*        The width of the column array, starting with the first column         */
        self.Redtable6.colWidthArr = colWid;
        //    table.colWidthArr = @[@80.0,@30.0,@70,@50,@50,@50,@50,@50,@50,@50];
        //    table.beginSpace = 30;
        /*        Text color of the table body         */
        self.Redtable6.bodyTextColor = [UIColor whiteColor];
        /*        Minimum grid height         */
        self.Redtable6.tableChartTitleItemsHeight = 46;
        self.Redtable6.minHeightItems = 25;
        /*        Table line color         */
        self.Redtable6.lineColor = [UIColor whiteColor];
        self.Redtable6.backgroundColor = [UIColor clearColor];
        //    self.table3.backgroundColor = RGBColor(76, 75, 102);
        /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
        if([self.useString isEqualToString:@"峰谷电价"]){
            self.Redtable6.dataArr = self.RedTbaleTipArr6;
        }else{
            self.Redtable6.dataArr = self.TbaleTipArr6;
        }
        
        
        SixTable.contentSize = CGSizeMake(KWidth, 35);
        /*        show                            */
        [self.Redtable6 showAnimation];
        [SixTable addSubview:self.Redtable6];
        /*        Automatic calculation table height        */
        self.Redtable6.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.Redtable6 heightFromThisDataSource]);
        if (self.RedYearFeeArr.count>11) {
            oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, KHeight/664*(310-51));
        }else{
            oneTable1.frame = CGRectMake(0,71, k_MainBoundsWidth, 20*self.RedYearFeeArr.count);
        }
        oneTable1.bounces = NO;
        [SixTable addSubview:oneTable1];
        self.Redtable66 = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, k_MainBoundsWidth, KHeight/664*(310-71))];
        self.Redtable66.typeCount = 11;
        self.Redtable66.isblue = NO;
        self.Redtable66.isRed = YES;
        self.Redtable66.tableTitleFont = [UIFont systemFontOfSize:14];
        if (self.RedYearFeeArr.count>0) {
            self.Redtable66.colTitleArr = self.RedYearFeeArr[0];
        }
        
        self.Redtable66.colWidthArr = colWid;
        self.Redtable66.bodyTextColor = [UIColor whiteColor];
        self.Redtable66.minHeightItems = 20;
        self.Redtable66.lineColor = [UIColor whiteColor];
        self.Redtable66.backgroundColor = [UIColor clearColor];
        //        self.table33.backgroundColor = RGBColor(76, 75, 102);
        NSMutableArray *day111 = [[NSMutableArray alloc] initWithCapacity:0];
        if([self.useString isEqualToString:@"峰谷电价"]){
            for (int i=0; i<self.RedYearFeeArr.count; i++) {
                if (i>0) {
                    [day111 addObject:self.RedYearFeeArr[i]];
                }
                
                
            }
            
        }else{
            for (int i=0; i<self.YearFeeArr.count; i++) {
                if (i>0) {
                    [day111 addObject:self.YearFeeArr[i]];
                }
                
                
            }
            
        }
        self.Redtable66.dataArr = day111;
        oneTable1.contentSize = CGSizeMake(KWidth, 20*(self.Redtable66.dataArr.count)+11);
        [self.Redtable66 showAnimation];
        [oneTable1 addSubview:self.Redtable66];
        self.Redtable66.frame = CGRectMake(0, 0, k_MainBoundsWidth, [self.Redtable66 heightFromThisDataSource]);
        
        self.Redtable6.hidden = YES;
        self.Redtable66.hidden = YES;
    }
}

//---------接口------
//发用电首页状态
-(void)requestStatus{
    NSString *URL = [NSString stringWithFormat:@"%@/app/roofs/roof/get-top-data",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    //    NSDictionary *dict = @{ @"bid":@"022017010719170501"};
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发用电状态%@",responseObject);
        if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
            [self newLoginTwo];
            
            
        }else  if([responseObject[@"result"][@"success"] intValue] ==1){
            
            [self.statusArr removeAllObjects];
            [self.statusArr addObject:responseObject[@"content"][@"gen_ele_sys"] ];//这条数据没用
            [self.statusArr addObject:responseObject[@"content"][@"net_ele"] ];
            [self.statusArr addObject:responseObject[@"content"][@"today_gen"] ];
            [self.statusArr addObject:responseObject[@"content"][@"today_gen_use_self"] ];
            [self.statusArr addObject:responseObject[@"content"][@"today_use"] ];
            [self.statusArr addObject:responseObject[@"content"][@"up_net_ele"] ];
            [self.statusArr addObject:responseObject[@"content"][@"med_use"] ];
            [self.statusArr addObject:responseObject[@"content"][@"low_use"] ];
            
            NSLog(@"_statusArr = %@",_statusArr);
            self.topStatus = responseObject[@"content"][@"gen_ele_sys"];
            self.downStatus = responseObject[@"content"][@"use_ele_sys"];
            NSNumber *alert_use_num = responseObject[@"content"][@"alert_use_num"];
            self.alert_use_num = [alert_use_num integerValue];
            NSNumber *alert_gen_num = responseObject[@"content"][@"alert_gen_num"];
            self.alert_gen_num = [alert_gen_num integerValue];
            self.isOnline = responseObject[@"content"][@"equipment_status"];
            //            self.yuyinString = [NSString stringWithFormat:@"今日上网电量:%@元",self.statusArr[0]];
            NSArray *array = _statusArr[2];
            float text0 = [array[0] floatValue];
            float text00 = [array[1] floatValue];
            NSString *string2 = [[NSString alloc] init];
            string2 = [NSString stringWithFormat:@"效益方面:\r\r今日发电量: %.2f度,发电收益: %.2f元。\r\r",text0,text00];
            
            NSArray *array3 = _statusArr[5];
            float text2 = [array3[0] floatValue];
            float text22 = [array3[1] floatValue];
            if([self.bingwangfangshi isEqualToString:@"余电上网"]){
                string2 = [NSString stringWithFormat:@"%@其中上网电量: %.2f度,现金收益: %.2f元。\r\r",string2,text2,text22];
            }
            NSArray *array4 = _statusArr[4];
            float text3 = [array4[0] floatValue];
            float text33 = [array4[1] floatValue];
            string2 = [NSString stringWithFormat:@"%@今日用电量: %.2f度,总电费: %.2f元。\r\r",string2,text3,text33];
            NSArray *array6 = _statusArr[1];
            float text6 = [array6[0] floatValue];
            float text66 = [array6[1] floatValue];
            if([self.bingwangfangshi isEqualToString:@"余电上网"]){
                string2 = [NSString stringWithFormat:@"%@其中网电电量: %.2f度,支出: %.2f元。\r\r",string2,text6,text66];
            }
            NSArray *array1 = _statusArr[3];
            float text1 = [array1[0] floatValue];
            float text11 = [array1[1] floatValue];
            if([self.bingwangfangshi isEqualToString:@"余电上网"]){
                string2 = [NSString stringWithFormat:@"%@今日自发自用电量: %.2f度, 价值: %.2f元。\r\r",string2,text1,text11];
            }
            float cha = text00-text33;
            if (cha>=0) {
                string2 = [NSString stringWithFormat:@"%@截止目前,发电收入与电费支出相比较,净赚 %.2f元。\r\r",string2,cha];
            }else{
                cha = cha*-1;
                string2 = [NSString stringWithFormat:@"%@截止目前,发电收入与电费支出相比较,亏损 %.2f元。\r\r",string2,cha];
            }
            
            NSDate *now = [NSDate date];
            NSLog(@"now date is: %@", now);
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
            int hour = (int) [dateComponent hour];
            if(hour>=0&&hour<12){
                string2 = [NSString stringWithFormat:@"%@汇报完毕,祝您早安。",string2];
            }else if(hour>=12&&hour<18){
                string2 = [NSString stringWithFormat:@"%@汇报完毕,祝您午安。",string2];
            }else{
                string2 = [NSString stringWithFormat:@"%@汇报完毕,祝您晚安。",string2];
            }
            
            _yuyinString = [NSString stringWithFormat:@"%@", string2 ];
            
            if (!self.isFirst) {
                self.content.text = self.yuyinString;
                //--------判断按钮状态-----
                if ([self.topStatus isEqualToString:@"normal"]) {
                    [self.twoBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    [self.twoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [self.threeBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    [self.threeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [self.oneBtn setBackgroundImage:[UIImage imageNamed:@"zhengchang"] forState:UIControlStateNormal];
                    [self.oneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }else if ([self.topStatus isEqualToString:@"abnormal"]){
                    [self.oneBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    [self.oneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [self.threeBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    [self.threeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [self.twoBtn setBackgroundImage:[UIImage imageNamed:@"yichang"] forState:UIControlStateNormal];
                    [self.twoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }else{
                    [self.oneBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    [self.oneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [self.threeBtn setBackgroundImage:[UIImage imageNamed:@"guzhang"] forState:UIControlStateNormal];
                    [self.threeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [self.twoBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    [self.twoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
                if ([self.downStatus isEqualToString:@"normal"]) {
                    [self.twoBtn1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    [self.twoBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [self.threeBtn1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    [self.threeBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [self.oneBtn1 setBackgroundImage:[UIImage imageNamed:@"zhengchang"] forState:UIControlStateNormal];
                    [self.oneBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }else if ([self.downStatus isEqualToString:@"abnormal"]){
                    [self.oneBtn1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    [self.oneBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [self.threeBtn1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    [self.threeBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [self.twoBtn1 setBackgroundImage:[UIImage imageNamed:@"yichang"] forState:UIControlStateNormal];
                    [self.twoBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }else{
                    [self.oneBtn1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    [self.oneBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [self.threeBtn1 setBackgroundImage:[UIImage imageNamed:@"guzhang"] forState:UIControlStateNormal];
                    [self.threeBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [self.twoBtn1 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    [self.twoBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
                
            }
            
            NSString *yuyin = [NSString stringWithFormat:@"%@\r\r%@",self.yuyinText,self.yuyinString];
            if (self.content) {
                self.content.text = [NSString stringWithFormat:@"%@",yuyin];
            }
        }
        
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
    
}

// 曲线图数据
-(void)requestFirstChart{
    NSString *URL = [NSString stringWithFormat:@"%@/app/roofs/roof/get-power-graph-data",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    //    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //    manager.requestSerializer = requestSerializer;
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"第一张图%@",responseObject);
        if([responseObject[@"result"][@"errorMsg"] isEqualToString:@"token expired"]){
            [self newLoginTwo];
            
            
        }else  if([responseObject[@"result"][@"success"] intValue] ==1){
            
            [self.FirstChartuseArr removeAllObjects];
            [self.FirstChartgenArr removeAllObjects];
            NSArray *array = responseObject[@"content"][@"use_power"];
            NSMutableArray *valuearr = [[NSMutableArray alloc]initWithCapacity:0];
            if ([array isEqual:[NSNull null]]) {
                array = nil;
            }else{
                
                for (int i =0; i<array.count; i++) {
                    NSString *value = [NSString stringWithFormat:@"%@",array[i]];
                    [valuearr addObject:value];
                }
                
                for (int i=0; i<valuearr.count; i++) {
                    CGFloat num = [valuearr[i] floatValue];
                    CGFloat number = [valuearr[valuearr.count-1] floatValue];
                    if (number<0) {
                        for (NSInteger m = valuearr.count-1; m>=0; m--) {
                            CGFloat number1 = [valuearr[m] floatValue];
                            if (number1<0) {
                                [valuearr removeObjectAtIndex:m];
                            }else{
                                break;
                            }
                        }
                    }
                    NSInteger count = 0;
                    if (num<0) {
                        if (i==0) {
                            [valuearr replaceObjectAtIndex:0 withObject:@"0"];
                        }
                        for (int j=i; j<valuearr.count-i; j++) {
                            CGFloat num1 = [valuearr[j] floatValue];
                        
                            if (num1<0) {
                                count++;
                            }else{
                                break;
                            }
                            
                        }
                        for (int k=0; k<count; k++) {
                            CGFloat hou = [valuearr[i+count] floatValue];
                            CGFloat qian = [valuearr[i-1] floatValue];
                            CGFloat tihuan = qian-(qian-hou)/(count)*(k+1);
                            NSString *str = [NSString stringWithFormat:@"%.2f",tihuan];
                            [valuearr replaceObjectAtIndex:i+k withObject:str];
                        }
                    }
                }
                
                self.FirstChartgenArr = valuearr;
            }
            NSLog(@"用电数组:%@",self.FirstChartgenArr);
            
            NSArray *array1 = responseObject[@"content"][@"gen_power"];
            
            NSMutableArray *valuearr1 = [[NSMutableArray alloc]initWithCapacity:0];
            if ([array1 isEqual:[NSNull null]] ) {
                array1 = nil;
            }else{
                
                for (int i =0; i<array1.count; i++) {
                    NSString *value1 = [NSString stringWithFormat:@"%@",array1[i]];
                    [valuearr1 addObject:value1];
                }
                
                for (int i=0; i<valuearr1.count; i++) {
                    CGFloat num = [valuearr1[i] floatValue];
                    CGFloat number = [valuearr1[valuearr1.count-1] floatValue];
                    if (number<0) {
                        for (NSInteger m = valuearr1.count-1; m>=0; m--) {
                            CGFloat number1 = [valuearr1[m] floatValue];
                            if (number1<0) {
                                [valuearr1 removeObjectAtIndex:m];
                            }else{
                                break;
                            }
                        }
                    }
                    NSInteger count = 0;
                    if (num<0) {
                        if (i==0) {
                            [valuearr1 replaceObjectAtIndex:0 withObject:@"0"];
                        }
                        for (int j=i; j<valuearr1.count-i; j++) {
                            CGFloat num1 = [valuearr1[j] floatValue];
                            if (num1<0) {
                                count++;
                            }else{
                                break;
                            }
                            
                        }
                        for (int k=0; k<count; k++) {
                            CGFloat hou = [valuearr1[i+count] floatValue];
                             CGFloat qian = [valuearr1[i-1] floatValue];
                            CGFloat tihuan = qian-(qian-hou)/count*(k+1);
                            NSString *str = [NSString stringWithFormat:@"%.2f",tihuan];
                            [valuearr1 replaceObjectAtIndex:i+k withObject:str];
                        }
                    }
                }
                
                self.FirstChartuseArr = valuearr1;
            }
            NSLog(@"发电数组:%@",self.FirstChartuseArr);
            
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
    
}

// 柱状图数据
-(void)requestSecondChart{
    NSString *URL = [NSString stringWithFormat:@"%@/app/roofs/roof/get-gen-use-med-low-graph-data",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"用电量柱状图%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            NSMutableArray *redAll = responseObject[@"content"][@"red"];
            [self.redArr removeAllObjects];
            for (int i=0; i<redAll.count; i++) {
                if (i%2==0) {
                    if (i+1==redAll.count) {
                        CGFloat qian = [redAll[i] floatValue];
                        CGFloat hou = 0;
                        NSString *str = [NSString stringWithFormat:@"%.2f",qian+hou];
                        [self.redArr addObject:str];
                    }else{
                        CGFloat qian = [redAll[i] floatValue];
                        CGFloat hou = [redAll[i+1] floatValue];
                        NSString *str = [NSString stringWithFormat:@"%.2f",qian+hou];
                        [self.redArr addObject:str];
                    }
                    
                }
            }
            
            NSMutableArray *yellowAll = responseObject[@"content"][@"yellow"];
            [self.yellowArr removeAllObjects];
            for (int i=0; i<yellowAll.count; i++) {
                if (i%2==0) {
                    if (i+1==yellowAll.count) {
                        CGFloat qian = [yellowAll[i] floatValue];
                        CGFloat hou = 0;
                        NSString *str = [NSString stringWithFormat:@"%.2f",qian+hou];
                        [self.yellowArr addObject:str];
                    }else{
                        CGFloat qian = [yellowAll[i] floatValue];
                        CGFloat hou = [yellowAll[i+1] floatValue];
                        NSString *str = [NSString stringWithFormat:@"%.2f",qian+hou];
                        [self.yellowArr addObject:str];
                    }
                    
                }
            }
            
            
            NSMutableArray *greenAll = responseObject[@"content"][@"green"];
            [self.greenArr removeAllObjects];
            for (int i=0; i<greenAll.count; i++) {
                if (i%2==0) {
                    if (i+1==greenAll.count) {
                        CGFloat qian = [greenAll[i] floatValue];
                        CGFloat hou = 0;
                        NSString *str = [NSString stringWithFormat:@"%.2f",qian+hou];
                        [self.greenArr addObject:str];
                    }else{
                        CGFloat qian = [greenAll[i] floatValue];
                        CGFloat hou = [greenAll[i+1] floatValue];
                        NSString *str = [NSString stringWithFormat:@"%.2f",qian+hou];
                        [self.greenArr addObject:str];
                    }
                    
                }
            }
            
            
            
            NSMutableArray *blueAll = responseObject[@"content"][@"bule"];
            [self.blueArr removeAllObjects];
            for (int i=0; i<blueAll.count; i++) {
                if (i%2==0) {
                    CGFloat qian = [blueAll[i] floatValue];
                    if (i+1==blueAll.count) {
                        CGFloat hou = 0;
                        NSString *str = [NSString stringWithFormat:@"%.2f",qian+hou];
                        [self.blueArr addObject:str];
                    }else{
                        CGFloat hou = [blueAll[i+1] floatValue];
                        NSString *str = [NSString stringWithFormat:@"%.2f",qian+hou];
                        [self.blueArr addObject:str];
                    }
                    
                }
            }
            
            for (int i=0; i<self.blueArr.count; i++) {
                if (i>3&&i<11) {
                    CGFloat blue = [self.blueArr[i] floatValue];
                    CGFloat red = [self.redArr[i] floatValue];
                    CGFloat fin = blue+red;
                    NSString *str = [NSString stringWithFormat:@"%.2f",fin];
                    [self.blueArr replaceObjectAtIndex:i withObject:str];
                }
            }
            for (int i=0; i<self.greenArr.count; i++) {
                if  (i<4||i>10){
                    CGFloat green = [self.greenArr[i] floatValue];
                    CGFloat red = [self.redArr[i] floatValue];
                    CGFloat fin = green+red;
                    NSString *str = [NSString stringWithFormat:@"%.2f",fin];
                    [self.greenArr replaceObjectAtIndex:i withObject:str];
                }
            }
            
            NSLog(@"red:%@",self.redArr);
            NSLog(@"yellowArr:%@",self.yellowArr);
            NSLog(@"blueArr:%@",self.blueArr);
            NSLog(@"greenArr:%@",self.greenArr);
            
            CGFloat max = 0;
            CGFloat sum = 0;
            for (int i=0; i<self.redArr.count; i++) {
                for (int k=0; k<_yellowArr.count; k++) {
                    if (k==i) {
                        CGFloat red = [self.redArr[i] floatValue];
                        CGFloat yellow = [self.yellowArr[k] floatValue];
                        sum = red+yellow;
                        if (sum>max) {
                            max = sum;
                        }
                    }
                }
            }
            CGFloat max1 = 0;
            CGFloat sum1 = 0;
            for (int i=0; i<self.blueArr.count; i++) {
                for (int k=0; k<_greenArr.count; k++) {
                    if (k==i) {
                        CGFloat red = [self.blueArr[i] floatValue];
                        CGFloat yellow = [self.greenArr[k] floatValue];
                        sum1 = red+yellow;
                        if (sum1>max1) {
                            max1 = sum1;
                        }
                    }
                }
            }
            if (max>max1) {
                self.maxNumber = max;
                self.zhuView.maxNumber = max;
            }else{
                self.maxNumber = max1;
                self.zhuView.maxNumber = max1;
            }
            
            
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
    
}

- (void)requestMessage{
    NSString *URL = [NSString stringWithFormat:@"%@/app/roofs/roof/get-site-info",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发用电详情%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            
            NSString * string=responseObject[@"content"][@"grid_time"];
            string=[string stringByReplacingOccurrencesOfString:@"-"withString:@"."];
            self.bingwangshijian = string;
            NSString * string1=responseObject[@"content"][@"install_time"];
            string1=[string stringByReplacingOccurrencesOfString:@"-"withString:@"."];
            self.anzhuangshijian = string1;
            NSNumber *zhuangji = responseObject[@"content"][@"installed_capacity"];
            NSInteger *zhuang = [zhuangji integerValue]/1000;
            if(zhuangji>0){
                self.zhuangjirongliang = [NSString stringWithFormat:@"%d",zhuang];
            }else{
                self.zhuangjirongliang = @"";
            }
            self.bingwangfangshi = responseObject[@"content"][@"access_way"];
            NSNumber *dianliu = responseObject[@"content"][@"rated_current"];
            if(dianliu>0){
                self.edingdianliu = [NSString stringWithFormat:@"%@",dianliu];
            }else{
                self.edingdianliu = @"";
            }
            self.dianjialeibie = responseObject[@"content"][@"use_ele_way"];
            self.fastring = responseObject[@"content"][@"access_way"];
            self.useString = responseObject[@"content"][@"use_ele_way"];
            currentCity = responseObject[@"content"][@"city"];
            //            [self requestWeather];
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
}
//用电日表格
- (void)requestFeeDay{
    
    NSString *URL = [NSString stringWithFormat:@"%@/app/uses/use/get-use-day-data",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"用电日表格详情%@",responseObject);
        NSNumber *code = responseObject[@"result"][@"errorCode"];
        NSString *errorcode = [NSString stringWithFormat:@"%@",code];
        if ([errorcode isEqualToString:@"41111"])  {
            [self newLogin];
        }
        if([responseObject[@"result"][@"success"] intValue] ==1){
            
            [self.dayFeeArr removeAllObjects];
            [_TbaleTipArr4 removeAllObjects];
            [_ReddayFeeArr removeAllObjects];
            [self.RedTbaleTipArr4 removeAllObjects];
            NSMutableArray *allArray = [[NSMutableArray alloc] initWithCapacity:0];
            [allArray addObject:@"总计"];
            NSArray *content = responseObject[@"content"];
            NSDictionary *part = content[1];
            NSDictionary *full = content[0];
            CGFloat total_fixed_fee = [part[@"total_part_use"] floatValue];
            CGFloat total_use_ele = [part[@"total_part_use_fee"] floatValue];
            CGFloat total_med_ele = [part[@"total_part_med"]  floatValue];
            CGFloat total_low_ele = [part[@"total_part_low"] floatValue];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_med_ele+total_low_ele]];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_use_ele]];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_med_ele]];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_low_ele]];
            [self.TbaleTipArr4 addObject:allArray];
            NSMutableArray *allArray1 = [[NSMutableArray alloc] initWithCapacity:0];
            [allArray1 addObject:@"总计"];
            CGFloat total_fixed_fee1 = [full[@"total_full_use"] floatValue];
            CGFloat total_med_ele1 = [full[@"total_full_med"]  floatValue];
            CGFloat total_use_ele1 = [full[@"total_full_use_fee"] floatValue];
            CGFloat total_low_ele1 = [full[@"total_full_low"] floatValue];
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_med_ele1+total_low_ele1]];
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_use_ele1]];
            
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_med_ele1]];
            
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_low_ele1]];
            [self.RedTbaleTipArr4 addObject:allArray1];
            
            for (NSDictionary *goodsDic in part[@"part_data"]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                _dayFeemodel =[[dayFeeModel alloc] initWithDictionary:goodsDic];
                NSInteger *number = [_dayFeemodel.day integerValue];
                if (number<10) {
                    NSString *day = [NSString stringWithFormat:@"0%@日",_dayFeemodel.day];
                    [array addObject:day];
                }else{
                    NSString *day = [NSString stringWithFormat:@"%@日",_dayFeemodel.day];
                    [array addObject:day];
                }
                
                CGFloat use_ele = [_dayFeemodel.use_ele floatValue];
                CGFloat use_fee = [_dayFeemodel.use_fee floatValue];
                CGFloat med = [_dayFeemodel.med floatValue];
                CGFloat low = [_dayFeemodel.low floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",med+low]];
                
                [array addObject:[NSString stringWithFormat:@"%.2f",use_fee]];
                
                [array addObject:[NSString stringWithFormat:@"%.2f",med]];
                
                [array addObject:[NSString stringWithFormat:@"%.2f",low]];
                
                [self.dayFeeArr addObject:array];
            }
            NSLog(@"%@",self.dayFeeArr);
            if (self.dayFeeArr.count<11){
                int count = 11-self.dayFeeArr.count;
                for (int i =0; i<count; i++) {
                    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [self.dayFeeArr addObject:array];
                }
            }
            for (NSDictionary *goodsDic in full[@"full_data"]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                _dayFeemodel =[[dayFeeModel alloc] initWithDictionary:goodsDic];
                NSInteger *number = [_dayFeemodel.day integerValue];
                if (number<10) {
                    NSString *day = [NSString stringWithFormat:@"0%@日",_dayFeemodel.day];
                    [array addObject:day];
                }else{
                    NSString *day = [NSString stringWithFormat:@"%@日",_dayFeemodel.day];
                    [array addObject:day];
                }
                
                CGFloat use_fee = [_dayFeemodel.use_fee floatValue];
                CGFloat use_ele = [_dayFeemodel.use_ele floatValue];
                CGFloat med = [_dayFeemodel.med floatValue];
                CGFloat low = [_dayFeemodel.low floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",med+low]];
                [array addObject:[NSString stringWithFormat:@"%.2f",use_fee]];
                [array addObject:[NSString stringWithFormat:@"%.2f",med]];
                
                [array addObject:[NSString stringWithFormat:@"%.2f",low]];
                
                [self.ReddayFeeArr addObject:array];
            }
            NSLog(@"%@",self.ReddayFeeArr);
            if (self.ReddayFeeArr.count<11){
                int count = 11-self.ReddayFeeArr.count;
                for (int i =0; i<count; i++) {
                    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [self.ReddayFeeArr addObject:array];
                }
            }
            
            //            if (!_isFirst) {
            //                self.table4.dataArr = self.dayFeeArr;
            //            }
            //        [self setFourTable];
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
}
//用电月表格
- (void)requestFeeMonth{
    NSString *URL = [NSString stringWithFormat:@"%@/app/uses/use/get-use-month-data",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"用电月表格详情%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            
            [self.MonthFeeArr removeAllObjects];
            [self.TbaleTipArr5 removeAllObjects];
            [self.RedMonthFeeArr removeAllObjects];
            [self.RedTbaleTipArr5 removeAllObjects];
            NSMutableArray *allArray = [[NSMutableArray alloc] initWithCapacity:0];
            [allArray addObject:@"总计"];
            NSArray *content = responseObject[@"content"];
            NSDictionary *part = content[1];
            NSDictionary *full = content[0];
            CGFloat total_use_ele = [part[@"total_part_use_fee"] floatValue];
            CGFloat total_fixed_fee = [part[@"total_part_use"]floatValue];
            CGFloat total_med_ele = [part[@"total_part_med"]floatValue];
            CGFloat total_low_ele = [part[@"total_part_low"]floatValue];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_med_ele+total_low_ele]];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_use_ele]];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_med_ele]];
            
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_low_ele]];
            [self.TbaleTipArr5 addObject:allArray];
            NSMutableArray *allArray1 = [[NSMutableArray alloc] initWithCapacity:0];
            [allArray1 addObject:@"总计"];
            CGFloat total_use_ele1 = [full[@"total_full_use_fee"] floatValue];
            CGFloat total_fixed_fee1 = [full[@"total_full_use"]floatValue];
            CGFloat total_med_ele1 = [full[@"total_full_med"]floatValue];
            CGFloat total_low_ele1 = [full[@"total_full_low"]floatValue];
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_med_ele1+total_low_ele1]];
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_use_ele1]];
            
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_med_ele1]];
            
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_low_ele1]];
            [self.RedTbaleTipArr5 addObject:allArray1];
            for (NSDictionary *goodsDic in part[@"part_data"]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                _dayFeemodel =[[dayFeeModel alloc] initWithDictionary:goodsDic];
                NSInteger *number = [_dayFeemodel.month integerValue];
                if (number<10) {
                    NSString *day = [NSString stringWithFormat:@"0%@月",_dayFeemodel.month];
                    [array addObject:day];
                }else{
                    NSString *day = [NSString stringWithFormat:@"%@月",_dayFeemodel.month];
                    [array addObject:day];
                }
                
                CGFloat use_fee = [_dayFeemodel.use_fee floatValue];
                CGFloat use_ele = [_dayFeemodel.use_ele floatValue];
                CGFloat med = [_dayFeemodel.med floatValue];
                CGFloat low = [_dayFeemodel.low floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",med+low]];
                [array addObject:[NSString stringWithFormat:@"%.2f",use_fee]];
                [array addObject:[NSString stringWithFormat:@"%.2f",med]];
                
                [array addObject:[NSString stringWithFormat:@"%.2f",low]];
                [self.MonthFeeArr addObject:array];
            }
            NSLog(@"%@",self.MonthFeeArr);
            if (self.MonthFeeArr.count<11){
                int count = 11-self.MonthFeeArr.count;
                for (int i =0; i<count; i++) {
                    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [self.MonthFeeArr addObject:array];
                }
            }
            for (NSDictionary *goodsDic in full[@"full_data"]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                _dayFeemodel =[[dayFeeModel alloc] initWithDictionary:goodsDic];
                NSInteger *number = [_dayFeemodel.month integerValue];
                if (number<10) {
                    NSString *day = [NSString stringWithFormat:@"0%@月",_dayFeemodel.month];
                    [array addObject:day];
                }else{
                    NSString *day = [NSString stringWithFormat:@"%@月",_dayFeemodel.month];
                    [array addObject:day];
                }
                
                CGFloat use_fee = [_dayFeemodel.use_fee floatValue];
                CGFloat use_ele = [_dayFeemodel.use_ele floatValue];
                CGFloat med = [_dayFeemodel.med floatValue];
                CGFloat low = [_dayFeemodel.low floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",med+low]];
                [array addObject:[NSString stringWithFormat:@"%.2f",use_fee]];
                [array addObject:[NSString stringWithFormat:@"%.2f",med]];
                
                [array addObject:[NSString stringWithFormat:@"%.2f",low]];
                [self.RedMonthFeeArr addObject:array];
            }
            if (self.RedMonthFeeArr.count<11){
                int count = 11-self.RedMonthFeeArr.count;
                for (int i =0; i<count; i++) {
                    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [self.RedMonthFeeArr addObject:array];
                }
            }
            if (!_isFirst) {
                self.table5.dataArr = self.MonthFeeArr;
            }
            //        [self setFiveTable];
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
}
//用电年表格
- (void)requestFeeYear{
    NSString *URL = [NSString stringWithFormat:@"%@/app/uses/use/get-use-year-data",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"用电年表格详情%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            
            [self.YearFeeArr removeAllObjects];
            [self.TbaleTipArr6 removeAllObjects];
            [self.RedYearFeeArr removeAllObjects];
            [self.RedTbaleTipArr6 removeAllObjects];
            NSMutableArray *allArray = [[NSMutableArray alloc] initWithCapacity:0];
            [allArray addObject:@"总计"];
            NSArray *content = responseObject[@"content"];
            NSDictionary *full = content[0];
            NSDictionary *part = content[1];
            CGFloat total_use_ele = [part[@"total_part_use_fee"] floatValue];
            CGFloat total_fixed_fee = [part[@"total_part_use"] floatValue];
            CGFloat total_med_ele = [part[@"total_part_med"] floatValue];
            CGFloat total_low_ele = [part[@"total_part_low"] floatValue];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_med_ele+total_low_ele]];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_use_ele]];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_med_ele]];
            
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_low_ele]];
            [self.TbaleTipArr6 addObject:allArray];
            NSMutableArray *allArray1 = [[NSMutableArray alloc] initWithCapacity:0];
            [allArray1 addObject:@"总计"];
            CGFloat total_use_ele1 = [full[@"total_full_use_fee"] floatValue];
            CGFloat total_fixed_fee1 = [full[@"total_full_use"] floatValue];
            CGFloat total_med_ele1 = [full[@"total_full_med"] floatValue];
            CGFloat total_low_ele1 = [full[@"total_full_low"] floatValue];
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_med_ele1+total_low_ele1]];
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_use_ele1]];
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_med_ele1]];
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_low_ele1]];
            [self.RedTbaleTipArr6 addObject:allArray1];
            for (NSDictionary *goodsDic in part[@"part_data"]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                _dayFeemodel =[[dayFeeModel alloc] initWithDictionary:goodsDic];
                NSString *day = [NSString stringWithFormat:@"%@年",_dayFeemodel.year];
                [array addObject:day];
                CGFloat use_fee = [_dayFeemodel.use_fee floatValue];
                CGFloat use_ele = [_dayFeemodel.use_ele floatValue];
                CGFloat med = [_dayFeemodel.med floatValue];
                CGFloat low = [_dayFeemodel.low floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",med+low]];
                [array addObject:[NSString stringWithFormat:@"%.2f",use_fee]];
                [array addObject:[NSString stringWithFormat:@"%.2f",med]];
                
                [array addObject:[NSString stringWithFormat:@"%.2f",low]];
                [self.YearFeeArr addObject:array];
                NSLog(@"%@",_YearFeeArr);
            }
            NSLog(@"%@",self.YearFeeArr);
            if (self.YearFeeArr.count<11){
                int count = 11-self.YearFeeArr.count;
                for (int i =0; i<count; i++) {
                    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [self.YearFeeArr addObject:array];
                }
            }
            for (NSDictionary *goodsDic in full[@"full_data"]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                _dayFeemodel =[[dayFeeModel alloc] initWithDictionary:goodsDic];
                NSString *day = [NSString stringWithFormat:@"%@年",_dayFeemodel.year];
                [array addObject:day];
                CGFloat use_fee = [_dayFeemodel.use_fee floatValue];
                CGFloat use_ele = [_dayFeemodel.use_ele floatValue];
                CGFloat med = [_dayFeemodel.med floatValue];
                CGFloat low = [_dayFeemodel.low floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",med+low]];
                [array addObject:[NSString stringWithFormat:@"%.2f",use_fee]];
                [array addObject:[NSString stringWithFormat:@"%.2f",med]];
                
                [array addObject:[NSString stringWithFormat:@"%.2f",low]];
                [self.RedYearFeeArr addObject:array];
                NSLog(@"%@",_RedYearFeeArr);
            }
            NSLog(@"%@",self.RedYearFeeArr);
            if (self.RedYearFeeArr.count<11){
                int count = 11-self.RedYearFeeArr.count;
                for (int i =0; i<count; i++) {
                    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [self.RedYearFeeArr addObject:array];
                }
            }
            if (!_isFirst) {
                self.table6.dataArr = self.YearFeeArr;
            }
            //        [self setSixTable];
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
}

//发电日表格
- (void)requestGenDay{
    NSString *URL = [NSString stringWithFormat:@"%@/app/gens/gen/get-gen-day-data",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发电日表格详情%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            
            [self.dayGenArr removeAllObjects];
            [self.TbaleTipArr1 removeAllObjects];
            [self.ReddayGenArr removeAllObjects];
            [self.RedTbaleTipArr1 removeAllObjects];
            NSMutableArray *allArray = [[NSMutableArray alloc] initWithCapacity:0];
            NSArray *content = responseObject[@"content"];
            [allArray addObject:@"总计"];
            NSDictionary *part = content[1];
            NSDictionary *full = content[0];
            CGFloat total_gen = [part[@"total_part_gen"] floatValue];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_gen]];
            CGFloat total_fee = [part[@"total_part_gen_income"] floatValue];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_fee]];
            CGFloat total_use_self = [part[@"total_part_cash_income"] floatValue];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_use_self]];
            CGFloat up_net_ele = [part[@"total_part_economize_price"] floatValue];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",up_net_ele]];
            [self.TbaleTipArr1 addObject:allArray];
            NSMutableArray *allArray1 = [[NSMutableArray alloc] initWithCapacity:0];
            [allArray1 addObject:@"总计"];
            CGFloat total_gen1 = [full[@"total_full_gen"] floatValue];
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_gen1]];
            CGFloat total_fee1 = [full[@"total_full_gen_income"] floatValue];
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_fee1]];
            CGFloat total_use_self1 = [full[@"total_full_cash_income"] floatValue];
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_use_self1]];
            CGFloat up_net_ele1 = [full[@"total_full_economize_price"] floatValue];
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",up_net_ele1]];
            [self.RedTbaleTipArr1 addObject:allArray1];
            
            for (NSDictionary *goodsDic in part[@"part_data"]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                _dayGenmodel =[[dayGenModel alloc] initWithDictionary:goodsDic];
                NSInteger *number = [_dayGenmodel.day integerValue];
                if (number<10) {
                    NSString *day = [NSString stringWithFormat:@"0%@日",_dayGenmodel.day];
                    [array addObject:day];
                }else{
                    NSString *day = [NSString stringWithFormat:@"%@日",_dayGenmodel.day];
                    [array addObject:day];
                }
                
                CGFloat gen = [_dayGenmodel.gen floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",gen]];
                CGFloat gen_income = [_dayGenmodel.gen_income floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",gen_income]];
                CGFloat cash_income = [_dayGenmodel.cash_income floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",cash_income]];
                CGFloat economize_price = [_dayGenmodel.economize_price floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",economize_price]];
                [self.dayGenArr addObject:array];
            }
            if (self.dayGenArr.count<11){
                int count = 11-self.dayGenArr.count;
                for (int i =0; i<count; i++) {
                    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [self.dayGenArr addObject:array];
                }
            }
            for (NSDictionary *goodsDic in full[@"full_data"]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                _dayGenmodel =[[dayGenModel alloc] initWithDictionary:goodsDic];
                NSInteger *number = [_dayGenmodel.day integerValue];
                if (number<10) {
                    NSString *day = [NSString stringWithFormat:@"0%@日",_dayGenmodel.day];
                    [array addObject:day];
                }else{
                    NSString *day = [NSString stringWithFormat:@"%@日",_dayGenmodel.day];
                    [array addObject:day];
                }
                CGFloat gen = [_dayGenmodel.gen floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",gen]];
                CGFloat gen_income = [_dayGenmodel.gen_income floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",gen_income]];
                CGFloat cash_income = [_dayGenmodel.cash_income floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",cash_income]];
                CGFloat economize_price = [_dayGenmodel.economize_price floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",economize_price]];
                [self.ReddayGenArr addObject:array];
            }
            if (self.ReddayGenArr.count<11){
                int count = 11-self.ReddayGenArr.count;
                for (int i =0; i<count; i++) {
                    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [self.ReddayGenArr addObject:array];
                }
            }
            if (!_isFirst) {
                self.table1.dataArr = self.dayGenArr;
            }
            
            NSLog(@"%@",self.dayGenArr);
            
            //        [self setFirstTable];
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
}
//发电月表格
- (void)requestGenMonth{
    NSString *URL = [NSString stringWithFormat:@"%@/app/gens/gen/get-gen-month-data",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发电月表格%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            
            [self.MonthGenArr removeAllObjects];
            [self.TbaleTipArr2 removeAllObjects];
            [self.RedMonthGenArr removeAllObjects];
            [self.RedTbaleTipArr2 removeAllObjects];
            NSArray *content = responseObject[@"content"];
            NSDictionary *part = content[1];
            NSDictionary *full = content[0];
            NSMutableArray *allArray = [[NSMutableArray alloc] initWithCapacity:0];
            [allArray addObject:@"总计"];
            CGFloat total_gen = [part[@"total_part_gen"] floatValue];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_gen]];
            CGFloat total_fee = [part[@"total_part_gen_income"] floatValue];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_fee]];
            CGFloat total_use_self = [part[@"total_part_cash_income"] floatValue];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_use_self]];
            CGFloat up_net_ele = [part[@"total_part_economize_price"] floatValue];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",up_net_ele]];
            [self.TbaleTipArr2 addObject:allArray];
            NSMutableArray *allArray1 = [[NSMutableArray alloc] initWithCapacity:0];
            [allArray1 addObject:@"总计"];
            CGFloat total_gen1 = [full[@"total_full_gen"] floatValue];
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_gen1]];
            CGFloat total_fee1 = [full[@"total_full_gen_income"] floatValue];
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_fee1]];
            CGFloat total_use_self1 = [full[@"total_full_cash_income"] floatValue];
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_use_self1]];
            CGFloat up_net_ele1 = [full[@"total_full_economize_price"] floatValue];
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",up_net_ele1]];
            [self.RedTbaleTipArr2 addObject:allArray1];
            for (NSDictionary *goodsDic in part[@"part_data"]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                _dayGenmodel =[[dayGenModel alloc] initWithDictionary:goodsDic];
                NSInteger *number = [_dayGenmodel.month integerValue];
                if (number<10) {
                    NSString *day = [NSString stringWithFormat:@"0%@月",_dayGenmodel.month];
                    [array addObject:day];
                }else{
                    NSString *day = [NSString stringWithFormat:@"%@月",_dayGenmodel.month];
                    [array addObject:day];
                }
                
                CGFloat gen = [_dayGenmodel.gen floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",gen]];
                CGFloat gen_income = [_dayGenmodel.gen_income floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",gen_income]];
                CGFloat cash_income = [_dayGenmodel.cash_income floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",cash_income]];
                CGFloat economize_price = [_dayGenmodel.economize_price floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",economize_price]];
                [self.MonthGenArr addObject:array];
            }
            
            NSLog(@"%@",self.MonthGenArr);
            if (self.MonthGenArr.count<11){
                int count = 11-self.MonthGenArr.count;
                for (int i =0; i<count; i++) {
                    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [self.MonthGenArr addObject:array];
                }
            }
            for (NSDictionary *goodsDic in full[@"full_data"]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                _dayGenmodel =[[dayGenModel alloc] initWithDictionary:goodsDic];
                NSInteger *number = [_dayGenmodel.month integerValue];
                if (number<10) {
                    NSString *day = [NSString stringWithFormat:@"0%@月",_dayGenmodel.month];
                    [array addObject:day];
                }else{
                    NSString *day = [NSString stringWithFormat:@"%@月",_dayGenmodel.month];
                    [array addObject:day];
                }
                
                CGFloat gen = [_dayGenmodel.gen floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",gen]];
                CGFloat gen_income = [_dayGenmodel.gen_income floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",gen_income]];
                CGFloat cash_income = [_dayGenmodel.cash_income floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",cash_income]];
                CGFloat economize_price = [_dayGenmodel.economize_price floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",economize_price]];
                [self.RedMonthGenArr addObject:array];
            }
            
            NSLog(@"%@",self.MonthGenArr);
            if (self.RedMonthGenArr.count<11){
                int count = 11-self.RedMonthGenArr.count;
                for (int i =0; i<count; i++) {
                    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [self.RedMonthGenArr addObject:array];
                }
            }
            
            if (!_isFirst) {
                self.table2.dataArr = self.MonthGenArr;
            }
            //        [self setSecondTable];
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
}
//发电年表格
- (void)requestGenYear{
    NSString *URL = [NSString stringWithFormat:@"%@/app/gens/gen/get-gen-year-data",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发电年表格%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            
            [self.YearGenArr removeAllObjects];
            [self.TbaleTipArr3 removeAllObjects];
            [self.RedYearGenArr removeAllObjects];
            [self.RedTbaleTipArr3 removeAllObjects];
            NSArray *content = responseObject[@"content"];
            NSDictionary *part = content[1];
            NSDictionary *full = content[0];
            NSMutableArray *allArray = [[NSMutableArray alloc] initWithCapacity:0];
            [allArray addObject:@"总计"];
            CGFloat total_gen = [part[@"total_part_gen"] floatValue];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_gen]];
            CGFloat total_fee = [part[@"total_part_gen_income"] floatValue];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_fee]];
            CGFloat total_use_self = [part[@"total_part_cash_income"] floatValue];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",total_use_self]];
            CGFloat up_net_ele = [part[@"total_part_economize_price"] floatValue];
            [allArray addObject:[NSString stringWithFormat:@"%.2f",up_net_ele]];
            [self.TbaleTipArr3 addObject:allArray];
            NSMutableArray *allArray1 = [[NSMutableArray alloc] initWithCapacity:0];
            [allArray1 addObject:@"总计"];
            CGFloat total_gen1 = [full[@"total_full_gen"] floatValue];
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_gen1]];
            CGFloat total_fee1 = [full[@"total_full_gen_income"] floatValue];
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_fee1]];
            CGFloat total_use_self1 = [full[@"total_full_cash_income"] floatValue];
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",total_use_self1]];
            CGFloat up_net_ele1 = [full[@"total_full_economize_price"] floatValue];
            [allArray1 addObject:[NSString stringWithFormat:@"%.2f",up_net_ele1]];
            [self.RedTbaleTipArr3 addObject:allArray1];
            NSArray *partData = part[@"part_data"];
            for (int i=0; i<partData.count; i++) {
                for (NSDictionary *goodsDic in part[@"part_data"]) {
                    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                    _dayGenmodel =[[dayGenModel alloc] initWithDictionary:goodsDic];
                    NSString *day = [NSString stringWithFormat:@"%@年",_dayGenmodel.year];
                    [array addObject:day];
                    CGFloat gen = [_dayGenmodel.gen floatValue];
                    [array addObject:[NSString stringWithFormat:@"%.2f",gen]];
                    CGFloat gen_income = [_dayGenmodel.gen_income floatValue];
                    [array addObject:[NSString stringWithFormat:@"%.2f",gen_income]];
                    CGFloat cash_income = [_dayGenmodel.cash_income floatValue];
                    [array addObject:[NSString stringWithFormat:@"%.2f",cash_income]];
                    CGFloat economize_price = [_dayGenmodel.economize_price floatValue];
                    [array addObject:[NSString stringWithFormat:@"%.2f",economize_price]];
                    [self.YearGenArr addObject:array];
                }
                
            }
            
            if (self.YearGenArr.count<11){
                int count = 11-self.YearGenArr.count;
                for (int i =0; i<count; i++) {
                    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [self.YearGenArr addObject:array];
                }
            }
            NSLog(@"YearGenArr%@",self.YearGenArr);
            for (NSDictionary *goodsDic in full[@"full_data"]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                _dayGenmodel =[[dayGenModel alloc] initWithDictionary:goodsDic];
                NSString *day = [NSString stringWithFormat:@"%@年",_dayGenmodel.year];
                [array addObject:day];
                CGFloat gen = [_dayGenmodel.gen floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",gen]];
                CGFloat gen_income = [_dayGenmodel.gen_income floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",gen_income]];
                CGFloat cash_income = [_dayGenmodel.cash_income floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",cash_income]];
                CGFloat economize_price = [_dayGenmodel.economize_price floatValue];
                [array addObject:[NSString stringWithFormat:@"%.2f",economize_price]];
                [self.RedYearGenArr addObject:array];
            }
            
            if (self.RedYearGenArr.count<11){
                int count = 11-self.RedYearGenArr.count;
                for (int i =0; i<count; i++) {
                    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [array addObject:@"-"];
                    [self.RedYearGenArr addObject:array];
                }
            }
            NSLog(@"RedYearGenArr%@",self.RedYearGenArr);
            if (!_isFirst) {
                self.table3.dataArr = self.YearGenArr;
            }
            //        [self setThirdTable];
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
}

- (void)requestFaDian{
    NSString *URL = [NSString stringWithFormat:@"%@/app/gens/gen/get-gen-alert",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发电故障详情%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            
            NSMutableArray *fadianArr = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSDictionary *goodsDic in responseObject[@"content"]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
                fadianModel *model =[[fadianModel alloc] initWithDictionary:goodsDic];
                [array addObject:model.EventTime];
                //            [array addObject:_model.INVERTER_ERRORCODE];
                //            [array addObject:_model.INVERTER_STATUS];
                [array addObject:model.property];
                [array addObject:model.reason];
                [array addObject:model.detail];
                [fadianArr addObject:array];
                
            }
            
            
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
}

- (void)requestText{
    NSString *URL = [NSString stringWithFormat:@"%@/app/roofs/roof/get-voice-data",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"语音播报内容%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            NSDictionary *gen = responseObject[@"content"][@"gen"];
            NSString *fadian = [[NSString alloc] init];
            NSInteger status = [gen[@"status"] integerValue];
            NSInteger abnormal = [gen[@"abnormal"] integerValue];
            NSInteger breakdown = [gen[@"breakdown"] integerValue];
            if (status==0) {
                fadian = @"尊敬的主人,红彤电力小管家向您汇报今天我们家的发用电系统安全和效益方面的一些情况:\r\r安全方面:\r\r发电系统正常。";
            }
            if(abnormal>0){
                fadian = [NSString stringWithFormat:@"尊敬的主人,红彤电力小管家向您汇报今天我们家的发用电系统安全和效益方面的一些情况:\r\r安全方面:\r\r今日发电系统有%@次异常",gen[@"status"]];
            }
            if(breakdown>0){
                if (fadian.length>0) {
                    fadian = [NSString stringWithFormat:@"%@,有%@次故障。",fadian,gen[@"breakdown"]];
                }else{
                    fadian = [NSString stringWithFormat:@"今日发电系统有%@次故障。",gen[@"breakdown"]];
                }
            }NSLog(@"%@",fadian);
            NSDictionary *use = responseObject[@"content"][@"use"];
            NSString *yongdian = [[NSString alloc] init];
            NSInteger status1 = [use[@"status"] integerValue];
            if (status1==0) {
                yongdian = @"用电系统正常。";
            }else if(status1==1){
                NSArray *useArr = use[@"data"];
                for (int i=0; i<useArr.count; i++) {
                    yongdian = [NSString stringWithFormat:@"%@\r\r%@",yongdian,useArr[i]];
                }
                NSLog(@"%@",yongdian);
            }
            
            if (status==0&&status1==0) {
                self.yuyinText = [NSString stringWithFormat:@"%@%@ (为您点赞)。",fadian,yongdian];
            }else{
                self.yuyinText = [NSString stringWithFormat:@"%@%@",fadian,yongdian];
            }
            NSString *yuyin = [NSString stringWithFormat:@"%@\r\r%@",self.yuyinText,self.yuyinString];
            if (self.content) {
                self.content.text = [NSString stringWithFormat:@"%@",yuyin];
            }
            
        }
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
    
}

-(NSMutableArray *)statusArr {
    if (!_statusArr) {
        _statusArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _statusArr;
}

-(StatusModel *)statusModel{
    if (!_statusModel) {
        _statusModel = [[StatusModel alloc] init];
    }
    return _statusModel;
}

-(NSMutableArray *)FirstChartgenArr{
    if (!_FirstChartgenArr) {
        _FirstChartgenArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _FirstChartgenArr;
}

-(NSMutableArray *)FirstChartuseArr{
    if (!_FirstChartuseArr) {
        _FirstChartuseArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _FirstChartuseArr;
}

- (NSMutableArray *)blueArr{
    if (!_blueArr) {
        _blueArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _blueArr;
}
- (NSMutableArray *)yellowArr{
    if (!_yellowArr) {
        _yellowArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _yellowArr;
}
- (NSMutableArray *)redArr{
    if (!_redArr) {
        _redArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _redArr;
}
- (NSMutableArray *)greenArr{
    if (!_greenArr) {
        _greenArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _greenArr;
}
- (NSMutableArray *)dayGenArr{
    if (!_dayGenArr) {
        _dayGenArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dayGenArr;
}
- (NSMutableArray *)MonthGenArr{
    if (!_MonthGenArr) {
        _MonthGenArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _MonthGenArr;
}
- (NSMutableArray *)YearGenArr{
    if (!_YearGenArr) {
        _YearGenArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _YearGenArr;
}
- (NSMutableArray *)dayFeeArr{
    if (!_dayFeeArr) {
        _dayFeeArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dayFeeArr;
}
- (NSMutableArray *)YearFeeArr{
    if (!_YearFeeArr) {
        _YearFeeArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _YearFeeArr;
}
- (NSMutableArray *)MonthFeeArr{
    if (!_MonthFeeArr) {
        _MonthFeeArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _MonthFeeArr;
}
- (NSMutableArray *)ReddayGenArr{
    if (!_ReddayGenArr) {
        _ReddayGenArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _ReddayGenArr;
}
- (NSMutableArray *)RedMonthGenArr{
    if (!_RedMonthGenArr) {
        _RedMonthGenArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _RedMonthGenArr;
}
- (NSMutableArray *)RedYearGenArr{
    if (!_RedYearGenArr) {
        _RedYearGenArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _RedYearGenArr;
}
- (NSMutableArray *)ReddayFeeArr{
    if (!_ReddayFeeArr) {
        _ReddayFeeArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _ReddayFeeArr;
}
- (NSMutableArray *)RedYearFeeArr{
    if (!_RedYearFeeArr) {
        _RedYearFeeArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _RedYearFeeArr;
}
- (NSMutableArray *)RedMonthFeeArr{
    if (!_RedMonthFeeArr) {
        _RedMonthFeeArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _RedMonthFeeArr;
}

- (NSMutableArray *)TbaleTipArr1{
    if (!_TbaleTipArr1) {
        _TbaleTipArr1 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _TbaleTipArr1;
}
- (NSMutableArray *)TbaleTipArr2{
    if (!_TbaleTipArr2) {
        _TbaleTipArr2 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _TbaleTipArr2;
}
- (NSMutableArray *)TbaleTipArr3{
    if (!_TbaleTipArr3) {
        _TbaleTipArr3 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _TbaleTipArr3;
}
- (NSMutableArray *)TbaleTipArr4{
    if (!_TbaleTipArr4) {
        _TbaleTipArr4 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _TbaleTipArr4;
}
- (NSMutableArray *)TbaleTipArr5{
    if (!_TbaleTipArr5) {
        _TbaleTipArr5 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _TbaleTipArr5;
}
- (NSMutableArray *)TbaleTipArr6{
    if (!_TbaleTipArr6) {
        _TbaleTipArr6 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _TbaleTipArr6;
}
- (NSMutableArray *)RedTbaleTipArr1{
    if (!_RedTbaleTipArr1) {
        _RedTbaleTipArr1 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _RedTbaleTipArr1;
}
- (NSMutableArray *)RedTbaleTipArr2{
    if (!_RedTbaleTipArr2) {
        _RedTbaleTipArr2 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _RedTbaleTipArr2;
}
- (NSMutableArray *)RedTbaleTipArr3{
    if (!_RedTbaleTipArr3) {
        _RedTbaleTipArr3 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _RedTbaleTipArr3;
}
- (NSMutableArray *)RedTbaleTipArr4{
    if (!_RedTbaleTipArr4) {
        _RedTbaleTipArr4 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _RedTbaleTipArr4;
}
- (NSMutableArray *)RedTbaleTipArr5{
    if (!_RedTbaleTipArr5) {
        _RedTbaleTipArr5 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _RedTbaleTipArr5;
}
- (NSMutableArray *)RedTbaleTipArr6{
    if (!_RedTbaleTipArr6) {
        _RedTbaleTipArr6 = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _RedTbaleTipArr6;
}
-(dayGenModel *)dayGenmodel{
    if (!_dayGenmodel) {
        _dayGenmodel = [[dayGenModel alloc] init];
    }
    return _dayGenmodel;
}
-(dayFeeModel *)dayFeemodel{
    if (!_dayFeemodel) {
        _dayFeemodel = [[dayFeeModel alloc] init];
    }
    return _dayFeemodel;
}
- (void)newLogin{
    [MBProgressHUD showText:@"请重新登录"];
    [self performSelector:@selector(backTo) withObject: nil afterDelay:2.0f];
}

- (void)newLoginTwo{
    [MBProgressHUD showText:@"您的账号已过期,请重新登录"];
    [self performSelector:@selector(backTo) withObject: nil afterDelay:2.0f];
}

-(void)backTo{
    [self clearLocalData];
    OneLoginViewController *VC =[[OneLoginViewController alloc] init];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)clearLocalData{
    //极光推送取消设置标签和别名
    //    [JPUSHService setTags:nil alias:nil fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
    //    }];
    //
    [self removeTimer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    [userDefaults setValue:nil forKey:@"passName"];
    //    [userDefaults setValue:nil forKey:@"passWord"];
    [userDefaults setValue:nil forKey:@"token"];
    //    [userDefaults setValue:nil forKey:@"registerid"];
    [userDefaults synchronize];
    //    [HSingleGlobalData sharedInstance].passName = nil;
    //    [HSingleGlobalData sharedInstance].passWord  =nil;
    [HSingleGlobalData sharedInstance].token =nil;
    [HSingleGlobalData sharedInstance].BID =nil;
    [HSingleGlobalData sharedInstance].address =nil;
    [HSingleGlobalData sharedInstance].position =nil;
    [HSingleGlobalData sharedInstance].city =nil;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
//--------科大讯飞-----
#pragma mark - IFlySpeechSynthesizerDelegate

//开始播放

-(void)onSpeakBegin{
    NSLog(@"onSpeakBegin");
    CGPoint offset = CGPointMake(0, 0);
    [self.content setContentOffset:offset animated:YES];
    NSMutableArray  *arrayM=[NSMutableArray array];
    for (int i=0; i<2; i++) {
        [arrayM addObject:[UIImage imageNamed:[NSString stringWithFormat:@"小人张嘴%d",i+1]]];
    }
    //设置动画数组
    [self.xiaorenImage setAnimationImages:arrayM];
    //设置动画播放次数
    [self.xiaorenImage setAnimationRepeatCount:4000];
    //设置动画播放时间
    [self.xiaorenImage setAnimationDuration:1.0];
    //开始动画
    [self.xiaorenImage startAnimating];
    NSMutableArray  *arrayM1=[NSMutableArray array];
    for (int i=0; i<3; i++) {
        [arrayM1 addObject:[UIImage imageNamed:[NSString stringWithFormat:@"laba%d",i+1]]];
    }
    //设置动画数组
    [self.labaImage setAnimationImages:arrayM1];
    //设置动画播放次数
    [self.labaImage setAnimationRepeatCount:4000];
    //设置动画播放时间
    [self.labaImage setAnimationDuration:1.0];
    //开始动画
    [self.labaImage startAnimating];
    
    
    
}
//缓冲进度
-(void)onBufferProgress:(int)
progress message:(NSString *)msg{
    
    NSLog(@"bufferProgress:%d,message:%@",progress,msg);
    
}
//播放进度
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos{
    NSLog(@"progress:%d,beginPos:%d,endPos:%d",progress,beginPos,endPos);
    
    CGFloat offsetY = (self.content.contentSize.height-self.content.frame.size.height)/100*progress;
    CGPoint offset = CGPointMake(0, offsetY);
    if (progress>20) {
        [self.content setContentOffset:offset animated:YES];
    }
    
    
    if (progress==100) {
        [self.labaImage stopAnimating];
        [self.xiaorenImage stopAnimating];
    }
}

//暂停播放
-(void)onSpeakPaused{
    [self.labaImage stopAnimating];
    [self.xiaorenImage stopAnimating];
    
    
}
//恢复播放
-(void)onSpeakResumed{
    
    
    
}



- (void)fadianguzhang{
    NSLog(@"fadianguzhang");
    FaPowerDetailViewController *vc = [[FaPowerDetailViewController alloc] init];
    [self clearGenNum];
    self.alert_gen_num = 0;
    self.topSmallBall.hidden = YES;
//    vc.hidesBottomBarWhenPushed = YES;
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    [user setInteger:0 forKey:@"fadianguzhang"];
//    NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
//    // 3.通过 通知中心 发送 通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

-(void)clearGenNum{
    NSString *URL = [NSString stringWithFormat:@"http://aipv6.xinyuntec.com/app/roofs/roof/del-alert-num"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:@"1" forKey:@"type"];
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"清除发电报警%@",responseObject);
        }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    

}
-(void)clearUseNum{
    NSString *URL = [NSString stringWithFormat:@"http://aipv6.xinyuntec.com/app/roofs/roof/del-alert-num"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:@"2" forKey:@"type"];
    [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"清除用电报警%@",responseObject);
    }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
    
}


- (void)yongdianguzhang{
    NSLog(@"yongdianguzhang");
    PowerDetailViewController *vc = [[PowerDetailViewController alloc] init];
    [self clearUseNum];
    self.alert_use_num = 0;
    self.downSmallBall.hidden = YES;
    vc.hidesBottomBarWhenPushed = YES;
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    [user setInteger:0 forKey:@"yongdianguzhang"];
//    NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
//    // 3.通过 通知中心 发送 通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)yongdianzhengce{
    NSLog(@"yongdianzhengce");
    UsePowerViewController *vc = [[UsePowerViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)fadianzhengce{
    NSLog(@"fadianzhengce");
    PowerViewController *vc = [[PowerViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//结束回调
-(void)onCompleted:(IFlySpeechError *) error{
    NSLog(@"error%@",error);
    [self.xiaorenImage stopAnimating];
    [self.labaImage stopAnimating];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
- (void)refresh{
    //    [_dataArray addObject:@"freshData"];
    
    [self requestStatus];
    [self requestMessage];
    [self requestText];
    [self requestFeeDay];
    [self requestFeeMonth];
    [self requestFeeYear];
    [self requestGenDay];
    [self requestGenMonth];
    [self requestGenYear];
    [self requestFirstChart];
    [self requestSecondChart];
    [self performSelector:@selector(remove) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    [self performSelector:@selector(setUI) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    [self performSelector:@selector(requestWeather) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    
    [self performSelector:@selector(setFirstChart) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    [self performSelector:@selector(setSecondChart) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    [self performSelector:@selector(setFirstTable) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    [self performSelector:@selector(setSecondTable) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    [self performSelector:@selector(setThirdTable) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    [self performSelector:@selector(setFourTable) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    [self performSelector:@selector(setFiveTable) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    [self performSelector:@selector(setSixTable) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    [self performSelector:@selector(endRefresh) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
    
    
}
- (void)endRefresh{
   [self.bgTable.mj_header endRefreshing];
}



- (void)remove{
    [self.visualEffectView removeFromSuperview];
    self.visualEffectView = nil;
    [self.clickView removeFromSuperview];
    self.clickView = nil;
    [self.chartView removeFromSuperview];
    [self removeTimer];
    [self.bgTable removeFromSuperview];
    [self.bgTable reloadData];
    [self.table11 removeFromSuperview];
    [self.table22 removeFromSuperview];
    [self.table33 removeFromSuperview];
    [self.table44 removeFromSuperview];
    [self.table55 removeFromSuperview];
    [self.table66 removeFromSuperview];
    [self.Redtable11 removeFromSuperview];
    [self.Redtable22 removeFromSuperview];
    [self.Redtable33 removeFromSuperview];
    [self.Redtable44 removeFromSuperview];
    [self.Redtable55 removeFromSuperview];
    [self.Redtable66 removeFromSuperview];
    [self.table1 removeFromSuperview];
    [self.table2 removeFromSuperview];
    [self.table3 removeFromSuperview];
    [self.table4 removeFromSuperview];
    [self.table5 removeFromSuperview];
    [self.table6 removeFromSuperview];
    [self.Redtable1 removeFromSuperview];
    [self.Redtable2 removeFromSuperview];
    [self.Redtable3 removeFromSuperview];
    [self.Redtable4 removeFromSuperview];
    [self.Redtable5 removeFromSuperview];
    [self.Redtable6 removeFromSuperview];
    [self.bgimage1 removeFromSuperview];
    [self.bgimage2 removeFromSuperview];
    [self.tableScroll removeFromSuperview];
    [self.tableScroll1 removeFromSuperview];
    
}


@end
