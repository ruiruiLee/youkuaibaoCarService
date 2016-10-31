//
//  InsuranceRatiosCell.m
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "InsuranceRatiosCell.h"

@implementation InsuranceRatiosCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInsuranceRationItemInfo:(InsuranceRatioItemModel*)model
{
    _ratioContentLabel.text = [NSString stringWithFormat:@"%@ ￥%.2f",model.insuranceRatio,model.insuranceRatioPrice.floatValue];
}
@end
