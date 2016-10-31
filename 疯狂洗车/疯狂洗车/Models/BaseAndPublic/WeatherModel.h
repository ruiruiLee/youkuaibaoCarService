//
//  WeatherModel.h
//  优快保
//
//  Created by cts on 15/5/27.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "JsonBaseModel.h"

@interface WeatherModel : JsonBaseModel

@property (strong, nonatomic) NSString *weather_id;

@property (strong, nonatomic) NSString *temperature;

@property (strong, nonatomic) NSString *weather;

@property (strong, nonatomic) NSString *wind;

@property (strong, nonatomic) NSString *city_id;

@property (strong, nonatomic) NSString *city_name;

@property (strong, nonatomic) NSString *week;

@property (strong, nonatomic) NSString *group;
@property (strong, nonatomic) NSString *dressing_index;
@property (strong, nonatomic) NSString *dressing_advice;

@property (strong, nonatomic) NSString *wash_index;

@property (strong, nonatomic) NSString *drying_index;



@end
