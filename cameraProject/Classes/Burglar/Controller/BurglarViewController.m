//
//  BurglarViewController.m
//  cameraProject
//
//  Created by Zhouhoo on 2017/1/20.
//  Copyright © 2017年 ziHou. All rights reserved.
//

#import "BurglarViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "HSingleGlobalData.h"
@interface BurglarViewController ()<AMapSearchDelegate,MAMapViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)AMapSearchAPI *search;
@property (nonatomic,copy)NSString * latitude;
@property (nonatomic,copy)NSString * longitude;
@property(nonatomic,strong)AMapReGeocodeSearchRequest *regeo;
@property (nonatomic,strong) NSMutableArray *addressList;
@property (nonatomic,strong) NSMutableArray *provinceList;
@property (nonatomic,strong) NSMutableArray *cityList;
@property (nonatomic,strong) NSMutableArray *districtList;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation BurglarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self setMap];
    //    [self setTableView];
}

- (void)setMap{
    ///初始化地图
    MAMapView *_mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, KWidth, KHeight/2)];
    ///把地图添加至view
    [self.view addSubview:_mapView];
    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    int64_t delayInSeconds = 0.5;      // 延迟的时间
    /*
     *@parameter 1,时间参照，从此刻开始计时
     *@parameter 2,延时多久，此处为秒级，还有纳秒等。10ull * NSEC_PER_MSEC
     */
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
    });
    //设定缩放级别
    [_mapView setZoomLevel:18.5 animated:YES];
    _mapView.delegate = self;
    _mapView.logoCenter = CGPointMake(CGRectGetWidth(self.view.bounds)-55, 450);
//    _mapView.centerCoordinate = _mapView.userLocation.location.coordinate;
//    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
//    [self.locationManager startUpdatingLocation];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    imageView.center = CGPointMake(KWidth/2, KHeight/4+64);
    imageView.image = [UIImage imageNamed:@"center_location"];  //添加大头针,使它固定在屏幕中心
    [self.view addSubview:imageView];
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
}

- (void)setTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KHeight/2+64, KWidth, KHeight/2-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGBColor(241, 241, 241);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = YES;
    //    [self setRefresh];
    [self.view addSubview:_tableView];
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


#pragma mark - 定位功能
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//地址搜索回调
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        return;
    }
    //解析response获取地理信息，具体解析见 Demo
    NSLog(@"地址搜索回调:%@",response);
}

#pragma mark - MAMapViewDelegate

//地图区域改变完成后调用的接口

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"%f",mapView.region.center.latitude); //拿到中心点的经纬度.存储本地
    [HSingleGlobalData sharedInstance].position = [NSString stringWithFormat:@"%f,%f",mapView.region.center.longitude,mapView.region.center.latitude];
    NSLog(@"%f\n",mapView.region.center.longitude);
    if(_latitude){
        NSString *nowlat = [NSString stringWithFormat:@"%f",mapView.region.center.latitude];
        NSString *nowlon = [NSString stringWithFormat:@"%f",mapView.region.center.longitude];
        if (_latitude == nowlat&&_latitude == nowlon) {
            
        }else{
            //如果将坐标转为地址,需要进行逆地理编码
            //设置逆地理编码查询参数 ,进行逆地编码时，请求参数类为 AMapReGeocodeSearchRequest，location为必设参数。
            _regeo = [[AMapReGeocodeSearchRequest alloc] init];
            _regeo.location = [AMapGeoPoint locationWithLatitude:mapView.region.center.latitude longitude:mapView.region.center.longitude];
            _regeo.requireExtension = YES;
            [_search AMapReGoecodeSearch:_regeo];
            
        }
    }else{
        //如果将坐标转为地址,需要进行逆地理编码
        //设置逆地理编码查询参数 ,进行逆地编码时，请求参数类为 AMapReGeocodeSearchRequest，location为必设参数。
        _regeo = [[AMapReGeocodeSearchRequest alloc] init];
        _regeo.location = [AMapGeoPoint locationWithLatitude:mapView.region.center.latitude longitude:mapView.region.center.longitude];
        _regeo.requireExtension = YES;
        [_search AMapReGoecodeSearch:_regeo];
        
    }
    //如果将坐标转为地址,需要进行逆地理编码
    //    //设置逆地理编码查询参数 ,进行逆地编码时，请求参数类为 AMapReGeocodeSearchRequest，location为必设参数。
    //    _regeo = [[AMapReGeocodeSearchRequest alloc] init];
    //    _regeo.location = [AMapGeoPoint locationWithLatitude:mapView.region.center.latitude longitude:mapView.region.center.longitude];
    //    _regeo.requireExtension = YES;
    //    [_search AMapReGoecodeSearch:_regeo];
    
    //    MACoordinateRegion region;
    //    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    //    region.center= centerCoordinate;
    //
    //    NSLog(@" regionDidChangeAnimated %f,%f",centerCoordinate.latitude, centerCoordinate.longitude);
    
}

/* 逆地理编码回调. */

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response

{
    if (response.regeocode != nil)
    {
        //解析response获取地址描述，具体解析见 Demo
        //位置信息
        NSLog(@"reGeocode:%@", response.regeocode.formattedAddress);//获得的中心点地址
        //根据地质搜索poi
        AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
        
        request.keywords            = response.regeocode.formattedAddress;
        //        request.city                = @"北京";
        //        request.types               = @"高等院校";
        request.requireExtension    = YES;
        
        /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
        request.cityLimit           = YES;
        request.requireSubPOIs      = YES;
        [self.search AMapPOIKeywordsSearch:request];
    }
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    [_addressList removeAllObjects];
    if (self.addressList.count==0||self.addressList.count) {
        for(AMapPOI *poi in response.pois){
            NSLog(@"poi:%@,%@,%@,%@",poi.name,poi.address,poi.city,poi.district);
            [HSingleGlobalData sharedInstance].city = poi.city;
            NSString *address = [NSString stringWithFormat:@"%@",poi.address];
            [_addressList addObject:address];
            NSString *province = [NSString stringWithFormat:@"%@",poi.province];
            [_provinceList addObject:province];
            NSString *city = [NSString stringWithFormat:@"%@",poi.city];
            [_cityList addObject:city];
            NSString *district = [NSString stringWithFormat:@"%@",poi.district];
            [_districtList addObject:district];
        }
    }
    [self tableviewRload];
}

-(void)tableviewRload{
    if (_tableView) {
        [_tableView reloadData];
    }else{
        [self setTableView];
    }
    
}

#pragma mark - tableView数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    if (_addressList.count>0) {
    return _addressList.count;
    //    }else{
    //        return 0;
    //    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"AddressListTableViewCell";
    // 2.从缓存池中取出cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 3.如果缓存池中没有cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = _addressList[indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [HSingleGlobalData sharedInstance].address = self.addressList[indexPath.row];
//    [HSingleGlobalData sharedInstance].province = self.provinceList[indexPath.row];
//    [HSingleGlobalData sharedInstance].city = self.cityList[indexPath.row];
//    [HSingleGlobalData sharedInstance].district = self.districtList[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSMutableArray *)addressList{
    if (!_addressList) {
        _addressList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _addressList;
}

-(NSMutableArray *)provinceList{
    if (!_provinceList) {
        _provinceList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _provinceList;
}
-(NSMutableArray *)cityList{
    if (!_cityList) {
        _cityList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _cityList;
}
-(NSMutableArray *)districtList{
    if (!_districtList) {
        _districtList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _districtList;
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
