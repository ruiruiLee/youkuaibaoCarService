//
//  GPSLocationManager.h
//  优快保
//
//  Created by cts on 15/8/6.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "CLLocation+YCLocation.h"
#import "WeatherModel.h"
#import "WebServiceHelper.h"
#import "MBProgressHUD+Add.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

//定位启动成功的通知，定位成功包的标志是含获取坐标,城市,以及系统参数
extern NSString *const NOTELocationLaunchSuccess;

//定位改变的通知，定位改变的条件是用户跑道另一个城市了
extern NSString *const NOTELocationChange;




@interface GPSLocationManager : NSObject<AMapLocationManagerDelegate,UIAlertViewDelegate,AMapSearchDelegate>
{
    AMapLocationManager           *_locationManager;
    
    AMapSearchAPI               *_searchAPI;
    
    CLLocation                  *_userCurrentLocation;
    
    WeatherModel                *_weatherModel;
    
    BOOL                         _isRunning;
    
    BOOL                         _lastCityLaunch;
    
    BOOL                         _shouldAskWhenChangeCity;
    
    CityModel                   *_currentCityModel;

}


/**
 *	@brief	启动GPS管理
 *
 *	@return	void
 */
- (void)startGPSLocationManager;

/**
 *	@brief	停止GPS管理，我觉得可能用不到
 *
 *	@return	void
 */
- (void)stopGPSLocationManager;

/**
 *	@brief	根据cityID获取城市服务开通情况
 *
 *	@return	void
 */
- (void)getCityServiceFromService:(NSString*)cityID
                  SuccessResponse:(void(^)(void))successResponse
                     failResponse:(void(^)(void))failResponse;

/**
 *	@brief	当登录用户没有城市id这个字短时调用
 *
 *	@return	void
 */
- (void)setUpUserCity:(CityModel*)cityModel;

- (BOOL)getTheServiceStatus:(NSInteger)targetServiceType;

/**
 *	@brief	更改应用程序的全局参数
 *
 *	@return	void
 */
- (void)changeAppConfigSuccessResponse:(void(^)(void))successResponse
                          failResponse:(void(^)(void))failResponse;

- (void)updateUserCurrentLocationStreetSuccessResponse:(void(^)(void))successResponse
                                          failResponse:(void(^)(void))failResponse;


@end
