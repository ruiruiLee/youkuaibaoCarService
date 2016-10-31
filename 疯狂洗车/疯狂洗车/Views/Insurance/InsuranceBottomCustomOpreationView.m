//
//  InsuranceBottomCustomOpreationView.m
//  
//
//  Created by cts on 15/10/20.
//
//

#import "InsuranceBottomCustomOpreationView.h"

@implementation InsuranceBottomCustomOpreationView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _customEditButton.layer.borderWidth = 0.7;
    _customEditButton.layer.borderColor = [UIColor colorWithRed:235/255.0
                                                     green:84/255.0
                                                      blue:1/255.0
                                                     alpha:1.0].CGColor;
    
    _customPhoneButton.layer.borderWidth = 0.7;
    _customPhoneButton.layer.borderColor = [UIColor colorWithRed:235/255.0
                                                          green:84/255.0
                                                           blue:1/255.0
                                                          alpha:1.0].CGColor;
    
    _orderPhoneButton.layer.borderWidth = 0.7;
    _orderPhoneButton.layer.borderColor = [UIColor colorWithRed:235/255.0
                                                           green:84/255.0
                                                            blue:1/255.0
                                                           alpha:1.0].CGColor;
    
    
    
}

- (void)shouldShowOrHideOrderFinishView:(BOOL)shouldShow
{
    _orderFinishView.hidden = !shouldShow;
}

- (IBAction)didCustomOpreationPhoneButtonTouch
{
    if ([self.delegate respondsToSelector:@selector(didCustomOpreationPhoneButtonTouched)])
    {
        [self.delegate didCustomOpreationPhoneButtonTouched];
    }
}

- (IBAction)didCustomOpreationEditButtonTouch
{
    if ([self.delegate respondsToSelector:@selector(didCustomOpreationEditButtonTouched)])
    {
        [self.delegate didCustomOpreationEditButtonTouched];
    }
}

- (IBAction)didCustomOpreationPayButtonTouch
{
    if ([self.delegate respondsToSelector:@selector(didCustomOpreationPayButtonTouched)])
    {
        [self.delegate didCustomOpreationPayButtonTouched];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
