//
//  Constants.m
//  GoHouseApp
//
//  Created by apple on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"
#import "WebServiceHelper.h"
#import "Reachability.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <errno.h>
#include <net/if_dl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <net/ethernet.h>
#import <AVFoundation/AVFoundation.h>
#import "CarBrandModel.h"
#import "CarSeriesModel.h"
#import "DBManager.h"

#define min(a,b)    ((a) < (b) ? (a) : (b))
#define max(a,b)    ((a) > (b) ? (a) : (b))

#define BUFFERSIZE  4000

#define MAXADDRS    32
char *if_names[MAXADDRS];
char *ip_names[MAXADDRS];
char *hw_addrs[MAXADDRS];
unsigned long ip_addrs[MAXADDRS];

static int   nextAddr = 0;

void InitAddresses()
{
    int i;
    for (i=0; i<MAXADDRS; ++i)
    {
        if_names[i] = ip_names[i] = hw_addrs[i] = NULL;
        ip_addrs[i] = 0;
    }
}

void FreeAddresses()
{
    int i;
    for (i=0; i<MAXADDRS; ++i)
    {
        if (if_names[i] != 0) free(if_names[i]);
        if (ip_names[i] != 0) free(ip_names[i]);
        if (hw_addrs[i] != 0) free(hw_addrs[i]);
        ip_addrs[i] = 0;
    }
    InitAddresses();
}

void GetIPAddresses()
{
    int                 i, len, flags;
    char                buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifconf       ifc;
    struct ifreq        *ifr, ifrcopy;
    struct sockaddr_in  *sin;
    
    char temp[80];
    
    int sockfd;
    
    for (i=0; i<MAXADDRS; ++i)
    {
        if_names[i] = ip_names[i] = NULL;
        ip_addrs[i] = 0;
    }
    
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0)
    {
        perror("socket failed");
        return;
    }
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) < 0)
    {
        perror("ioctl error");
        return;
    }
    
    lastname[0] = 0;
    
    for (ptr = buffer; ptr < buffer + ifc.ifc_len; )
    {
        ifr = (struct ifreq *)ptr;
        len = max(sizeof(struct sockaddr), ifr->ifr_addr.sa_len);
        ptr += sizeof(ifr->ifr_name) + len;  // for next one in buffer
        
        if (ifr->ifr_addr.sa_family != AF_INET)
        {
            continue;   // ignore if not desired address family
        }
        
        if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL)
        {
            *cptr = 0;      // replace colon will null
        }
        
        if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0)
        {
            continue;   /* already processed this interface */
        }
        
        memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
        
        ifrcopy = *ifr;
        ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
        flags = ifrcopy.ifr_flags;
        if ((flags & IFF_UP) == 0)
        {
            continue;   // ignore if interface not up
        }
        
        if_names[nextAddr] = (char *)malloc(strlen(ifr->ifr_name)+1);
        if (if_names[nextAddr] == NULL)
        {
            return;
        }
        strcpy(if_names[nextAddr], ifr->ifr_name);
        
        sin = (struct sockaddr_in *)&ifr->ifr_addr;
        strcpy(temp, inet_ntoa(sin->sin_addr));
        
        ip_names[nextAddr] = (char *)malloc(strlen(temp)+1);
        if (ip_names[nextAddr] == NULL)
        {
            return;
        }
        strcpy(ip_names[nextAddr], temp);
        
        ip_addrs[nextAddr] = sin->sin_addr.s_addr;
        
        ++nextAddr;
    }
    
    close(sockfd);
}

void GetHWAddresses()
{
    struct ifconf ifc;
    struct ifreq *ifr;
    int i, sockfd;
    char buffer[BUFFERSIZE], *cp, *cplim;
    char temp[80];
    
    for (i=0; i<MAXADDRS; ++i)
    {
        hw_addrs[i] = NULL;
    }
    
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0)
    {
        perror("socket failed");
        return;
    }
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, (char *)&ifc) < 0)
    {
        perror("ioctl error");
        close(sockfd);
        return;
    }
    
    ifr = ifc.ifc_req;
    
    cplim = buffer + ifc.ifc_len;
    
    for (cp=buffer; cp < cplim; )
    {
        ifr = (struct ifreq *)cp;
        if (ifr->ifr_addr.sa_family == AF_LINK)
        {
            struct sockaddr_dl *sdl = (struct sockaddr_dl *)&ifr->ifr_addr;
            int a,b,c,d,e,f;
            int i;
            
            strcpy(temp, (char *)ether_ntoa(LLADDR(sdl)));
            sscanf(temp, "%x:%x:%x:%x:%x:%x", &a, &b, &c, &d, &e, &f);
            sprintf(temp, "%02X:%02X:%02X:%02X:%02X:%02X",a,b,c,d,e,f);
            
            for (i=0; i<MAXADDRS; ++i)
            {
                if ((if_names[i] != NULL) && (strcmp(ifr->ifr_name, if_names[i]) == 0))
                {
                    if (hw_addrs[i] == NULL)
                    {
                        hw_addrs[i] = (char *)malloc(strlen(temp)+1);
                        strcpy(hw_addrs[i], temp);
                        break;
                    }
                }
            }
        }
        cp += sizeof(ifr->ifr_name) + max(sizeof(ifr->ifr_addr), ifr->ifr_addr.sa_len);
    }
    
    close(sockfd);
}



const NSString * KWebviewReload = @"webviewReload";


NSString *const kForceExitNotifaction = @"kForceExitNotifaction";
NSString *const kLoginSuccessNotifaction = @"kLoginSuccessNotifaction";
NSString *const kLogoutSuccessNotifaction = @"kLogoutSuccessNotifaction";
NSString *const kLoginByCheckCodeSuccessNotifaction = @"kLoginByCheckCodeSuccessNotifaction";

NSString *const kFinishCitySettingNotifaction = @"FinishCitySettingNotifaction";

NSString *const kOrderDetailShouldUpdateNotification = @"OrderDetailShouldUpdateNotification";


NSString *const kPaySuccessNotification = @"kPaySuccessNotification";
NSString *const kWXPaySuccessNotification = @"kWXPaySuccessNotification";
NSString *const kAddCommentsSuccess = @"kAddCommentsSuccess";

NSString *const kWXPayOutTradeNo = @"kWXPayOutTradeNo";
NSString *const kShouldUpdateCenter = @"kShouldUpdateCenter";

NSString *const kShouldUpdateInsurance = @"ShouldUpdateInsurance";

NSString *const kUnreadMessage = @"UnreadMessage";

NSString *const kUnreadSystemMessageCount = @"UnreadSystemMessageCount";


NSString *const kUnreadSystemMessageNotification = @"UnreadSystemMessageNotification";


NSString *const kNeedBackKey = @"kNeedBackKey";

NSString *const kNeedBackToMainNotification = @"kNeedBackToMainNotification";

//微博

NSString *const kWeiboAppKey = @"335066783";
NSString *const kWeiboAppSecret = @"e596a4bfffb22219405b41da30085764";

//微信

NSString *const kWeixinAppKey = @"wx51f6b8a9feaad978";
NSString *const kWeixinAppSecret= @"431034a221940c4be1f7d8ef4ff3cdc5";

//QQ

NSString *const kQQAppKey = @"1102522250";//16进制值为41B7278A
NSString *const kQQAppSecret = @"kKBcbz0xMKYFqAEY";

NSString *const kShareSDKAppKey = @"585a85027456";

NSString *const kUserInfoKey = @"UserInfo";

NSString *const kStartInfoKey = @"StartInfo";

NSString *const kLoginToken = @"token";

NSString *const kAutoLogin = @"AutoLogin";

NSString *const localDBName = @"crazy_car_wash_local.db";

NSString *const kIsForcedUpdate = @"isForcedUpdate";

NSString *const kUpdateContent = @"UpdateContent";

NSString *const kSharePicUrl = @"SharePicUrl";

NSString *const kShareAppUrl = @"ShareAppUrl";

NSString *const kShareAppTitle = @"ShareAppTitle";

NSString *const kCustomLaunch = @"CustomLaunch";

NSString *const kMainAdvImageShowTime = @"MainAdvImageShowTime";



NSString *const kLastAppConfig = @"LastAppConfig";



NSString *const kShareContent = @"kShareContent";


NSString *const kCarBrandVerNo = @"brand_ver_no";
NSString *const kCarBrandNeedUpdate = @"CarBrandNeedUpdate";

 NSString *const kLocationCityIDKey = @"LocationCityIDKey";

NSString *const kLocationCityNameKey = @"LocationCityNameKey";

NSString *const kLastUserCity = @"LastUserCity";

NSString *const kLastUserCitySetted = @"LastUserCitySetted";



NSString *const kUserCurrentAddressKey = @"UserCurrentAddressKey";


NSString *const kLocationDBVersion = @"LocationDBVersion";

NSString *const kCarSeriesVerNo = @"series_ver_no";
NSString *const kCarSeriesNeedUpdate = @"CarSeriesNeedUpdate";


NSString *const kCarKindVerNo = @"kind_ver_no";

NSString *const kCarKindNeedUpdate = @"kCarKindNeedUpdate";



NSString *const kGaoDeMapKey = @"f4ee9c4f59c4d6f895954228b2c60bd3";




NSString *const kDownloadUrl = @"http://www.car517.com/views/phone/index.html";

NSString *const kLocationKey = @"LocationKey";

NSString *const kDeviceToken = @"DeviceToken";

//NSString *const kLastAppConfig = @"LastAppConfig";


NSString *const kMainInsuranceImage = @"MainInsuranceImage";


NSString *const kJuheKey = @"135f64c53d7280468a014a7d16d6a288";


@implementation Constants

+ (UIAlertView *)showMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"好的"
                                              otherButtonTitles:nil];
    [alertView show];
    return  alertView;
}


- (NSString*)getPlist:(NSString *) key
{
    NSArray *myPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *myDocPath = [myPaths objectAtIndex:0];
    NSString *filename = [myDocPath stringByAppendingPathComponent:@"properties.plist"];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:filename];
    return [dict objectForKey: key] ;
}

- (void)setPlist:(NSString *)key andValue:(NSString*)value
{
    NSArray *myPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *myDocPath = [myPaths objectAtIndex:0];
    NSString *filename = [myDocPath stringByAppendingPathComponent:@"properties.plist"];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:filename];
    [dict setValue:value forKey:key];
    [dict writeToFile:filename atomically:YES];
}

- (BOOL)netWork
{
    Reachability *r = [Reachability reachabilityWithHostName:[self getPlist:@"checkNet"]];
    switch ([r currentReachabilityStatus])
    {
        case NotReachable:
            // 没有网络连接
            NSLog(@"没有网络");
            return YES;
        case ReachableViaWWAN:
            // 使用3G网络
            NSLog(@"正在使用3G网络");
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            NSLog(@"正在使用wifi网络");
            break;
    }
    return NO;
}

+ (void)showMessage:(NSString *)message
           delegate:(id)delegate
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:message
                                                       delegate:delegate
                                              cancelButtonTitle:@"好的"
                                              otherButtonTitles:nil];
    [alertView show];
}

+ (void)showMessage:(NSString *)message
           delegate:(id)delegate
                tag:(int)tag
       buttonTitles:(NSString *)otherButtonTitles, ...
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:message
                                                       delegate:delegate
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil];
    va_list args;
    va_start(args, otherButtonTitles);
    for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*))
    {
        [alertView addButtonWithTitle:arg];
    }
    va_end(args);
    [alertView show];
    alertView.tag = tag;
}

+ (NSString *)deviceIPAdress
{
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    
    return [NSString stringWithFormat:@"%s", ip_names[5]];
}

+ (NSString *)devicePublicIPAdress
{
    //http://20140507.ip138.com/ic.asp
    //http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js
    NSError *error = nil;
    NSString *ipString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://20140507.ip138.com/ic.asp"]
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
    if (error)
    {
        return nil;
    }
    return ipString;
}

+ (BOOL)canMakePhoneCall
{
    NSString *deviceType = [UIDevice currentDevice].model;
    return  !([deviceType  isEqualToString:@"iPod touch"]||
              [deviceType  isEqualToString:@"iPad"]||
              [deviceType  isEqualToString:@"iPhone Simulator"]);
}

+ (NSString*)getCrazyCarWashImageDirestory
{
    NSArray *libraryPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *imageDirectory = [libraryPaths objectAtIndex:0];
    NSString *resultDirectory = [imageDirectory stringByAppendingFormat:@"/CrazyCarWashImages"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:resultDirectory ])
    {
        [fileManager createDirectoryAtPath:resultDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return resultDirectory;
}


+ (NSString*)getPayWayDescription:(NSString*)payWayString
{
    NSString *resultString = nil;
    
    if ([payWayString isEqualToString:@"1"])
    {
        resultString = @"余额支付";
    }
    else if ([payWayString isEqualToString:@"2"])
    {
        resultString = @"支付宝";
    }
    else if ([payWayString isEqualToString:@"3"])
    {
        resultString = @"微信支付";
    }
    else if ([payWayString isEqualToString:@"5"])
    {
        resultString = @"优惠券支付";
    }
    else if ([payWayString isEqualToString:@"6"])
    {
        resultString = @"优惠券 + 余额 + 支付宝";
    }
    else if ([payWayString isEqualToString:@"7"])
    {
        resultString = @"优惠券 + 余额 + 微信支付";
    }
    else if ([payWayString isEqualToString:@"8"])
    {
        resultString = @"余额 + 支付宝";
    }
    else if ([payWayString isEqualToString:@"9"])
    {
        resultString = @"余额 + 微信支付";
    }
    else if ([payWayString isEqualToString:@"10"])
    {
        resultString = @"优惠券 + 余额";
    }
    else if ([payWayString isEqualToString:@"11"])
    {
        resultString = @"优惠券 + 支付宝";
    }
    else if ([payWayString isEqualToString:@"12"])
    {
        resultString = @"优惠券 + 微信支付";
    }
    else if ([payWayString isEqualToString:@"13"])
    {
        resultString = @"银联支付";
    }
    else if ([payWayString isEqualToString:@"14"])
    {
        resultString = @"优惠券 + 余额 + 银联支付";
    }
    else if ([payWayString isEqualToString:@"15"])
    {
        resultString = @"余额 + 银联支付";
    }
    else if ([payWayString isEqualToString:@"16"])
    {
        resultString = @"优惠券 + 银联支付";
    }
    else if ([payWayString isEqualToString:@"4"])
    {
        resultString = @"现场支付";
    }
    else
    {
        resultString = @"其他方式";
    }

    return resultString;
}
- (void)showAlter:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:msg
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
}

- (NSUInteger)indexOf:(NSString*)str1 msg:(NSString*)str2{
    NSRange range = [str1 rangeOfString:str2];
    return range.length;
}

- (NSString *)getNowTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [formatter stringFromDate:[NSDate date]];
}


- (NSString*)sbjson:(NSDictionary*)dic msg:(NSString*)key
{
    @try
    {
        if([dic objectForKey:key])
        {
            return [dic objectForKey:key];
        }
        else
        {
            return @"";
        }
    }
    @catch (NSException *exception)
    {
        return @"";
    }
}

+ (NSString *)distanceBetweenOrderBy:(double)lat1
                                :(double)lat2
                                :(double)lng1
                                :(double)lng2
{
    double dd = M_PI/180;
    double x1=lat1*dd,x2=lat2*dd;
    double y1=lng1*dd,y2=lng2*dd;
    double R = 6371004;
    double distance = (2*R*asin(sqrt(2-2*cos(x1)*cos(x2)*cos(y1-y2) - 2*sin(x1)*sin(x2))/2));
    if (distance > 1000)
    {
        return  [NSString stringWithFormat:@"%.2f千米", distance/1000];
    }
    //km  返回
    //     return  distance*1000;
    
    //返回 m

    return   [NSString stringWithFormat:@"%f米", distance];
    
}

+(NSString *)LantitudeLongitudeDist:(double)lon1
                          other_Lat:(double)lat1
                           self_Lon:(double)lon2
                           self_Lat:(double)lat2
{
    double er = 6378137; // 6378700.0f;
    //ave. radius = 6371.315 (someone said more accurate is 6366.707)
    //equatorial radius = 6378.388
    //nautical mile = 1.15078
    double radlat1 = M_PI*lat1/180.0f;
    double radlat2 = M_PI*lat2/180.0f;
    //now long.
    double radlong1 = M_PI*lon1/180.0f;
    double radlong2 = M_PI*lon2/180.0f;
    if( radlat1 < 0 ) radlat1 = M_PI/2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = M_PI/2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = M_PI*2 - fabs(radlong1);//west
    if( radlat2 < 0 ) radlat2 = M_PI/2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = M_PI/2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = M_PI*2 - fabs(radlong2);// west
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    //side, side, side, law of cosines and arccos
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er;
    if (dist > 1000)
    {
        return  [NSString stringWithFormat:@"%.2f千米", dist/1000];
    }
    //km  返回
    //     return  distance*1000;
    
    //返回 m
    return   [NSString stringWithFormat:@"%.2f米", dist];
}

+ (void)reloadUserInfo
{
    
}

+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withTarget:(UIImage*)target

{
    UIImage *sourceImage = target;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
        
    {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContextWithOptions(targetSize, YES, 0);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void)speakingWithWords:(NSString*)string
{
    AVSpeechSynthesizer *avSpeech = [[AVSpeechSynthesizer alloc] init];
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:string];
    //设置语言类别（不能被识别，返回值为nil）
    AVSpeechSynthesisVoice *voiceType = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utterance.voice = voiceType;
    //设置语速快慢
    utterance.rate *= 0.3;
    //语音合成器会生成音频
    [avSpeech speakUtterance:utterance];
}


+ (void)checkAndSupplyCarInfo:(CarInfos*)targetModel
               normalResponse:(void(^)(CarInfos *result))normalResponse
            exceptionResponse:(void(^)(void))exceptionResponse
{
    CarInfos *resultModel = nil;
    if (targetModel.series_id == nil || [targetModel.brand_id isEqualToString:@""] || [targetModel.series_id isEqualToString:@""] || targetModel.series_id == nil)
    {
        CarBrandModel *brandModel = [DBManager queryCarBrandByBrandName:targetModel.car_brand];
        if (brandModel == nil)
        {
            exceptionResponse();
            return;
        }
        else
        {
            CarSeriesModel *seriesModel = [DBManager queryCarSeriesBySeriesName:targetModel.car_xilie];
            if (seriesModel == nil)
            {
                exceptionResponse();
                return;
            }
            else
            {
                resultModel = targetModel;
                NSMutableDictionary *paramDic = [@{} mutableCopy];
                [paramDic setValue:_userInfo.member_id forKey:@"member_id"];
                [paramDic setValue:resultModel.car_id forKey:@"car_id"];
                [paramDic setValue:resultModel.car_no
                            forKey:@"car_no"];
                [paramDic setValue:resultModel.car_type
                            forKey:@"car_type"];
                [paramDic setValue:resultModel.car_brand forKey:@"car_brand"];
                [paramDic setValue:brandModel.BRAND_ID forKey:@"brand_id"];
                [paramDic setValue:resultModel.car_kuanshi forKey:@"car_kuanshi"];
                [paramDic setValue:resultModel.car_xilie forKey:@"car_xilie"];
                [paramDic setValue:seriesModel.SERIES_ID forKey:@"series_id"];
                
                [paramDic setValue:@"update" forKey:@"op_type"];
                
                [WebService requestJsonOperationWithParam:paramDic
                                                   action:@"car/service/manage"
                                           normalResponse:^(NSString *status, id data)
                 {
                     resultModel.series_id = seriesModel.SERIES_ID;
                     resultModel.brand_id = brandModel.BRAND_ID;
                     normalResponse(resultModel);
                     return;
                 }
                                        exceptionResponse:^(NSError *error)
                 {
                     exceptionResponse();
                     return;
                 }];

                

            }
        }
    }
    else
    {
        resultModel = targetModel;
        normalResponse(resultModel);
        return;
    }
}

+ (NSDate*) convertDateFromString:(NSString*)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH"];
    NSDate *date=[formatter dateFromString:string];
    return date;
}

//+ (NSString *) getTicketsStringWIthValue:(NSInteger) value
//{
//    if(value == 100000){
//        _ticketPriceLabel.text = @"免费";
//        _priceTitleLabel.text = @"";
//        _lbExplainInfo.text = [model.code_desc stringByReplacingOccurrencesOfString:@" " withString:@""];
//    }else if (value >=10000 && value < 100000){
//        CGFloat f = price / 10000.0;
//        _ticketPriceLabel.text = [NSString stringWithFormat:@"%.1f", f];
//        _priceTitleLabel.text = @"折";
//        _lbExplainInfo.text = @"";
//    }
//    else{
//        _ticketPriceLabel.text = [NSString stringWithFormat:@"%d",model.price.intValue];
//        _priceTitleLabel.text = @"元";
//        _lbExplainInfo.text = @"";
//    }
//}

@end
