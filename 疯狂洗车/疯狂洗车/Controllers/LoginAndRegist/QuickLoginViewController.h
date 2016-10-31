//
//  QuickLoginViewController.h
//  优快保
//
//  Created by cts on 15/6/4.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"

//登录页面
@interface QuickLoginViewController : BaseViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *_mobileField;
    
    IBOutlet UIButton    *_submitButton;
    
    IBOutlet UIView      *_inputView;
}

+ (id)sharedLoginByCheckCodeViewControllerWithProtocolEnable:(id)target;


@end
