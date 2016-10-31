//
//  ButlerHelperView.m
//  优快保
//
//  Created by cts on 15/6/26.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "ClubHelperView.h"
#import "UIView+Genie.h"

@implementation ClubHelperView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    _displayScrollView.layer.masksToBounds = YES;
    _displayScrollView.layer.cornerRadius = 5;
}

- (IBAction)didCloseButtonTouch:(id)sender
{
    [self hideButlerHelperView];
}


- (void)showPublicHelperViewWithServiceType:(NSInteger)serviceType
{
    for (int x = 0; x<_cityServiceArray.count; x++)
    {
        HomeButtonModel *tmpModel = _cityServiceArray[x];
        if ((int)serviceType == tmpModel.service_type.intValue)
        {
            if ([tmpModel.service_intro_pic isEqualToString:@""]||tmpModel.service_intro_pic == nil)
            {
                _targetModel = nil;
            }
            else
            {
                _targetModel = tmpModel;
            }
            break;
        }
    }
    if (_targetModel == nil)
    {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       UIWindow *window = [[UIApplication sharedApplication]keyWindow];
                       [window addSubview:self];
                       _serviceType = serviceType;
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
    
    if (_clubDisplayImageView == nil)
    {
        _clubDisplayImageView = [[UIImageView alloc] init];

        [_clubDisplayImageView sd_setImageWithURL:[NSURL URLWithString:_targetModel.service_intro_pic]
                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
        {
            if (error == nil)
            {
                float targetWidth = SCREEN_WIDTH - 30;
                float targetHeight = 0;
                float targetScle = targetWidth/image.size.width;
                targetHeight = image.size.height*targetScle;                
                _clubDisplayImageView.frame = CGRectMake(0, 0, targetWidth, targetHeight);
                [_displayScrollView addSubview:_clubDisplayImageView];
                [_displayScrollView setContentSize:CGSizeMake(targetWidth, targetHeight)];
            }
        }];
    }
    _butlerHelperDisplayView.userInteractionEnabled = NO;
    _closeButton.userInteractionEnabled = NO;
    [_butlerHelperDisplayView genieOutTransitionWithDuration:dur
                                                   startRect:endRect
                                                   startEdge:BCRectEdgeBottom
                                                  completion:^{
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
