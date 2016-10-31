//
//  InsuranceBaseItemCell.m
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "InsurancePresentItemCell.h"

@implementation InsurancePresentItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInsurancePresentItemModel:(InsurancePresentItemModel*)model
{
    _insuranceTitleName.text = [NSString stringWithFormat:@"%@：",model.presentName];
    
    _insurancePriceLabel.text = model.presentContent;
}

@end
