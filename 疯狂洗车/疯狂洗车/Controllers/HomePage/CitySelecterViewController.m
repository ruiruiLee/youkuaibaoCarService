//
//  CitySelecterViewController.m
//  优快保
//
//  Created by cts on 15/3/28.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CitySelecterViewController.h"
#import "DBManager.h"
#import "OpenCityModel.h"
#import "CityModel.h"
#import "POAPinyin.h"
#import "NSString+Pinyin.h"
#import "MBProgressHUD+Add.h"
#import "WebServiceHelper.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import <MapKit/MapKit.h>
#import "LocationCityCell.h"
#import "HotCityCell.h"
#import "CityHeaderView.h"



@interface CitySelecterViewController ()<CLLocationManagerDelegate,AMapSearchDelegate,UIAlertViewDelegate,HotCityCellDelegate,LocationCityCellDelegate>
{
    NSString                    *_userCity;
    
    NSString                    *_userCityID;
    
    AMapSearchAPI               *_search;
    
    CLLocationManager           *_locationManager;
    
    CityModel                   *_locationCityModel;
    
    

}

@end

@implementation CitySelecterViewController

static NSString *cityHeaderViewIdentifier = @"CityHeaderView";

static NSString *cellIdentifier = @"CitySelectCell";

static NSString *locationCityCellIdentifier = @"LocationCityCell";

static NSString *hotCityCellIdentifier = @"HotCityCell";



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _citysArray = [NSMutableArray array];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back_btn"]
             forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 7, 26, 30)];
    [backBtn addTarget:self
                action:@selector(cancelCitySetting)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    [_cityTableView registerNib:[UINib nibWithNibName:locationCityCellIdentifier
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:locationCityCellIdentifier];
    
    [_cityTableView registerNib:[UINib nibWithNibName:hotCityCellIdentifier
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:hotCityCellIdentifier];

    if (self.forbidBack)
    {
        backBtn.hidden = YES;
    }
    
    if ([CLLocationManager locationServicesEnabled])
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 1000.0f;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)
        {
            [_locationManager requestWhenInUseAuthorization];
        }
        [_locationManager startUpdatingLocation];
        
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    else
    {
        [Constants showMessage:@"您无法使用定位服务"];
        [self getUserCityFail];
    }
    
    [self setTitle:@"选择城市"];
    
    [self getOpenCityFromeService];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isFirstLaunch)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveLastUserCitySetted:)
                                                     name:kLastUserCitySetted
                                                   object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.isFirstLaunch)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:kLastUserCitySetted
                                                      object:nil];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    [self getUserCityFail];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@",locations);
    
    [manager stopUpdatingLocation];
    
    CLLocation *location = locations[0];
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    //regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeoRequest];
    
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        
        NSString *cityName = response.regeocode.addressComponent.city;
        if ([cityName isEqualToString:@""])
        {
            if ([response.regeocode.addressComponent.province isEqualToString:@""])
            {
                [Constants showMessage:@"数据错误，无法获知您的位置"];
                return ;
            }
            else
            {
                cityName = response.regeocode.addressComponent.province;
            }
        }
        _userCity = cityName;
        NSDictionary *queryDic = [DBManager queryCityByCityName:_userCity];
        
        if (queryDic)
        {
            _locationCityModel = [[CityModel alloc] initWithDictionary:queryDic];
            _userCity = _locationCityModel.CITY_NAME;
            _userCityID = _locationCityModel.CITY_ID;
            [_cityTableView reloadData];
        }
        else
        {
            [self getUserCityFail];
        }
    }
    else
    {
        [self getUserCityFail];
    }
}

- (void)getUserCityFail
{
    _userCity = @"定位失败";
    _userCityID = @"-1";
    [_cityTableView reloadData];
}

- (void)didReceiveLastUserCitySetted:(NSNotification*)notification
{
    if ([notification.object isKindOfClass:[CityModel class]])
    {
        CityModel *pushUserCity = (CityModel*)notification.object;
        NSString *alertString = [NSString stringWithFormat:@"\nGPS定位城市：%@\n\n是否选择进入该城市?",pushUserCity.CITY_NAME];
        [Constants showMessage:alertString
                      delegate:self
                           tag:511
                  buttonTitles:@"取消",@"是的", nil];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 511)
    {
        if (buttonIndex == 0)
        {
            self.isFirstLaunch = NO;
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:kLastUserCitySetted
                                                          object:nil];
        }
        else
        {
            [self cancelCitySetting];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _citysArray.count+2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 29;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        return 1;
    }
    else
    {
        NSDictionary *englishDic = [_citysArray objectAtIndex:section-2];
        NSArray *tmpArray = [englishDic objectForKey:@"brands"];
        if ([tmpArray count] == 0)
        {
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        }
        else
        {
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        }
        return [tmpArray count];
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    CityHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cityHeaderViewIdentifier];
    
    if (view == nil)
    {
        view = [[NSBundle mainBundle] loadNibNamed:@"CityHeaderView"
                                             owner:nil
                                           options:nil][0];
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 29);
    }
    
    if (section == 0)
    {
        [view setCityHeaderTitle:@"当前定位城市"];
    }
    else if (section == 1)
    {
        [view setCityHeaderTitle:@"热门城市"];
    }
    else
    {
        NSDictionary *englishDic = [_citysArray objectAtIndex:section-2];
        
        
        [view setCityHeaderTitle:[englishDic objectForKey:@"initial"]];
    }
    
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 65;
    }
    else if (indexPath.section == 1)
    {
        if (_hotCitysArray.count > 0)
        {
            float itemHeight = 35;
            float cloumFloat = (int)_hotCitysArray.count /3.0;
            int cloum = (int)cloumFloat;
            if (cloumFloat > cloum)
            {
                cloum++;
            }
            CGSize imageContentSize = CGSizeMake(0, cloum*itemHeight+(cloum-1)*10+30);
            return imageContentSize.height;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 44;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return  @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return [self tableView:tableView locationCityCellForRowAtIndexPath:indexPath];
    }
    else if (indexPath.section == 1)
    {
        return [self tableView:tableView hotCityCellForRowAtIndexPath:indexPath];
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        NSDictionary *englishDic = [_citysArray objectAtIndex:indexPath.section - 2];
        NSArray *tmpArray = [englishDic objectForKey:@"brands"];
        
        OpenCityModel *model = tmpArray[indexPath.row];
        cell.textLabel.text = model.city_name;
        
        return cell;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView locationCityCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationCityCell *cell = [tableView dequeueReusableCellWithIdentifier:locationCityCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[LocationCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:locationCityCellIdentifier];
    }
    
    if (_userCityID)
    {
        [cell setLocationCityName:_userCity];
    }
    else
    {
        [cell setLocationCityName:nil];
    }
    cell.delegate = self;
    
    
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView hotCityCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotCityCell *cell = [tableView dequeueReusableCellWithIdentifier:hotCityCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[HotCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotCityCellIdentifier];
    }
    cell.delegate = self;

    [cell setDisplayHotCitys:_hotCitysArray];
    
    
    return cell;
}

#pragma mark - HotCityCellDelegate

- (void)didSelectedHotCityAtIndex:(NSInteger)cityIndex
{
    NSString *cityID = nil;
    NSString *cityName = nil;
    
    OpenCityModel *model = _hotCitysArray[cityIndex];
    
    if (self.isForCommit)
    {
        if ([self.delegate respondsToSelector:@selector(didFinishCitySelectForCommiting:)])
        {
            [self.delegate didFinishCitySelectForCommiting:model];
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    else
    {
        cityID = model.city_id;
        cityName = model.city_name;
        _currentSettingCityCoordinate = CLLocationCoordinate2DMake(model.latitude.doubleValue, model.longitude.doubleValue);
    }

    
    
    
    NSDictionary *resultDic = nil;
    resultDic  = [DBManager queryCityByCityName:cityName];
    
    if (resultDic)
    {
        CityModel *userCity = [[CityModel alloc] initWithDictionary:resultDic];
        [[NSUserDefaults standardUserDefaults] setObject:[userCity convertToDictionary]
                                                  forKey:kLastUserCity];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:cityID forKey:kLocationCityIDKey];
    [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:kLocationCityNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [_appDelegate.gpsLocationManager
     changeAppConfigSuccessResponse:^{
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTELocationChange
                                                             object:nil];
         [self.navigationController popViewControllerAnimated:YES];
     }
     failResponse:^{
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [self.navigationController popViewControllerAnimated:YES];
     }];
}


#pragma mark - LocationCityCellDelegate

- (void)didLocationCityButtonTouched
{
    NSString *cityID = nil;
    NSString *cityName = nil;
    
    if ([_userCityID isEqualToString:@"-1"] || _userCityID == nil)
    {
        return;
    }
    else
    {
        if (self.isForCommit)
        {
            if ([self.delegate respondsToSelector:@selector(didFinishCitySelectForCommiting:)])
            {
                OpenCityModel *model = [[OpenCityModel alloc] init];
                
                model.city_id = _locationCityModel.CITY_ID;
                model.city_name = _locationCityModel.CITY_NAME;
                
                [self.delegate didFinishCitySelectForCommiting:model];
            }
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        else
        {
            cityID = _locationCityModel.CITY_ID;
            cityName = _locationCityModel.CITY_NAME;
            _currentSettingCityCoordinate = CLLocationCoordinate2DMake(_locationCityModel.LATITUDE.doubleValue, _locationCityModel.LONGITUDE.doubleValue);
        }
    }
    
    
    NSDictionary *resultDic = nil;
    resultDic  = [DBManager queryCityByCityName:cityName];
    
    if (resultDic)
    {
        CityModel *userCity = [[CityModel alloc] initWithDictionary:resultDic];
        
        [[NSUserDefaults standardUserDefaults] setObject:[userCity convertToDictionary]
                                                  forKey:kLastUserCity];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:cityID forKey:kLocationCityIDKey];
    [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:kLocationCityNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [_appDelegate.gpsLocationManager
     changeAppConfigSuccessResponse:^{
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTELocationChange
                                                             object:nil];
         [self.navigationController popViewControllerAnimated:YES];
     }
     failResponse:^{
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [self.navigationController popViewControllerAnimated:YES];
     }];

}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        return;
    }
    NSString *cityID = nil;
    NSString *cityName = nil;
    if (indexPath.section == 0)
    {
        if ([_userCityID isEqualToString:@"-1"] || _userCityID == nil)
        {
            return;
        }
        else
        {
            if (self.isForCommit)
            {
                if ([self.delegate respondsToSelector:@selector(didFinishCitySelectForCommiting:)])
                {
                    OpenCityModel *model = [[OpenCityModel alloc] init];
                    
                    model.city_id = _locationCityModel.CITY_ID;
                    model.city_name = _locationCityModel.CITY_NAME;
                    
                    [self.delegate didFinishCitySelectForCommiting:model];
                }
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            else
            {
                cityID = _locationCityModel.CITY_ID;
                cityName = _locationCityModel.CITY_NAME;
                _currentSettingCityCoordinate = CLLocationCoordinate2DMake(_locationCityModel.LATITUDE.doubleValue, _locationCityModel.LONGITUDE.doubleValue);
            }
        }
    }
    else
    {
        NSDictionary *englishDic = [_citysArray objectAtIndex:indexPath.section-2];
        NSArray *tmpArray = [englishDic objectForKey:@"brands"];
        
        OpenCityModel *model = tmpArray[indexPath.row];
        
        if (self.isForCommit)
        {
            if ([self.delegate respondsToSelector:@selector(didFinishCitySelectForCommiting:)])
            {
                [self.delegate didFinishCitySelectForCommiting:model];
            }
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        else
        {
            cityID = model.city_id;
            cityName = model.city_name;
            _currentSettingCityCoordinate = CLLocationCoordinate2DMake(model.latitude.doubleValue, model.longitude.doubleValue);

        }

    }
    


    NSDictionary *resultDic = nil;
    resultDic  = [DBManager queryCityByCityName:cityName];
    
    if (resultDic)
    {
        CityModel *userCity = [[CityModel alloc] initWithDictionary:resultDic];
        [[NSUserDefaults standardUserDefaults] setObject:[userCity convertToDictionary]
                                                  forKey:kLastUserCity];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:cityID forKey:kLocationCityIDKey];
    [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:kLocationCityNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [_appDelegate.gpsLocationManager
     changeAppConfigSuccessResponse:^{
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTELocationChange
                                                             object:nil];
         [self.navigationController popViewControllerAnimated:YES];
    }
     failResponse:^{
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [self.navigationController popViewControllerAnimated:YES];
    }];
//    NSDictionary *submitDic =@{@"city_id":cityID};
//    [WebService requestJsonModelWithParam:submitDic
//                                   action:@"carWash/service/checkService"
//                               modelClass:[CityServiceModel class]
//                           normalResponse:^(NSString *status, id data, JsonBaseModel *model)
//     {
//         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//         if (status.intValue > 0)
//         {
//             _cityServiceModel = (CityServiceModel*)model;
//             _currentSettingCityCoordinate = coordinate;
//             [[NSUserDefaults standardUserDefaults] setObject:cityID forKey:kLocationCityIDKey];
//             [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:kLocationCityNameKey];
//             [[NSUserDefaults standardUserDefaults] synchronize];
//             [[NSNotificationCenter defaultCenter] postNotificationName:kFinishCitySettingNotifaction
//                                                                 object:cityID];
//             [self.navigationController popViewControllerAnimated:YES];
//             
//         }
//         else
//         {
//             [Constants showMessage:@"获取不到城市服务信息"];
//             _cityServiceModel = nil;
//         }
//     }
//                        exceptionResponse:^(NSError *error)
//     {
//         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//         [Constants showMessage:@"获取城市服务信息失败"];
//         _cityServiceModel = nil;
//     }];

    

}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = -1;
    for (int x = 0; x<_citysArray.count; x++)
    {
        NSDictionary *englishDic = [_citysArray objectAtIndex:x];
        if ([title isEqualToString:[englishDic objectForKey:@"initial"]])
        {
            count = x+1;
        }
    }

    return count;
}

- (void)cancelCitySetting
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getOpenCityFromeService
{
    [WebService requestJsonOperationWithParam:nil
                                       action:@"city/service/getOpen"
                               normalResponse:^(NSString *status, id data)
     {
         if (status.intValue > 0)
         {
             NSArray *result = data;
             NSMutableArray *insertArray = [NSMutableArray array];
             
             for (int x = 0; x<result.count; x++)
             {
                 NSDictionary *tmpDic = result[x];
                 
                 OpenCityModel *model = [[OpenCityModel alloc] initWithDictionary:tmpDic];
                 [insertArray addObject:model];
             }
             
             if (insertArray.count > 0)
             {
                 _hotCitysArray = [NSMutableArray array];
                 for (int y = 0; y<insertArray.count; y++)
                 {
                     OpenCityModel *model = insertArray[y];
                     
                     if (model.wash_hot.intValue > 0)
                     {
                         [_hotCitysArray addObject:model];
                     }
                 }
             }

             
             [self sequencingChineseName:insertArray];
             
         }
         else
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [MBProgressHUD showError:@"更新车系数据库失败" toView:self.view];
         }
     }
                            exceptionResponse:^(NSError *error) {
                                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                [MBProgressHUD showError:@"更新城市数据库失败" toView:self.view];
                            }];

}

- (void)sequencingChineseName:(NSArray*)target
{
    NSLog(@"start:%ld",time(NULL));
    NSMutableSet *tmpSet = [NSMutableSet set];
    for (OpenCityModel *model in target)
    {
        [tmpSet addObject:[[POAPinyin quickConvert:model.city_name] substringToIndex:1]];
        
    }
    
    NSArray *initialArray =[[tmpSet allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                            {
                                
                                return [obj1 compare:obj2 options:NSNumericSearch];
                            }];
    
    //    NSLog(@"block1:%ld",time(NULL));
    NSLog(@"得到拼音 %@",initialArray);
    //    NSLog(@"block2:%ld",time(NULL));
    NSMutableArray *resultArray = [NSMutableArray array];
    for (int x=0; x<initialArray.count; x++)
    {
        NSMutableArray *brands = [NSMutableArray array];
        NSString *stringUseForCompare = initialArray[x];
        for (OpenCityModel *model in target)
        {
            if ([[[POAPinyin quickConvert:model.city_name]substringToIndex:1] isEqualToString:stringUseForCompare])
            {
                [brands addObject:model];
            }
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:stringUseForCompare forKey:@"initial"];
        [dict setValue:brands forKey:@"brands"];
        [resultArray addObject:dict];
        //        [resultArray addObject:@{@"initial":stringUseForCompare,
        //                                 @"contacters":contacters}];
    }
    
    //     NSLog(@"block5:%ld",time(NULL));
    
    for (NSMutableDictionary *dict in resultArray)
    {
        NSArray *brandsArray = [dict valueForKey:@"brands"];
        NSArray *newArray = [self sortWithArray:brandsArray];
        [dict setValue:newArray forKey:@"brands"];
    }
    
    _citysArray = resultArray;
    [POAPinyin clearCache];
    
    [_cityTableView reloadData];
    _cityTableView.userInteractionEnabled = YES;
}


#pragma mark -  姓名排序
// 对数组中联系人 按姓名的中文字母进行排序
// array 存放联系人模型的数组
- (NSArray *)sortWithArray:(NSArray *)array
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (int i = 0; i<array.count; i++)
    {
        OpenCityModel *sortModel = [array objectAtIndex:i];
        if (0 == i)
        {
            [resultArray addObject:sortModel];
            continue;
        }
        int j = 0;
        for (; j<resultArray.count; j++)
        {
            OpenCityModel *model = [resultArray objectAtIndex:j];
            int comp = [self compCheneseString:model.city_name secondString:sortModel.city_name];
            if (0 == comp)
            {
                continue;
            }
            else if (1 == comp)
            {
                [resultArray insertObject:sortModel atIndex:j];
                break;
            }
            else
            {
                [resultArray insertObject:sortModel atIndex:j];
                break;
            }
        }
        if (j == resultArray.count)
        {
            [resultArray addObject:sortModel];
        }
    }
    return [resultArray copy];
}

// 返回 0 firt < sec
// 1 firt == sec
//  2 firt > sec
- (int)compCheneseString:(NSString *)firtString secondString:(NSString *)secString
{
    int k = 0;
    for (;k < firtString.length; k++)
    {
        NSString *word = [firtString substringWithRange:NSMakeRange(k, 1)];
        if (k + 1 > secString.length)
        {
            return 2;
        }
        NSString *sortWord = [secString substringWithRange:NSMakeRange(k, 1)];
        NSString *wordPin = [POAPinyin quickConvert:word];
        NSString *sortWordPin = [POAPinyin quickConvert:sortWord];
        NSComparisonResult compResult = [wordPin compare:sortWordPin];
        if (compResult == NSOrderedSame)
        {
            continue;
        }
        else if (compResult == NSOrderedAscending)
        {
            return 0;
        }
        else
        {
            return 2;
        }
    }
    if (secString.length > k)
    {
        return 0;
    }
    else if (secString.length == k)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
