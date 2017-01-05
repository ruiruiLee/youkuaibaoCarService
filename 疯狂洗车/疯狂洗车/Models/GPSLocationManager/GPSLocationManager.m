//
//  GPSLocationManager.m
//  优快保
//
//  Created by cts on 15/8/6.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "GPSLocationManager.h"
#import "DBManager.h"
#import "HomeButtonModel.h"

NSString *const NOTELocationLaunchSuccess = @"LocationLaunchSuccessNotifaction";

NSString *const NOTELocationLaunchFail = @"LocationLaunchFailNotifaction";

NSString *const NOTELocationChange = @"LocationChangeNotifaction";


@implementation GPSLocationManager


- (void)startGPSLocationManager
{
    if (_isRunning)
    {
        NSLog(@"定位已在启动中");
        return;
    }
    

    if ([[NSUserDefaults standardUserDefaults] objectForKey:kLastUserCity])
    {
        CityModel *userCity = [[CityModel alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:kLastUserCity]];
        
        _userCityModel = userCity;
        [[NSUserDefaults standardUserDefaults] setObject:_userCityModel.CITY_ID forKey:kLocationCityIDKey];
        [[NSUserDefaults standardUserDefaults] setObject:_userCityModel.CITY_NAME forKey:kLocationCityNameKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _publicUserCoordinate = CLLocationCoordinate2DMake(_userCityModel.LATITUDE.doubleValue, _userCityModel.LONGITUDE.doubleValue);
        _overallCoordinate = _publicUserCoordinate;
        _currentSettingCityCoordinate = CLLocationCoordinate2DMake(_userCityModel.LATITUDE.doubleValue, _userCityModel.LONGITUDE.doubleValue);
        

        _userCityModel = userCity;
        
        _lastCityLaunch = YES;
        _shouldAskWhenChangeCity = YES;
    }
    if (_locationManager == nil)
    {
        _searchAPI = [[AMapSearchAPI alloc] init];
        _searchAPI.delegate = self;
        
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 100.0f;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
//        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)
//        {
//            [_locationManager requestWhenInUseAuthorization];
//        }
        [_locationManager startUpdatingLocation];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didShouldUpdateCenter)
                                                     name:kShouldUpdateCenter
                                                   object:nil];
    }
}

- (void)stopGPSLocationManager
{
    
}

//#pragma mark - CLLocationManagerDelegate Method
//#pragma mark
//
//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
//{
//    NSLog(@"didChangeAuthorizationStatus %d",status);
//    if (status == kCLAuthorizationStatusDenied)
//    {
//        [Constants showMessage:@"请打开定位，以便正常使用优快保"];
//        if (_userCityModel == nil)
//        {
//            [self setCurrentToChengduWithCurrentLocation:nil];
//        }
//        else if (_appconfig == nil)
//        {
//            [self setUpOrderShareParameterWithNormalResponse:^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:NOTELocationLaunchSuccess
//                                                                    object:nil];
//            } exceptionResponse:^{
//                
//            }];
//        }
//        
//    }
//    else if (status == kCLAuthorizationStatusRestricted)
//    {
//        [Constants showMessage:@"您的设备现在无法使用定位服务"];
//        if (_userCityModel == nil)
//        {
//            [self setCurrentToChengduWithCurrentLocation:nil];
//        }
//        else if (_appconfig == nil)
//        {
//            [self setUpOrderShareParameterWithNormalResponse:^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:NOTELocationLaunchSuccess
//                                                                    object:nil];
//            } exceptionResponse:^{
//                
//            }];
//        }
//    }
//    else
//    {
//        _isRunning = YES;
//    }
//}
//
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    CLLocation *fixedLocation = [manager.location locationMarsFromEarth];
//    _publicUserCoordinate = fixedLocation.coordinate;
//    NSDictionary *dic = @{@"latitude": [NSNumber numberWithDouble:fixedLocation.coordinate.latitude],
//                          @"longitude": [NSNumber numberWithDouble:fixedLocation.coordinate.longitude]};
//    [[NSUserDefaults standardUserDefaults] setObject:dic
//                                              forKey:kLocationKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self updateUserCurrentLocationCity:fixedLocation
//                        successResponse:^{
//                            
//                        }
//                           failResponse:^{
//                               
//                           }];
//}
//
#pragma mark - AMapLocationManagerDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    if (_userCityModel == nil)
    {
        [Constants showMessage:@"您的设备现在无法使用定位服务"];
        [self setCurrentToChengduWithCurrentLocation:nil];
    }
    else if (_appconfig == nil)
    {
        [self setUpOrderShareParameterWithNormalResponse:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTELocationLaunchSuccess
                                                                object:nil];
        } exceptionResponse:^{
            
        }];
    }

}

/**
 *  连续定位回调函数
 *
 *  @param manager 定位 AMapLocationManager 类。
 *  @param location 定位结果。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    if (!_isRunning)
    {
        _isRunning = YES;
      //  CLLocation *fixedLocation = [manager.location locationMarsFromEarth];
        _publicUserCoordinate = location.coordinate;
        _userCurrentLocation = location;
        NSDictionary *dic = @{@"latitude": [NSNumber numberWithDouble:location.coordinate.latitude],
                              @"longitude": [NSNumber numberWithDouble:location.coordinate.longitude]};
        [[NSUserDefaults standardUserDefaults] setObject:dic
                                                  forKey:kLocationKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        [self updateUserCurrentLocationCity:location
//                            successResponse:^{
//                                
//                            }
//                               failResponse:^{
//                                   
//                               }];
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location = [AMapGeoPoint locationWithLatitude:_publicUserCoordinate.latitude
                                                  longitude:_publicUserCoordinate.longitude];
        regeo.radius = 10000;
        
        //发起逆地理编码
        [_searchAPI AMapReGoecodeSearch:regeo];

    }
}

//实现逆地理编码的回调函数
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
//    int j = 0;
    NSString *placemakCityName = [[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityNameKey];
    NSDictionary *resultDic = nil;
    if ([placemakCityName rangeOfString:@"北京市"].location != NSNotFound)
    {
        resultDic = [DBManager queryCityByCityName:@"北京市"];
    }
    else if ([placemakCityName rangeOfString:@"上海市"].location != NSNotFound)
    {
        resultDic = [DBManager queryCityByCityName:@"上海市"];
    }
    else if ([placemakCityName rangeOfString:@"天津市"].location != NSNotFound)
    {
        resultDic = [DBManager queryCityByCityName:@"天津市"];
    }
    else if ([placemakCityName rangeOfString:@"重庆市"].location != NSNotFound)
    {
        resultDic = [DBManager queryCityByCityName:@"重庆市"];
    }
    else if ([placemakCityName isEqualToString:@""] || placemakCityName == nil)
    {
        [self setCurrentToChengduWithCurrentLocation:nil];
        return;
    }
    else
    {
        resultDic  = [DBManager queryCityByCityName:placemakCityName];
    }
    
    if (resultDic)
    {
        CityModel *userCity = [[CityModel alloc] initWithDictionary:resultDic];
        if (![[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey])
        {
            AMapReGeocodeSearchRequest *regeo = (AMapReGeocodeSearchRequest*) request;
            [[NSUserDefaults standardUserDefaults] setObject:userCity.CITY_ID forKey:kLocationCityIDKey];
            [[NSUserDefaults standardUserDefaults] setObject:userCity.CITY_NAME forKey:kLocationCityNameKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            _publicUserCoordinate = CLLocationCoordinate2DMake(regeo.location.latitude, regeo.location.longitude);
            _currentSettingCityCoordinate = CLLocationCoordinate2DMake(userCity.LATITUDE.doubleValue, userCity.LONGITUDE.doubleValue);
        }
        if (_userCityModel == nil)
        {
            _userCityModel = userCity;
            
            [[NSUserDefaults standardUserDefaults] setObject:[_userCityModel convertToDictionary]
                                                      forKey:kLastUserCity];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            CityModel *pushUserCity = [[CityModel alloc] initWithDictionary:resultDic];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLastUserCitySetted
                                                                object:pushUserCity];
            
        }
        else if (![_userCityModel.CITY_ID isEqualToString:userCity.CITY_ID])
        {
            if (_shouldAskWhenChangeCity)
            {
                _currentCityModel = userCity;
                _shouldAskWhenChangeCity = NO;
                
                NSString *alertString = [NSString stringWithFormat:@"您当前位置为%@，是否切换城市",userCity.CITY_NAME];
                [Constants showMessage:alertString
                              delegate:self
                                   tag:531
                          buttonTitles:@"取消",@"切换", nil];
            }
        }
        
        
        if (_userInfo.member_id && [_userInfo.city_id isEqualToString:@""])
        {
            [self setUpUserCity:userCity];
        }
        if (_userCityModel && _appconfig == nil)
        {
            [self setUpOrderShareParameterWithNormalResponse:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTELocationLaunchSuccess
                                                                    object:nil];
            } exceptionResponse:^{
                
            }];
        }
        
    }
    else
    {
        [self setCurrentToChengduWithCurrentLocation:nil];
        
    }

    
}
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request
                     response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        NSLog(@"ReGeo: %@", result);
        
        _userCurrentLoactionStreet = [NSString stringWithFormat:@"%@%@%@",response.regeocode.addressComponent.district?response.regeocode.addressComponent.district:@"",
                                      response.regeocode.addressComponent.streetNumber.street? response.regeocode.addressComponent.streetNumber.street:@"",
                                      response.regeocode.addressComponent.streetNumber.number?response.regeocode.addressComponent.streetNumber.number:@""];
        
        NSString *placemakCityName = nil;
        if (response.regeocode.addressComponent.city == nil || [response.regeocode.addressComponent.city isEqualToString:@""])
        {
            placemakCityName = response.regeocode.addressComponent.province;
        }
        else
        {
            placemakCityName = response.regeocode.addressComponent.city;
        }
        NSDictionary *resultDic = nil;
        if ([placemakCityName rangeOfString:@"北京市"].location != NSNotFound)
        {
            resultDic = [DBManager queryCityByCityName:@"北京市"];
        }
        else if ([placemakCityName rangeOfString:@"上海市"].location != NSNotFound)
        {
            resultDic = [DBManager queryCityByCityName:@"上海市"];
        }
        else if ([placemakCityName rangeOfString:@"天津市"].location != NSNotFound)
        {
            resultDic = [DBManager queryCityByCityName:@"天津市"];
        }
        else if ([placemakCityName rangeOfString:@"重庆市"].location != NSNotFound)
        {
            resultDic = [DBManager queryCityByCityName:@"重庆市"];
        }
        else if ([placemakCityName isEqualToString:@""] || placemakCityName == nil)
        {
            [self setCurrentToChengduWithCurrentLocation:nil];
            return;
        }
        else
        {
            resultDic  = [DBManager queryCityByCityName:placemakCityName];
        }
        
        if (resultDic)
        {
            CityModel *userCity = [[CityModel alloc] initWithDictionary:resultDic];
            if (![[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey])
            {
                [[NSUserDefaults standardUserDefaults] setObject:userCity.CITY_ID forKey:kLocationCityIDKey];
                [[NSUserDefaults standardUserDefaults] setObject:userCity.CITY_NAME forKey:kLocationCityNameKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                _publicUserCoordinate = CLLocationCoordinate2DMake(response.regeocode.addressComponent.streetNumber.location.latitude, response.regeocode.addressComponent.streetNumber.location.longitude);
                _currentSettingCityCoordinate = CLLocationCoordinate2DMake(userCity.LATITUDE.doubleValue, userCity.LONGITUDE.doubleValue);
            }
            if (_userCityModel == nil)
            {
                _userCityModel = userCity;
                
                [[NSUserDefaults standardUserDefaults] setObject:[_userCityModel convertToDictionary]
                                                          forKey:kLastUserCity];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                CityModel *pushUserCity = [[CityModel alloc] initWithDictionary:resultDic];
                [[NSNotificationCenter defaultCenter] postNotificationName:kLastUserCitySetted
                                                                    object:pushUserCity];
                
            }
            else if (![_userCityModel.CITY_ID isEqualToString:userCity.CITY_ID])
            {
                if (_shouldAskWhenChangeCity)
                {
                    _currentCityModel = userCity;
                    _shouldAskWhenChangeCity = NO;
                    
                    NSString *alertString = [NSString stringWithFormat:@"您当前位置为%@，是否切换城市",userCity.CITY_NAME];
                    [Constants showMessage:alertString
                                  delegate:self
                                       tag:531
                              buttonTitles:@"取消",@"切换", nil];
                }
            }
            
            
            if (_userInfo.member_id && [_userInfo.city_id isEqualToString:@""])
            {
                [self setUpUserCity:userCity];
            }
            if (_userCityModel && _appconfig == nil)
            {
                [self setUpOrderShareParameterWithNormalResponse:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTELocationLaunchSuccess
                                                                        object:nil];
                } exceptionResponse:^{
                    
                }];
            }

        }
        else
        {
            [self setCurrentToChengduWithCurrentLocation:nil];

        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (_userCityModel == nil)
    {
        [self setCurrentToChengduWithCurrentLocation:manager.location];
    }
}


- (void)updateUserCurrentLocationStreetSuccessResponse:(void(^)(void))successResponse
                                          failResponse:(void(^)(void))failResponse
{
    NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    
    
    // 强制 成 简体中文
    CLLocation *fixedLocation = _userCurrentLocation;//[_locationManager.location locationMarsFromEarth];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans", nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    CLGeocoder *revGeo = [[CLGeocoder alloc] init];
    
    [revGeo reverseGeocodeLocation:fixedLocation
                 completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil)
         {
             CLPlacemark *placemark =  placemarks[0];
             
             NSMutableString *userCurrentStreet = [NSMutableString string];
             
             if (![placemark.subLocality isEqualToString:@""] && placemark.subLocality != nil)
             {
                 [userCurrentStreet appendString:placemark.subLocality];
             }
             if (![placemark.thoroughfare isEqualToString:@""] && placemark.thoroughfare != nil)
             {
                 [userCurrentStreet appendString:placemark.thoroughfare];
             }
             if (![placemark.subThoroughfare isEqualToString:@""] && placemark.subThoroughfare != nil)
             {
                 [userCurrentStreet appendString:placemark.subThoroughfare];
             }
             [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             _userCurrentLoactionStreet = userCurrentStreet;
             successResponse();

         }
         else
         {
             [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             failResponse();
         }
         
     }];

}


- (void)setCurrentToChengduWithCurrentLocation:(CLLocation*)location
{
    NSDictionary *resultDic = nil;
    resultDic  = [DBManager queryCityByCityName:@"成都"];
    CityModel *userCity = [[CityModel alloc] initWithDictionary:resultDic];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey])
    {
        [[NSUserDefaults standardUserDefaults] setObject:userCity.CITY_ID forKey:kLocationCityIDKey];
        [[NSUserDefaults standardUserDefaults] setObject:userCity.CITY_NAME forKey:kLocationCityNameKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _publicUserCoordinate = CLLocationCoordinate2DMake(userCity.LATITUDE.doubleValue, userCity.LONGITUDE.doubleValue);
        _overallCoordinate = _publicUserCoordinate;
        _currentSettingCityCoordinate = CLLocationCoordinate2DMake(userCity.LATITUDE.doubleValue, userCity.LONGITUDE.doubleValue);
    }
    
    if (_userCityModel == nil)
    {
        _userCityModel = userCity;
    }
    else if (![_userCityModel.CITY_ID isEqualToString:userCity.CITY_ID])
    {
        _userCityModel = userCity;
    }
    
    
    if (_userInfo.member_id && [_userInfo.city_id isEqualToString:@""])
    {
        [self setUpUserCity:userCity];
    }
    if (_userCityModel && _appconfig == nil)
    {

        [self setUpOrderShareParameterWithNormalResponse:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTELocationLaunchSuccess
                                                                object:nil];
        } exceptionResponse:^{
            
        }];


    }
}



#pragma mark - 通过获取了城市后和服务器的交互方法

- (void)setUpOrderShareParameterWithNormalResponse:(void(^)(void))normalResponse
                                 exceptionResponse:(void(^)(void))exceptionResponse
{
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey])
    {
        _appconfig = nil;
        normalResponse();
        return ;
    }
    NSDictionary *submitDic = @{@"city_id"  : [[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey],
                                @"member_id": !_userInfo.member_id? @"":_userInfo.member_id};
    [WebService requestJsonModelWithParam:submitDic
                                   action:@"system/service/appconfig"
                               modelClass:[OrderShareModel class]
                           normalResponse:^(NSString *status, id data, JsonBaseModel *model)
     {
         if (status.intValue > 0)
         {
             _appconfig = (OrderShareModel*)model;
             if (!_appconfig.service_phone)
             {
                 
             }
             else
             {
                 _kefudianhuaNumber = _appconfig.service_phone;
             }
             
             if ([_appconfig.insurance_btn_img isEqualToString:@""] ||_appconfig.insurance_btn_img == nil)
             {
                 [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMainInsuranceImage];
             }
             else
             {
                 [[NSUserDefaults standardUserDefaults] setObject:_appconfig.insurance_btn_img
                                                           forKey:kMainInsuranceImage];
             }             
             [[NSUserDefaults standardUserDefaults] setObject:[_appconfig convertToDictionary]
                                                       forKey:kLastAppConfig];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }
         else
         {
             _appconfig = nil;
         }
         normalResponse();
         return ;
     }
                        exceptionResponse:^(NSError *error) {
                            _appconfig = nil;
                            exceptionResponse();
                            return ;
                        }];
}

- (void)changeAppConfigSuccessResponse:(void(^)(void))successResponse
                          failResponse:(void(^)(void))failResponse;
{
    [self setUpOrderShareParameterWithNormalResponse:^{
        successResponse();
        return;
    }
                                   exceptionResponse:^{
                                       failResponse();
                                       return;
    }];
}

#pragma mark - 检查城市服务开通情况
- (void)updateDateCityService
{
    [self getCityServiceFromService:[[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey]
                    SuccessResponse:^{
        
    }
                       failResponse:^{
        
    }];
}

- (void)getCityServiceFromService:(NSString*)cityID
                  SuccessResponse:(void(^)(void))successResponse
                     failResponse:(void(^)(void))failResponse;
{
    NSDictionary *submitDic =@{@"city_id":cityID};
    NSLog(@"开始请求城市开通");
    [WebService requestJsonArrayOperationWithParam:submitDic
                                            action:@"carWash/service/getBtn"
                                        modelClass:[HomeButtonModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
    {
        if (status.intValue > 0 && array.count > 0)
        {
            _cityServiceArray = array;
            successResponse();
            return;
        }
        else
        {
            [Constants showMessage:@"获取不到城市服务信息"];
            _cityServiceArray = nil;
            failResponse();
            return;
        }
    }
                                 exceptionResponse:^(NSError *error) {
                                     [Constants showMessage:[error domain]];
                                     _cityServiceArray = nil;
                                     failResponse();
                                     return;
    }];
}


- (void)setUpUserCity:(CityModel*)cityModel
{
    if (cityModel == nil)
    {
        return;
    }
    NSDictionary *submitDic = @{@"member_id":_userInfo.member_id,
                                @"city_id":cityModel.CITY_ID};
    
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"member/service/setCity"
                               normalResponse:^(NSString *status, id data)
     {
         if (status.intValue > 0)
         {
             AppDelegate   *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
             
             [appDelegate updateUserInfo];
             _userInfo.city_id = cityModel.CITY_ID;
             NSMutableDictionary *userInfo = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserInfoKey] mutableCopy];
             [userInfo setObject:_userInfo.city_id forKey:@"city_id"];
             [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:kUserInfoKey];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
         }
         else
         {
             
         }
     }
                            exceptionResponse:^(NSError *error)
     {
     }];
}


#pragma mark - UIAlerViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 531)
    {
        _userCityModel = _currentCityModel;
        if (buttonIndex == 1)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[_userCityModel convertToDictionary]
                                                      forKey:kLastUserCity];
            [[NSUserDefaults standardUserDefaults] setObject:_userCityModel.CITY_ID forKey:kLocationCityIDKey];
            [[NSUserDefaults standardUserDefaults] setObject:_userCityModel.CITY_NAME forKey:kLocationCityNameKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            _currentSettingCityCoordinate = CLLocationCoordinate2DMake(_userCityModel.LATITUDE.doubleValue, _userCityModel.LONGITUDE.doubleValue);
            
            [self setUpOrderShareParameterWithNormalResponse:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTELocationChange
                                                                    object:nil];
            } exceptionResponse:^{
                
            }];
        }
        else
        {
            _shouldAskWhenChangeCity = NO;
        }
        
        
    }
}

#pragma mark － 从后台切换至前台使用

- (void)didShouldUpdateCenter
{
    if ([_userCityModel.CITY_ID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTELocationChange
                                                            object:nil];
    }
}

- (BOOL)getTheServiceStatus:(NSInteger)targetServiceType
{
    BOOL result = NO;
    
    
    for (int x = 0; x<_cityServiceArray.count; x++)
    {
        HomeButtonModel *model = _cityServiceArray[x];
        
        if (model.service_type.intValue == (int)targetServiceType)
        {
            if (model.open_status.intValue > 0)
            {
                result = YES;
            }
            break;
        }
        
    }
    
    
    return result;
}

- (CLLocation *) getUserCurrentLocation
{
    return _userCurrentLocation;
}

@end
