//
//  ButlerHelperView.h
//  优快保
//
//  Created by cts on 15/6/26.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButlerHelperView : UIView
{
    IBOutlet UIImageView *_butlerDisplayImageView;
    
    IBOutlet UIButton *_closeButton;
    
    IBOutlet UIView   *_butlerHelperDisplayView;
}

- (void)showButlerHelperView;

@end
