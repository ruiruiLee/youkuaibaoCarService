//
//  InsuranceBaseItemModel.h
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

///保险报价详情项目model类，包含一个保险项目的项目名称和价格
@interface InsuranceBaseItemModel : JsonBaseModel

@property (strong, nonatomic) NSString *insuranceName;//项目名

@property (strong, nonatomic) NSString *insurancePrice;//该项目的价格

@property (assign, nonatomic) BOOL      isSYPrice;//是否代表商业保险总价

@end
