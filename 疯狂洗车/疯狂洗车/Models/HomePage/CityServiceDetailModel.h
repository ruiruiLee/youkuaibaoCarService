//
//  CityServiceDetailModel.h
//  优快保
//
//  Created by cts on 15/8/14.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

///新的城市服务开通情况model类，包含服务的各个信息，还有在首页的图标
@interface CityServiceDetailModel : JsonBaseModel

@property (strong, nonatomic) NSString *service_type;//服务类型
/*
0.洗车
1.保养
2.划痕
3.美容
4.救援
5.车保姆
6.速援
7.快修
20.特殊
 */

@property (strong, nonatomic) NSString *service_name;//服务名（跳转页面title）

@property (strong, nonatomic) NSString *service_short_name;//简称（按钮名）

@property (strong, nonatomic) NSString *btn_pic;//按钮图片地址

@property (strong, nonatomic) NSString *open_status;//是否开通 0.否1.是

@end
