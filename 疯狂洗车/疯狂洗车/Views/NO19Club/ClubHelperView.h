//
//  ButlerHelperView.h
//  优快保
//
//  Created by cts on 15/6/26.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeButtonModel.h"


@interface ClubHelperView : UIView
{
    IBOutlet UIButton *_closeButton;
    
    IBOutlet UIView   *_butlerHelperDisplayView;
    
    IBOutlet UIScrollView *_displayScrollView;
    
    UIImageView       *_clubDisplayImageView;
    
    NSInteger          _serviceType;
    
    HomeButtonModel   *_targetModel;
}

- (void)showPublicHelperViewWithServiceType:(NSInteger)serviceType;

@end
