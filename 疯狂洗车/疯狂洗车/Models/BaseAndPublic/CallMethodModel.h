//
//  CallMethodModel.h
//  疯狂洗车
//
//  Created by cts on 16/1/22.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "JsonBaseModel.h"
typedef enum {
    CallMethodTypeCarWash = 0,
    CallMethodTypeCarService = 1,
    CallMethodTypeThirdPay = 5,
    CallMethodTypeCarOther = 10
    
} CallMethodType;

typedef enum {
    CallMethodControllerTypeList = 0,
    CallMethodControllerTypeDetail = 1,
    CallMethodControllerTypeRemainderPay = 5,
    CallMethodControllerTypeWeChatPay = 6,
    CallMethodControllerTypeAliPay = 7,
    CallMethodControllerTypeUnionPay = 8,
    CallMethodControllerTypeOther = 10
} CallMethodControllerType;


@interface CallMethodModel : JsonBaseModel


@property (strong, nonatomic) NSString *model;

@property (assign, nonatomic) CallMethodType callMethodType;

@property (strong, nonatomic) NSString *method;

@property (assign, nonatomic) CallMethodControllerType callMethodControllerType;

@property (strong, nonatomic) NSDictionary *params;


@end
