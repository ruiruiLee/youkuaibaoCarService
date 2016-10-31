//
//  InsuranceGroupModel.h
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "InsuranceInfoModel.h"

///保险列表model类，需要将所有保险意向id相同的保险归纳在一起
@interface InsuranceGroupModel : JsonBaseModel

@property (strong, nonatomic) NSString *total_counts;

@property (strong, nonatomic) NSString *insurance_id;

@property (strong, nonatomic) NSString *member_id;

@property (strong, nonatomic) NSString *suggest_num;

@property (strong, nonatomic) NSString *buy_suggest_id;

@property (strong, nonatomic) NSString *cid;

@property (strong, nonatomic) NSString *user_phone;

@property (strong, nonatomic) NSString *car_no;

@property (strong, nonatomic) NSString *member_name;

@property (strong, nonatomic) NSString *sb_no;

@property (strong, nonatomic) NSString *fdj_no;

@property (strong, nonatomic) NSString *city_id;

@property (strong, nonatomic) NSString *city_name;

@property (strong, nonatomic) NSString *paid_status;

@property (strong, nonatomic) NSString *create_time;

@property (strong, nonatomic) NSString *edit_time;

@property (strong, nonatomic) NSString *insurance_no;

@property (strong, nonatomic) NSArray *img_list;

@property (strong, nonatomic) NSArray *suggest_list;

@property (strong, nonatomic) NSString *photo_addr;

@property (strong, nonatomic) NSString *photo_addr2;

@property (strong, nonatomic) NSString *custom_submitted;

@property (strong, nonatomic) NSString *insur_status;


@end
