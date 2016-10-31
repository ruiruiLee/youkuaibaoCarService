//
//  InsuranceCustomItemCell.m
//  疯狂洗车
//
//  Created by cts on 15/11/19.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "InsuranceCustomItemCell.h"

@implementation InsuranceCustomItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDisplayCustomItemInfo:(InsuranceCustomSelectModel*)model
{
    if (model.valueType == CustomSelectValueTypeJQCC)
    {
        _rightArrowImageView.hidden = YES;
    }
    else
    {
        _rightArrowImageView.hidden = NO;
    }
    _insuranceNameLabel.text = model.selectTitle;
    _insuranceBuyProbabilityLabel.text = model.selectIntro;
    InsuranceCustomValueModel *valueModel = model.itemsArray[model.selectedIndex];
    _insuranceSelectValueLabel.text = [NSString stringWithFormat:@"%@%@",valueModel.valueName,model.bjmpSelected?@"(不计免赔)":@""];;
}

@end
