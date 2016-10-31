//
//  MainAdvView.h
//  优快保
//
//  Created by cts on 15/7/14.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADVModel.h"

@protocol CustomLaunchViewDelegate <NSObject>

- (void)didShouldHideCustomLaunchView;

- (void)didTouchOnLaunchButtoned;

@end

@interface CustomLaunchView : UIView
{
    IBOutlet UIButton *_skipeButton;
    
    IBOutlet UIButton *_launchButton;
    
    IBOutlet UIImageView *_defaultImageView;
    
    IBOutlet UIImageView *_displayImageView;
        
    NSTimer *_timer;
    
    int _seconds;
    
    OrderShareModel *_launchAppConfig;
}

@property (assign, nonatomic) id <CustomLaunchViewDelegate> delegate;

- (void)startCustomLaunchRefrishTimer;

- (void)hideMainAdvView;

@end
