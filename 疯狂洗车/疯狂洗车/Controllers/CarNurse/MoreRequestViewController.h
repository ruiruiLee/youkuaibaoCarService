//
//  MoreRequestViewController.h
//  优快保
//
//  Created by cts on 15/4/10.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "GCPlaceholderTextView.h"

@protocol  MoreRequestDelegate <NSObject>

- (void)didFinishMoreRequestEditing:(NSString*)contextString;

@end

//更多需求填写页面
@interface MoreRequestViewController : BaseViewController
{
    
    IBOutlet UIView *_inputView;
        
    IBOutlet UIButton *_submitButton;
}

@property (assign, nonatomic) id <MoreRequestDelegate> delegate;

@property (strong, nonatomic) IBOutlet GCPlaceholderTextView *inputTextView;

@property (strong, nonatomic) NSString *requestString;


@end
