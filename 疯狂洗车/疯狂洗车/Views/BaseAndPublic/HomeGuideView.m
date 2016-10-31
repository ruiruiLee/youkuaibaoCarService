//
//  HomeGuideView.m
//  优快保
//
//  Created by cts on 15/4/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "HomeGuideView.h"

#define imageWidth 348

#define imageWidth4S 248


@implementation HomeGuideView

+ (id)sharedHomeGuideView
{
    static HomeGuideView *homeGuideView = nil;
    //
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{homeGuideView = [[HomeGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];});
    //
    return homeGuideView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        if (SCREEN_HEIGHT < 568)
        {
            _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2-382/2, self.frame.size.width, 382)];
            _scrollView.pagingEnabled = YES;
            
            float padding = (self.frame.size.width - imageWidth4S)/2;
            
            for (int x = 1; x<=4 ; x++)
            {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding + (x-1)*_scrollView.frame.size.width, 0 , imageWidth4S, _scrollView.frame.size.height)];
                [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_home_guide_%d",x]]];
                [_scrollView addSubview:imageView];
            }
            _scrollView.showsHorizontalScrollIndicator = NO;
            [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width*4, _scrollView.frame.size.height)];
            [self addSubview:_scrollView];
            
            _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _cancelButton.frame = CGRectMake(padding + imageWidth4S-28*SCREEN_WIDTH/375,_scrollView.frame.origin.y, 28*SCREEN_WIDTH/375, 28*SCREEN_WIDTH/375);
            [_cancelButton setImage:[UIImage imageNamed:@"btn_homePage_close"] forState:UIControlStateNormal];
            [_cancelButton addTarget:self action:@selector(hideCarSelectView) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_cancelButton];
        }
        else
        {
            _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2-535*SCREEN_WIDTH/375/2, self.frame.size.width, 535*SCREEN_WIDTH/375)];
            _scrollView.pagingEnabled = YES;
            
            float padding = (self.frame.size.width - imageWidth*SCREEN_WIDTH/375)/2;
            
            for (int x = 1; x<=4 ; x++)
            {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(padding + (x-1)*_scrollView.frame.size.width, 0 , imageWidth*SCREEN_WIDTH/375, _scrollView.frame.size.height)];
                [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"img_home_guide_%d",x]]];
                [_scrollView addSubview:imageView];
            }
            _scrollView.showsHorizontalScrollIndicator = NO;
            [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width*4, _scrollView.frame.size.height)];
            [self addSubview:_scrollView];
            
            _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _cancelButton.frame = CGRectMake(padding + imageWidth*SCREEN_WIDTH/375-28*SCREEN_WIDTH/375-10, _scrollView.frame.origin.y+10, 28*SCREEN_WIDTH/375, 28*SCREEN_WIDTH/375);
            [_cancelButton setImage:[UIImage imageNamed:@"btn_homePage_close"] forState:UIControlStateNormal];
            [_cancelButton addTarget:self action:@selector(hideCarSelectView) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_cancelButton];
        }
    }
    
    return self;
}

+ (void)showHomeGuideView
{
    [[HomeGuideView sharedHomeGuideView] showHomeGuideView];
}

- (void)showHomeGuideView
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       UIWindow *window = [[UIApplication sharedApplication]keyWindow];
                       [window addSubview:self];
                       [self exChangeOutdur:0.3];
                   });
}

- (void)hideCarSelectView
{
    [self exChangeIndur:0.3];
    [self removeFromSuperview];
    
}

-(void)exChangeOutdur:(CFTimeInterval)dur
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = dur;
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 0.3)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 0.5)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 0.7)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [_scrollView.layer addAnimation:animation forKey:nil];
    
    return;
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
    [_scrollView.layer addAnimation:animation forKey:nil];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
