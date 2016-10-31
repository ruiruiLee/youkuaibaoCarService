//
//  CityModel.h
//  优快保
//
//  Created by cts on 15/3/28.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

@interface CityModel : JsonBaseModel

@property (strong, nonatomic) NSString *CITY_ID;
@property (strong, nonatomic) NSString *PROVINCE_ID;
@property (strong, nonatomic) NSString *CITY_NAME;
@property (strong, nonatomic) NSString *PY_CODE;
@property (strong, nonatomic) NSString *SEQ_NO;
@property (strong, nonatomic) NSString *LONGITUDE;
@property (strong, nonatomic) NSString *LATITUDE;
@property (strong, nonatomic) NSString *TEL_CODE;
@property (strong, nonatomic) NSString *C_CITY_NAME;
@property (strong, nonatomic) NSString *C_PY_CODE;
@property (strong, nonatomic) NSString *OPEN_FLAG;




@end
