//
//  CarWashInfoCallOutView.m
//  优快保
//
//  Created by cts on 15/5/4.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "ButlerInfoCallOutView.h"
#import "UIImageView+WebCache.h"

@implementation ButlerInfoCallOutView


- (id)initWithFrame:(CGRect)frame
       withClubMode:(BOOL)isClub
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.isClubMode = isClub;

        _nameBgView = [[CarWashNameBgView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 55/2)];
        _nameBgView.isClub = self.isClubMode;

        [self addSubview:_nameBgView];
        _nameBgView.hidden = YES;
        
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 40, 40)];
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.layer.cornerRadius = 40.0/2;
        _headerImageView.layer.borderWidth = 1;
        _headerImageView.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:0.5].CGColor;
        [self addSubview:_headerImageView];
        
        _carNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 7.5, self.frame.size.width-70, 18)];
        _carNameLabel.textAlignment = NSTextAlignmentLeft;
        _carNameLabel.text = @"车保姆";
        _carNameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_carNameLabel];
        
        _serviceDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(_carNameLabel.frame.origin.x,
                                                                    _carNameLabel.frame.origin.y+_carNameLabel.frame.size.height+7,
                                                                     80, 16)];
        _serviceDesLabel.textAlignment = NSTextAlignmentLeft;
        _serviceDesLabel.text = @"4S店服务";
        _serviceDesLabel.font = [UIFont systemFontOfSize:14];
        _serviceDesLabel.textColor = [UIColor colorWithRed:235/255.0 green:84/255.0 blue:1/255.0 alpha:1.0];

        
        [self addSubview:_serviceDesLabel];

        
    }
    
    return self;
}


- (void)setDisplayCarWashInfo:(CarNurseModel*)model
{
    _nameBgView.frame = CGRectMake(0, 0, self.frame.size.width, 55/2);
    _carNameLabel.frame = CGRectMake(60, 7.5, self.frame.size.width-70, 18);
    _carNameLabel.text = model.short_name;
    _serviceDesLabel.text = model.service_types;
    _serviceDesLabel.frame = CGRectMake(_serviceDesLabel.frame.origin.x, _serviceDesLabel.frame.origin.y, self.frame.size.width-70, 16);


    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:model.logo]
                 placeholderImage:[UIImage imageNamed:@"img_default_logo"]
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if (error == nil)
         {
             [_headerImageView setImage:[Constants imageByScalingAndCroppingForSize:_headerImageView.frame.size withTarget:image]];
         }
     }];
    
    [self updateShadowDisplay];
}

- (void)setIsSelected:(BOOL)isSelected
{
    if (_isSelected == isSelected)
    {
        return;
    }
    _isSelected = isSelected;
    if (self.isSelected)
    {
        _carNameLabel.textColor = self.isClubMode?[UIColor colorWithRed:227/255.0
                                                                  green:174/255.0
                                                                   blue:82/255.0
                                                                  alpha:1.0]:[UIColor whiteColor];
        _nameBgView.hidden = NO;
    }
    else
    {
        _carNameLabel.textColor = [UIColor blackColor];
        _nameBgView.hidden = YES;
    }
    
}

#define kArrorHeight        7
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self drawInContext:UIGraphicsGetCurrentContext()];

}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor);
    [self getDrawPath:context];
    CGContextFillPath(context);
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = rrect.size.width*0.618,
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

- (void)updateShadowDisplay
{
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,1);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 1;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat midx = self.bounds.size.width*0.618;
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    [path moveToPoint:CGPointMake(midx+kArrorHeight, maxy)];
    //添加四个二元曲线
    [path addLineToPoint:CGPointMake(midx, maxy+kArrorHeight)];
    [path addLineToPoint:CGPointMake(midx-kArrorHeight, maxy)];
    
    
    [path addLineToPoint:CGPointMake(radius, self.frame.size.height-kArrorHeight)];
    [path addQuadCurveToPoint:CGPointMake(0, self.frame.size.height-kArrorHeight-radius)
                 controlPoint:CGPointMake(0, self.frame.size.height-kArrorHeight)];
    [path addLineToPoint:CGPointMake(0, radius)];
    [path addQuadCurveToPoint:CGPointMake(radius, 0)
                 controlPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width-radius, 0)];
    [path addQuadCurveToPoint:CGPointMake(self.frame.size.width, radius)
                 controlPoint:CGPointMake(self.frame.size.width, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height-kArrorHeight-radius)];
    
    [path addQuadCurveToPoint:CGPointMake(self.frame.size.width-radius, self.frame.size.height-kArrorHeight)
                 controlPoint:CGPointMake(self.frame.size.width, self.frame.size.height-kArrorHeight)];
    [path closePath];
    
    //设置阴影路径
    self.layer.shadowPath = path.CGPath;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
