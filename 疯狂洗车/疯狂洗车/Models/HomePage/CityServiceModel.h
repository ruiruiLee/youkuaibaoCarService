//
//  CityServiceModel.h
//  优快保
//
//  Created by cts on 15/6/14.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

///城市服务开通情况列表model类，包含正在该城市各个服务的开通开关 0.未开通 1.已开通
@interface CityServiceModel : JsonBaseModel

@property (strong, nonatomic) NSString *wash;

@property (strong, nonatomic) NSString *baoyang;

@property (strong, nonatomic) NSString *huahen;

@property (strong, nonatomic) NSString *meirong;

@property (strong, nonatomic) NSString *jiuyuan;

@property (strong, nonatomic) NSString *guanjia;

@property (strong, nonatomic) NSString *suyuan;

@property (strong, nonatomic) NSString *fast_repair;


@end
