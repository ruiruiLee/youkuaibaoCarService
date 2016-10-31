//
//  CarRevieModel.h
//  
//
//  Created by cts on 15/10/29.
//
//

#import "JsonBaseModel.h"

@interface CarReviewModel : JsonBaseModel

@property (strong, nonatomic) NSString *car_review_url;

@property (strong, nonatomic) NSString *repair_url;

@property (strong, nonatomic) NSString *service_id;

@property (strong, nonatomic) NSString *car_wash_id;

@property (strong, nonatomic) NSString *service_name;

@property (strong, nonatomic) NSString *service_type;

@property (strong, nonatomic) NSString *original_price;

@property (strong, nonatomic) NSString *member_price;

@property (strong, nonatomic) NSString *service_content;

@property (strong, nonatomic) NSString *accessories;

@property (strong, nonatomic) NSString *service_city;

@property (strong, nonatomic) NSString *contact_phone;

@property (strong, nonatomic) NSString *logo;

//券字段

@property (nonatomic, strong) NSString *code_count;

@property (strong, nonatomic) NSString *code_id;

@property (strong, nonatomic) NSString *code_content;

@property (strong, nonatomic) NSString *price;

@property (strong, nonatomic) NSString *consume_type;

@property (strong, nonatomic) NSString *create_time;

@property (strong, nonatomic) NSString *code_name;

@property (strong, nonatomic) NSString *begin_time;

@property (strong, nonatomic) NSString *end_time;

@property (strong, nonatomic) NSString *remain_times;

@property (strong, nonatomic) NSString *code_desc;

@property (strong, nonatomic) NSString *comp_id;

@property (strong, nonatomic) NSString *comp_name;

@property (strong, nonatomic) NSString *pay_flag;

@property (strong, nonatomic) NSString *times_limit;









@end
