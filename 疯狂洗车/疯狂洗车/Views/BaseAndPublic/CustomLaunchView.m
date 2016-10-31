//
//  MainAdvView.m
//  优快保
//
//  Created by cts on 15/7/14.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CustomLaunchView.h"
#import "UIImageView+WebCache.h"

@implementation CustomLaunchView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
    }
    
    return self;
}

- (void)awakeFromNib
{
    if (SCREEN_WIDTH < 375)
    {
        if (SCREEN_HEIGHT < 568)
        {
            [_defaultImageView setImage:[UIImage imageNamed:@"img_launch_4"]];
        }
        else
        {
            [_defaultImageView setImage:[UIImage imageNamed:@"img_launch_5"]];
        }
    }
    else if (SCREEN_WIDTH < 414)
    {
        [_defaultImageView setImage:[UIImage imageNamed:@"img_launch_6"]];
    }
    else
    {
        [_defaultImageView setImage:[UIImage imageNamed:@"img_launch_6p"]];
    }
    _skipeButton.layer.masksToBounds = YES;
    _skipeButton.layer.cornerRadius = 20;
}


- (void)showMainAdvViewWithTarget:(id)target
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       UIWindow *window = [[UIApplication sharedApplication]keyWindow];
                       [window addSubview:self];
                   });
}

- (void)hideMainAdvView
{
    [UIView animateWithDuration:0.7
                     animations:^{
                         self.alpha = 0;
                         self.transform = CGAffineTransformMakeScale(3, 3);
    }
                     completion:^(BOOL finished)
    {
                         if (finished)
                         {
                             [self removeFromSuperview];
                         }
    }];
    
}

-(void)exChangeIndur:(CFTimeInterval)dur
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = dur;
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 0.7)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 0.5)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 0.1)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [self.layer addAnimation:animation forKey:nil];
}


#pragma mark - 计时器

- (void)startCustomLaunchRefrishTimer
{

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    NSString *customLaunchImage = nil;
    
    NSString *imageDirectory = [Constants getCrazyCarWashImageDirestory];
    
    customLaunchImage = [NSString stringWithFormat:@"%@/%@",imageDirectory,kCustomLaunch];
    
    [_displayImageView setImage:[UIImage imageWithContentsOfFile:customLaunchImage]];
    _displayImageView.clipsToBounds = YES;

    
    
    [self performSelector:@selector(startShowCustomLaunchImage)
               withObject:nil afterDelay:1];
}

- (void)startShowCustomLaunchImage
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         _defaultImageView.alpha = 0;
                     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             _skipeButton.hidden = NO;
             _launchButton.hidden = NO;
             if ([_timer isValid])
             {
                 [_timer invalidate];
             }
             
             _seconds = 2;
             
             _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(beginTimingRecord)
                                                     userInfo:nil
                                                      repeats:YES];
         }
     }];

}
- (IBAction)didSkipeButtonTouch:(id)sender
{
    [self stopMSGRefrishTimer];
    if ([self.delegate respondsToSelector:@selector(didShouldHideCustomLaunchView)])
    {
        [self.delegate didShouldHideCustomLaunchView];
    }
}

- (void)beginTimingRecord
{
    if (_seconds>0)
    {
        _seconds--;
    }
    else
    {
        [self stopMSGRefrishTimer];
        if ([self.delegate respondsToSelector:@selector(didShouldHideCustomLaunchView)])
        {
            [self.delegate didShouldHideCustomLaunchView];
        }
    }
}

- (void)stopMSGRefrishTimer
{
    if ([_timer isValid])
    {
        [_timer invalidate];
    }
}

- (IBAction)didTouchOnLaunchButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didTouchOnLaunchButtoned)])
    {
        [self.delegate didTouchOnLaunchButtoned];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
