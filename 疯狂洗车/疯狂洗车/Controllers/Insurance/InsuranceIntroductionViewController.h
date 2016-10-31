//
//  InsuranceViewController.h
//  优快保
//
//  Created by cts on 15/7/7.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"

//用户未登录并在首页点击保险服务时进入的车险介绍页
@interface InsuranceIntroductionViewController : BaseViewController<UIWebViewDelegate>
{
    
    UIImageView *_insuranceImageView;
    
    UIButton    *_insuranceButton;
    
    UIImageView *_insuranceCompanyImageView;
    
}


@end
