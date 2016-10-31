//
//  UserAnnotationView.h
//  优快保
//
//  Created by cts on 15/3/30.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface UserAnnotationView : MKAnnotationView
{
    UIImageView *_arrowImageView;
    
    UIImageView *_headingImageView;
}



- (void)updateUserLocationHeading:(CLHeading*)userHeading;
@end
