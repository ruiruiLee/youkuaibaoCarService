//
//  ServiceGroupModel.m
//  优快保
//
//  Created by cts on 15/5/25.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "ServiceGroupModel.h"

@implementation ServiceGroupModel

- (void)setServiceType:(NSString *)serviceType
{
    _serviceType = serviceType;
    if (_serviceType.intValue == 1)
    {
        self.serviceGroupName = @"保养";
    }
    else if (_serviceType.intValue == 2)
    {
        self.serviceGroupName = @"划痕";
    }
    else if (_serviceType.intValue == 3)
    {
        self.serviceGroupName = @"美容";
    }
    else if (_serviceType.intValue == 4)
    {
        self.serviceGroupName = @"救援";
    }
    else if (_serviceType.intValue == 4)
    {
        self.serviceGroupName = @"速缘";
    }
    self.subServiceArray = [NSMutableArray array];
}
@end
