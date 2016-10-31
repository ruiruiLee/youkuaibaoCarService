//
//  MoreRequestViewController.m
//  优快保
//
//  Created by cts on 15/4/10.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "MoreRequestViewController.h"

@interface MoreRequestViewController ()<UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer *_naviBarTapGesture;
}

@end

@implementation MoreRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"更多需求"];
    
    [_inputTextView setPlaceholder:@"有什么需求，请告诉我们……"];
    
    _inputView.layer.masksToBounds = YES;
    _inputView.layer.cornerRadius = 5;
    _inputView.layer.borderColor = [UIColor colorWithRed:210/255.0
                                                   green:210/255.0
                                                    blue:210/255.0
                                                   alpha:1.0].CGColor;
    _inputView.layer.borderWidth = 0.7;
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 5 ;

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(closeKeyBoard)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    _naviBarTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(closeKeyBoard)];
    _naviBarTapGesture.delegate = self;
    
    [self.navigationController.navigationBar addGestureRecognizer:_naviBarTapGesture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar removeGestureRecognizer:_naviBarTapGesture];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.requestString != nil)
    {
        [_inputTextView setText:self.requestString];
    }
}


- (IBAction)didSubmitButtonTouch:(id)sender
{
    if ([_inputTextView.text isEqualToString:@""] || _inputTextView.text == nil)
    {
        [Constants showMessage:@"请填写您的需求"];
    }
    else if ([_inputTextView.text length] > 50)
    {
        [Constants showMessage:@"更多需求不能超过50"];
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(didFinishMoreRequestEditing:)])
        {
            [self.delegate didFinishMoreRequestEditing:_inputTextView.text];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark UIGestureRecognizer Method

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]] ||
        [touch.view isKindOfClass:[UITextView class]])
    {
        return NO;
    }
    return YES;
}

#pragma mark - closeKeyBoard

- (void)closeKeyBoard
{
    [[self findFirstResponder:self.view]resignFirstResponder];
}

- (UIView *)findFirstResponder:(UIView*)view
{
    for ( UIView *childView in view.subviews )
    {
        if ([childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder])
        {
            return childView;
        }
        UIView *result = [self findFirstResponder:childView];
        if (result) return result;
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
