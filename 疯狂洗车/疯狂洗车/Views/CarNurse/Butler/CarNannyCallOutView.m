//
//  CarNannyCallOutView.m
//  优快保
//
//  Created by cts on 15/6/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CarNannyCallOutView.h"

@implementation CarNannyCallOutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _nannyDistanceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 90, 18)];
        _nannyDistanceTitleLabel.textAlignment = NSTextAlignmentLeft;
        _nannyDistanceTitleLabel.text = @"车保姆距您";
        _nannyDistanceTitleLabel .font = [UIFont systemFontOfSize:18];
        _nannyDistanceTitleLabel.textColor = [UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:0.7];
        [self addSubview:_nannyDistanceTitleLabel];
        
        _nannyDistanceValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+_nannyDistanceTitleLabel.frame.size.width, 6, 90, 18)];
        _nannyDistanceValueLabel.textAlignment = NSTextAlignmentLeft;
        _nannyDistanceValueLabel.text = @"0.0";
        _nannyDistanceValueLabel .font = [UIFont systemFontOfSize:18];
        _nannyDistanceValueLabel.textColor = [UIColor colorWithRed:235.0/255.0 green:84.0/255.0 blue:1.0/255.0 alpha:1];
        [self addSubview:_nannyDistanceValueLabel];
        
        _nannyDistanceUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nannyDistanceTitleLabel.frame.origin.x+_nannyDistanceTitleLabel.frame.size.width,
                                                                            6, 36, 18)];
        _nannyDistanceUnitLabel.textAlignment = NSTextAlignmentLeft;
        _nannyDistanceUnitLabel.text = @"公里";
        _nannyDistanceUnitLabel .font = [UIFont systemFontOfSize:18];
        _nannyDistanceUnitLabel.textColor = [UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:0.7];
        [self addSubview:_nannyDistanceUnitLabel];

    }
    
    return self;
}

- (void)setDisplayCarWashInfo:(ButlerOrderModel*)model
{
    _nannyDistanceTitleLabel.frame = CGRectMake(10, 6, 90, 18);
    
    NSString *distanceString = nil;
    distanceString = [NSString stringWithFormat:@"%.2f",model.distance.floatValue];


    CGSize    distanceLabelSize = CGSizeMake(MAXFLOAT, 18);
    CGSize    distanceSize =[distanceString boundingRectWithSize:distanceLabelSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0]}
                                                   context:nil].size;
    _nannyDistanceValueLabel.frame = CGRectMake(10+_nannyDistanceTitleLabel.frame.size.width, _nannyDistanceTitleLabel.frame.origin.y, distanceSize.width, 18);
    _nannyDistanceValueLabel.text = distanceString;
    
    _nannyDistanceUnitLabel.frame = CGRectMake(_nannyDistanceValueLabel.frame.origin.x+_nannyDistanceValueLabel.frame.size.width,
                                               _nannyDistanceValueLabel.frame.origin.y, 36, 18);
    
    
}

#define kArrorHeight        8
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor);
    CGContextSetShadow(context, CGSizeMake(0, 1), 1);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 3.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = rrect.size.width*0.5,
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
