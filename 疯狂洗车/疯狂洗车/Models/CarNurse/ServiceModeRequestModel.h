//
//  ServiceModeRequestModel.h
//  疯狂洗车
//
//  Created by cts on 15/11/11.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "JsonBaseModel.h"

typedef enum
{
    ServiceModeRequestTypeTime,
    ServiceModeRequestTypeAddress,
    ServiceModeRequestTypeMore
}ServiceModeRequestType;

@interface ServiceModeRequestModel : JsonBaseModel

@property (assign, nonatomic) ServiceModeRequestType modelType;

@property (strong, nonatomic) NSString     *valueString;

@property (strong, nonatomic) NSString     *placeHolderText;

@property (strong, nonatomic) id            valueObject;

@end
