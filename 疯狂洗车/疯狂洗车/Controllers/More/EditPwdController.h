//
//  EditPwdController.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/28.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"

//修改密码页面
@interface EditPwdController : BaseViewController <UITextFieldDelegate>
{
    IBOutlet UITextField    *_oldPwdField;
    IBOutlet UITextField    *_newPwdField;
    IBOutlet UIButton       *_showPwdBtn;
}

@end
