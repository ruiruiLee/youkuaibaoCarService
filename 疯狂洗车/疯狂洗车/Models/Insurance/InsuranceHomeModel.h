//
//  InsuranceHomeModel.h
//  优快保
//
//  Created by cts on 15/7/8.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "JsonBaseModel.h"

///保险首页信息model类，包含保险首页需要的字段
@interface InsuranceHomeModel : JsonBaseModel

@property (strong, nonatomic) NSString *is_used;//用户使用过 0.否 1.是  PS:当为1时，点击保险首页右下角的按钮时，需要跳转到保险列表

@property (strong, nonatomic) NSString *service_phone;//服务电话

@property (strong, nonatomic) NSString *adv_img_url;//广告图片地址

@property (strong, nonatomic) NSString *adv_img_url2;//广告图片地址2

@property (strong, nonatomic) NSString *intro_url;//Html版介绍

@property (strong, nonatomic) NSString *btn_text;//按钮显示的名字

@property (strong, nonatomic) NSString *insurance_new_img;


@end
