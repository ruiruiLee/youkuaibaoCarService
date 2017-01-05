//
//  AppointInfo.h
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/13.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "JsonBaseModel.h"

//预约订单数据

@interface AppointInfo : JsonBaseModel

@property (nonatomic, strong) NSString *addr;
@property (nonatomic, strong) NSString *b_time;
@property (nonatomic, strong) NSString *car_id;
@property (nonatomic, strong) NSString *car_no;
@property (nonatomic, strong) NSString *car_wash_id;
@property (nonatomic, strong) NSString *city_name;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *e_time;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *member_phone;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *order_price;
@property (nonatomic, strong) NSString *out_trade_no;
@property (nonatomic, strong) NSString *pay_price;
@property (nonatomic, strong) NSString *province_name;
@property (nonatomic, strong) NSString *reg_name;
@property (nonatomic, strong) NSString *reserve_day;
@property (nonatomic, strong) NSString *reserve_status;
@property (nonatomic, strong) NSString *reserve_status_name;
@property (nonatomic, assign) NSInteger reserve_type;
@property (nonatomic, strong) NSString *service_id;
@property (nonatomic, strong) NSString *service_name;
@property (nonatomic, strong) NSString *service_type;
@property (nonatomic, strong) NSString *total_counts;
@property (nonatomic, strong) NSString *update_time;

@end
