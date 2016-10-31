//
//  OrderSuccessViewController.h
//  优快保
//
//  Created by cts on 15/6/19.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "WebServiceHelper.h"
#import "CrazyCarWashWebView.h"

//订单支付成功页面
@interface OrderSuccessViewController : BaseViewController<UIWebViewDelegate>
{
    IBOutlet CrazyCarWashWebView *_webView;
}


@property (strong, nonatomic) NSString *share_order_url;



@end
