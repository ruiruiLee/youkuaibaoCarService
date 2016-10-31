//
//  InsuranceBaseItemCell.m
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "InsuranceBaseItemCell.h"

@implementation InsuranceBaseItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInsuranceBaseItemInfo:(InsuranceBaseItemModel*)model
{
    _insuranceTitleName.text = model.insuranceName;
    _insurancePriceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.insurancePrice.floatValue];
    
    if (model.isSYPrice)
    {
        _insurancePriceLabel.textColor = [UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1.0];
    }
    else
    {
        _insurancePriceLabel.textColor = [UIColor blueColor];
    }
}

@end
