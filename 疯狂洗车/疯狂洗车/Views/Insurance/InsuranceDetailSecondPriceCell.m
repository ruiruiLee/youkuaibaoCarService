//
//  InsuranceDetailSecondPriceCell.m
//  
//
//  Created by cts on 15/9/15.
//
//

#import "InsuranceDetailSecondPriceCell.h"

@implementation InsuranceDetailSecondPriceCell

- (void)awakeFromNib {
    // Initialization code
    if (SCREEN_WIDTH < 375)
    {
        _senondNameLabel.font = [UIFont systemFontOfSize:14];
        _secondPriceLabel.font = [UIFont systemFontOfSize:14];
    }
    else
    {
        _senondNameLabel.font = [UIFont systemFontOfSize:16];
        _secondPriceLabel.font = [UIFont systemFontOfSize:16];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDisplayInfo:(InsuranceBaseItemModel *)model
{
    _senondNameLabel.text = model.insuranceName;
    
    _secondPriceLabel.text = [NSString stringWithFormat:@"%@",model.insurancePrice];
}
@end
