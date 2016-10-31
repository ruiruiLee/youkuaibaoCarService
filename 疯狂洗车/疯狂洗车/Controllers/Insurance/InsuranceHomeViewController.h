//
//  InsuranceViewController.h
//  优快保
//
//  Created by cts on 15/7/7.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "InsuranceHomeModel.h"

//用户通过首页进入车险服务时的车险首页
@interface InsuranceHomeViewController : BaseViewController<UIWebViewDelegate>
{
    
    IBOutlet UIWebView   *_webView;
    
    IBOutlet UIButton    *_callButton;
    
    IBOutlet UIButton    *_insuranceButton;
    
}

@end
