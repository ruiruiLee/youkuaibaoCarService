//
//  SupportCarModel.h
//  
//
//  Created by cts on 15/9/8.
//
//

#import "JsonBaseModel.h"

@interface SupportCarModel : JsonBaseModel

@property (nonatomic, strong) NSString *support_id;

@property (nonatomic, strong) NSString *brand_id;

@property (nonatomic, strong) NSString *series_id;

@property (nonatomic, strong) NSString *service_type;

@property (nonatomic, strong) NSString *car_wash_id;

@property (nonatomic, strong) NSString *brand_name;

@property (nonatomic, strong) NSString *series_name;

@end
