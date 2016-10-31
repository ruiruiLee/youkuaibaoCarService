//
//  EvaluationListModel.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/31.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

@interface EvaluationListModel : JsonBaseModel
{
    
}

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *car_no;

@property (nonatomic, copy) NSString *car_wash_id;

@property (nonatomic, copy) NSString *evaluation_id;

@property (nonatomic, copy) NSString *car_type;

@property (nonatomic, copy) NSString *evaluation_time;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *service_type;

@property (nonatomic, copy) NSString *total_counts;

@property (nonatomic, copy) NSString *service_id;

@property (nonatomic, copy) NSString *member_id;

@end

