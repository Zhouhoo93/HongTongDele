//
//  DisViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/7/5.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "DisViewController.h"
#import "DisTableViewCell.h"
#import "XYFeedCell.h"
#import "XYHeaderView.h"
#import "XYFeedModel.h"
#import "UICollectionView+XYTemplateLayoutCell.h"
#import "UICollectionView+XYTemplateReusableView.h"
#import "CommentViewController.h"
#import "repairViewController.h"
#import "ChatListViewController.h"
#import "commentModel.h"
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define ScreenW [UIScreen mainScreen].bounds.size.width
static NSString * const kXYFeedCell = @"XYFeedCell";
static NSString * const kXYHeaderView = @"XYHeaderView";
@interface DisViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,zanBtnDelegate,popBtnDelegate,UIWebViewDelegate>
@property (strong, nonatomic)  UICollectionView *collectionView;
@property (retain, nonatomic) NSArray *data;
@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic,copy) NSString *userID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *touImage;
@property (nonatomic,strong)XYFeedModel *model;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic, strong) UIView* commentView;
@property (nonatomic, strong) UIView* comment;
@property (nonatomic,assign)BOOL isCreat;
@end

@implementation DisViewController

-(void)dealloc{
    self.webView.delegate = nil;
    self.webView.scrollView.delegate = nil;
     [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
       [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setUI];
    [self requestHeaderImg];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    //设置对话框文字
    HUD.labelText = @"请稍等";
    //显示对话框
    [HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        sleep(1);
    } completionBlock:^{
        //操作执行完后取消对话框
        [HUD removeFromSuperview];
        //        HUD = nil;
    }];

    
    
    // Do any additional setup after loading the view.
}

- (void)setUI{
//    UIView *we = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight/667*400)];
//    UIScrollView *we = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
//    we.backgroundColor = [UIColor whiteColor];
//    we.contentSize = CGSizeMake(KWidth, KHeight/667*(667+267));
//    [self.view addSubview:we];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, KWidth, KHeight-64)];
    // 2.创建URL
    NSString *str = [NSString stringWithFormat:@"http://aipv6.xinyuntec.com/admin/comment#/article_show/%@",self.article_id];
    NSURL *url = [NSURL URLWithString:str];
    // 3.创建Request
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    // 4.加载网页
    [self.webView loadRequest:request];
    self.webView.delegate= self;
    self.webView.tag = 1314;
    self.webView.scrollView.delegate = self;
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
    // 5.最后将webView添加到界面
    [self.view addSubview:self.webView];
    
    self.commentView = self.webView.scrollView.subviews[0];
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 0)];
    [self.webView addSubview:headerImageView];

    CGRect frame = self.commentView.frame;
    frame.origin.y = CGRectGetMaxY(headerImageView.frame);
    self.commentView.frame = frame;

    [self.webView sendSubviewToBack:headerImageView];

    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor clearColor];
    headView.frame = CGRectMake(0, 0, KWidth, 0);
    [self.webView.scrollView addSubview:headView];


}
-(void)writeBtnClick{
    CommentViewController *vc = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil];
    vc.userID = self.userID;
    vc.LabelText = self.title1;
    vc.ID = self.ID;
    vc.name = self.name;
    vc.touImage = self.touImage;
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
    
//    ChatListViewController *chatList = [[ChatListViewController alloc] init];
//    
//    [self.navigationController pushViewController:chatList animated:YES];

}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return  _dataArr;
}

-(XYFeedModel *)model{
    if (!_model) {
        _model = [[XYFeedModel alloc] init];
    }
    return _model;
}
- (void)backToVC{
    [self requestComment];
//    [self.collectionView reloadData];
}
- (void)requestHeaderImg{
    NSString *URL = [NSString stringWithFormat:@"%@/app/users/user/1",kUrl];
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
        NSLog(@"获取userID%@",responseObject);
        self.userID = responseObject[@"content"][@"id"];
        self.touImage = responseObject[@"content"][@"headimgurl"];
        self.name = responseObject[@"content"][@"nickname"];
        [self requestComment];
    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
}

- (void)requestComment{
    NSString *URL = [NSString stringWithFormat:@"%@/select-comment",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.ID forKey:@"id"];
    [parameters setValue:self.userID forKey:@"userid"];
    NSLog(@"文章ID:%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"评论%@",responseObject);
//        self.userID = responseObject[@"content"][@"id"];
        [self.dataArr removeAllObjects];
        for (NSDictionary *dic in responseObject[@"content"]) {
            _model = [[XYFeedModel alloc] initWithDictionary:dic];
            [self.dataArr addObject:_model];
        }
            [self.collectionView reloadData];
        
        
    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
}



- (void)zan:(NSString *)pinglunnum{
    NSString *URL = [NSString stringWithFormat:@"%@/zan",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:@"1" forKey:@"god"];
    [parameters setValue:pinglunnum forKey:@"id"];
    [parameters setValue:self.userID forKey:@"user_id"];
    NSLog(@"点赞参数%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"点赞成功%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            [self requestComment];
        }else{
            NSString *str = responseObject[@"result"][@"errorMsg"];
            [MBProgressHUD showText:str];
        }

       
    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             NSLog(@"%@",error);  //这里打印错误信息
         }];
    
}

- (void)quxiaozan:(NSString *)pinglunnum{
    NSString *URL = [NSString stringWithFormat:@"%@/zan",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSLog(@"token is :%@",token);
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:@"0" forKey:@"god"];
    [parameters setValue:pinglunnum forKey:@"id"];
    [parameters setValue:self.userID forKey:@"user_id"];
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"取消点赞%@",responseObject);
        if([responseObject[@"result"][@"success"] intValue] ==1){
            [self requestComment];
        }else{
            NSString *str = responseObject[@"result"][@"errorMsg"];
            [MBProgressHUD showText:str];
        }
        
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
              NSLog(@"%@",error);  //这里打印错误信息
          }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Initialize
- (void)setUpViews{
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XYFeedCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kXYFeedCell];

}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XYFeedCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kXYFeedCell forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = self.dataArr[indexPath.item];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [collectionView xy_getCellSizeForIdentifier:kXYFeedCell width:ScreenW config:^(XYFeedCell * cell) {
        cell.model = self.dataArr[indexPath.item];
    }];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 10, 0);
}

-(void)addObserverForWebViewContentSize{
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
}
- (void)removeObserverForWebViewContentSize{
    [self.comment removeFromSuperview];
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}
//以下是监听结果回调事件：
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //在这里边添加你的代码
    if([keyPath isEqualToString:keyPath]){
    [self layoutCell];
    }
    
}
//设置footerView的合理位置
- (void)layoutCell{
    //取消监听，因为这里会调整contentSize，避免无限递归
    [self removeObserverForWebViewContentSize];
    UIView *viewss = [self.view viewWithTag:99999];
    CGSize contentSize = self.webView.scrollView.contentSize;
    

    self.comment = [[UIView alloc] initWithFrame:CGRectMake(0, contentSize.height, KWidth, 367)];
    self.comment.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.webView addSubview:self.comment];
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(KWidth/2-50, 10, 100, 20)];
    topLabel.text = @"精选留言";
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.textColor = [UIColor grayColor];
    topLabel.font = [UIFont systemFontOfSize:13];
    [self.comment addSubview:topLabel];
    
    UIButton *writeBtn = [[UIButton alloc] initWithFrame:CGRectMake(KWidth-100, 35, 70, 20)];
    writeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [writeBtn setImage:[UIImage imageNamed:@"bianj"]forState:UIControlStateNormal];
    [writeBtn setTitle:@" 写留言" forState:UIControlStateNormal];
    [writeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [writeBtn addTarget:self action:@selector(writeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.comment addSubview:writeBtn];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置每个item的大小，
    flowLayout.itemSize = CGSizeMake(KWidth, 72);
    //    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    // 设置列的最小间距
    flowLayout.minimumInteritemSpacing = 0;
    // 设置最小行间距
    flowLayout.minimumLineSpacing = 15;
    // 设置布局的内边距
    flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    // 滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, KWidth, KHeight/667*307) collectionViewLayout:flowLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        //    writeTable.separatorStyle = NO;
        [self.comment addSubview:self.collectionView];
    
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.title = @"通知";
    [self setUpViews];
    
    [self.webView.scrollView addSubview:self.comment];
    
    self.webView.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height+367);
       //重新监听
    [self addObserverForWebViewContentSize];
}
//- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
//    CGFloat curContentSizeHeight = [aWebView.scrollView contentSize].height;
//    
//    NSString *curHeight = [aWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
//    
//    CGFloat height = [curHeight floatValue];
//    
//    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
//    
//    float resultContentSizeHeight = MAX(MAX(height, fittingSize.height),curContentSizeHeight);
//}

- (void) webViewDidFinishLoad:(UIWebView *)webView {
   
}

#pragma mark - Actions

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
