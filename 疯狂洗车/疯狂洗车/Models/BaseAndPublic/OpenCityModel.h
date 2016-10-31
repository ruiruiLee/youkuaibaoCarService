//
//  CityModel.h
//  优快保
//
//  Created by cts on 15/3/28.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

@interface OpenCityModel : JsonBaseModel

@property (strong, nonatomic) NSString *city_id;
@property (strong, nonatomic) NSString *province_id;
@property (strong, nonatomic) NSString *city_name;
@property (strong, nonatomic) NSString *py_code;
@property (strong, nonatomic) NSString *seq_no;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *tel_code;
@property (strong, nonatomic) NSString *c_city_name;
@property (strong, nonatomic) NSString *c_py_code;
@property (strong, nonatomic) NSString *open_flag;
@property (strong, nonatomic) NSString *open_ins_flag;

@property (strong, nonatomic) NSString *wash_hot;

@property (strong, nonatomic) NSString *insurance_hot;






@end
