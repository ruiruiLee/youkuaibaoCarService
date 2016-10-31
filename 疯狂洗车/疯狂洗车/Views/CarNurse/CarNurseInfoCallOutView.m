//
//  CarWashInfoCallOutView.m
//  优快保
//
//  Created by cts on 15/5/4.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CarNurseInfoCallOutView.h"

@implementation CarNurseInfoCallOutView


- (id)initWithFrame:(CGRect)frame
       withClubMode:(BOOL)isClub
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.isClubMode = isClub;

        _nameBgView = [[CarWashNameBgView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 24)];
        _nameBgView.isClub = self.isClubMode;

        [self addSubview:_nameBgView];
        _nameBgView.hidden = YES;
        _carNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, self.frame.size.width-20, 16)];
        _carNameLabel.textAlignment = NSTextAlignmentLeft;
        _carNameLabel.text = @"测试气泡";
        _carNameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_carNameLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_carNameLabel.frame.origin.x, _carNameLabel.frame.origin.y+_carNameLabel.frame.size.height+8, 26, 15)];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.text = @"¥100";
        _priceLabel.font = [UIFont systemFontOfSize:13];
        _priceLabel.textColor = self.isClubMode?[UIColor colorWithRed:227/255.0
                                                                green:174/255.0
                                                                 blue:82/255.0
                                                                alpha:1.0]:[UIColor colorWithRed:235.0/255.0 green:84.0/255.0 blue:1.0/255.0 alpha:1.0];
        [self addSubview:_priceLabel];
        
        _oldPriceLabel = [[OldPriceLabel alloc] initWithFrame:CGRectMake(0, 0, 60, 15)];
        _oldPriceLabel.text = @"¥100";
        _oldPriceLabel.textAlignment = NSTextAlignmentLeft;
        _oldPriceLabel.font = [UIFont systemFontOfSize:10];
        _oldPriceLabel.textColor = self.isClubMode?[UIColor colorWithRed:167/255.0
                                                                   green:167/255.0
                                                                    blue:167/255.0
                                                                   alpha:1.0]:[UIColor colorWithRed:137/255.0
                                                   green:137/255.0
                                                    blue:137/255.0
                                                   alpha:0.7];
        [self addSubview:_oldPriceLabel];
        
        _supportServiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_carNameLabel.frame.origin.x, _carNameLabel.frame.origin.y+_carNameLabel.frame.size.height+8, 26, 15)];
        _supportServiceLabel.textAlignment = NSTextAlignmentLeft;
        _supportServiceLabel.text = @"";
        _supportServiceLabel.font = [UIFont boldSystemFontOfSize:15];
        _supportServiceLabel.textColor = self.isClubMode?[UIColor colorWithRed:227/255.0
                                                                green:174/255.0
                                                                 blue:82/255.0
                                                                alpha:1.0]:[UIColor colorWithRed:235.0/255.0 green:84.0/255.0 blue:1.0/255.0 alpha:1.0];
        [self addSubview:_supportServiceLabel];
        _supportServiceLabel.hidden = YES;
        
    }
    
    return self;
}


- (void)setDisplayCarWashInfo:(CarNurseModel*)model
{
    _nameBgView.frame = CGRectMake(0, 0, self.frame.size.width, 24);
    _carNameLabel.frame = CGRectMake(10, 3, self.frame.size.width-20, 16);
    _carNameLabel.text = model.short_name;
    
    NSString *priceString = [NSString stringWithFormat:@"¥%@",model.member_price];
    CGSize    priceLabelSize = CGSizeMake(MAXFLOAT, 15);
    CGSize    priceSize =[priceString boundingRectWithSize:priceLabelSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]}
                                                  context:nil].size;
    _priceLabel.frame = CGRectMake(_carNameLabel.frame.origin.x, _priceLabel.frame.origin.y, priceSize.width, 15);
    _priceLabel.text = priceString;
    
    NSString *oldPiceString = [NSString stringWithFormat:@"¥%@",model.original_price];
    CGSize    oldPriceLabelSize = CGSizeMake(MAXFLOAT, 15);
    CGSize    oldPiceSize =[oldPiceString boundingRectWithSize:oldPriceLabelSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0]}
                                                   context:nil].size;
    
    _oldPriceLabel.frame = CGRectMake(_priceLabel.frame.origin.x+_priceLabel.frame.size.width+4, _priceLabel.frame.origin.y+1, oldPiceSize.width, 15);
    _oldPriceLabel.text = oldPiceString;
    
    _supportServiceLabel.hidden = YES;
    
    [self updateShadowDisplay];
}

- (void)setDisplayInsuranceCarWashInfo:(CarNurseModel*)model
{
    _nameBgView.frame = CGRectMake(0, 0, self.frame.size.width, 24);
    _carNameLabel.frame = CGRectMake(10, 3, self.frame.size.width-20, 16);
    _carNameLabel.text = model.short_name;
    
    NSString *priceString = [NSString stringWithFormat:@"%@",model.service_name];
    CGSize    priceLabelSize = CGSizeMake(MAXFLOAT, 15);
    CGSize    priceSize =[priceString boundingRectWithSize:priceLabelSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0]}
                                                   context:nil].size;
    _supportServiceLabel.frame = CGRectMake(_carNameLabel.frame.origin.x, _priceLabel.frame.origin.y, priceSize.width, 15);
    _supportServiceLabel.text = priceString;
    _supportServiceLabel.hidden = NO;
    
    _priceLabel.hidden = YES;
    _oldPriceLabel.hidden = YES;
    
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
    CGContextSetShadow(context, CGSizeMake(0, 1), 1);

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
    self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    self.layer.shadowRadius = 1;//阴影半径，默认3
    
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
