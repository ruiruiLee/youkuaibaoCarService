//
//  MainAdvView.h
//  优快保
//
//  Created by cts on 15/7/14.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADVModel.h"
#import "MainAdvModel.h"

@protocol MainAdvViewDelegate <NSObject>

- (void)didMainAdvImageTouched:(adv_list*)model;

- (void)didMainAdvImageHide;

@end

@interface MainAdvView : UIView<UIScrollViewDelegate>
{
    IBOutlet UIView       *_displayView;
        
    IBOutlet UIScrollView *_displayScrollView;
    
    IBOutlet UIButton     *_skipeButton;
    
    UIPageControl         *_pageControl;
        
    int _seconds;
    
    BOOL _isLaunched;
}

+ (void)showMainAdvViewWithTarget:(id)target;

+ (void)resetMainAdvView;


@property (assign, nonatomic) id <MainAdvViewDelegate> delegate;

@end
