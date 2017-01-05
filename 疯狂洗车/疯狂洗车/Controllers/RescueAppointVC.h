//
//  RescueAppointVC.h
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/22.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "BaseViewController.h"

@class RescueAppointVC;
@class BMKPoiInfo;

@protocol RescueAppointVCDelegate <NSObject>

- (void) MapViewController:(RescueAppointVC *)vc LocationAddr:(BMKPoiInfo *)LocationAddr;

@end

@interface RescueAppointVC : BaseViewController

@property (nonatomic, assign) id<RescueAppointVCDelegate> delegate;

@end
