//
//  OrderListModel.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/29.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

///订单信息model类，包含车相关订单的详细信息
@interface OrderListModel : JsonBaseModel

@property (nonatomic, strong) NSString *order_id;//订单id

@property (nonatomic, strong) NSString *member_id;//用户id

@property (nonatomic, strong) NSString *car_id;//车id

@property (nonatomic, strong) NSString *pay_money;//金额

@property (nonatomic, strong) NSString *pay_type;//支付类型
/*
1.账户余额
2.支付宝
3.微信
4.现场支付
5.券支付
6.支付余额券
7.微信余额券
8.支付余额
9.微信余额
10.券+余额
11.券+支付宝
12.券+微信
13.银联
14.银联余额券
15.银联余额
16.银联券
 */
@property (nonatomic, strong) NSString *car_wash_id;//车场id

@property (nonatomic, strong) NSString *order_state;//订单状态
/*
1.进行中
2.已完成
-1.取消中
-2.已撤单
 */

@property (nonatomic, strong) NSString *out_trade_no;//第三方订单号

@property (nonatomic, strong) NSString *create_time;//下订单时间

@property (nonatomic, strong) NSString *car_no;//车牌号

@property (nonatomic, strong) NSString *car_type;//车型，1：轿车，2：SUV

@property (nonatomic, strong) NSString *car_brand;//品牌

@property (strong, nonatomic) NSString *car_xilie;//车系

@property (nonatomic, strong) NSString *total_counts;//总条数

@property (nonatomic, strong) NSString *car_wash_name;//车场名

@property (nonatomic, strong) NSString *car_wash_address;//车场地址

@property (nonatomic, strong) NSString *evaluation_counts;//车场评论次数

@property (nonatomic, strong) NSString *average_score;//评论平均分

@property (nonatomic, strong) NSString *member_phone;//用户电话

@property (strong, nonatomic) NSString *member_name;//用户姓名

@property (strong ,nonatomic) NSString *paid_status;//支付状态
/*
 0.未支付
 1.已支付
 */

@property (strong, nonatomic) NSString *service_type;//服务类型
/*
 0.或者空：洗车订单
 1.保养
 2.划痕
 3.美容
 4.救援
 5.车保姆
 6.速援
 */

@property (strong, nonatomic) NSString *service_id;//服务id

@property (strong, nonatomic) NSString *order_type;//订单类型
/*
 1.洗车订单
 2.车服务订单
 */
@property (strong, nonatomic) NSString *business_hours_to;//车场营业开始时间

@property (strong, nonatomic) NSString *business_hours_from;//车场营业结束时间

@property (nonatomic, strong) NSString *server_time;//用户需求取车时间

@property (nonatomic, strong) NSString *server_addr;//用户需求取车地址


@property (nonatomic, strong) NSString *if_evaluationed;//

@property (strong, nonatomic) NSString *service_mode;//



@property (nonatomic, strong) NSString *if_finished;//


@property (nonatomic, strong) NSString *evaluation_id;//


@property (strong, nonatomic) NSString *code_id;//
@property (strong, nonatomic) NSString *consume_type;//
@property (strong, nonatomic) NSString *code_name;//

@property (strong, nonatomic) NSString *member_price;//




@end
