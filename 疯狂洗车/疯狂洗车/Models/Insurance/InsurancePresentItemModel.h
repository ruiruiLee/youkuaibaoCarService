//
//  InsurancePresentItemModel.h
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

///保险报价赠送礼包model类，包含一个礼包的名称和价格
@interface InsurancePresentItemModel : JsonBaseModel

@property (strong, nonatomic) NSString *presentName;//礼包名称

@property (strong, nonatomic) NSString *presentContent;//礼包内容

@end
