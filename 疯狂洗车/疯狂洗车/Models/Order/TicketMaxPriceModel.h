//
//  TicketMaxPriceModel.h
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/28.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "JsonBaseModel.h"

@interface TicketMaxPriceModel : JsonBaseModel

@property (nonatomic, strong) NSString *accessories;
@property (nonatomic, assign) float agreement_price;
@property (nonatomic, strong) NSString *car_wash_id;
@property (nonatomic, assign) float member_price;
@property (nonatomic, assign) float original_price;
@property (nonatomic, strong) NSString *service_content;
@property (nonatomic, strong) NSString *service_id;
@property (nonatomic, strong) NSString *service_name;
@property (nonatomic, assign) NSInteger service_status;
@property (nonatomic, assign) float vip_price;

@end
