//
//  InsuranceViewController.h
//  优快保
//
//  Created by cts on 15/7/7.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"

//当当前用户选择或所在城市存在保险服务时的保险首页
@interface InsuranceViewController : BaseViewController<UIWebViewDelegate>
{
    
    UIImageView *_insuranceImageView;
    
    UIButton    *_insuranceButton;
    
    UIImageView *_insuranceCompanyImageView;
    
}
@end
