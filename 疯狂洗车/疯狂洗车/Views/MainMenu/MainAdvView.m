//
//  MainAdvView.m
//  优快保
//
//  Created by cts on 15/7/14.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "MainAdvView.h"
#import "UIImageView+WebCache.h"
#import "CustomLaunchView.h"
#import "UIView+Genie.h"

@implementation MainAdvView

+ (id)sharedMainAdvView
{
    static MainAdvView *mainAdvView = nil;
    //
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *nibName = nil;
        if (bIsiOS7)
        {
            nibName = @"MainAdvView_7";
        }
        else if (SCREEN_WIDTH <= 320)
        {
            nibName = @"MainAdvView";
        }
        else if (SCREEN_WIDTH < 414)
        {
            nibName = @"MainAdvView_6";
        }
        else
        {
            nibName = @"MainAdvView_6p";
        }
        mainAdvView = [[NSBundle mainBundle] loadNibNamed:nibName
                                                    owner:self
                                                  options:nil][0];

        mainAdvView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    });
    //
    return mainAdvView;
}


+ (void)showMainAdvViewWithTarget:(id)target
{
    [[MainAdvView sharedMainAdvView] showMainAdvViewWithTarget:target];
}

- (void)showMainAdvViewWithTarget:(id)target
{
    if (!_isLaunched)
    {
        _isLaunched = YES;
        _skipeButton.layer.masksToBounds = YES;
        _skipeButton.layer.cornerRadius = 5;
        
        _displayScrollView.delegate = self;
        _displayScrollView.clipsToBounds = YES;
        _displayScrollView.layer.masksToBounds = YES;
        _displayScrollView.layer.cornerRadius = 5;
        _displayScrollView.pagingEnabled = YES;
        _displayScrollView.showsHorizontalScrollIndicator = NO;
        
        for (int x = 0; x<_mainAdvModel.adv_list.count; x++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x*_displayScrollView.frame.size.width, 0, _displayScrollView.frame.size.width, _displayScrollView.frame.size.height)];
            adv_list *model = _mainAdvModel.adv_list[x];
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.main_adv_img]
                         placeholderImage:[UIImage imageNamed:@"img_mainAdv_loading"]];
            imageView.userInteractionEnabled = YES;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = imageView.bounds;
            button.tag = x;
            [button addTarget:self action:@selector(didMainAdvImageViewTouch:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
            [_displayScrollView addSubview:imageView];
        }
        
        if (_pageControl == nil)
        {
            _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,_displayScrollView.frame.origin.y+_displayScrollView.frame.size.height-20, _displayView.frame.size.width, 20)];
            [_displayView addSubview:_pageControl];
        }
        [_pageControl setNumberOfPages:_mainAdvModel.adv_list.count];
        _displayScrollView.contentSize = CGSizeMake(_displayScrollView.frame.size.width*_mainAdvModel.adv_list.count, 0);
    }
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       UIWindow *window = [[UIApplication sharedApplication]keyWindow];
                       
                       NSArray *views = window.subviews;
                       BOOL isLaunch = NO;
                       for (int x = 0; x<views.count; x++)
                       {
                           if ([views[x] isKindOfClass:[CustomLaunchView class]])
                           {
                               isLaunch = YES;
                               [window insertSubview:self belowSubview:views[x]];
                           }
                       }
                       
                       self.delegate = target;

                       
                       if (!isLaunch)
                       {
                           [window addSubview:self];
                           CGRect endRect = CGRectInset(_skipeButton.frame, 5.0, 5.0);
                           
                           self.userInteractionEnabled = NO;
                           [_displayView genieOutTransitionWithDuration:0.4
                                                              startRect:endRect
                                                              startEdge:BCRectEdgeBottom
                                                             completion:^{
                               self.userInteractionEnabled = YES;
                           }];

                       }
                   });
}

#pragma mark - UIScrollViewDelegate Method

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / _displayScrollView.frame.size.width;
    if (_pageControl)
    {
        [_pageControl setCurrentPage:index];
    }
}

+ (void)resetMainAdvView
{
    [[MainAdvView sharedMainAdvView] resetMainAdvView];
}

- (void)resetMainAdvView
{
    for (UIView *view in _displayScrollView.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview];
        }
    }
    _isLaunched = NO;
}

- (void)hideMainAdvView
{
    CGRect endRect = CGRectInset(_skipeButton.frame, 5.0, 5.0);
    
    self.userInteractionEnabled = NO;
    _skipeButton.userInteractionEnabled = NO;
    [_displayView genieInTransitionWithDuration:0.3
                                            destinationRect:endRect
                                            destinationEdge:BCRectEdgeBottom completion:
     ^{
         self.userInteractionEnabled = YES;
         _skipeButton.userInteractionEnabled = YES;
         if ([self.delegate respondsToSelector:@selector(didMainAdvImageHide)])
         {
             [self.delegate didMainAdvImageHide];
         }
         [self removeFromSuperview];
         
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



- (IBAction)didSkipeButtonTouch:(id)sender
{
    _skipeButton.userInteractionEnabled = NO;
    [self hideMainAdvView];
    
}

- (void)didMainAdvImageViewTouch:(UIButton*)sender
{
    adv_list *model = _mainAdvModel.adv_list[sender.tag];
    
    if ([self.delegate respondsToSelector:@selector(didMainAdvImageTouched:)])
    {
        [self.delegate didMainAdvImageTouched:model];
        [self hideMainAdvView];
    }
}

- (void)dealloc
{
    self.delegate = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
