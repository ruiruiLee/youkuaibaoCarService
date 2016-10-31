//
//  HomeButtonModel.h
//  
//
//  Created by cts on 15/9/10.
//
//

#import "JsonBaseModel.h"

@interface HomeButtonModel : JsonBaseModel

@property (strong, nonatomic) NSString *service_type;

@property (strong, nonatomic) NSString *service_short_name;

@property (strong, nonatomic) NSString *service_name;

@property (strong, nonatomic) NSString *btn_pic;

@property (strong, nonatomic) NSString *open_status;

@property (strong, nonatomic) NSString *service_intro_pic;



@end
