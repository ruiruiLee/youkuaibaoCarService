//
//  InsuranceSubmitViewController.h
//  优快保
//
//  Created by cts on 15/7/7.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "BaseViewController.h"
#import "InsuranceGroupModel.h"

//当用户从未提交过报价方案时显示的提交页面
@interface InsuranceSubmitViewController : BaseViewController<UITextFieldDelegate>
{
    IBOutlet UIImageView *_insuranceImageNewView;
    
    IBOutlet UIView      *_textInfoView;
    
    IBOutlet UITextField *_idNumberField;
    
    IBOutlet UITextField *_cityField;
    
    IBOutlet UIButton *_frontButton;
    
    IBOutlet UIImageView *_frontImageView;
    
    IBOutlet UIButton *_submitButton;
    
    NSString   *_cityID;
    
    IBOutlet UIScrollView *_scrollView;
}

@property (assign, nonatomic) BOOL isEdit;

@property (assign, nonatomic) BOOL isCustomdSubmited;


@property (strong, nonatomic) InsuranceGroupModel *insuranceGroupModel;

@end
