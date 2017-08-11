//
//  PersonalViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/1/16.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "PersonalViewController.h"
#import "PersonalTableViewCell.h"
#import "ModifyViewController.h"
@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic,strong) UIAlertView *SEXAlert;
@property (nonatomic,strong) UITableView *tableView;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@implementation PersonalViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
//    [_tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self setTableView];
    self.title = @"账户中心";
}

- (void)setTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
}
#pragma mark - tableView数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    
    return KHeight-4*44-64;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = RGBColor(243, 243, 243);
    return footView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"MineTableViewCell";
    // 2.从缓存池中取出cell
    PersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3.如果缓存池中没有cell
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"PersonalTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.backgroundColor = [UIColor clearColor];
        cell.leftLabel.font = [UIFont systemFontOfSize:14];
        
        //首先得拿到照片的路径，也就是下边的string参数，转换为NSData型。
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.headimgurl]];
        //然后就是添加照片语句，这次不是`imageWithName`了，是 imageWithData。
        cell.touXiangImage.image = [UIImage imageWithData:data];
        switch (indexPath.row) {
            case 0:
                cell.leftLabel.text = @"头像";
                cell.touXiangImage.layer.masksToBounds = YES;
                cell.touXiangImage.layer.cornerRadius = 18;
                cell.rightLabel.hidden = YES;
                break;
            case 1:
               cell.leftLabel.text = @"昵称";
                cell.touXiangImage.hidden = YES;
                cell.rightLabel.hidden = NO;
                cell.rightLabel.text = self.name?self.name:[[NSUserDefaults standardUserDefaults] valueForKey:@"phone"];
                break;
            case 2:
               cell.leftLabel.text = @"性别";
                cell.touXiangImage.hidden = YES;
                cell.rightLabel.hidden = NO;
                if ([self.sex isEqualToString:@"0"]) {
                    cell.rightLabel.text = @"未选择性别";
                }else if ([self.sex isEqualToString:@"1"]){
                    cell.rightLabel.text = @"男";
                }else{
                    cell.rightLabel.text = @"女";
                }
                break;
            case 3:
                cell.leftLabel.text = @"修改密码";
                cell.touXiangImage.hidden = YES;
                cell.rightLabel.hidden = YES;
                break;
            default:
                break;
        }
    }
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        //判断手机的系统,8.0以上使用UIAlertController,一下使用UIAlertView
        if (iOS8) {
            
            self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            alert.view.tintColor = [UIColor blackColor];
            //通过拍照上传图片
            UIAlertAction * takingPicAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    
                    UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
                    imagePicker.delegate = self;
                    imagePicker.allowsEditing = YES;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }
                
            }];
            //从手机相册中选择上传图片
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                    UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
                    imagePicker.delegate = self;
                    imagePicker.allowsEditing = YES;
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }
                
            }];
            
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:takingPicAction];
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }else{
            
            UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择", nil];
            [actionSheet showInView:self.view];
        }
    }else if(indexPath.row == 2){
        self.SEXAlert = [[UIAlertView alloc] initWithTitle:@"设置" message:@"请选择您的性别" delegate:self cancelButtonTitle:@"男" otherButtonTitles:@"女", nil];
        [self.SEXAlert show];
    }else if(indexPath.row == 1){
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"设置" message:@"请输入您的昵称" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
        alertview.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertview show];
    }else if(indexPath.row == 3){
        ModifyViewController *vc = [[ModifyViewController alloc] initWithNibName:@"ModifyViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }


}




-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView == _SEXAlert){
        if (buttonIndex == 0) {
            NSString *url = [NSString stringWithFormat:@"%@/app/users/user/1",kUrl];
            //1。创建管理者对象
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
            manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            manager.requestSerializer = requestSerializer;
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *token = [userDefaults valueForKey:@"token"];
            [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                [parameters setValue:@"1" forKey:@"sex"];
            [manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"上传性别%@",responseObject);
                self.sex = @"1";
                [self.tableView reloadData];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];

        }else{
            NSString *url = [NSString stringWithFormat:@"%@/app/users/user/1",kUrl];
            //1。创建管理者对象
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
            manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            manager.requestSerializer = requestSerializer;
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *token = [userDefaults valueForKey:@"token"];
            [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setValue:@"2" forKey:@"sex"];
            [manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"上传性别%@",responseObject);
                self.sex = @"2";
                [self.tableView reloadData];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];

        }
    }else{
       UITextField *nameField = [alertView textFieldAtIndex:0];
        NSString *str = nameField.text;
        if (buttonIndex ==0 ) {
            NSString *url = [NSString stringWithFormat:@"%@/app/users/user/1",kUrl];
            //1。创建管理者对象
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
            manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            manager.requestSerializer = requestSerializer;
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *token = [userDefaults valueForKey:@"token"];
            [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            [parameters setValue:str forKey:@"nickname"];
            [manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"上传昵称%@",responseObject);
//                NSString *str = nameField.text;
                self.name = str;
//                NSUserDefaults *userDefaults = [[NSUserDefaults standardUserDefaults];
                [userDefaults setValue:self.name forKey:@"name"];
                [_myDelegate genggai];
                [self.tableView reloadData];
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];

        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 调用系统相册及拍照功能实现方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * chosenImage = info[UIImagePickerControllerEditedImage];
    UIImageView * picImageView = (UIImageView *)[self.view viewWithTag:500];
    picImageView.image = chosenImage;
    chosenImage = [self imageWithImageSimple:chosenImage scaledToSize:CGSizeMake(60, 60)];
    NSData * imageData = UIImageJPEGRepresentation(chosenImage, 0.8);
//        [self saveImage:chosenImage withName:@"avatar.png"];
//        NSURL * filePath = [NSURL fileURLWithPath:[self documentFolderPath]];
    
    //将图片上传到服务器
    //    --------------------------------------------------------
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/javascript",@"text/json", nil];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults valueForKey:@"token"];
    [manager.requestSerializer  setValue:token forHTTPHeaderField:@"token"];
    NSString * urlString = [NSString stringWithFormat:@"%@/api/upload-img",kUrl];
//    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:1];
//    [dict setObject:[userDefaults objectForKey:@"user_id"] forKey:@"user_id"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
//    [dic setValue:imageData forKey:@"upload_file"];
    [dic setValue:@"app" forKey:@"from_editor"];
    [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //通过post请求上传用户头像图片,name和fileName传的参数需要跟后台协商,看后台要传的参数名
        [formData appendPartWithFileData:imageData name:@"upload_file" fileName:@"headImg.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析后台返回的结果,如果不做一下处理,打印结果可能是一些二进制流数据

        self.headimgurl = responseObject[@"file_path"];
        [_tableView reloadData];
        [_myDelegate genggai];
        NSLog(@"上传图片成功0---%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传图片-- 失败  -%@",error);
    }];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];

    
}
//用户取消选取时调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
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
