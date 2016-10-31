//
//  AgentModel.h
//  疯狂洗车
//
//  Created by cts on 15/11/23.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "JsonBaseModel.h"

@interface AgentModel : UserInfo

#pragma mark - 登录时返回的经纪人信息

@property (nonatomic, strong) NSString *agent_id;

@property (nonatomic, strong) NSString *agent_name;

@property (nonatomic, strong) NSString *agent_phone;

@property (nonatomic, strong) NSString *agent_logo;

@property (nonatomic, strong) NSString *agent_title;

@end
