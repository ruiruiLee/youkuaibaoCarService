//
//  QuickRescueCell.m
//  优快保
//
//  Created by cts on 15/5/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "QuickRescueCell.h"
#import "TQStarRatingView.h"

@implementation QuickRescueCell

- (void)awakeFromNib {
    // Initialization code
    _phoneLabel.adjustsFontSizeToFitWidth = YES;
    _quickRescuePhoneButton.layer.masksToBounds = YES;
    _quickRescuePhoneButton.layer.cornerRadius = 3;
    
    if (SCREEN_WIDTH < 375)
    {
        _carWashNameLabel.font = [UIFont systemFontOfSize:14];
        _carWashAddressLabel.font = [UIFont systemFontOfSize:12];
        _carWashTimeLabel.font = [UIFont systemFontOfSize:14];
    }
    else
    {
        _carWashNameLabel.font = [UIFont systemFontOfSize:18];
        _carWashAddressLabel.font = [UIFont systemFontOfSize:13];
        _carWashTimeLabel.font = [UIFont systemFontOfSize:16];
    }
    
    _carWashImageView.layer.borderWidth = 1;
    _carWashImageView.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:0.5].CGColor;
    _carWashImageView.layer.masksToBounds = YES;
    _carWashImageView.layer.cornerRadius = 7;
    
    _openStatusLabel.layer.masksToBounds = YES;
    _openStatusLabel.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didQuickRescuePhoneButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didQuickRescuePhoneButtonTouched)])
    {
        [self.delegate didQuickRescuePhoneButtonTouched];
    }
}
- (IBAction)didQuickRescueCommentButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didQuickRescueCommentButtonTouched)])
    {
        [self.delegate didQuickRescueCommentButtonTouched];
    }
}

@end
