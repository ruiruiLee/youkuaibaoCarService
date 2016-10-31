//
//  CarNurseServiceModel.h
//  优快保
//
//  Created by cts on 15/4/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

///车服务信息model类，包含某一项车服务的详细信息和推荐的优惠券
@interface CarNurseServiceModel : JsonBaseModel

@property (strong, nonatomic) NSString *service_id;//服务id

@property (strong, nonatomic) NSString *car_wash_id;//车场id



@property (strong, nonatomic) NSString *service_type;//服务类型 1.保养 2.划痕 3.美容 4.救援

@property (strong, nonatomic) NSString *service_name;//服务名字

@property (strong, nonatomic) NSString *member_price;//下单价

@property (strong, nonatomic) NSString *agreement_price;//

@property (strong, nonatomic) NSString *original_price;//店面价

@property (strong, nonatomic) NSString *service_content;//服务内容

@property (strong, nonatomic) NSString *accessories;//配件


@property (strong, nonatomic) NSString *service_mode;//服务方式，逗号分隔 1.到店服务 2.上门取送

@property (strong, nonatomic) NSString *code_count;//大于0，可以使用券支付

@property (strong, nonatomic) NSString *service_group;//分组

@property (strong, nonatomic) NSString *service_group_name;//

@property (assign, nonatomic) BOOL     isShangmen;

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
