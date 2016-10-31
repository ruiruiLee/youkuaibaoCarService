//
//  CarWashAnnotationView.h
//  优快保
//
//  Created by cts on 15/5/4.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "CarWashModel.h"
#import "CarWashInfoCallOutView.h"

@interface CarWashAnnotationView : MKAnnotationView
{
    CarWashInfoCallOutView *_infoView;
}
- (void)setCustomAnnotationSelect:(BOOL)shouldSelect;

- (void)setDisplayInfo:(CarWashModel*)model;

@property (assign, nonatomic) BOOL isClubMode;
@end
