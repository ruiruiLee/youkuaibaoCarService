//
//  CarWashModel.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/29.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

@interface CarWashModel : JsonBaseModel
{
    
}

/*
 "account_remainder" = "";
 address = 123456;
 "admin_id" = "";
 "area_id" = "";
 "business_hours_from" = "";
 "business_hours_to" = "";
 "car_agreement_price" = 20;
 "car_member_price" = 25;
 "car_original_price" = 30;
 "car_wash_id" = 1;
 "city_id" = "";
 "evaluation_counts" = "";
 "if_opening" = "";
 latitude = "33.60";
 logo = "car_wash_default.png";
 longitude = "11.20";
 name = zx01;
 phone = 139;
 "province_id" = "";
 "suv_agreement_price" = 20;
 "suv_member_price" = 25;
 "suv_original_price" = 30;
 */

@property (nonatomic, strong) NSString *account_remainder;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *area_id;
@property (nonatomic, strong) NSString *business_hours_from;
@property (nonatomic, strong) NSString *admin_id;
@property (nonatomic, strong) NSString *business_hours_to;
@property (nonatomic, strong) NSString *car_agreement_price;
@property (nonatomic, strong) NSString *car_vip_price;

@property (nonatomic, strong) NSString *car_member_price;
@property (nonatomic, strong) NSString *car_original_price;
@property (nonatomic, strong) NSString *car_wash_id;
@property (nonatomic, strong) NSString *city_id;
@property (nonatomic, strong) NSString *evaluation_counts;
@property (nonatomic, strong) NSString *if_opening;
@property (nonatomic, strong) NSString *logo;

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *short_name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *province_id;
@property (nonatomic, strong) NSString *suv_agreement_price;
@property (nonatomic, strong) NSString *suv_vip_price;
@property (nonatomic, strong) NSString *suv_member_price;
@property (nonatomic, strong) NSString *suv_original_price;
@property (nonatomic, strong) NSString *average_score;
@property (nonatomic, strong) NSString *total_score;
@property (nonatomic, strong) NSString *if_verified;
@property (nonatomic, strong) NSString *introduction;
@property (nonatomic, strong) NSString *total_counts;

@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *target_distance;
@property (nonatomic, strong) NSString *if_chain;
@property (nonatomic, strong) NSString *offline_pay;

@property (nonatomic, strong) NSString *code_count;

@property (nonatomic, strong) NSString *service_type;

@property (nonatomic, strong) NSString *off_work;

@property (nonatomic, strong) NSString *photo_addrs;


@property (strong, nonatomic) NSString *code_id;

@property (strong, nonatomic) NSString *code_content;

@property (strong, nonatomic) NSString *price;

@property (strong, nonatomic) NSString *consume_type;

@property (strong, nonatomic) NSString *create_time;

@property (strong, nonatomic) NSString *code_name;

@property (strong, nonatomic) NSString *begin_time;

@property (strong, nonatomic) NSString *end_time;

@property (strong, nonatomic) NSString *remain_times;

@property (strong, nonatomic) NSString *code_desc;

@property (strong, nonatomic) NSString *comp_id;

@property (strong, nonatomic) NSString *comp_name;

@property (strong, nonatomic) NSString *pay_flag;

@property (strong, nonatomic) NSString *times_limit;




@end
