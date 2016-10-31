//
//  CarWashAnnotationView.h
//  优快保
//
//  Created by cts on 15/5/4.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "CarNurseModel.h"
#import "CarNurseInfoCallOutView.h"

@interface CarNurseAnnotationView : MKAnnotationView
{
    CarNurseInfoCallOutView *_infoView;
}
- (void)setCustomAnnotationSelect:(BOOL)shouldSelect;

- (void)setDisplayInfo:(CarNurseModel*)model;

- (void)setDisplayInsuranceInfo:(CarNurseModel*)model;

@property (assign, nonatomic) BOOL isClubMode;

@end
