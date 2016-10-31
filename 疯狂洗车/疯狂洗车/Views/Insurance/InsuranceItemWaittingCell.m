//
//  InsuranceItemCell.m
//  优快保
//
//  Created by cts on 15/7/8.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "InsuranceItemWaittingCell.h"
#import "UIImageView+WebCache.h"

@implementation InsuranceItemWaittingCell

- (void)awakeFromNib {
    // Initialization code
    
    CGRect topRect = CGRectMake(0, 0, SCREEN_WIDTH - 20, 30);
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
                              placeholderImage:[UIImage imageNamed:@"img_insurance_comp_renbao"]];

    _insuranceNameLabel.text = model.insurance_name == nil? @"保险公司：":[NSString stringWithFormat:@"%@：",model.insurance_name];
    _insuranceContentLabel.text = @"等待报价";
    _insuranceStatusLabel.hidden = NO;
}


@end
