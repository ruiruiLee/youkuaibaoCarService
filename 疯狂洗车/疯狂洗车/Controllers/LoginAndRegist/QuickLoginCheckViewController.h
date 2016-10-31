//
//  QuickLoginCheckViewController.h
//  优快保
//
//  Created by cts on 15/6/5.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "WebServiceHelper.h"

@interface QuickLoginCheckViewController : BaseViewController
{
    IBOutlet UIView *_inputView;
    
    IBOutlet UITextField *_checkCodeField;
    
    IBOutlet UIButton *_submitButton;
    
    IBOutlet UIButton *_messageCodeButton;
    
    IBOutlet UIButton *_audioCodeButton;
    
    IBOutlet UILabel *_titleLabel;
}

@property (strong, nonatomic) NSString *mobile;

@end
