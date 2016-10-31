//
//  ButlerHelperView.m
//  优快保
//
//  Created by cts on 15/6/26.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "ButlerHelperView.h"
#import "UIView+Genie.h"

@implementation ButlerHelperView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    _butlerDisplayImageView.layer.masksToBounds = YES;
    _butlerDisplayImageView.layer.cornerRadius = 3;
}

- (IBAction)didCloseButtonTouch:(id)sender
{
    [self hideButlerHelperView];
}


- (void)showButlerHelperView
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       UIWindow *window = [[UIApplication sharedApplication]keyWindow];
                       [window addSubview:self];
                       [self exChangeOutdur:0.3];
                   });
}

- (void)hideButlerHelperView
{
    [self exChangeIndur:0.3];
    
}

-(void)exChangeOutdur:(CFTimeInterval)dur
{
    CGRect endRect = CGRectInset(_closeButton.frame, 5.0, 5.0);
    
    _butlerHelperDisplayView.userInteractionEnabled = NO;
    _closeButton.userInteractionEnabled = NO;
    [_butlerHelperDisplayView genieOutTransitionWithDuration:dur startRect:endRect startEdge:BCRectEdgeBottom completion:^{
        _butlerHelperDisplayView.userInteractionEnabled = YES;
        _closeButton.userInteractionEnabled = YES;
    }];
    
    return;
}

-(void)exChangeIndur:(CFTimeInterval)dur
{
    CGRect endRect = CGRectInset(_closeButton.frame, 5.0, 5.0);
    
    _butlerHelperDisplayView.userInteractionEnabled = NO;
    _closeButton.userInteractionEnabled = NO;
    [_butlerHelperDisplayView genieInTransitionWithDuration:dur
                                            destinationRect:endRect
                                            destinationEdge:BCRectEdgeBottom completion:
     ^{
         _closeButton.userInteractionEnabled = YES;
         [self removeFromSuperview];
         
     }];
}

@end
