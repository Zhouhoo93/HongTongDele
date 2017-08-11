//
//  CommentViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/7/6.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "CommentViewController.h"
#import "LiuqsEmotionPageView.h"
#import "LiuqsTextAttachment.h"
#import "XYFeedCell.h"
#define bottomBarH 40
#define sendBtnW 60
#define pages 4
@interface CommentViewController ()<UIScrollViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property(nonatomic, strong) UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic, strong) UIScrollView *baseView;

@property(nonatomic, strong) NSDictionary *emojiDict;
//表情大小需要根据字体计算
@property(assign, nonatomic) CGFloat  emotionSize;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.baseView];
    self.baseView.hidden = YES;
    self.titleLabel.text = self.LabelText;
    self.pageControl.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendBtnClick:(id)sender {
    NSLog(@"输入框内容:%@",self.commentTextView.text);
    [self requestComment];
}

- (IBAction)faceBtnClick:(id)sender {
    [self.commentTextView resignFirstResponder];
    
    if (self.baseView.hidden) {
        self.baseView.hidden = NO;
        self.pageControl.hidden = NO;
    }else{
        self.baseView.hidden = YES;
        self.pageControl.hidden = YES;
    }
    
}
-(void)requestComment{
    NSString *URL = [NSString stringWithFormat:@"%@/up-comment",kUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    NSString *userID = [NSString stringWithFormat:@"%d",self.userID ];
//     NSString *ID = [NSString stringWithFormat:@"%d",self.ID];
    [parameters setValue:self.userID forKey:@"userid"];
    [parameters setValue:self.ID forKey:@"id"];
    [parameters setValue:self.commentTextView.text forKey:@"comment"];
    [parameters setValue:self.touImage forKey:@"user_pic"];
    [parameters setValue:self.name forKey:@"user_name"];
    NSLog(@"%@",parameters);
    [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"正确%@",responseObject);
        if ([responseObject[@"result"][@"success"] intValue] ==0) {
            NSString *str = responseObject[@"result"][@"errorMsg"];
            [MBProgressHUD showText:str];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
            if ([self.delegate respondsToSelector:@selector(backToVC)]) {
                
                // 4、委托方：发送方，调用协议方法，发送传递值
                [self.delegate backToVC];
            }

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"失败%@",error);
        //        [MBProgressHUD showText:@"%@",error[@"error"]];
    }];
    

}


//根视图（最底部滚动视图）
- (UIScrollView *)baseView {
    
    if (!_baseView) {
        _baseView = [[UIScrollView alloc]init];
        _baseView.pagingEnabled = YES;
        _baseView.bounces = NO;
        _baseView.delegate = self;
        _baseView.showsHorizontalScrollIndicator = NO;
        self.baseView.frame = CGRectMake(0, KHeight-(rows * emotionW +(rows + 1) * pageH)-20,KWidth, rows * emotionW +(rows + 1) * pageH);
        self.baseView.contentSize = CGSizeMake(KWidth * pages + 1, rows * emotionW +(rows + 1) * pageH);
        if (!self.font) {self.font = [UIFont systemFontOfSize:17.0f];}
        _emotionSize = [self heightWithFont:self.font];
        self.baseView.userInteractionEnabled = YES;
        self.baseView.backgroundColor = [UIColor grayColor];
        [self creatPageViews];
    }
    return _baseView;
}
//存放表情图片的数组
- (NSDictionary *)emojiDict {
    
    if (!_emojiDict) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ISEmojiList" ofType:@"plist"];
        self.emojiDict = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _emojiDict;
}

//根据页数（通过拥有的表情的个数除以每页表情数计算出来）创建pageView
- (void)creatPageViews {
    
    for (int i = 0; i < pages; i ++) {
        LiuqsEmotionPageView *pageView = [[LiuqsEmotionPageView alloc]init];
        pageView.page = i;
        [self.baseView addSubview:pageView];
        pageView.frame = CGRectMake(i * KWidth, 0, screenW, rows * emotionW +(rows + 1) * pageH);
        __weak typeof (self) weakSelf = self;
        [pageView setDeleteButtonClick:^(LiuqsButton *deleteButton) {
            [weakSelf deleteBtnClick:deleteButton];
        }];
        [pageView setEmotionButtonClick:^(LiuqsButton *emotionButton) {
            [weakSelf insertEmoji:emotionButton];
        }];
    }
}

//删除按钮事件
- (void)deleteBtnClick:(LiuqsButton *)btn {
    
    [self.commentTextView deleteBackward];
}

- (UIPageControl *)pageControl {
    
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.numberOfPages = 4;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        _pageControl.hidesForSinglePage = YES;
        self.pageControl.frame = CGRectMake(KWidth/2-75, CGRectGetMaxY(self.baseView.frame) - 5, KWidth, 10);
        
    }
    return _pageControl;
}

//点击表情时，插入图片到输入框
- (void)insertEmoji:(LiuqsButton *)btn {
    NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
    NSArray *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //    NSLog(@"%@",rootDict[0]);
    int index = [btn.emotionName intValue]-101;
    
    self.commentTextView.text = [NSString stringWithFormat:@"%@%@",self.commentTextView.text,rootDict[index]];
    //    //创建附件
    //    LiuqsTextAttachment *emojiTextAttachment = [LiuqsTextAttachment new];
    //    NSString *emojiTag = [self getKeyForValue:btn.emotionName fromDict:self.emojiDict];
    //    emojiTextAttachment.emojiTag = emojiTag;
    //    //取到表情对应的表情
    //    NSString *imageName = btn.emotionName;
    //    //给附件设置图片
    //    emojiTextAttachment.image = [UIImage imageNamed:imageName];
    //    // 给附件设置尺寸
    //    emojiTextAttachment.bounds = CGRectMake(0, -4, _emotionSize, _emotionSize);
    //    //textview插入富文本，用创建的附件初始化富文本
    //    [_commentTextView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment] atIndex:_commentTextView.selectedRange.location];
    //    _commentTextView.selectedRange = NSMakeRange(_commentTextView.selectedRange.location + 1, _commentTextView.selectedRange.length);
    
    //重设输入框字体
    [self resetTextStyle];
}
- (void)resetTextStyle {
    
    NSRange wholeRange = NSMakeRange(0, _commentTextView.textStorage.length);
    [_commentTextView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [_commentTextView.textStorage addAttribute:NSFontAttributeName value:self.font range:wholeRange];
    [self.commentTextView scrollRectToVisible:CGRectMake(0, 0, _commentTextView.contentSize.width, _commentTextView.contentSize.height) animated:NO];
    
}

#pragma mark ==== scrollView代理 ====
//改变pageControl
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5);
}

#pragma mark ==== 工具 ====
//根据字体计算表情的高度
- (CGFloat)heightWithFont:(UIFont *)font {
    
    if (!font){font = [UIFont systemFontOfSize:17];}
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize maxsize = CGSizeMake(100, MAXFLOAT);
    CGSize size = [@"/" boundingRectWithSize:maxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size.height;
}
//通过value获取到对应的key
- (NSString *)getKeyForValue:(NSString *)value fromDict:(NSDictionary *)dict {
    
    __block NSString *resultKey;
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if ([obj isEqualToString:value]) {
            resultKey = key;
        }
    }];
    return resultKey;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        self.commentTextView.text = @"请输入评论内容..";
        self.commentTextView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请输入评论内容.."]){
        self.commentTextView.text=@"";
        self.commentTextView.textColor=[UIColor blackColor];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
