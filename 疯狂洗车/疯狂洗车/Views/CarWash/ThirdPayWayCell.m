//
//  PayWayCell.m
//  优快保
//
//  Created by cts on 15/5/13.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "ThirdPayWayCell.h"

@implementation ThirdPayWayCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDisplayInfoWithName:(NSString*)name
                 withThirdType:(NSInteger)type
{
    if (type == 2)
    {
        [_thirdPayImageView setImage:[UIImage imageNamed:@"alipay_icon"]];
    }
    else if (type == 3)
    {
        [_thirdPayImageView setImage:[UIImage imageNamed:@"weixin_pay_icon"]];
    }
    else if (type == 4)
    {
        [_thirdPayImageView setImage:[UIImage imageNamed:@"union_pay_icon"]];
    }
    else
    {
        [_thirdPayImageView setImage:[UIImage imageNamed:@"live_pay_icon"]];
    }
    _payNameLabel.text = name;
}



@end
