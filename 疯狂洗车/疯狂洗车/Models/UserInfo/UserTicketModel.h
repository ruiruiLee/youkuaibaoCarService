//
//  UserTicketModel.h
//  优快保
//
//  Created by cts on 15/5/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

@interface UserTicketModel : JsonBaseModel

@property (strong, nonatomic) NSString *code_count;

@property (strong, nonatomic) NSString *service_type;


@end
