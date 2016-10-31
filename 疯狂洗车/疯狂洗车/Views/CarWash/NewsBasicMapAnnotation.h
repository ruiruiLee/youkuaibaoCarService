//
//  NewsBasicMapAnnotation.h
//  优快保
//
//  Created by 朱伟铭 on 13-7-15.
//  Copyright (c) 2013年 朱伟铭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface NewsBasicMapAnnotation : NSObject<MKAnnotation>
{
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
	NSString *_title;
}

@property (nonatomic, retain) NSString      *title;
@property(retain,nonatomic) CarWashModel    *calloutInfo;//标注点传递的callout吹出框显示的信息
- (id)initWithLatitude:(CLLocationDegrees)  latitude
		  andLongitude:(CLLocationDegrees)  longitude;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end