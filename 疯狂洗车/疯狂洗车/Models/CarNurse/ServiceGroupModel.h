//
//  ServiceGroupModel.h
//  优快保
//
//  Created by cts on 15/5/25.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

@interface ServiceGroupModel : JsonBaseModel

@property (strong, nonatomic) NSMutableArray *subServiceArray;

@property (strong, nonatomic) NSString *serviceType;

@property (strong, nonatomic) NSString *serviceGroupName;

@property (assign, nonatomic) NSInteger selectIndex;

@end
