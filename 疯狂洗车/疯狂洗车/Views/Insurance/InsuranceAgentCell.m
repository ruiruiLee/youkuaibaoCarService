//
//  InsuranceBaseItemCell.m
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "InsuranceAgentCell.h"

@implementation InsuranceAgentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInsurancePresentItemModel:(InsurancePayInfoModel*)model withIndex:(NSInteger)index;
{
    if (index == 0)
    {
        _insuranceTitleName.text = @"保险公司：";
        
        _insurancePriceLabel.text = !model.bx_name?@"":model.bx_name;

    }
    else if (index == 1)
    {
        _insuranceTitleName.text = @"订单号：";
        
        _insurancePriceLabel.text = !model.insurance_no?@"":model.insurance_no;
    }
    else
    {
        _insuranceTitleName.text = @"保险经纪人：";
        
        _insurancePriceLabel.text = !model.bx_user_name?@"":model.bx_user_name;
    }

}

@end
