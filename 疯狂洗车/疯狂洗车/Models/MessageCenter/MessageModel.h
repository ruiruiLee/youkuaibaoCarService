//
//  MessageModel.h
//  优快保
//
//  Created by cts on 15/7/13.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

@interface MessageModel : JsonBaseModel

@property (strong, nonatomic) NSString *msg_id;//消息id

@property (strong, nonatomic) NSString *create_time;//创建时间

@property (strong, nonatomic) NSString *user_id;//用户id

@property (strong, nonatomic) NSString *user_type;//用户类型 1.车主 2.车场 3.车保姆

@property (strong, nonatomic) NSString *msg_title;//标题

@property (strong, nonatomic) NSString *photo_addr;//列表图地址，应该暂时不需要

@property (strong, nonatomic) NSString *msg_content;//内容

@property (strong, nonatomic) NSString *is_read;//是否已读 0.否 1.是 PS:该字段从服务器获取，为0时，当用户阅读后需要在本地数据控制修改为1

@property (strong, nonatomic) NSString *msg_type;//消息类型 0.系统消息

@property (strong, nonatomic) NSString *json;//返回json。格式暂定为








@end
