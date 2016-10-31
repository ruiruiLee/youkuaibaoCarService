//
//  RechargeRecordCell.m
//  优快保
//
//  Created by cts on 15/6/2.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "RechargeRecordCell.h"

@implementation RechargeRecordCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDisplayInfo:(RechargeRecordModel*)model
{
    _timeLabel.text = model.recharge_time;
    
    if (model.recharge_type.intValue > 1)
    {
        _rechargeWayLabel.text = @"微信支付";
    }
    else
    {
        _rechargeWayLabel.text = @"支付宝支付";
    }
    
    NSString *presentString = nil;
    
    if ([model.present isEqualToString:@""] || model.present == nil)
    {
        presentString = @"";
    }
    else
    {
        presentString = [NSString stringWithFormat:@"(送%@)",model.present];

    }
    
    _rechargeLabel.text = [NSString stringWithFormat:@"%@元%@",model.recharge_money,presentString];

}
@end
