//
//  CarWashNameBgView.m
//  优快保
//
//  Created by cts on 15/5/4.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CarWashNameBgView.h"

@implementation CarWashNameBgView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    [self drawInContext:UIGraphicsGetCurrentContext()];
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, self.isClub?[UIColor colorWithRed:51/255.0
                                                                        green:52/255.0
                                                                         blue:56/255.0
                                                                        alpha:1.0].CGColor:[UIColor colorWithRed:235.0/255.0
                                                                                                   green:84.0/255.0
                                                                                                            blue:1.0/255.0
                                                                                                           alpha:1.0].CGColor);
    [self getSelectedDrawPath:context];
    CGContextFillPath(context);
}

- (void)getSelectedDrawPath:(CGContextRef)context
{
    CGRect rrect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect);
    
    
    CGContextMoveToPoint(context, maxx, self.frame.size.height);
    CGContextAddLineToPoint(context,minx, self.frame.size.height);
    
    
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, self.frame.size.height, radius);
    CGContextClosePath(context);
}


@end
