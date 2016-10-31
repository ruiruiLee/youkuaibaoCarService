//
//  FouSServiceSmallAnnotationView.h
//  疯狂洗车
//
//  Created by cts on 16/1/29.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "CarNurseModel.h"
#import "FourSServiceSmallCallOutView.h"

@interface FouSServiceSmallAnnotationView : MKAnnotationView
{
    FourSServiceSmallCallOutView *_infoView;
}

- (void)setCustomAnnotationSelect:(BOOL)shouldSelect;

- (void)setDisplayInfo:(CarNurseModel*)model;

@end
