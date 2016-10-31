//
//  InsuranceDetailOthersCell.m
//  
//
//  Created by cts on 15/9/15.
//
//

#import "InsuranceDetailOthersCell.h"

@implementation InsuranceDetailOthersCell

- (void)awakeFromNib {
    // Initialization code
    
    if (SCREEN_WIDTH < 375)
    {
        _othersTitleLabel.font = [UIFont systemFontOfSize:14];
        _othersContentLabel.font = [UIFont systemFontOfSize:14];
    }
    else
    {
        _othersTitleLabel.font = [UIFont systemFontOfSize:16];
        _othersContentLabel.font = [UIFont systemFontOfSize:16];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDisplayInsuranceInfo:(InsuranceDetailOthersItemModel*)model
{
    _othersTitleLabel.text = model.insuranceOtherName;
    
    _othersContentLabel.text = model.insuranceOtherContent;

    _othersDescLabel.text = model.insuranceOtherDesc;

}

@end
