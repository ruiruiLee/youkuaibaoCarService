//
//  RechargeCell.m
//  优快保
//
//  Created by cts on 15/3/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "RechargeCell.h"

@implementation RechargeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInfoWithRechargeValue:(NSString*)rechargeValue
                           andSendValue:(NSString*)giftValue
{
    _rechargeLabel.text = [NSString stringWithFormat:@"充值%@元",rechargeValue];
    if (giftValue != nil && giftValue.floatValue > 0)
    {
        _rechargeSendLabel.hidden = NO;
        _rechargeSendLabel.text = [NSString stringWithFormat:@"送%@",giftValue];
    }
    else
    {
        _rechargeSendLabel.hidden = NO;
        _rechargeSendLabel.text = [NSString stringWithFormat:@"%@",giftValue == nil?@"":giftValue];
    }
}

@end
