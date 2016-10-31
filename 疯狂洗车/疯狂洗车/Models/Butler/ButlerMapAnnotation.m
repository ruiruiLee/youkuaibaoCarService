//
//  NewsMapAnnotation.m
//  优快保
//
//  Created by 朱伟铭 on 13-7-15.
//  Copyright (c) 2013年 朱伟铭. All rights reserved.
//

#import "ButlerMapAnnotation.h"

@implementation ButlerMapAnnotation
@synthesize latitude;
@synthesize longitude;
@synthesize locationInfo;

- (id)initWithLatitude:(CLLocationDegrees)lat
		  andLongitude:(CLLocationDegrees)lon
{
	if (self = [super init])
    {
		self.latitude = lat;
		self.longitude = lon;
	}
	return self;
}


-(CLLocationCoordinate2D)coordinate
{
    
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
    
    
}
@end
