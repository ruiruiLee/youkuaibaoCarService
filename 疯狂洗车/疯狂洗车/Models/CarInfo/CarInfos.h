//
//  CarInfos.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/27.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

@interface CarInfos : JsonBaseModel
{
    
}

/*
 car_id:车辆id号
 member_id:会员编号
 car_no:牌照
 car_type(1:轿车,2:SUV)
 car_brand:品牌 如用户没输入，请传入””(空)
 */
@property (nonatomic, copy) NSString *car_id;
@property (nonatomic, copy) NSString *member_id;
@property (nonatomic, copy) NSString *car_no;
@property (nonatomic, copy) NSString *car_type;
@property (nonatomic, copy) NSString *car_brand;
@property (nonatomic, copy) NSString *car_kuanshi;
@property (nonatomic, copy) NSString *car_xilie;

@property (nonatomic, copy) NSString *brand_id;

@property (nonatomic, copy) NSString *series_id;

@property (nonatomic, copy) NSString *total_counts;

@end
