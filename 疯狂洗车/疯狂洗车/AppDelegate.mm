//
//  AppDelegate.m
//  优快保
//
//  Created by 朱伟铭 on 15/1/19.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "AppDelegate.h"
#import "RDVTabBarController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WeiboSDK.h"
#import "WeiboSDK+Statistics.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "UIView+Toast.h"
#import "WebServiceHelper.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <sqlite3.h>

#import "PayHelper.h"
#import "TabActivityCircle.h"
#import "MainViewController.h"
#import "CarNannyMessageViewController.h"
#import "OrderShareModel.h"
#import "CustomLaunchView.h"
#import "KGStatusBar.h"
#import "MessageModel.h"
#import "DBManager.h"
#import <AVFoundation/AVFoundation.h>
#import "MyOrdersController.h"
#import "MTA.h"
#import "MTAConfig.h"
#import "InsuranceViewController.h"
#import "InsuranceHelper.h"
#import "base64.h"
#import "ActivitysController.h"
#import "StartInfoModel.h"

#define refreshSecond 60 //轮循刷新频率

#define defaultCarBrandVerNo  @"1.0" //数据库车辆品牌版本号
#define defaultCarSeriesVerNo @"1.0" //数据库车系列版本号
#define defaultCarKindVerNo   @"1.0" //数据库车类型版本号
#define defaultDBVerNo        @"3.0" //数据库版本号

#define defaultLaunchVersion       @"4.30" //自定义启动页面版本号



@interface AppDelegate ()<CustomLaunchViewDelegate,UIAlertViewDelegate,TencentSessionDelegate,WeiboSDKDelegate>
{
    int _seconds;
    
    TabActivityCircle *_activityView;
    
    CustomLaunchView  *_customLaunchImageView;
    
    BOOL   _isFromMessageCenter;
    
    UIView    *_statusMessageView;
    
    UILabel   *_hotLabel;
    
    BOOL   _carNannyMessageLoading;
    
    BOOL   _messageCenterLoading;
    
    TencentOAuth *_tencentOAuth;

}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
     
     
     */
    
    application.applicationIconBadgeNumber = 0;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    
    //注册推送
    [self registNotification:application];

    //推送token设为全局变量
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kDeviceToken])
    {
        _notificationDeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceToken];
        NSLog(@"%@",_notificationDeviceToken);
    }
    
    //设置全局客服电话
    _kefudianhuaNumber = [NSString stringWithFormat:@"%@",defaultPhoneNumber];
    
    //注册appdelegate的推送通知
    [self installNotifications];
    
    //引导页版本号
    _kVersionEverLaunch = [NSString stringWithFormat:@"%@EverLaunch",defaultLaunchVersion];
    
    //判断是否由推送通知进入应用
    if(launchOptions)
    {
        NSDictionary* pushNotificationInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if(pushNotificationInfo)
        {
            _isFromMessageCenter = YES;
        }
    }
    
    //设置数据库默认版本
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kCarBrandVerNo])
    {
        [[NSUserDefaults standardUserDefaults] setObject:defaultCarBrandVerNo forKey:kCarBrandVerNo];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kCarSeriesVerNo])
    {
        [[NSUserDefaults standardUserDefaults] setObject:defaultCarSeriesVerNo forKey:kCarSeriesVerNo];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kCarKindVerNo])
    {
        [[NSUserDefaults standardUserDefaults] setObject:defaultCarKindVerNo forKey:kCarKindVerNo];
    }

    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLocationCityIDKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLocationCityNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //注册并启动高德地图SDK
    [MAMapServices sharedServices].apiKey = kGaoDeMapKey;
    [AMapLocationServices sharedServices].apiKey = kGaoDeMapKey;
    [AMapSearchServices sharedServices].apiKey = kGaoDeMapKey;
    
    //生成并启动定位模块
    self.gpsLocationManager = [[GPSLocationManager alloc] init];
    [self.gpsLocationManager startGPSLocationManager];
    
    //创建本地数据库
    [self createEditableCopyOfDatabaseIfNeeded];
    
    //注册并启动腾讯MTA统计
    if ([MTA startWithAppkey:@"IX3QB8CGU63H"
           checkedSdkVersion:MTA_SDK_VERSION]) {
        NSLog(@"mta启动成功");
    }
    
    //2. 初始化社交平台
    //2.1 代码初始化社交平台的方法
    [self initializePlat];
    
    //更新闪屏图片资源
    [self updateProjectSplashImage];
    
    //获取并更新应用设置参数
    [self setUpApplicationParameter];

    //自动登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserInfoKey])
    {
        _userInfo = [[UserInfo alloc] initWithCacheKey:kUserInfoKey];
        [self startAutoLogin:_userInfo
            autoLoginSuccess:^{
                
                
            }
              autoLoginError:^{
                  
                  [self cleanAllUserRelationInfo];
              }];
    }

    //判断是否应该显示引导页
    if (![[NSUserDefaults standardUserDefaults] boolForKey:_kVersionEverLaunch])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES
                                                forKey:_kVersionEverLaunch];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIViewController *controller = ALLOC_WITH_CLASSNAME(@"HFTWelcomeViewController");
        [self.window setRootViewController:controller];
        
        
    }
    else
    {
        //不显示引导页时，生成TabBar
        [self setupTabbar];

        //是否显示自定义闪屏界面
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kCustomLaunch])
        {
            _customLaunchImageView = [[NSBundle mainBundle] loadNibNamed:@"CustomLaunchView" owner:self options:nil][0];
            _customLaunchImageView.frame = [UIScreen mainScreen].bounds;
            _customLaunchImageView.delegate = self;
            [self.window addSubview:_customLaunchImageView];
            [self.window bringSubviewToFront:_customLaunchImageView];
            [_customLaunchImageView startCustomLaunchRefrishTimer];
        }

    }
    // Override point for customization after application launch.
    return YES;
}

#pragma mark - 用户信息相关

- (void)startAutoLogin:(UserInfo*)userInfo
      autoLoginSuccess:(void(^)(void))normalResponse
        autoLoginError:(void(^)(void))exceptionResponse
{
    NSDictionary *tmpDic=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"]];
    NSDictionary *autoLogin = [[NSUserDefaults standardUserDefaults] objectForKey:kAutoLogin];
    NSDictionary *submitDic = @{@"login_name":[autoLogin objectForKey:@"login_name"],
                                @"app_type":@"2",
                                @"user_type":@"1",
                                @"app_version":[NSString stringWithFormat:@"%.2f",[[tmpDic valueForKey:@"CFBundleShortVersionString"] floatValue]],
                                @"client_id":_notificationDeviceToken==nil?@"":_notificationDeviceToken};
    [WebService requestJsonModelWithParam:submitDic
                                   action:@"member/service/login"
                               modelClass:[UserInfo class]
                           normalResponse:^(NSString *status, id data, JsonBaseModel *model)
     {
         if (status.intValue > 0)
         {
             _userInfo = (UserInfo *)model;
             if (_userInfo.member_id && [_userInfo.city_id isEqualToString:@""] && _userCityModel)
             {
                 [self.gpsLocationManager setUpUserCity:_userCityModel];
             }
             _agentModel = [[AgentModel alloc] initWithDictionary:data];
             [[NSUserDefaults standardUserDefaults] setObject:[_userInfo convertToDictionary]
                                                       forKey:kUserInfoKey];
             [[NSUserDefaults standardUserDefaults] setObject:_userInfo.token
                                                       forKey:kLoginToken];
             [[NSUserDefaults standardUserDefaults] synchronize];
             [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotifaction
                                                                 object:nil];
             normalResponse();
             return ;
         }
         else
         {
             exceptionResponse();
             return ;
         }
     }
                        exceptionResponse:^(NSError *error) {

                            exceptionResponse();
                            return ;
                        }];
}

#pragma mark - 清楚跟客户信息有关数据和界面更新 Method

- (void)cleanAllUserRelationInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults integerForKey:kUnreadSystemMessageCount] > 0)
    {
        [userDefaults setInteger:0 forKey:kUnreadSystemMessageCount];
    }
    
    if ([userDefaults objectForKey:kUnreadMessage])
    {
        [userDefaults removeObjectForKey:kUnreadMessage];
       // [self refreshMessageNumLabel:@""];
    }
    
    [userDefaults synchronize];
    
    [self showNewLabel:0 andNannyMessage:0];
}


#pragma mark - 注册推送 Method

- (void)registNotification:(UIApplication *)application
{
    UIRemoteNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
    UIUserNotificationType typesForiOS8 = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)])
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:typesForiOS8
                                                                                        categories:nil]];
        [application registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
}

#pragma mark - 更新客户信息 Method

- (void)updateUserInfo
{
    NSDictionary *submitDic = @{@"member_id":_userInfo.member_id};
    [WebService requestJsonModelWithParam:submitDic
                                   action:@"member/service/get"
                               modelClass:[UserInfo class]
                           normalResponse:^(NSString *status, id data, JsonBaseModel *model)
     {
         if (status.intValue > 0)
         {
             UserInfo *userInfo = (UserInfo *)model;
             [[NSUserDefaults standardUserDefaults] setObject:[userInfo convertToDictionary]
                                                       forKey:kUserInfoKey];
             [[NSUserDefaults standardUserDefaults] synchronize];
             [self startMSGRefrishTimer];
         }
         else
         {
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAutoLogin];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserInfoKey];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLoginToken];
             [[NSUserDefaults standardUserDefaults] synchronize];
         }
     }
                        exceptionResponse:^(NSError *error)
     {
         
     }];
}

#pragma mark - 注册通知 Method

- (void)installNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess:)
                                                 name:kLoginSuccessNotifaction
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logoutSuccess:)
                                                 name:kLogoutSuccessNotifaction
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupTabbar)
                                                 name:kNeedBackToMainNotification
                                               object:nil];
    
}

#pragma mark - 自定义闪屏页面是否消除 Method

- (void)didShouldHideCustomLaunchView
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [_customLaunchImageView hideMainAdvView];
}

#pragma mark - 用户点击自定义闪屏页面弹出广告 Method

- (void)didTouchOnLaunchButtoned
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [_customLaunchImageView hideMainAdvView];
    if (_startInfo != nil )
    {
        if ([_startInfo.adv_url isEqualToString:@""] || _startInfo.adv_url == nil)
        {
            return;
        }
        else
        {
            ADVModel *headerModel = [[ADVModel alloc] init];
            headerModel.url = _startInfo.adv_url;
            headerModel.url_type = _startInfo.url_type;
            headerModel.title = _startInfo.url_tilte;
            ActivitysController *viewController = [[ActivitysController alloc] initWithNibName:@"ActivitysController" bundle:nil];
            viewController.advModel = headerModel;
            
            viewController.forbidAddMark = [headerModel.url_type isEqualToString:@"2"]?NO:YES;
            
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:viewController];
            
            [self.window.rootViewController presentViewController:navi
                                                         animated:YES
                                                       completion:^{
                                                           
                                                       }];
        }
    }


}

#pragma mark - 生成TabBar Method

- (void)setupTabbar
{
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc]init];
    
    MainViewController *homePage = nil;
    homePage = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    
    UINavigationController *homeNavi = [[UINavigationController alloc] initWithRootViewController:homePage];
    
    
//    InsuranceViewController *insuranceController = [[InsuranceViewController alloc] initWithNibName:@"InsuranceViewController" bundle:nil];
    InsuranceViewController *insuranceController = [[InsuranceViewController alloc] init];

    
    UINavigationController *insuranceNavi = [[UINavigationController alloc] initWithRootViewController:insuranceController];

    UIViewController *mine = ALLOC_WITH_CLASSNAME(@"MineViewController");
    UINavigationController *mineNavi = [[UINavigationController alloc] initWithRootViewController:mine];
    
    [tabBarController setViewControllers:@[homeNavi,
                                           insuranceNavi,
                                           mineNavi]];
    [self customizeTabBarForController:tabBarController];
    
    [self.window setRootViewController:tabBarController];
    [self shouldShowOrHideHot:YES];

    if (_isFromMessageCenter)
    {
        [self showNewLabel:1
           andNannyMessage:0];
    }

}

#pragma mark - 生成TabBar Method

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController
{
    NSArray *tabBarItemImages = @[@"img_tabbar_carwash", @"img_tabbar_insurance",@"img_tabbar_mine"];
    NSArray *tabBarItemTitle = @[@"首页", @"保险",@"我的"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items])
    {
        [item setTitle:tabBarItemTitle[index]];
        
        [item setSelectedTitleAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                           NSForegroundColorAttributeName: [UIColor colorWithRed:205.0/255.0
                                                                                           green:85.0/255.0
                                                                                            blue:20.0/255.0
                                                                                           alpha:1.0]}];
        
        [item setUnselectedTitleAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                           NSForegroundColorAttributeName: [UIColor colorWithRed:137.0/255.0
                                                                                           green:137.0/255.0
                                                                                            blue:137.0/255.0
                                                                                           alpha:1.0]}];
        [item setBadgeTextColor:[UIColor orangeColor]];
        
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_h",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage
           withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
    

    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineLabel.backgroundColor  = [UIColor colorWithRed:178.0/255.0
                                                 green:178.0/255.0
                                                  blue:178.0/255.0
                                                 alpha:0.5];
    [[tabBarController tabBar] addSubview:lineLabel];
    [[tabBarController tabBar] setBackgroundColor:[UIColor colorWithRed:250.0/255.0
                                                                  green:250.0/255.0
                                                                   blue:250.0/255.0
                                                                  alpha:1.0]];
}

#pragma mark - 用户退出登录的通知响应，停止轮循获取消息，更新保险页面 Method

- (void)logoutSuccess:(NSNotification *)notification
{
    [self stopMSGRefrishTimer];
    [InsuranceHelper requestInsuranceHomeModelNormalResponse:^{
    }
                                           exceptionResponse:^{
                                               
                                           }];
    
}

#pragma mark - 用户登录成功的通知响应，更新保险页面 Method

- (void)loginSuccess:(NSNotification *)notification
{
    _userInfo = [[UserInfo alloc] initWithCacheKey:kUserInfoKey];
    [InsuranceHelper requestInsuranceHomeModelNormalResponse:^{
    }
                                           exceptionResponse:^{
                                               
                                           }];
}

#pragma mark - 注册并启动第三方sdk（微博、微信、QQ） Method


- (void)initializePlat
{
    
    [WeiboSDK registerApp:kWeiboAppKey];
    
    [WXApi registerApp:kWeixinAppKey];

    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQAppKey
                                            andDelegate:self];
}

#pragma mark - 应用将进入后台时停止轮循 Method

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"applicationWillResignActive");
    [self stopMSGRefrishTimer];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"applicationDidEnterBackground");
}


#pragma mark - 应用将从后台恢复时更新地理位置信息 Method

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
    [[NSNotificationCenter defaultCenter] postNotificationName:kShouldUpdateCenter object:nil];

}

#pragma mark - 应用从后台恢复后重新开始轮循 Method

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive");
    application.applicationIconBadgeNumber = 0;
    if (!_userInfo.member_id)
    {
        
    }
    else
    {
        [self startMSGRefrishTimer];
        
    }

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - 推送通知注册成功后获取token Method

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"DeviceToken: {%@}",deviceToken);
    NSString *deviceTokenString = [NSString stringWithFormat:@"%@",deviceToken];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@">" withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenString
                                              forKey:kDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _notificationDeviceToken = deviceTokenString;


    //    [Utility showMessage:[NSString stringWithFormat:@"%@",deviceToken]];
    //这里进行的操作，是将Device Token发送到服务端
}

#pragma mark - 推送通知注册失败后清楚token Method

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Register Remote Notifications error:{%@}", [error localizedDescription]);
    _notificationDeviceToken = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //    [Utility showMessage:[error localizedDescription]];
}

#pragma mark - 接收到推送通知后根据通知内容向服务器请求消息 Method

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    application.applicationIconBadgeNumber = 0;
    
    NSLog(@"\n\ndidReceiveRemoteNotification：%@",userInfo);
    //NSLog(@"\n\n%@",[[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"loc-key"]);
    
    NSString *infoJsonStr = [userInfo valueForKey:@"json"] ;
    NSError  *error = nil;
    //
    NSDictionary *bodyJsonDic = [NSJSONSerialization JSONObjectWithData:[infoJsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
    if (error == nil && bodyJsonDic != nil)
    {
        if ([[bodyJsonDic objectForKey:@"msgType"] isEqualToString:@"1"])
        {
            //拉取所有系统消息
            [self getAllTypeUnreadMessage];
        }
        else if ([[bodyJsonDic objectForKey:@"msgType"] isEqualToString:@"2"])
        {
            //拉取所有车大白消息
            [self getAllCarNannyRespone];
        }
        else
        {
            //仅在status bar显示通知
            [self showStatusMessageAlertWithTitle:@"您收到一条新消息"];
        }
    }
    else
    {
        [Constants showMessage:[error description]];
    }
}

- (void)showStatusMessageAlertWithTitle:(NSString *)titleString
{
    [KGStatusBar showWithStatus:titleString];
    //5秒后status bar 提醒消失
    [self performSelector:@selector(hideStatusMessageAlert)
               withObject:nil afterDelay:5.0];

    return;
}

- (void)hideStatusMessageAlert
{
    [KGStatusBar dismiss];
    return;

}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([[url absoluteString] rangeOfString:kWeixinAppKey].location != NSNotFound)
    {
        return [WXApi handleOpenURL:url
                           delegate:self];
    }
    if ([[url absoluteString] rangeOfString:[NSString stringWithFormat:@"wb%@",kWeiboAppKey]].location != NSNotFound)
    {
        return [WeiboSDK handleOpenURL:url
                              delegate:self];
    }
    
    
    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic)
         {
             NSLog(@"result = %@", resultDic);
             
             
             NSDictionary *submitDic = @{@"member_id":_userInfo.member_id};
             [WebService requestJsonModelWithParam:submitDic
                                            action:@"member/service/get"
                                        modelClass:[UserInfo class]
                                    normalResponse:^(NSString *status, id data, JsonBaseModel *model)
              {
                  if (status.intValue > 0)
                  {
                      UserInfo *userInfo = (UserInfo *)model;
                      _userInfo.account_remainder = userInfo.account_remainder;
                      [[NSUserDefaults standardUserDefaults] setObject:[userInfo convertToDictionary]
                                                                forKey:kUserInfoKey];
                      //    [[NSUserDefaults standardUserDefaults] setObject:userInfo.token forKey:kLoginToken];
                      [[NSUserDefaults standardUserDefaults] synchronize];
                  }
                  else
                  {
                      
                  }
              }
                                 exceptionResponse:^(NSError *error) {
                                     
                                     
                                 }];

             [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccessNotification object:resultDic];
         }];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    if ([[url absoluteString] rangeOfString:kWeixinAppKey].location != NSNotFound)
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    [TencentOAuth HandleOpenURL:url];
    
    if ([[url absoluteString] rangeOfString:[NSString stringWithFormat:@"wb%@",kWeiboAppKey]].location != NSNotFound)
    {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    
    return YES;
}

#pragma mark - 微信sdk回调

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"支付结果"];
        NSString *strMsg = nil;

        switch (resp.errCode)
        {
            case 0:
            {

                strMsg = @"支付成功";
                NSDictionary *submitDic = @{@"member_id":_userInfo.member_id};
                //支付成功后更新用户信息和账户余额信息
                [WebService requestJsonModelWithParam:submitDic
                                               action:@"member/service/get"
                                           modelClass:[UserInfo class]
                                       normalResponse:^(NSString *status, id data, JsonBaseModel *model)
                 {
                     if (status.intValue > 0)
                     {
                         UserInfo *userInfo = (UserInfo *)model;
                         _userInfo.account_remainder = userInfo.account_remainder;
                         [[NSUserDefaults standardUserDefaults] setObject:[_userInfo convertToDictionary]
                                                                   forKey:kUserInfoKey];
                       //  [[NSUserDefaults standardUserDefaults] setObject:userInfo.token forKey:kLoginToken];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                     }
                     else
                     {
                         
                     }
                 }
                                    exceptionResponse:^(NSError *error) {
                                        
                                        
                                    }];
                //发送用户微信支付成功的订单号
                [[NSNotificationCenter defaultCenter] postNotificationName:kWXPaySuccessNotification object:[PayHelper getWXPayOutTradeNo]];
            }
                break;
            case -1:
            {
                strMsg = @"支付失败";
            }
                break;
            case -2:
            {
                strMsg = @"支付取消";
                //想后台发送用户微信支付取消的订单号
                [self submitUserCancelPayOpreationWithOutTradeNo:[PayHelper getWXPayOutTradeNo]];
            }
                break;
                
            default:
                break;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                        message:strMsg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else  if ([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        
    }

}

#pragma mark - 新浪SDK回调

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if (response.statusCode == WeiboSDKResponseStatusCodeSuccess)
    {
        [Constants showMessage:@"分享成功"];
    }
    else if (response.statusCode == WeiboSDKResponseStatusCodeUserCancel)
    {
        [Constants showMessage:@"分享取消"];
    }
    else
    {
        [Constants showMessage:@"分享失败"];
    }
}

#pragma mark - qqSDk回调

- (void)addShareResponse:(APIResponse*)response
{
    NSLog(@"%@",response);
}

#pragma mark - database

- (void)createEditableCopyOfDatabaseIfNeeded
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:localDBName];
    
    bool success = [fileManager fileExistsAtPath:writableDBPath];
    if (success)
    {
        NSLog(@"数据库存在");
        unsigned long long fileSize = [[fileManager attributesOfItemAtPath:writableDBPath
                                                                     error:nil]
                                       fileSize];
        if (fileSize <= 1000)
        {
            NSLog(@"数据库存但损坏");
            [fileManager removeItemAtPath:writableDBPath error:nil];
        }
        else
        {
            NSString *locationDBVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kLocationDBVersion];
            
            if (locationDBVersion.floatValue < defaultDBVerNo.floatValue)
            {
                NSLog(@"存在老的数据库，删除");
                [fileManager removeItemAtPath:writableDBPath error:nil];
            }
            else
            {
                return;
            }
        }
    }
    
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:localDBName];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success)
    {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    else
    {

        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:defaultCarBrandVerNo forKey:kCarBrandVerNo];
        [userDefault setObject:defaultCarSeriesVerNo forKey:kCarSeriesVerNo];
        [userDefault setObject:defaultCarKindVerNo forKey:kCarKindVerNo];
        [userDefault setObject:defaultDBVerNo forKey:kLocationDBVersion];
        [userDefault synchronize];
        
        NSLog(@"createEditableCopyOfDatabaseIfNeeded 初始化成功");
    }
}

#pragma mark - 强制更新Alert的响应 Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 530)
    {
        if (buttonIndex == alertView.cancelButtonIndex)
        {
            NSString *ifForceUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:kIsForcedUpdate];
            if (ifForceUpdate && [ifForceUpdate isEqualToString:@"1"])
            {
                exit(0);
            }
        }
        if (buttonIndex != alertView.cancelButtonIndex)
        {

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/feng-kuang-qi-che/id899405519?l=zh&ls=1&mt=8"]];
        }
    }
}

#pragma mark - 更新自定义闪屏资源 Method

- (void)updateProjectSplashImage
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserInfoKey])
    {
        _startInfo = [[StartInfoModel alloc] initWithCacheKey:kStartInfoKey];
    }

    NSString *pixelsString = nil;
    
    if (SCREEN_WIDTH < 375)
    {
        if (SCREEN_HEIGHT < 568)
        {
            pixelsString = @"640*960";
        }
        else
        {
            pixelsString = @"640*1136";
        }
    }
    else if (SCREEN_WIDTH > 375)
    {
        pixelsString = @"1242*2208";
    }
    else
    {
        pixelsString = @"750*1334";
    }
    
    NSDictionary *submitdDic = @{@"app_type":@"2",
                                 @"pixels":pixelsString,
                                 @"user_type":@1};
    [WebService requestJsonModelWithParam:submitdDic
                                   action:@"system/service/startinfo"
                               modelClass:[StartInfoModel class]
                           normalResponse:^(NSString *status, id data, JsonBaseModel *model)
     {
         _startInfo = (StartInfoModel*)model;
         [[NSUserDefaults standardUserDefaults] setObject:[_startInfo convertToDictionary]
                                                   forKey:kStartInfoKey];
         [[NSUserDefaults standardUserDefaults] synchronize];
         if (![_startInfo.app_splash_img isEqualToString:@""] && _startInfo.app_splash_img != nil)
         {
             [WebService downloadImageFromServiceWithUrl:_startInfo.app_splash_img
                                                 forName:kCustomLaunch
                                            andMediaType:@""];
             
         }

    }
                        exceptionResponse:^(NSError *error) {
        
    }];
}

#pragma mark - 更新应用参数 Method

- (void)setUpApplicationParameter
{
    NSDictionary *submitDic = @{@"app_type":@"2"};
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"system/service/check"
                               normalResponse:^(NSString *status, id data)
    {
        if (status.intValue > 0)
        {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:[data objectForKey:@"if_forced_update"] forKey:kIsForcedUpdate];//是否强制自动更新
            
            [userDefault setObject:[data objectForKey:@"share_content"] forKey:kShareContent];//应用分享内容
            
            NSString *downloadPath = nil;
            if ([data objectForKey:@"share_pic"])
            {
                [userDefault setObject:[data objectForKey:@"share_pic"] forKey:kSharePicUrl];//应用分享图片
                downloadPath = [data objectForKey:@"share_pic"];
                [WebService downloadImageFromServiceWithUrl:downloadPath forName:@"shareImage" andMediaType:nil];
            }
            if ([data objectForKey:@"share_url"])
            {
                [userDefault setObject:[data objectForKey:@"share_url"] forKey:kShareAppUrl];//应用分享链接
            }
            if ([data objectForKey:@"share_title"])
            {
                [userDefault setObject:[data objectForKey:@"share_title"] forKey:kShareAppTitle];//应用分享标题
            }
            
            
            if (![[data objectForKey:@"brand_ver_no"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kCarBrandVerNo]])
            {
                NSLog(@"品牌过期了");
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kCarBrandNeedUpdate];
            }
            if (![[data objectForKey:@"series_ver_no"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kCarSeriesVerNo]])
            {
                NSLog(@"车系过期了");
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kCarSeriesNeedUpdate];
            }
            if (![[data objectForKey:@"kind_ver_no"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kCarKindVerNo]])
            {
                NSLog(@"车型过期了");
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kCarKindNeedUpdate];
            }
            
            
            [userDefault setObject:[data objectForKey:@"update_content"]
                            forKey:kUpdateContent];//应用更新提示内容
            
            [userDefault synchronize];
            
            NSString *cur_ver_no = [data objectForKey:@"cur_ver_no"];
            if ([cur_ver_no isEqualToString:@""] || cur_ver_no == nil)
            {
                
            }
            else
            {
                NSDictionary *tmpDic=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([cur_ver_no floatValue] > [[tmpDic valueForKey:@"CFBundleShortVersionString"]floatValue])
                    {
                        NSString *updateContent  = nil;
                        
                        if ([[NSUserDefaults standardUserDefaults] objectForKey:kUpdateContent])
                        {
                            updateContent = [[NSUserDefaults standardUserDefaults] objectForKey:kUpdateContent];
                        }
                        else
                        {
                            updateContent = @"存在新的版本是否升级？";
                        }
                        
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                                       message:updateContent
                                                                      delegate:self
                                                             cancelButtonTitle:@"暂不升级"
                                                             otherButtonTitles:@"立即升级",nil];
                        alert.tag = 530;
                        [alert show];
                        
                    }
                });
            }
            
        }
//        [self checkUpdate];

    }
                            exceptionResponse:^(NSError *error) {
      //  [self checkUpdate];
    }];
}

#pragma mark - 获取未读系统消息并写入本地数据库 Method

- (void)getAllTypeUnreadMessage
{
    if (!_userInfo.member_id || _messageCenterLoading)
    {
        return;
    }
    else
    {
        int unReadMessageFromDb = [DBManager queryUserUnReadMessageCountByUserId];
        if ([[NSUserDefaults standardUserDefaults] integerForKey:kUnreadSystemMessageCount] > 0 || unReadMessageFromDb > 0)
        {
            _unReadMessageCount = (int)[[NSUserDefaults standardUserDefaults] integerForKey:kUnreadSystemMessageCount];
            
            if (_unReadMessageCount < unReadMessageFromDb)
            {
                _unReadMessageCount = unReadMessageFromDb;
            }
            
            [self showNewLabel:_unReadMessageCount andNannyMessage:[[NSUserDefaults standardUserDefaults] objectForKey:kUnreadMessage]?1:0];
        }
        _messageCenterLoading = YES;
        NSDictionary *submitDic = @{@"user_id":_userInfo.member_id,
                                    @"user_type":@"1",
                                    @"is_read":@0};
        
        [WebService requestJsonArrayOperationWithParam:submitDic
                                                action:@"msg/service/list"
                                            modelClass:[MessageModel class]
                                        normalResponse:^(NSString *status, id data, NSMutableArray *array)
         {
             _messageCenterLoading = NO;
             if (status.intValue > 0 && array.count > 0)
             {
                 [DBManager insertDateToDBforTab:20
                                       withArray:array
                                          result:^{
                                              int messageCount = (int)array.count;
                                              _unReadMessageCount += messageCount;
                                              NSString *alertString = [NSString stringWithFormat:@"您收到%d条新消息",messageCount];
                                              [self showStatusMessageAlertWithTitle:alertString];
                                              AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                                              [[NSUserDefaults standardUserDefaults] setInteger:_unReadMessageCount
                                                                                         forKey:kUnreadSystemMessageCount];
                                              [[NSUserDefaults standardUserDefaults] synchronize];
                                              [self showNewLabel:_unReadMessageCount
                                                 andNannyMessage:[[NSUserDefaults standardUserDefaults] objectForKey:kUnreadMessage]?1:0];
                                          }
                                           error:^{
                                               
                                           }];
             }
         }
                                     exceptionResponse:^(NSError *error)
         {
             _messageCenterLoading = NO;
         }];
    }
}

#pragma mark - 获取未读系统消息并发送通知和计数 Method

- (void)getAllCarNannyRespone
{
    if (!_userInfo.member_id || _carNannyMessageLoading)
    {
        
    }
    else
    {
        NSDictionary *submitDic = @{@"member_id":_userInfo.member_id};
        _carNannyMessageLoading = YES;
        [WebService requestJsonOperationWithParam:submitDic
                                           action:@"nanny/service/count/unread"
                                   normalResponse:^(NSString *status, id data)
         {
             _carNannyMessageLoading = NO;
             if (status.intValue > 0)
             {
                 

                 NSString *messageCount = [data objectForKey:@"count"];
                 NSString *unreadMessage = [[NSUserDefaults standardUserDefaults] objectForKey:kUnreadMessage];
                 if (messageCount.intValue > 0 && unreadMessage.intValue != messageCount.intValue)
                 {
                     [self showStatusMessageAlertWithTitle:@"车大白回复了您"];
                     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                     [self didReceiveCarNannyMessage:messageCount];
                 }
                 else if (messageCount.intValue == 0)
                 {
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUnreadMessage];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     [self showNewLabel:_unReadMessageCount andNannyMessage:0];
                 }
                 else
                 {
                     [self showNewLabel:_unReadMessageCount andNannyMessage:1];
                 }
                 
             }
             else
             {
                 
             }
         }
                                exceptionResponse:^(NSError *error)
         {
             _carNannyMessageLoading = NO;
         }];
    }
}

- (void)didReceiveCarNannyMessage:(NSString*)string
{
    if (string.intValue > 0)
    {
        //[self refreshMessageNumLabel:string];
        [[NSUserDefaults standardUserDefaults] setObject:string
                                                  forKey:kUnreadMessage];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter]  postNotificationName:@"shouldupdatedate"
                                                             object:string];
        [self showNewLabel:_unReadMessageCount
           andNannyMessage:1];
        
    }
}

#pragma mark - 显示或隐藏Tabbar上的Hot标志 Method

- (void)shouldShowOrHideHot:(BOOL)shouldShould
{
    if (!_hotLabel)
    {
        _hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3/2+5, 3, 15, 14)];
        _hotLabel.text = @"Hot";
        _hotLabel.font = [UIFont boldSystemFontOfSize:7];
        _hotLabel.textColor = [UIColor whiteColor];
        _hotLabel.backgroundColor = [UIColor colorWithRed:235/255.0
                                                    green:84/255.0
                                                     blue:1/255.0
                                                    alpha:1.0];
        _hotLabel.textAlignment = NSTextAlignmentCenter;
        _hotLabel.layer.masksToBounds = YES;
        _hotLabel.layer.cornerRadius = 5;
        RDVTabBarController *controller = (RDVTabBarController *)self.window.rootViewController;
        RDVTabBarItem *item = controller.tabBar.items[1];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadSystemMessageNotification
                                                            object:nil];
        [item addSubview:_hotLabel];
        _activityView.hidden = NO;
    }
    _hotLabel.hidden = !shouldShould;
}



#pragma mark - 计时器 Method

- (void)startMSGRefrishTimer
{
    if ([_msgRefrishTimer isValid])
    {
        [_msgRefrishTimer invalidate];
    }
    _seconds = 0;
    _msgRefrishTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                        target:self
                                                      selector:@selector(beginTimingRecord)
                                                      userInfo:nil
                                                       repeats:YES];
}
//开始计时
- (void)beginTimingRecord
{
    if (_seconds>0)
    {
        _seconds--;
    }
    else
    {
        NSLog(@"请求回复消息");
        if (!_userInfo.member_id)
        {
            [self stopMSGRefrishTimer];
        }
        else
        {
            _seconds = refreshSecond;
            [self getAllTypeUnreadMessage];
            [self getAllCarNannyRespone];
        }

    }
}
//停止及时
- (void)stopMSGRefrishTimer
{
    if ([_msgRefrishTimer isValid])
    {
        [_msgRefrishTimer invalidate];
    }
}


#pragma mark - 在“我的”和“车大白（已废）”的Tabbar分别显示未读标记和消息数量 Method


- (void)showNewLabel:(int)unreadMessageCount
     andNannyMessage:(int)nannyMessageCount
{
    if (unreadMessageCount + nannyMessageCount > 0)
    {
        if (!_userInfo.member_id ||![self.window.rootViewController isKindOfClass:[RDVTabBarController class]]) {
            return;
        }
        
        _unReadMessageCount = (int)unreadMessageCount;
        RDVTabBarController *controller = (RDVTabBarController *)self.window.rootViewController;
        RDVTabBarItem *item = controller.tabBar.items[2];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUnreadSystemMessageNotification
                                                            object:nil];
        
        if (_activityView == nil)
        {
            _activityView = [[TabActivityCircle alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3/2+10, 3, 9, 9)];
            [item addSubview:_activityView];
        }
        _activityView.hidden = NO;
    }
    else
    {
        _unReadMessageCount = 0;
        if (_activityView == nil)
        {
            
        }
        else
        {
            _activityView.hidden = YES;
        }
    }
}

#pragma mark - 弹出alert提醒用户去设置推送（限iOS 8以上） Method

- (void)showAlertMessageForRegisterNotifacation:(NSString*)alertString
{
    if (bIsiOS7)
    {
        [Constants showMessage:alertString];
    }
    else
    {
        [Constants showMessage:alertString
                      delegate:self
                           tag:930
                  buttonTitles:@"取消",@"设置", nil];
    }

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 930 && buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}
#pragma mark - 向用户发送用户取消的订单的订单号 Method

- (void)submitUserCancelPayOpreationWithOutTradeNo:(NSString*)outTradeNo;
{
    NSDictionary *submitDic = @{@"out_trade_no":outTradeNo};
    
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"third/pay/cancelPay"
                               normalResponse:^(NSString *status, id data)
    {
    }
                            exceptionResponse:^(NSError *error) {
    }];
}


@end
