//
//  ShareActivityViewController.h
//  优快保
//
//  Created by cts on 15/6/20.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "CrazyCarWashWebView.h"

//活动分享页面
@interface ShareActivityViewController : BaseViewController<UIWebViewDelegate>
{
    IBOutlet CrazyCarWashWebView      *_webView;
}

@property (strong , nonatomic) NSString *baseUrlString;

@property (strong , nonatomic) NSString *titleString;
@end
