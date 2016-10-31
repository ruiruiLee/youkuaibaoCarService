//
//  NO19ClubSegmentView.m
//  优快保
//
//  Created by cts on 15/8/10.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "NO19ClubSegmentView.h"

#define ButtonItemNormalColor [UIColor colorWithRed:51/255.0 green:52/255.0 blue:56/255.0 alpha:1.0]

#define ButtonItemSelectedColor [UIColor colorWithRed:227/255.0 green:174/255.0 blue:82/255.0 alpha:1.0]

@implementation NO19ClubSegmentView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithRed:151/255.0
                                             green:151/255.0
                                              blue:151/255.0
                                             alpha:1.0].CGColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
}

- (void)setUpSegmentViewWithItems:(NSArray *)itemsArray
{
    float itemWidth = (SCREEN_WIDTH-20)/(float)itemsArray.count;

    for (int x = 0; x<itemsArray.count; x++)
    {
        UIButton *buttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonItem.frame = CGRectMake(x*itemWidth, 0, itemWidth, self.frame.size.height);
        buttonItem.titleLabel.font = [UIFont systemFontOfSize:13];
        [buttonItem setTitle:itemsArray[x]
                    forState:UIControlStateNormal];
        [buttonItem setTitleColor:ButtonItemNormalColor
                         forState:UIControlStateNormal];
        
        [buttonItem setTitleColor:ButtonItemSelectedColor
                         forState:UIControlStateSelected];
        [buttonItem setBackgroundColor:[UIColor clearColor]];
        buttonItem.tag = x;
        [buttonItem addTarget:self
                       action:@selector(didButtonItemTouch:)
             forControlEvents:UIControlEventTouchUpInside];
        if (x == 0)
        {
            buttonItem.selected = YES;
            [buttonItem setBackgroundColor:ButtonItemNormalColor];
            self.selectIndex = 0;
        }
        [self addSubview:buttonItem];
    }
    for (int x = 1; x<itemsArray.count; x++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x*itemWidth, 0, 1, self.frame.size.height)];
        view.backgroundColor = [UIColor colorWithRed:151/255.0
                                               green:151/255.0
                                                blue:151/255.0
                                               alpha:1.0];
        [self addSubview:view];
    }
    
}


- (void)didButtonItemTouch:(UIButton*)sender
{
    if (!sender.selected)
    {
        for (UIView *view in self.subviews)
        {
            if ([view isKindOfClass:[UIButton class]])
            {
                UIButton *buttonItem = (UIButton*)view;
                if (buttonItem.tag == sender.tag)
                {
                    buttonItem.selected = YES;
                    [buttonItem setBackgroundColor:ButtonItemNormalColor];
                }
                else
                {
                    buttonItem.selected = NO;
                    [buttonItem setBackgroundColor:[UIColor clearColor]];
                }
            }
        }
        
        self.selectIndex = sender.tag;
        if ([self.delegate respondsToSelector:@selector(didClubSegmentIndexChanged:)])
        {
            [self.delegate didClubSegmentIndexChanged:sender.tag];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/
//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetLineCap(context, kCGLineCapSquare);
//    //设置线条粗细宽度
//    CGContextSetLineWidth(context, 1.0);
//    
//    
//    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, 100, 0);
//    CGContextAddLineToPoint(context, 100, 100);
//
//    CGContextStrokePath(context);
//    CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 1.0);
//
//    CGContextMoveToPoint(context, 200, 0);
//    CGContextAddLineToPoint(context, 200, 100);
//    
//    CGContextStrokePath(context);
//}
@end
