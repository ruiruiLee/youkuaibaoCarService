//
//  ButlerOrderModel.h
//  优快保
//
//  Created by cts on 15/6/20.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

///车保姆订单信息model类，包含正在执行的车保姆订单的基本信息
@interface ButlerOrderModel : JsonBaseModel

@property (strong, nonatomic) NSString *car_wash_id;//车场id
@property (strong, nonatomic) NSString *order_id;//订单id
@property (strong, nonatomic) NSString *name;//车保姆名字
@property (strong, nonatomic) NSString *logo;//车保姆logo
@property (strong, nonatomic) NSString *admin_phone;//车保姆联系电话
@property (strong, nonatomic) NSString *longitude;//车保姆经度
@property (strong, nonatomic) NSString *latitude;//车保姆纬度
@property (strong, nonatomic) NSString *distance;//车保姆和用户距离，单位公里

@property (strong, nonatomic) NSString *service_count;//服务次数

@property (strong, nonatomic) NSString *create_time;//订单创建时间
@property (strong, nonatomic) NSString *member_price;//下单价
@property (strong, nonatomic) NSString *original_price;//原价
@property (strong, nonatomic) NSString *nanny_state;//订单状态 0.正常 1.接单中 2.车保姆完成订单 3.车主完成订单  PS:期中，当状态为3时需要主动切换至完成车保姆订单页面ButlerOrderFinishViewController
@property (strong, nonatomic) NSString *service_id;//服务id





@end
