//
//  OrderShareModel.h
//  优快保
//
//  Created by cts on 15/6/20.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

@interface OrderShareModel : JsonBaseModel

@property (strong , nonatomic) NSString *share_order_title;

@property (strong , nonatomic) NSString *share_order_desc;

@property (strong , nonatomic) NSString *open_share_order_flag;

@property (strong , nonatomic) NSString *share_code_url;

@property (strong , nonatomic) NSString *open_share_code_flag;

@property (strong, nonatomic)  NSString *question_survey;

@property (strong, nonatomic) NSString *service_phone;


#pragma mark - app启动广告

@property (strong, nonatomic)  NSString *main_adv_url;

@property (strong, nonatomic)  NSString *main_adv_img;

@property (strong, nonatomic)  NSString *main_adv_type;

@property (strong, nonatomic)  NSString *main_adv_title;

@property (strong, nonatomic)  NSString *open_main_adv;

@property (strong, nonatomic)  NSString *force_main_adv;

@property (strong, nonatomic)  NSString *service_code_intro;

#pragma mark - app自动已启动页

@property (strong, nonatomic)  NSString *app_splash_img;


@property (strong, nonatomic)  NSString *insurance_btn_img;

@end
