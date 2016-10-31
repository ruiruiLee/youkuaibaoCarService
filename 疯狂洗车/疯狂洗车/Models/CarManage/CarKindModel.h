//
//  CarKindModel.h
//  优快保
//
//  Created by cts on 15/3/24.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

@interface CarKindModel : JsonBaseModel

@property (nonatomic, strong) NSString *SERIES_ID;

@property (nonatomic, strong) NSString *KIND_ID;

@property (nonatomic, strong) NSString *NAME;

@property (nonatomic, strong) NSString *VER_NO;

@end
