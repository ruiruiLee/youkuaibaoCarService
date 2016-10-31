//
//  MyTicketCycleView.m
//  优快保
//
//  Created by cts on 15/5/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "MyTicketCycleView.h"

@implementation MyTicketCycleView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (!_isSetting)
    {
        _isSetting = YES;
        float padding = 3.0;
        float target = (SCREEN_WIDTH-23)/10.0;
        if (target<(int)target)
        {
            target--;
        }
        for (int x = 0; x<(int)target; x++)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(padding+x*10, 0, 7, 7)];
            view.backgroundColor = [UIColor whiteColor];
            view.layer.cornerRadius = 7/2;
            view.layer.masksToBounds = YES;
            [self addSubview:view];
        }
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
