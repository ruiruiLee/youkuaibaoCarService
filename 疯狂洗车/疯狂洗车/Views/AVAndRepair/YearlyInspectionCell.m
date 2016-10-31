//
//  YearlyInspectionCell.m
//  疯狂洗车
//
//  Created by cts on 15/12/4.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "YearlyInspectionCell.h"
#import "UIImageView+WebCache.h"

@implementation YearlyInspectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInfo:(CarReviewModel*)model
{
    [_yearlyInspectionImageView sd_setImageWithURL:[NSURL URLWithString:model.logo]
                                  placeholderImage:[UIImage imageNamed:@"img_home_top_default"]];
}

- (void)setDisplayCarNurseInfo:(CarNurseModel*)model
{
    [_yearlyInspectionImageView sd_setImageWithURL:[NSURL URLWithString:model.logo]
                                  placeholderImage:[UIImage imageNamed:@"img_home_top_default"]];
}

- (IBAction)didIntroductionButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didIntroductionButtonTouched)])
    {
        [self.delegate didIntroductionButtonTouched];
    }
}
- (IBAction)didPhoneButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didPhoneButtonTouched)])
    {
        [self.delegate didPhoneButtonTouched];
    }
}

@end
