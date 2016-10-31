//
//  CarNurseModel.h
//  优快保
//
//  Created by cts on 15/4/4.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CarWashModel.h"

@interface CarNurseModel : CarWashModel

@property (strong, nonatomic) NSString *service_name;

@property (strong, nonatomic) NSString *service_names;

@property (strong, nonatomic) NSString *member_price;

@property (strong, nonatomic) NSString *original_price;

@property (strong, nonatomic) NSString *service_count;

@property (strong, nonatomic) NSString *service_year;

@property (strong, nonatomic) NSArray  *supportServiceArray;

@property (strong, nonatomic) NSString *service_intro_url;



@property (strong, nonatomic) NSArray  *serviceArray;

@property (strong, nonatomic) NSString *SHANGMENG_FLAG;

@property (strong, nonatomic) NSString *DAODIAN_FLAG;

@property (strong, nonatomic) NSString *bao_original_price;

@property (strong, nonatomic) NSString *bao_member_price;

@property (strong, nonatomic) NSString *mei_original_price;

@property (strong, nonatomic) NSString *mei_member_price;

@property (strong, nonatomic) NSString *display_mei_bao_price;

@property (strong, nonatomic) NSString *display_mei_bao_original_price;

@property (strong, nonatomic) NSString *accident_rescue_img_url;

@property (strong, nonatomic) NSString *service_types;







@end
