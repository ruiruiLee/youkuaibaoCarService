//
//  TicketModel.h
//  优快保
//
//  Created by cts on 15/5/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

@interface TicketModel : JsonBaseModel

@property (strong, nonatomic) NSString *code_id;

@property (strong, nonatomic) NSString *code_content;

@property (strong, nonatomic) NSString *price;

@property (strong, nonatomic) NSString *consume_type;

@property (strong, nonatomic) NSString *create_time;

@property (strong, nonatomic) NSString *service_type;

@property (strong, nonatomic) NSString *code_name;

@property (strong, nonatomic) NSString *begin_time;

@property (strong, nonatomic) NSString *end_time;

@property (strong, nonatomic) NSString *remain_times;

@property (strong, nonatomic) NSString *code_desc;

@property (strong, nonatomic) NSString *comp_id;

@property (strong, nonatomic) NSString *comp_name;

@property (strong, nonatomic) NSString *pay_flag;

@property (strong, nonatomic) NSString *times_limit;

@property (strong, nonatomic) NSString *code_status;





@end
