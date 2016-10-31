//
//  NewsMapAnnotation.h
//  优快保
//
//  Created by 朱伟铭 on 13-7-15.
//  Copyright (c) 2013年 朱伟铭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface NewsMapAnnotation : NSObject<MKAnnotation>
{
    
}
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property(retain,nonatomic) CarWashModel *locationInfo;//callout吹出框要显示的各信息
@property (assign, nonatomic) BOOL isRecent;

- (id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon;
@end