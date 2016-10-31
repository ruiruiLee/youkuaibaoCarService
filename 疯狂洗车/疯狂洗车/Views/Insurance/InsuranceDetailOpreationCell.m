//
//  InsuranceDetailOpreationCell.m
//  
//
//  Created by cts on 15/9/15.
//
//

#import "InsuranceDetailOpreationCell.h"

@implementation InsuranceDetailOpreationCell

- (void)awakeFromNib
{
    // Initialization code

    
    _giftView.layer.borderWidth = 1;
    _giftView.layer.borderColor = [UIColor colorWithRed:235/255.0
                                                     green:84/255.0
                                                      blue:1/255.0
                                                     alpha:1.0].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInsuranceInfo:(InsuranceDetailItemModel*)model
{
    _totalTitleLabel.text = model.total_content_title;
    _totalPriceLabel.text = [NSString stringWithFormat:@"共计：%@",model.total_content_price];
    _newPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.fk_member_price];
    _oldPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.fk_orginal_price];
    
    _giftContentLabel.text = model.giftsString;
}

- (IBAction)didDetailOpreationPhoneButtonTouch
{
    if ([self.delegate respondsToSelector:@selector(didDetailOpreationPhoneButtonTouched)])
    {
        [self.delegate didDetailOpreationPhoneButtonTouched];
    }
}

- (IBAction)didDetailOpreationOrderButtonTouch
{
    if ([self.delegate respondsToSelector:@selector(didDetailOpreationOrderButtonTouched)])
    {
        [self.delegate didDetailOpreationOrderButtonTouched];
    }
}

@end
