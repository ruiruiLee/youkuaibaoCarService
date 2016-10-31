//
//  RechargeTypeCell.m
//  优快保
//
//  Created by cts on 15/3/21.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "RechargeTypeCell.h"

@implementation RechargeTypeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInfoWithPayType:(NSInteger)typeIndex
{
    if (typeIndex == 1)
    {
        _payTypeNameLabel.text = @"支付宝";
    }
    else
    {
        _payTypeNameLabel.text = @"微信支付";
    }
}

@end
