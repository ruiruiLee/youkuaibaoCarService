//
//  BottomCarWashView.m
//  优快保
//
//  Created by cts on 15/3/27.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BottomCarWashView.h"

@implementation BottomCarWashView

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    _orderButton.layer.masksToBounds = YES;
    _orderButton.layer.cornerRadius = 5;
    
    _bookButton.layer.masksToBounds = YES;
    _bookButton.layer.cornerRadius = 5;
    _bookButton.layer.borderWidth = 0.5;
    _bookButton.layer.borderColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1.0].CGColor;
    
    
    //添加四个边阴影
    
    _displayInfoView.layer.masksToBounds = NO;
    _displayInfoView.layer.cornerRadius = 5;
//    _displayInfoView.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
//    _displayInfoView.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
//    _displayInfoView.layer.shadowOpacity = 0.8;//不透明度
//    _displayInfoView.layer.shadowRadius = 2.0;//半径
    
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

- (void)setDisplayCarNurseInfo:(CarWashModel*)model
{
    [self.titleLabel setText:model.name];
    [self.addressLabel setText:model.address];
    
    double distanceValue = model.distance.doubleValue;
    if (distanceValue >= 100)
    {
        self.distanceLabel.adjustsFontSizeToFitWidth = YES;
        
        [self.distanceLabel  setText:@"大于100km"];
    }
    else if (distanceValue >= 1)
    {
        [self.distanceLabel setText:[NSString stringWithFormat:@"%.1fkm", distanceValue]];
    }
    else
    {
        [self.distanceLabel  setText:[NSString stringWithFormat:@"%.fm", distanceValue*1000]];
    }
    [self.jiaochePriceLabel setText:[NSString stringWithFormat:@"￥%@", model.car_member_price]];
    [self.jiaocheOldPrice setText:[NSString stringWithFormat:@"￥%@", model.car_original_price]];
    [self.suvPriceLabel setText:[NSString stringWithFormat:@"￥%@", model.suv_member_price]];
    [self.oldSuvLabel setText:[NSString stringWithFormat:@"￥%@", model.suv_original_price]];
    [self.startRatingView setScore:model.average_score.floatValue/5.0 withAnimation:NO];


}
- (IBAction)didTapOnStarRattingView
{
    if ([self.delegate respondsToSelector:@selector(didTapedOnStarRattingView:)])
    {
        [self.delegate didTapedOnStarRattingView:self.itemIndex];
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
