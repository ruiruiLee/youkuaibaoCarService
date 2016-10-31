//
//  CarSeriesModel.h
//  优快保
//
//  Created by cts on 15/3/24.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "JsonBaseModel.h"

@interface CarSeriesModel : JsonBaseModel

@property (nonatomic, strong) NSString *SERIES_ID;

@property (nonatomic, strong) NSString *BRAND_ID;

@property (nonatomic, strong) NSString *NAME;


@property (nonatomic, strong) NSString *VER_NO;


@end
