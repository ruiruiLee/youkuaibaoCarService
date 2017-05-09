//
//  MainViewController.h
//  优快保
//
//  Created by cts on 15/6/11.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import <MAMapKit/MAMapKit.h>

#import "UIScrollView+MJRefresh.h"

//首页
@interface MainViewController : BaseViewController
{
    IBOutlet UIImageView *_defaultADVImageView;
    
    IBOutlet UIView *_topAdvView;
    
    IBOutlet UIScrollView *_contextScrollView;
    
    IBOutlet UIView *_centerView;
    
    IBOutlet UIButton *_carService;
    
    IBOutlet UIView *_agentView;
    
    IBOutlet UIImageView *_agentHeaderImageView;
    
    IBOutlet UILabel *_agentTitleLabel;
    
    IBOutlet UILabel *_agentNameLabel;
    
    IBOutlet UIButton *_agentPhoneButton;
    
    IBOutlet UIButton *_agentMessageButton;
    
    IBOutlet UIView   *_agentMessageLine;
}

@end
