//
//  MapViewController.h
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/20.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "BaseViewController.h"
#import "CityInfoModel.h"

@class MapViewController;
@class BMKPoiInfo;

@protocol MapViewControllerDelegate <NSObject>

- (void) MapViewController:(MapViewController *)vc LocationAddr:(BMKPoiInfo *)LocationAddr;

@end

@interface MapViewController : BaseViewController

@property (nonatomic, assign) id<MapViewControllerDelegate> delegate;

@end
