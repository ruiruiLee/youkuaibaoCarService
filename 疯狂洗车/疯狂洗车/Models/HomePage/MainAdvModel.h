//
//  MainAdvModel.h
//  疯狂洗车
//
//  Created by cts on 16/1/25.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "JsonBaseModel.h"
#import "adv_list.h"

@interface MainAdvModel : JsonBaseModel

@property (strong, nonatomic) NSString *is_forced;

@property (strong, nonatomic) NSString *total_count;

@property (strong, nonatomic) NSArray  *adv_list;




@end
