//
//  define.h
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/15.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#ifndef define_h
#define define_h

#define ThemeImage(imageName)  [UIImage imageNamed:imageName]
#define _COLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define _FONT(s) [UIFont fontWithName:@"Helvetica Neue" size:(s)]

#define Disabled_Color  _COLOR(0x8f, 0x8f, 0x97)
#define Abled_Color  [UIColor colorWithRed:(0x27)/255.0 green:(0xa6)/255.0 blue:(0x69)/255.0 alpha:1]

#define STATIC_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define STATIC_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width



/**********************
 **
 ** 发布版本时候注意测试环境和登陆时验证短信获取
 **
 **********************/


//****************begin*****/
//测试环境
//#define BASE_Uri_FOR_WEB @"http://ibwxt.leanapp.cn"
//#define MAIN_SERVECE_BASE_STR @"http://118.123.249.87:8080/"  //测服
//#define Service_WX_STR @"http://car.wxt.ukuaibao.com/"//微信后台
//#define Owner_CarWah_ID @"5217"
//正式环境
#define BASE_Uri_FOR_WEB @"http://ibwx.leanapp.cn"
#define MAIN_SERVECE_BASE_STR @"http://118.123.249.69:8080/" //正服
#define Service_WX_STR @"http://car.wx.ukuaibao.com/"//微信后台
#define Owner_CarWah_ID  @"5617"

///**************end*******/

#define GU_JIA_URL @"%@/?#!/gujia?memberId=%@&type=%@&carWashId=%@" //@“http://ibwx.leanapp.cn/?#!/gujia?memberId=776&type=1&carWashId=5217”
#define CHE_XIAO_BAP_URL @"%@/#!/chexiaobao/app?memberId=%@"
#define WEI_ZHANG_CHA_XUN @"%@/?#!/wzdb/search/app?memberId=%@"
#define ER_SHOU_CHE_GU_JIA @"%@/?#!/ershouche/app?memberId=%@"
#define TICKET_SHI_YONG_SHUOMING @"%@/?#!/ruleuse?memberId=%@"
#define LI_BAO_LING_QU @"%@/?#!/reward/app?memberId=%@&userName=%@&phone=%@"
#define ABOUT_UKB @"%@/#!/abourt?memberId=%@"

#define SERVICE_PHONE @"4000803939"


#endif /* define_h */
