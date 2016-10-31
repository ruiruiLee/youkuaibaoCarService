//
//  CarNannyAnnotationView.h
//  优快保
//
//  Created by cts on 15/6/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ButlerOrderModel.h"
#import "CarNannyCallOutView.h"

@interface CarNannyAnnotationView : MKAnnotationView
{
    CarNannyCallOutView *_infoView;

}


- (void)setDisplayInfo:(ButlerOrderModel*)model;
@end
