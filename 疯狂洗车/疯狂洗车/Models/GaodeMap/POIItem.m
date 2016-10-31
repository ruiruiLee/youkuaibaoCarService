//
//  POIItem.m
//  BicycleFunction
//
//  Created by Darsky on 15/3/9.
//  Copyright (c) 2015年 Darsky. All rights reserved.
//

#import "POIItem.h"

@implementation POIItem

- (id)initWithDictionary:(NSDictionary *)jsonDic
{
    self = [super initWithDictionary:jsonDic];
    
    if (self)
    {
        NSArray *location = [jsonDic objectForKey:@"location"];
        NSLog(@"%d",location.count);
    }
    
    return self;
}

@end
