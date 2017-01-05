//
//  AppDelegate.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/19.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "WXApi.h"
#import "GPSLocationManager.h"
#import "BaiduMapAPI_Map/BMKMapView.h"//只引入所需的单个头文件

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>
{
    BMKMapManager* _mapManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIWindow *loginWindow;

@property (strong, nonatomic) GPSLocationManager *gpsLocationManager;

@property (strong, nonatomic) NSTimer  *msgRefrishTimer;


- (void)updateUserInfo;

- (void)getAllTypeUnreadMessage;

- (void)startMSGRefrishTimer;

- (void)stopMSGRefrishTimer;


- (void)showNewLabel:(int)unreadMessageCount
     andNannyMessage:(int)nannyMessageCount;

- (void)shouldShowOrHideHot:(BOOL)shouldShould;

- (void)showAlertMessageForRegisterNotifacation:(NSString*)alertString;

- (void)startAutoLogin:(UserInfo*)userInfo
      autoLoginSuccess:(void(^)(void))normalResponse
        autoLoginError:(void(^)(void))exceptionResponse;

- (void)cleanAllUserRelationInfo;

- (void)submitUserCancelPayOpreationWithOutTradeNo:(NSString*)outTradeNo;
@end

