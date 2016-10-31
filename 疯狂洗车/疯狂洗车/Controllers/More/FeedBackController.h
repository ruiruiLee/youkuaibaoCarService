//
//  FeedBackController.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/28.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "GCPlaceholderTextView.h"

//意见反馈
@interface FeedBackController : BaseViewController <UITextViewDelegate>
{
    IBOutlet UIView                 *_feedBackTextViewBg;
    IBOutlet GCPlaceholderTextView  *_feedBackTextView;
    IBOutlet UIButton               *_submitBtn;
}

@end
