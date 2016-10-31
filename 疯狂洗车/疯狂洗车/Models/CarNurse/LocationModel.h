//
//  LocationModel.h
//  优快保
//
//  Created by cts on 15/4/10.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"
#import <MapKit/MapKit.h>

@interface LocationModel : JsonBaseModel

@property (strong, nonatomic) NSString *addressString;

@property (assign, nonatomic) CLLocationCoordinate2D locationCoordinate;

@end
