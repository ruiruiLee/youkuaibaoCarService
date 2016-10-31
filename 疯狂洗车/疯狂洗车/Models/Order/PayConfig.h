//
//  PayConfig.h
//  优快保
//
//  Created by cts on 15/3/20.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

@interface PayConfig : JsonBaseModel

@property (nonatomic, copy) NSString *partner;
@property (nonatomic, copy) NSString *seller;
@property (nonatomic, copy) NSString *rsa_private;
@property (nonatomic, copy) NSString *rsa_alipay_public;
@property (nonatomic, copy) NSString *alipay_url;
@property (nonatomic, copy) NSString *tenpay_url;



@end
