//
//  RechargeRecordAlertCell.m
//  优快保
//
//  Created by cts on 15/6/2.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "RechargeRecordAlertCell.h"

@implementation RechargeRecordAlertCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    if (SCREEN_WIDTH <= 320)
    {
        _alertLabel.font = [UIFont systemFontOfSize:12];
    }
    else
    {
        _alertLabel.font = [UIFont systemFontOfSize:15];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)didCloseTouched:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didCloseRechargeRecordAlertTouched)])
    {
        [self.delegate didCloseRechargeRecordAlertTouched];
    }
}


@end
