//
//  TabActivityCircle.m
//  优快保
//
//  Created by cts on 15/4/28.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "TabActivityCircle.h"

@implementation TabActivityCircle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.frame.size.width/2;
        self.backgroundColor = [UIColor redColor];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
