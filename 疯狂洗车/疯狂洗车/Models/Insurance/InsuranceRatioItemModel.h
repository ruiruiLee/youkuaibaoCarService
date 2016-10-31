//
//  InsuranceRatioItemModel.h
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

///保险报价详情优惠model类，包含一个保险项目的优惠名称和价格
@interface InsuranceRatioItemModel : JsonBaseModel

@property (strong, nonatomic) NSString *insuranceRatio;//优惠名称

@property (strong, nonatomic) NSString *insuranceRatioPrice;//优惠价格

@property (assign, nonatomic) BOOL     isTotalPrice;//是否是总价
@end
