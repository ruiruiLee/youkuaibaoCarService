//
//  RescueAppointVC.m
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/22.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "RescueAppointVC.h"
#import "MapItemTableViewCell.H"
#import "base64.h"
#import "CityInfoModel.h"
#import "AddressSelectView.h"
#import "define.h"
#import "CustomDatePicker.h"
#import "AddNewCarController.h"
#import "UIView+Toast.h"
#import "AppointSuccessVC.h"
#import "OwnerStoreCarWashModel.h"

/**
 *  百度api
 */
#import "BaiduMapAPI_Base/BMKBaseComponent.h"//引入base相关所有的头文件

#import "BaiduMapAPI_Map/BMKMapComponent.h"//引入地图功能所有的头文件

#import "BaiduMapAPI_Search/BMKSearchComponent.h"//引入检索功能所有的头文件

#import "BaiduMapAPI_Cloud/BMKCloudSearchComponent.h"//引入云检索功能所有的头文件

#import "BaiduMapAPI_Location/BMKLocationComponent.h"//引入定位功能所有的头文件

#import "BaiduMapAPI_Utils/BMKUtilsComponent.h"//引入计算工具所有的头文件

#import "BaiduMapAPI_Radar/BMKRadarComponent.h"//引入周边雷达功能所有的头文件

#import "BaiduMapAPI_Map/BMKMapView.h"//只引入所需的单个头文件



//设备物理尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
#define Myuser [NSUserDefaults standardUserDefaults]

@interface RescueAppointVC ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate, BMKPoiSearchDelegate, UISearchDisplayDelegate, AddressSelectViewDelegate, CustomDatePickerDataSource,CustomDatePickerDelegate, AddNewCarDelegate>
{
    
    BMKPinAnnotationView *newAnnotation;
    
    BMKGeoCodeSearch *_geoCodeSearch;
    
    BMKPoiSearch *_boiSearch;
    
    BMKReverseGeoCodeOption *_reverseGeoCodeOption;
    
    BMKLocationService *_locService;
    
    
    CarInfos *_selectedCar;
    
    NSMutableArray            *_myCarsArray;
    
    int _pageIndex;
    
    int _pageSize;
    
    AddressSelectView *_popview;
    CustomDatePicker *_carSelectView;

}

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *mapPin;

@property (weak, nonatomic) IBOutlet UITableView *cityTableview;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;


@property(nonatomic,strong)NSMutableArray *cityDataArr;
@property (nonatomic, strong) NSMutableArray *searchedArray;

@property (nonatomic, strong) OwnerStoreCarWashModel *carWashModel;

@property (nonatomic, copy) ReturnCarInfoBlock ACTION;

@end



@implementation RescueAppointVC

-(NSMutableArray *)cityDataArr
{
    if (_cityDataArr==nil)
    {
        _cityDataArr=[NSMutableArray arrayWithCapacity:0];
    }
    
    return _cityDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"救援"];
    
    _searchBar.placeholder = @"搜索";
    [_searchBar sizeToFit];
    _searchBar.showsCancelButton = YES;
    
    [self.cityTableview registerNib:[UINib nibWithNibName:@"MapItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayController.searchResultsDataSource = self;
    _searchDisplayController.searchResultsDelegate = self;
    _searchDisplayController.delegate = self;
    [_searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"MapItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    
    [self initLocationService];
    [self loadData];
    [self loadMoreCars];
    _myCarsArray = [[NSMutableArray alloc] init];
}

- (void) loadData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    GPSLocationManager *manager = ((AppDelegate *)[UIApplication sharedApplication].delegate).gpsLocationManager;
    CLLocation *location = [manager getUserCurrentLocation];
    
    [WebService requestJsonWXOperationWithParam:@{ @"member_id": _userInfo.member_id,
                                                   @"longitude": [NSNumber numberWithDouble:location.coordinate.longitude],
                                                   @"latitude": [NSNumber numberWithDouble:location.coordinate.latitude],
                                                   @"ob": @"price",
                                                   @"service_type": @"6"}
                                         action:@"carWash/service/ownstore"
                                 normalResponse:^(NSString *status, id data)
     {
         if([[MBProgressHUD allHUDsForView:self.view] count] > 1)
             [MBProgressHUD hideHUDForView:self.view animated:NO];
         else
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         self.carWashModel = [[OwnerStoreCarWashModel alloc] initWithDictionary:data];
         
     }
                              exceptionResponse:^(NSError *error)
     {
         if([[MBProgressHUD allHUDsForView:self.view] count] > 1)
             [MBProgressHUD hideHUDForView:self.view animated:NO];
         else
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self.view makeToast:[[error userInfo] valueForKey:@"msg"]];
     }];
}

- (void)loadMoreCars
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _selectedCar = nil;
    [WebService requestJsonArrayOperationWithParam:@{@"member_id": _userInfo.member_id,
                                                     @"page_index": [NSNumber numberWithInteger:_pageIndex],
                                                     @"page_size": [NSNumber numberWithInteger:20]}
                                            action:@"car/service/list"
                                        modelClass:[CarInfos class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         if([[MBProgressHUD allHUDsForView:self.view] count] > 1)
             [MBProgressHUD hideHUDForView:self.view animated:NO];
         else
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (_pageIndex == 1)
         {
             if (_myCarsArray.count > 0)
             {
                 [_myCarsArray removeAllObjects];
             }
             [_myCarsArray addObjectsFromArray:array];
         }
         else
         {
             [_myCarsArray addObjectsFromArray:array];
         }
         if ([_myCarsArray count] < 20*_pageIndex)
         {
             
         }
         else
         {
             _pageIndex += 1;
         }
         
     }
                                 exceptionResponse:^(NSError *error)
     {
         if([[MBProgressHUD allHUDsForView:self.view] count] > 1)
             [MBProgressHUD hideHUDForView:self.view animated:NO];
         else
             [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

#pragma mark  tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _cityTableview)
        return self.cityDataArr.count;
    else
        return self.searchedArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _cityTableview){
        static NSString *cellID=@"cell";
        MapItemTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil)
        {
            cell=[[MapItemTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        CityInfoModel *model=self.cityDataArr[indexPath.row];
        
        cell.lbTitle.text=model.name;
        cell.lbAddress.text=model.address;
        
        return cell;
    }else{
        static NSString *cellID1=@"cell1";
        MapItemTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellID1];
        if (cell==nil)
        {
            cell=[[MapItemTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID1];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        CityInfoModel *model=self.searchedArray[indexPath.row];
        
        cell.lbTitle.text=model.name;
        cell.lbAddress.text=model.address;
        
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(tableView == _cityTableview){
            
        CityInfoModel *model = [self.cityDataArr objectAtIndex:indexPath.row];
        
        if(!_popview){
            _popview = [[NSBundle mainBundle] loadNibNamed:@"AddressSelectView"
                                                     owner:self
                                                   options:nil][0];
            _popview.delegate = self;
            [self.view.window addSubview:_popview];
        }
        _popview.frame = CGRectMake(0, 0, STATIC_SCREEN_WIDTH, STATIC_SCREEN_HEIGHT);
        _popview.addressInfo = model;
        if([_myCarsArray count] > 0)
            _popview.carInfo = [_myCarsArray objectAtIndex:0];
        
        [_popview show];
    }else{
        CityInfoModel *model = [self.searchedArray objectAtIndex:indexPath.row];
        
        BMKCoordinateRegion region ;//表示范围的结构体
        region.center = model.location;//中心点
        region.span.latitudeDelta = 0.004;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
        region.span.longitudeDelta = 0.004;//纬度范围
        [_mapView setRegion:region animated:YES];
        
        [_searchDisplayController setActive:NO animated:YES];
    }
}


#pragma mark 设置cell分割线做对齐
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews {
    
    if ([self.cityTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.cityTableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.cityTableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.cityTableview setLayoutMargins:UIEdgeInsetsZero];
    }
    
}


#pragma mark 初始化地图，定位
-(void)initLocationService
{
    
    [_mapView setMapType:BMKMapTypeStandard];// 地图类型 ->卫星／标准、
    
    _mapView.zoomLevel=17;
    _mapView.delegate=self;
    _mapView.showsUserLocation = YES;
    
    [_mapView bringSubviewToFront:_mapPin];
    
    
    if (_locService==nil) {
        
        _locService = [[BMKLocationService alloc]init];
        
        [_locService setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
}

#pragma mark BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _mapView.showsUserLocation = YES;//显示定位图层
    //设置地图中心为用户经纬度
    
    [_mapView updateLocationData:userLocation];
    
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = _mapView.centerCoordinate;//中心点
    region.span.latitudeDelta = 0.004;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.004;//纬度范围
    [_mapView setRegion:region animated:YES];
    
    [_locService stopUserLocationService];
    
}

#pragma mark BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //屏幕坐标转地图经纬度
    CLLocationCoordinate2D MapCoordinate=[_mapView convertPoint:_mapPin.center toCoordinateFromView:_mapView];
    
    if (_geoCodeSearch==nil) {
        //初始化地理编码类
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        _geoCodeSearch.delegate = self;
        
    }
    if (_reverseGeoCodeOption==nil) {
        
        //初始化反地理编码类
        _reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    }
    
    //需要逆地理编码的坐标位置
    _reverseGeoCodeOption.reverseGeoPoint = MapCoordinate;
    [_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
    
}

#pragma mark BMKGeoCodeSearchDelegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //获取周边用户信息
    if (error==BMK_SEARCH_NO_ERROR) {
        
        [self.cityDataArr removeAllObjects];
        for(BMKPoiInfo *poiInfo in result.poiList)
        {
            CityInfoModel *model=[[CityInfoModel alloc]init];
            model.name=poiInfo.name;
            model.address=poiInfo.address;
            model.location = poiInfo.pt;
            model.info = poiInfo;
            
            [self.cityDataArr addObject:model];
            [self.cityTableview reloadData];
        }
        
        if([result.poiList count] == 0){
            
            BMKCoordinateRegion region ;//表示范围的结构体
            region.center = _mapView.centerCoordinate;//中心点
            region.span.latitudeDelta = 0.004;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
            region.span.longitudeDelta = 0.004;//纬度范围
            [_mapView setRegion:region animated:YES];
        }
    }else{
        
        NSLog(@"BMKSearchErrorCode: %u",error);
    }
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    // 发送内容进行搜索
    BMKNearbySearchOption* option = [[BMKNearbySearchOption alloc] init];
    option.keyword  = searchString;
    option.radius = 1000;
    option.location = _mapView.centerCoordinate;
    
    if (_boiSearch==nil) {
        //初始化地理编码类
        _boiSearch = [[BMKPoiSearch alloc]init];
        _boiSearch.delegate = self;
        
    }
    
    [_boiSearch poiSearchNearBy:option];
    
    //刷新表格
    return YES;
}

//实现Delegate处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        
        if(!self.searchedArray)
            self.searchedArray = [[NSMutableArray alloc] init];
        else
            [self.searchedArray removeAllObjects];
        
        for(BMKPoiInfo *poiInfo in poiResult.poiInfoList)
        {
            CityInfoModel *model=[[CityInfoModel alloc]init];
            model.name=poiInfo.name;
            model.address=poiInfo.address;
            model.location = poiInfo.pt;
            model.info = poiInfo;
            
            [self.searchedArray addObject:model];
        }
        
        [_searchDisplayController.searchResultsTableView reloadData];
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma AddressSelectViewDelegate

- (void)addressSelectViewCancelAction
{
    
}

- (void)addressSelectView:(AddressSelectView *) view WithCarInfo:(CarInfos *) car Address:(CityInfoModel *) address
{
    if(car == nil){
        [Constants showMessage:@"清选择你要救援的车辆!"];
        return;
    }
    
        NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
        
        NSString *member_id = _userInfo.member_id;
        [pramas setObject:member_id forKey:@"member_id"];
        NSString *province_id = _userInfo.province_id;
        [pramas setObject:province_id forKey:@"province_id"];
        NSString *city_id = _userInfo.city_id;
        [pramas setObject:city_id forKey:@"city_id"];
        NSString *car_id = car.car_id;
        [pramas setObject:car_id forKey:@"car_id"];
        [pramas setObject:@"6" forKey:@"service_type"];
        [pramas setObject:[NSNumber numberWithInteger:1] forKey:@"reserve_type"];
        [pramas setObject:self.carWashModel.car_wash_id forKey:@"car_wash_id"];
        
        [pramas setObject:self.carWashModel.service_id forKey:@"service_id"];
    
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        
        NSDateComponents *comps  = [calendar components:unitFlags fromDate:[NSDate date]];
        
        NSInteger year = [comps year];
        NSInteger month = [comps month];
        NSInteger day = [comps day];
        NSInteger hour = [comps hour];
        NSInteger minute = [comps minute];
        NSString *reserve_day = [NSString stringWithFormat:@"%4d-%02d-%02d", year, month, day];
        [pramas setObject:reserve_day forKey:@"reserve_day"];
        NSString *b_time = [NSString stringWithFormat:@"%02d:%02d", hour, minute];
        [pramas setObject:b_time forKey:@"b_time"];
        NSString *e_time = [NSString stringWithFormat:@"%02d:%02d", hour + 1, minute];
        [pramas setObject:e_time forKey:@"e_time"];
        
            
        CLLocation *location = [[CLLocation alloc] initWithLatitude:address.info.pt.latitude longitude:address.info.pt.longitude];
        CLLocation *locationHuoxing = [location locationMarsFromBaidu];
        NSString *longitude = [[NSNumber numberWithFloat:locationHuoxing.coordinate.longitude] stringValue];
        [pramas setObject:longitude forKey:@"longitude"];
        NSString *latitude = [[NSNumber numberWithFloat:locationHuoxing.coordinate.latitude] stringValue];
        [pramas setObject:latitude forKey:@"latitude"];
        NSString *addr = [NSString stringWithFormat:@"%@%@", address.address, address.name];
        [pramas setObject:addr forKey:@"addr"];
        
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [WebService requestJsonWXOperationWithParam:pramas
                                         action:@"reserve/service/reserveOrder"
                                 normalResponse:^(NSString *status, id data)
     {
         [MBProgressHUD hideHUDForView:self.view animated:NO];
         //         [self.navigationController popToRootViewControllerAnimated:NO];
         
         AppointSuccessVC *vc = [[AppointSuccessVC alloc] initWithNibName:@"AppointSuccessVC" bundle:nil];
         vc.successDic = pramas;
         NSString *carNo = car.car_no;
         vc.carNo = carNo;
         vc.service_type = 4;
         vc.fuwuType = 1;
         [self.navigationController pushViewController:vc animated:YES];
         
     }
                              exceptionResponse:^(NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self.view makeToast:[[error userInfo] valueForKey:@"msg"]];
     }];
}

-(CustomDatePicker *)pickerView {
    if (_carSelectView == nil) {
        _carSelectView = [CustomDatePicker new];
        _carSelectView.frame = CGRectMake(0,self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        _carSelectView.backgroundColor = [UIColor redColor];
        _carSelectView.delegate = self;
        _carSelectView.dataSource = self;
    }
    return _carSelectView;
}

- (void)addressSelectView:(AddressSelectView *) view addCarWithBlock:(ReturnCarInfoBlock) block
{
    self.ACTION = block;
    
    if (_userInfo.member_id == nil)
    {
        id viewController = [QuickLoginViewController sharedLoginByCheckCodeViewControllerWithProtocolEnable:nil];
        
        [self presentViewController:viewController animated:YES completion:^
         {
             [[[UIApplication sharedApplication] keyWindow] makeToast:@"请先登录"];
         }];
        return;
    }

    AddNewCarController *controller = ALLOC_WITH_CLASSNAME(@"AddNewCarController");
    controller.delegate = self;
    controller.shouldComplete = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)addressSelectView:(AddressSelectView *) view withBlock:(ReturnCarInfoBlock) block{
//    if (_carSelectView == nil) {
        _carSelectView = [[CustomDatePicker alloc] initWithSureBtnTitle:@"取消" otherButtonTitle:@"确定"];
        _carSelectView.delegate = self;
        _carSelectView.dataSource = self;
//    }
    
    [_carSelectView show];
    
    self.ACTION = block;
}

-(NSInteger)CpickerView:(UIPickerView *)pickerView numberOfRowsInPicker:(NSInteger)component {
    return _myCarsArray.count;
}

-(UIView *)CpickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel * cellTitle = [[UILabel alloc] init];
    cellTitle.text = ((CarInfos*)_myCarsArray[row]).car_no;
    cellTitle.textColor = [UIColor blackColor];
    cellTitle.textAlignment = NSTextAlignmentCenter;
    
    return cellTitle;
}

-(CGFloat)CpickerView:(UIPickerView *)pickerView rowHeightForPicker:(NSInteger)component {
    return 43;
}

-(void)CpickerViewdidSelectRow:(NSInteger)row
{
    if(self.ACTION){
        CarInfos *model = _myCarsArray[row];
        _selectedCar = model;
        
        self.ACTION(model);
    }
    [_carSelectView dismisView];
}

/**获取当前window*/
- (UIWindow *)getCurrentWindowView {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}

- (void)didFinishEditCar:(CarInfos*)result
{
    _pageIndex = 1;
    [self loadMoreCars];
}

- (void)didFinishAddNewCar
{
    _pageIndex = 1;
    [self loadMoreCars];
}

@end
