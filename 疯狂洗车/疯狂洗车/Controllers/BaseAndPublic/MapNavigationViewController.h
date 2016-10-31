//
//  MapNavigationViewController.h
//  优快保
//
//  Created by cts on 15/7/4.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "CarNurseModel.h"
#import <AMapSearchKit/AMapSearchAPI.h>

@interface MapNavigationViewController : BaseViewController<MAMapViewDelegate,AMapSearchDelegate>
{
    
    MAMapView       *_mapView;
    
    AMapSearchAPI   *_searchAPI;
    
    IBOutlet UIView *_mapDisplayView;
    
    IBOutlet UIView *_bottomView;
    
    IBOutlet UIButton *_baiduNaviButton;
    
    IBOutlet UIButton *_gaodeNaviButton;
}


@property (strong, nonatomic) CarNurseModel *carNurseModel;

@end
