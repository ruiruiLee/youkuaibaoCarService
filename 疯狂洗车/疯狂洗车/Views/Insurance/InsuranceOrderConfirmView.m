//
//  InsuranceOrderConfirmView.m
//  疯狂洗车
//
//  Created by cts on 15/12/17.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "InsuranceOrderConfirmView.h"

@implementation InsuranceOrderConfirmView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _displayInfoView.layer.masksToBounds = YES;
    _displayInfoView.layer.cornerRadius = 10;
}


- (void)showAndSetUpWithPayInfoModel:(InsurancePayInfoModel*)model
                      withTicketInfo:(TicketModel*)tickerModel
{
    _jqccsyPriceLabel.text = [NSString stringWithFormat:@"%@",model.total_price_content];
    _reducePriceLabel.text = [NSString stringWithFormat:@"-￥%@",model.zk_price];
    if (tickerModel != nil)
    {
        _ticketPriceLabel.text = [NSString stringWithFormat:@"-￥%@",model.price];
        _payPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.member_price.floatValue-model.price.floatValue];

    }
    else
    {
        _ticketPriceLabel.text = @"-￥0.00";
        _payPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.member_price];
    }
    [self showInsuranceOrderConfirmViewOnWindow];

}


#pragma mark - 现实或隐藏整个view的代码

- (void)showInsuranceOrderConfirmViewOnWindow
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
        //[self updateMinTime];
        [self exChangeOutdur:0.3];
        
    });
}


-(void)exChangeOutdur:(CFTimeInterval)dur
{
    _displayInfoView.hidden = NO;
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = dur;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [_displayInfoView.layer addAnimation:animation forKey:nil];
}

- (IBAction)didCancelButtonTouch:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)didConfirmButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didInsuranceOrderConfirmViewDismissAfterConfirm)])
    {
        [self.delegate didInsuranceOrderConfirmViewDismissAfterConfirm];
    }
    [self didCancelButtonTouch:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
