//
//  BaseCheckModel.h
//  
//
//  Created by cts on 15/9/9.
//
//

#import "JsonBaseModel.h"

@interface BaseCheckModel : JsonBaseModel

@property (strong, nonatomic) NSString *car_id;

@property (strong, nonatomic) NSString *car_wash_id;

@property (strong, nonatomic) NSString *member_id;

@property (strong, nonatomic) NSString *service_type;

@property (strong, nonatomic) NSString *service_id;

@property (strong, nonatomic) NSString *is_super;



@end
