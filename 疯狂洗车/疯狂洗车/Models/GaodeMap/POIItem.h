//
//  POIItem.h
//  BicycleFunction
//
//  Created by Darsky on 15/3/9.
//  Copyright (c) 2015年 Darsky. All rights reserved.
//

#import "JsonBaseModel.h"

@interface POIItem : JsonBaseModel

@property (strong, nonatomic) NSString *uid;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSString *address;



@end
