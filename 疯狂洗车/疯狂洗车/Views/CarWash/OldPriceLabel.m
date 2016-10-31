//
//  OldPriceLabel.m
//  优快保
//
//  Created by cts on 15/4/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "OldPriceLabel.h"

@implementation OldPriceLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    // Drawing code.
    //获得处理的上下文
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1.0);
    
    //设置颜色
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetStrokeColorWithColor(context, self.textColor.CGColor);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 0, self.frame.size.height/2);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height/2);

    CGContextStrokePath(context);
    
}




@end
