//
//  UnionPayResopne.h
//  优快保
//
//  Created by cts on 15/7/30.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

@interface UnionPayResopne : JsonBaseModel

@property (strong, nonatomic) NSString *out_trade_no;

@property (strong, nonatomic) NSString *mode;

@property (strong, nonatomic) NSString *money;

@property (strong, nonatomic) NSString *trade_no;
@end
