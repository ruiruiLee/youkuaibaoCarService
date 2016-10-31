//
//  InsuranceItemCell.m
//  优快保
//
//  Created by cts on 15/7/8.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "InsuranceItemCell.h"
#import "UIImageView+WebCache.h"

@implementation InsuranceItemCell

- (void)awakeFromNib {
    // Initialization code
    
    _opreationButton.layer.masksToBounds = YES;
    _opreationButton.layer.cornerRadius = 5;
    _phoneCallButton.layer.masksToBounds = YES;
    _phoneCallButton.layer.cornerRadius = 5;
    
    CGRect topRect = CGRectMake(0, 0, SCREEN_WIDTH - 20, 40);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:topRect
                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = topRect;
    maskLayer.path = maskPath.CGPath;
    _bottomCornerView.layer.mask = maskLayer;
    
    _insuranceStatusLabel.adjustsFontSizeToFitWidth = YES;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInsuranceInfo:(InsuranceInfoModel*)model
{

    [_insuranceComImageView sd_setImageWithURL:[NSURL URLWithString:model.logo]
                              placeholderImage:[UIImage imageNamed:@"img_insurance_comp_default"]];

    if ([model.suggest_id isEqualToString:@""] || model.suggest_id == nil)
    {
        
        _insuranceNameLabel.text = model.insurance_name == nil? @"保险公司：":[NSString stringWithFormat:@"%@：",model.insurance_name];
        _insuranceContentLabel.text = @"等待报价";
        _presentLabel.text = @"";
        _phoneCallButton.hidden = YES;
        _presentLabel.hidden = YES;
        _insruanceRationLabel.hidden = YES;
        _insuranceStatusLabel.hidden = NO;
    }
    else
    {
        _insuranceNameLabel.text = [NSString stringWithFormat:@"%@：",model.insurance_name];
        _insuranceContentLabel.text = [NSString stringWithFormat:@"%@元",model.suggest_price];
        _insruanceRationLabel.text = model.sy_price_ratio;
        _insruanceRationLabel.hidden = NO;
       // _presentLabel.text = model.giftsString;
        if (model.giftsString)
        {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.giftsString];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            
            [paragraphStyle setLineSpacing:10];//调整行间距
            [attributedString addAttribute:NSFontAttributeName
                                     value:[UIFont systemFontOfSize:13.0]
                                     range:NSMakeRange(0, [model.giftsString length])];
            [attributedString addAttribute:NSParagraphStyleAttributeName
                                     value:paragraphStyle
                                     range:NSMakeRange(0, [model.giftsString length])];
            _presentLabel.attributedText = attributedString;
            _presentLabel.hidden = NO;
        }
        else
        {
            _presentLabel.hidden = YES;
        }

        _phoneCallButton.hidden = NO;
        _insuranceStatusLabel.hidden = YES;
    }
    
    NSLog(@"%f",self.bottomCubeView.frame.size.width);
}



- (IBAction)didOpreationButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didOpreationButtonTouched:)])
    {
        [self.delegate didOpreationButtonTouched:self.indexPath];
    }
}

- (IBAction)didPhoneCallButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didPhoneCallButtonTouched:)])
    {
        [self.delegate didPhoneCallButtonTouched:self.indexPath];
    }
}

@end
