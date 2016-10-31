//
//  HomeGuideView.h
//  优快保
//
//  Created by cts on 15/4/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeGuideView : UIView
{
    UIScrollView *_scrollView;
    
    UIButton     *_cancelButton;
}

+ (void)showHomeGuideView;

@end
