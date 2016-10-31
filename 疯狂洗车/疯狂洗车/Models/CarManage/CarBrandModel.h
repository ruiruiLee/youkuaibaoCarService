//
//  CarBrandModel.h
//  优快保
//
//  Created by cts on 15/3/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

@interface CarBrandModel : JsonBaseModel

@property (nonatomic, strong) NSString *BRAND_ID;
@property (nonatomic, strong) NSString *LETTER;
@property (nonatomic, strong) NSString *LOGO;
@property (nonatomic, strong) NSString *NAME;
@property (nonatomic, strong) NSString *VER_NO;



@end
