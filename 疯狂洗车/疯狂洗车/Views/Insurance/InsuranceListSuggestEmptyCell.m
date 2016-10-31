//
//  InsuranceListSuggestEmptyCell.m
//  疯狂洗车
//
//  Created by cts on 15/11/27.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "InsuranceListSuggestEmptyCell.h"

@implementation InsuranceListSuggestEmptyCell

- (void)awakeFromNib
{
    // Initialization code
    _insuranceSelectButton.layer.masksToBounds = YES;
    _insuranceSelectButton.layer.cornerRadius = 5;
    
    CGRect topRect = CGRectMake(0, 0, SCREEN_WIDTH - 20, 80);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:topRect
                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = topRect;
    maskLayer.path = maskPath.CGPath;
    _infoDisplayView.layer.mask = maskLayer;

}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didInsuranceSelectButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didInsuranceSelectButtonTouched:)])
    {
        [self.delegate didInsuranceSelectButtonTouched:self.indexPath];
    }
}


@end
