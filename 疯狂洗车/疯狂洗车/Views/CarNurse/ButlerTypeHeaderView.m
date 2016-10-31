//
//  ServiceTypeHeaderView.m
//  优快保
//
//  Created by cts on 15/4/8.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "ButlerTypeHeaderView.h"

@implementation ButlerTypeHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)didServiceButtonTouch:(UIButton*)sender
{
    if (sender.selected)
    {
        if ([self.delegate respondsToSelector:@selector(didMoreServiceButtonTouched)])
        {
            [self.delegate didMoreServiceButtonTouched];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(didServiceTypeSelect:)])
        {
            [self.delegate didServiceTypeSelect:self.sectionIndex];
        }
    }

}


@end
