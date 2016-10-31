//
//  InsuranceInfoModel.h
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"
#import "InsuranceSuggestModel.h"


///保险信息报价model类，包含一个保险信息的基本数据
@interface InsuranceInfoModel : JsonBaseModel

@property (strong, nonatomic) NSString *insurance_id;//保险意向id PS:根据该字段进行分组合并数据

@property (strong, nonatomic) NSString *member_id;//用户id

@property (strong, nonatomic) NSString *suggest_num;//报价数量

@property (strong, nonatomic) NSString *buy_suggest_id;//已购买的报价id

@property (strong, nonatomic) NSString *buy_suggest_money;//已购买的报价

@property (strong, nonatomic) NSString *cid;//保单身份证

@property (strong, nonatomic) NSString *user_phone;//保单电话

@property (strong, nonatomic) NSString *photo_addr;//行驶证地址

@property (strong, nonatomic) NSString *photo_addr2;//行驶证副本地址

@property (strong, nonatomic) NSString *car_no;//车牌号

@property (strong, nonatomic) NSString *member_name;//车辆所有人

@property (strong, nonatomic) NSString *sb_no;//识别码

@property (strong, nonatomic) NSString *fdj_no;//发动机号

@property (strong, nonatomic) NSString *suggest_id;//报价id

@property (strong, nonatomic) NSString *suggest_intro;//报价描述

@property (strong, nonatomic) NSString *suggest_price;//报价

@property (strong, nonatomic) NSString *service_pack_price;//服务包价值

@property (strong, nonatomic) NSString *service_pack_content;//服务包内容

@property (strong, nonatomic) NSString *insurance_name;//保险公司名字

@property (strong, nonatomic) NSString *total_counts;//总条数

@property (strong, nonatomic) NSString *logo;//保险公司logo

@property (strong, nonatomic) NSString *sy_price_ratio;//商业险优惠额度

@property (strong, nonatomic) NSString *insurance_no;//保单编号

@property (strong, nonatomic) NSString *gifts;//赠送礼包 |分隔数组，#分隔键值对

@property (strong, nonatomic) NSString *giftsString;//赠送礼包的字符串   PS:用于将赠送礼包的各个内容拼接成一个由换行构成的字符串

@property (strong, nonatomic) NSString *waiting_suggests;//等待报价 |分隔数组，#分隔键值对

@property (strong, nonatomic) NSString *waiting_suggests_string;//等待报价的字符串   PS:用于将等待报价的各个内容拼接成一个由换行构成的字符串

@property (strong, nonatomic) NSString *source_name;//信息来源

@property (strong, nonatomic) NSString *city_id;//城市ID

@property (strong, nonatomic) NSString *city_name;//城市名称

@property (strong, nonatomic) NSString *paid_status;//保险状态

@property (strong, nonatomic) NSString *img_addrs;//图片地址|分割数组。＃分割简直队

@property (strong, nonatomic) NSString *create_time;//创建时间

@property (strong, nonatomic) NSString *suggest_no;

@property (strong, nonatomic) NSString *comp_id;

@property (strong, nonatomic) NSString *contact_phone;

//@property (strong, nonatomic) NSString *suggest_type;





@end
