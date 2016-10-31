//
//  InsuranceDetailBasePriceCell.m
//  
//
//  Created by cts on 15/9/15.
//
//

#import "InsuranceDetailBasePriceCell.h"

@implementation InsuranceDetailBasePriceCell

- (void)awakeFromNib {
    // Initialization code
    
    if (SCREEN_WIDTH < 375)
    {
        _infoNameLabel.font = [UIFont systemFontOfSize:14];
        _priceLabel.font = [UIFont systemFontOfSize:14];
    }
    else
    {
        _infoNameLabel.font = [UIFont systemFontOfSize:16];
        _priceLabel.font = [UIFont systemFontOfSize:16];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInfo:(InsuranceBaseItemModel*)model
{
    _infoNameLabel.text = model.insuranceName;
    
    _priceLabel.text = [NSString stringWithFormat:@"%@",model.insurancePrice];
}

@end
