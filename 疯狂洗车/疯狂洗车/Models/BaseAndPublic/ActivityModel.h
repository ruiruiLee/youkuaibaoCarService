//
//  ActivityModel.h
//  优快保
//
//  Created by cts on 15/4/17.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

@interface ActivityModel : JsonBaseModel

@property (strong, nonatomic) NSString *open_activity;

@property (strong, nonatomic) NSString *activity_url;

@property (strong, nonatomic) NSString *activity_count;


@end
