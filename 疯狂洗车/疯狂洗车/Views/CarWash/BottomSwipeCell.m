//
//  BottomSwipeCell.m
//  优快保
//
//  Created by 朱伟铭 on 15/2/1.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BottomSwipeCell.h"

@implementation BottomSwipeCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    _orderButton.layer.masksToBounds = YES;
    _orderButton.layer.cornerRadius = 5;
    
    _bookButton.layer.masksToBounds = YES;
    _bookButton.layer.cornerRadius = 5;
    
 
    //添加四个边阴影

    _displayInfoView.layer.masksToBounds = NO;
    _displayInfoView.layer.cornerRadius = 5;
    _displayInfoView.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    _displayInfoView.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    _displayInfoView.layer.shadowOpacity = 0.8;//不透明度
    _displayInfoView.layer.shadowRadius = 2.0;//半径
}
- (IBAction)didOrderButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didOrderButtonTouched:shouldOrderTime:)])
    {
        [self.delegate didOrderButtonTouched:self.itemIndex shouldOrderTime:NO];
    }
}
- (IBAction)didOrderWithTimeButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didOrderButtonTouched:shouldOrderTime:)])
    {
        [self.delegate didOrderButtonTouched:self.itemIndex shouldOrderTime:YES];
    }
}

@end
