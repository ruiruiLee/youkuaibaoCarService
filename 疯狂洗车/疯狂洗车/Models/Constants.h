
#import "UserInfo.h"
#import "CarInfos.h"
#import "ActivityModel.h"
#import "CarWashModel.h"
#import "EvaluationListModel.h"
#import "OrderListModel.h"
#import <MapKit/MapKit.h>
#import "CityModel.h"
#import "QuickLoginViewController.h"
#import "CityServiceModel.h"
#import "OrderShareModel.h"
#import "ButlerOrderModel.h"
#import "AgentModel.h"
#import "InsuranceHomeModel.h"
#import "StartInfoModel.h"
#import "MainAdvModel.h"

#define kNormalTintColor [UIColor colorWithRed:235/255.0 green:84/255.0 blue:1/255.0 alpha:1.0]

#define kClubBlackGoldColor [UIColor colorWithRed:227/255.0 green:174/255.0 blue:82/255.0 alpha:1.0]

#define kClubBlackColor [UIColor colorWithRed:51/255.0 green:52/255.0 blue:56/255.0 alpha:1.0]

#define kClubLightGrayColor [UIColor colorWithRed:207/255.0 green:207/255.0 blue:208/255.0 alpha:1.0]

#define defaultPhoneNumber @"400-080-3939"

extern NSString *const kForceExitNotifaction;
extern NSString *const kLoginSuccessNotifaction;
extern NSString *const kLoginByCheckCodeSuccessNotifaction;

extern NSString *const kOrderDetailShouldUpdateNotification;

extern NSString *const kLogoutSuccessNotifaction;
extern NSString *const kPaySuccessNotification;
extern NSString *const kWXPaySuccessNotification;
extern NSString *const kAddCommentsSuccess;
extern NSString *const kShouldUpdateCenter;


extern NSString *const kShouldUpdateInsurance;

extern NSString *const kFinishCitySettingNotifaction;

extern NSString *const kWXPayOutTradeNo;



extern NSString *const kWeiboAppKey;

extern NSString *const kWeiboAppSecret;

extern NSString *const kWeixinAppKey;

extern NSString *const kWeixinAppSecret;

extern NSString *const kQQAppKey;

extern NSString *const kQQAppSecret;

extern NSString *const kUnreadMessage;

extern NSString *const kUnreadSystemMessageCount;

extern NSString *const kUnreadSystemMessageNotification;

extern NSString *const kShareSDKAppKey;

extern NSString *const kUserInfoKey;

extern NSString *const kDownloadUrl;

extern NSString *const kLocationKey;

extern NSString *const kLocationCityIDKey;

extern NSString *const kLocationCityNameKey;

extern NSString *const kUserCurrentAddressKey;

extern NSString *const kLastUserCity;

extern NSString *const kLastUserCitySetted;

extern NSString *const kLoginToken;

extern NSString *const kStartInfoKey;

extern NSString *const kGaoDeMapKey;

extern NSString *const kAutoLogin;

extern NSString *const localDBName;

extern NSString *const kIsForcedUpdate;

extern NSString *const kUpdateContent;

extern NSString *const kShareContent;

extern NSString *const kSharePicUrl;

extern NSString *const kShareAppUrl;

extern NSString *const kShareAppTitle;

extern NSString *const kCustomLaunch;


extern NSString *const kLastAppConfig;

extern NSString *const kMainAdvImageShowTime;



extern NSString *const kLocationDBVersion;

extern NSString *const kCarBrandVerNo;

extern NSString *const kCarSeriesVerNo;

extern NSString *const kCarKindVerNo;


extern NSString *const kCarBrandNeedUpdate;

extern NSString *const kCarSeriesNeedUpdate;

extern NSString *const kCarKindNeedUpdate;

extern NSString *const kNeedBackKey;

extern NSString *const kDeviceToken;

//extern NSString *const kLastAppConfig;

extern NSString *const kMainInsuranceImage;



extern NSString *const kNeedBackToMainNotification;
extern NSString *const kJuheKey;

UserInfo               *_userInfo;

StartInfoModel         *_startInfo;

MainAdvModel           *_mainAdvModel;

AgentModel             *_agentModel;

ActivityModel          *_activityModel;

CityModel              *_userCityModel;

InsuranceHomeModel     *_insuranceHomeModel;

int                     _unReadMessageCount;

NSString               *_aliPayOutTradeNo;

NSString               *_userCurrentLoactionStreet;

NSString               *_notificationDeviceToken;

NSString               *_kVersionEverLaunch;

NSString               *_kefudianhuaNumber;


CLLocationCoordinate2D  _overallCoordinate;

CLLocationCoordinate2D  _publicUserCoordinate;

CLLocationCoordinate2D  _currentSettingCityCoordinate;


NSMutableArray         *_cityServiceArray;

OrderShareModel        *_appconfig;

ButlerOrderModel       *_userButlerOrder;

BOOL                    _isClubMode;

BOOL                    _loginShouldCreate;

@interface Constants : NSObject


+ (UIAlertView *)showMessage:(NSString *)message;

/*!
 @method
 @abstract 通过需要提示的信息和代理显示一个alert
 @discussion 默认标题为“温馨提示” ，默认dismiss button title为好的
 @param message alert需要显示的内容
 @param delegate alert的代理
 @result void
 */
+ (void)showMessage:(NSString *)message
           delegate:(id)delegate;

/*!
 @method
 @abstract 通过需要提示的信息，代理，tag和多个button显示一个alert
 @discussion 默认标题为“温馨提示”
 @param message alert需要显示的内容
 @param delegate alert的代理
 @param tag 用于区分弹出的多个alert
 @param otherButtonTitles 多个按钮的名字
 @result void
 */
+ (void)showMessage:(NSString *)message
           delegate:(id)delegate
                tag:(int)tag
       buttonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/*!
 @method
 @abstract 获取本机IP地址
 @discussion 默认为获取内网地址，现在默认返回的是IP中心地址
 @result NSString *
 */
+ (NSString *)deviceIPAdress;

/*!
 @method
 @abstract 获取外网IP地址
 @discussion 此方法有网络请求，会卡线程，不建议使用
 @result NSString *
 */
+ (NSString *)devicePublicIPAdress;

+ (BOOL)canMakePhoneCall;

+ (void)speakingWithWords:(NSString*)string;

+ (NSString *)distanceBetweenOrderBy:(double)lat1
                                :(double)lat2
                                :(double)lng1
                                :(double)lng2;

+(NSString *)LantitudeLongitudeDist:(double)lon1
                          other_Lat:(double)lat1
                           self_Lon:(double)lon2
                           self_Lat:(double)lat2;

+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
                                  withTarget:(UIImage*)target;

+ (NSString*)getCrazyCarWashImageDirestory;

+ (NSString*)getPayWayDescription:(NSString*)payWayString;

+ (void)checkAndSupplyCarInfo:(CarInfos*)targetModel
               normalResponse:(void(^)(CarInfos *result))normalResponse
            exceptionResponse:(void(^)(void))exceptionResponse;

+ (NSDate*) convertDateFromString:(NSString*)string;

+ (NSString *) getTicketsStringWIthValue:(NSInteger) value;

@end
