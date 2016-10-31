//
//  AddWashYardViewController.h
//  优快保
//
//  Created by Darsky on 15/2/12.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

//推广人员添加车场页面
@interface AddWashYardViewController : BaseViewController <CLLocationManagerDelegate>
{
    
    IBOutlet UIView *_carWashAgreementView;
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *clGeocoder;

@end
