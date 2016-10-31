//
//  UserInfo.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/27.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

@interface UserInfo : JsonBaseModel
{
    
}


@property (nonatomic, strong) NSString *login_password;
@property (nonatomic, strong) NSString *member_phone;
@property (nonatomic, strong) NSString *member_address;
@property (nonatomic, strong) NSString *member_name;
@property (nonatomic, strong) NSString *member_birthday;
@property (nonatomic, strong) NSString *member_age;
@property (nonatomic, strong) NSString *login_name;
@property (nonatomic, strong) NSString *member_level;
@property (nonatomic, strong) NSString *member_sfzh;
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) NSString *member_sex;
@property (nonatomic, strong) NSString *account_remainder;
@property (nonatomic, strong) NSString *member_pid;
@property (nonatomic, strong) NSString *if_first_presented;
@property (nonatomic, strong) NSString *if_salesman;
@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *city_id;
@property (nonatomic, strong) NSString *province_id;

@property (nonatomic, strong) NSString *crm_user;
@property (nonatomic, strong) NSString *present;

@property (nonatomic, strong) NSString *present_money;

@property (strong, nonatomic) NSString *insure_user;








@end
