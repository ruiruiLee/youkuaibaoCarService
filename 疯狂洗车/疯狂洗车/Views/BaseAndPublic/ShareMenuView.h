//
//  ShareMenuView.h
//  OldErp4iOS
//
//  Created by Darsky on 14/11/8.
//  Copyright (c) 2014年 HFT_SOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"


@interface ShareMenuView : UIView<UIGestureRecognizerDelegate>
{    
    UIView              *_menuView;
    
    UIPageControl       *_pageControl;
    
    UIButton            *_cancelButton;
    
    UIImage             *_shareImage;
    
    NSString            *_titleString;
    
    NSString            *_shareImageUrl;

    NSString            *_contentString;
    
    NSString            *_urlString;
        
    NSDictionary        *_shareTencentDic;
    
    NSInteger            _shareTarget;
}


@property (strong, nonatomic) UIViewController *target;



+ (void)showShareMenuViewAtTarget:(UIViewController*)controller
                      withContent:(NSString*)contentString
                        withTitle:(NSString *)title
                        withImage:(UIImage*)shareImage
                          withUrl:(NSString*)urlString;

//分享内容，不仅仅是券
+ (void)showShareMenuViewAtTarget:(UIViewController *)controller
                      withContent:(NSString *)contentString
                        withTitle:(NSString *)title
                     withImageUrl:(NSString *)shareImageUrl
                          withUrl:(NSString *)urlString;

+ (void)hideAllShareMenuView;

@end
