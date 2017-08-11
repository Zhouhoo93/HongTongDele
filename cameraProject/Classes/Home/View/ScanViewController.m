//
//  ScanViewController.m
//  QRCodeDemo
//
//  Created by huanxin xiong on 2016/12/5.
//  Copyright © 2016年 xiaolu zhao. All rights reserved.
//

#import "ScanViewController.h"
// 二维码需要的框架
#import <AVFoundation/AVFoundation.h>
#import "UIViewController+Message.h"
#import "MaskView.h"
#import "HSingleGlobalData.h"
#import "ConnectViewController.h"
#import "sendViewController.h"

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

// 创建AVCaptureSession
@property (nonatomic, strong) AVCaptureSession *session;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MaskView *view = [[MaskView alloc] initWithFrame:CGRectMake(0, 64, KWidth, KHeight-64)];
        UIImageView *line = [[UIImageView alloc] initWithFrame: CGRectMake((KWidth-300)/2, (KHeight-364)/2, 300, 9)];
        line.image = [UIImage imageNamed:@"line"];
        [view addSubview:line ];
        /* 添加动画 */
        [UIView animateWithDuration:2.5 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
            line.frame = CGRectMake((KWidth-300)/2, (KHeight-364)/2+250, 300, 9);
        } completion:nil];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    
    //利用session生成一个AVCaptureVideoPreviewLayer加到view的layer上，就可以实时显示摄像头捕捉的内容了
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //开始捕获
    [self.session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //停止捕获
    [super viewWillDisappear:animated];
    [self.session stopRunning];
}

#pragma makr - AVCaptureMetadataOutputObjectsDelegate
//扫描出结果后调用该代理方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        NSString *BID =[metadataObject.stringValue substringWithRange:NSMakeRange(8,18)];
        NSString *GPRS =[metadataObject.stringValue substringWithRange:NSMakeRange(29,4)];
        NSLog(@"%@",BID);
        NSLog(@"%@",GPRS);
        if ([GPRS isEqualToString:@"GPRS"]) {
            sendViewController *vc = [[sendViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
        [self requestBID:BID];
        }
    }
}

- (void)requestBID:(NSString *)bid{
    NSString *URL = [NSString stringWithFormat:@"http://aipv6.xinyuntec.com/app/roofs/roof/get-bid-status?bid=%@",bid];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json",@"text/JavaScript", nil];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"查询bid%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            NSString *bidFirst =[bid substringWithRange:NSMakeRange(0,2)];
            NSLog(@"%@",bidFirst);
            if ([bidFirst isEqualToString:@"01"]){
                NSLog(@"是发用电bid");
                [HSingleGlobalData sharedInstance].BID = bid;
                //        [self showAlertWithTitle:@"扫描结果" message:metadataObject.stringValue handler:^(UIAlertAction *action) {
                //            [self.session startRunning];
                //        }];
                ConnectViewController *vc = [[ConnectViewController alloc] init];
                UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
                self.navigationItem.backBarButtonItem = barButtonItem;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [MBProgressHUD showText:@"不是发用电二维码,请重新扫描"];
            }

            
        }else{
        [MBProgressHUD showText:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"errorMsg"]]];
        }
        //        self.fayongdianArr = responseObject[@"content"][@"roof"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"查询bid%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    


}

#pragma mark - Getter
- (AVCaptureSession *)session
{
    if (!_session) {
        _session = ({
            //获取摄像设备
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            //创建输入流
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            if (!input)
            {
                return nil;
            }
            
            //创建输出流
            AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
            //设置代理 在主线程里刷新
            [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            //设置扫描区域的比例
            CGFloat width = 300 / CGRectGetHeight(self.view.frame);
            CGFloat height = 300 / CGRectGetWidth(self.view.frame);
            output.rectOfInterest = CGRectMake((1 - width) / 2, (1- height) / 2, width, height);
            
            AVCaptureSession *session = [[AVCaptureSession alloc] init];
            //高质量采集率
            [session setSessionPreset:AVCaptureSessionPresetHigh];
            [session addInput:input];
            [session addOutput:output];
            
            //设置扫码支持的编码格式(这里设置条形码和二维码兼容)
            output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                           AVMetadataObjectTypeEAN13Code,
                                           AVMetadataObjectTypeEAN8Code,
                                           AVMetadataObjectTypeCode128Code];
            
            session;
        });
    }
    return  _session;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
