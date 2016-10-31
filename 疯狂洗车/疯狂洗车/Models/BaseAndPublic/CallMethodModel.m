//
//  CallMethodModel.m
//  疯狂洗车
//
//  Created by cts on 16/1/22.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "CallMethodModel.h"

@implementation CallMethodModel

- (void)setModel:(NSString *)model
{
    _model = model;
    if ([_model isEqualToString:@"carWash"])
    {
        self.callMethodType = CallMethodTypeCarWash;
    }
    else if ([_model isEqualToString:@"thirdPay"])
    {
        self.callMethodType = CallMethodTypeThirdPay;
    }
    else
    {
        self.callMethodType = CallMethodTypeCarOther;
    }
}


- (void)setMethod:(NSString *)method
{
    _method = method;
    if ([_method isEqualToString:@"detail"])
    {
        self.callMethodControllerType = CallMethodControllerTypeDetail;
    }
    else if ([_method isEqualToString:@"aliPay"])
    {
        self.callMethodControllerType = CallMethodControllerTypeAliPay;
    }
    else if ([_method isEqualToString:@"tenPay"])
    {
        self.callMethodControllerType = CallMethodControllerTypeWeChatPay;
    }
    else if ([_method isEqualToString:@"unionPay"])
    {
        self.callMethodControllerType = CallMethodControllerTypeUnionPay;
    }
    else
    {
        self.callMethodControllerType = CallMethodControllerTypeOther;
    }
}

//- (void)setParams:(NSString *)params
//{
//    _params = params;
//    
//    NSData *respineData = [_params dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:respineData options:NSJSONReadingMutableLeaves error:nil];
//    self.paramsDic = jsonDict;
//}

@end
