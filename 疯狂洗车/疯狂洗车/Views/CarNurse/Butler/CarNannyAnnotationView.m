//
//  CarNannyAnnotationView.m
//  优快保
//
//  Created by cts on 15/6/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CarNannyAnnotationView.h"



@implementation CarNannyAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, -40);
        self.frame = CGRectMake(0, 0, 42, 61);
        
        if (_infoView == nil)
        {
            _infoView = [[CarNannyCallOutView alloc] initWithFrame:CGRectMake(-70, -self.frame.size.height/2-10, 140, 38)];
            [self addSubview:_infoView];
        }
        
    }
    
    return self;
}

- (void)setDisplayInfo:(ButlerOrderModel*)model;
{
    if (_infoView == nil)
    {
        _infoView = [[CarNannyCallOutView alloc] initWithFrame:CGRectMake(-70, -40, 140, 38)];
        [self addSubview:_infoView];
    }
    
    NSString *distanceString = [NSString stringWithFormat:@"%.2f",model.distance.floatValue];
    CGSize    distanceLabelSize = CGSizeMake(MAXFLOAT, 18);
    CGSize    distanceSize =[distanceString boundingRectWithSize:distanceLabelSize
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0]}
                                                         context:nil].size;
    if (distanceSize.width+146<= 140)
    {
        _infoView.frame = CGRectMake(-70, -self.frame.size.height/2-10, 140, 76);
    }
    else
    {
        float callOutWidth = distanceSize.width+146;
        _infoView.frame = CGRectMake(self.frame.size.width/2-callOutWidth/2, -self.frame.size.height/2-10, callOutWidth, 38);
    }
    
    
    [_infoView setDisplayCarWashInfo:model];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
