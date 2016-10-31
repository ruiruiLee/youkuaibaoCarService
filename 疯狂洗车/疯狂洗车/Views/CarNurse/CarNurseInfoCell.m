//
//  CarNurseInfoCell.m
//  优快保
//
//  Created by cts on 15/4/16.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CarNurseInfoCell.h"
#import "UIImageView+WebCache.h"


@implementation CarNurseInfoCell

- (void)awakeFromNib {
    // Initialization code
    
    if (SCREEN_WIDTH < 375)
    {
        _carNurseNameLabel.font = [UIFont systemFontOfSize:14];
        _carNurseAddressLabel.font = [UIFont systemFontOfSize:12];

        _businessTimeLabel.font = [UIFont systemFontOfSize:14];
        
        [self layoutSubviews];
    }
    else
    {
        _carNurseNameLabel.font = [UIFont systemFontOfSize:18];
        _carNurseAddressLabel.font = [UIFont systemFontOfSize:13];

        _businessTimeLabel.font = [UIFont systemFontOfSize:16];
    }
    _carNurseImageView.layer.borderWidth = 1;
    _carNurseImageView.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:0.5].CGColor;

    
    _openStatusLabel.layer.masksToBounds = YES;
    _openStatusLabel.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayCarNurseInfo:(CarNurseModel*)model
{
    
    if (_openStatusLabel.tag < 0)
    {
        if ([model.off_work isEqualToString:@"0"])
        {
            _openStatusLabel.text = @"营业中";
            _openStatusLabel.textColor = kClubBlackColor;
            _openStatusLabel.backgroundColor = [UIColor clearColor];
            _openStatusLabel.layer.borderWidth = 0.7;
            _openStatusLabel.layer.borderColor = kClubBlackColor.CGColor;
        }
        else
        {
            _openStatusLabel.text = @"打烊了";

            _openStatusLabel.textColor = kClubBlackGoldColor;
            _openStatusLabel.backgroundColor = kClubBlackColor;
            _openStatusLabel.layer.borderWidth = 0.7;
            _openStatusLabel.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
    else
    {
        
        if ([model.off_work isEqualToString:@"0"])
        {
            _openStatusLabel.text = @"营业中";
            _openStatusLabel.backgroundColor = [UIColor colorWithRed:39/255.0
                                                               green:185/255.0
                                                                blue:84/255.0
                                                               alpha:1.0];
        }
        else
        {
            _openStatusLabel.text = @"打烊了";
            _openStatusLabel.backgroundColor = [UIColor colorWithRed:237/255.0
                                                               green:92/255.0
                                                                blue:16/255.0
                                                               alpha:1.0];
        }
    }
    if (self.tag == 0)
    {
        _carNurseImageView.layer.masksToBounds = YES;
        _carNurseImageView.layer.cornerRadius = 7;
    }
    else
    {
        _carNurseImageView.layer.masksToBounds = YES;
        _carNurseImageView.layer.cornerRadius = 85/2;
    }

    [_carNurseImageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:[UIImage imageNamed:@"img_default_logo"]];


    _carNurseNameLabel.text = model.name;
    _carNurseAddressLabel.text = model.address;

    double distanceValue = model.distance.floatValue;
    if (distanceValue >= 100)
    {
        _distanceLabel.adjustsFontSizeToFitWidth = YES;
        [_distanceLabel setText:@"大于100km"];
    }
    else if (distanceValue >= 1)
    {
        [_distanceLabel setText:[NSString stringWithFormat:@"%.1fkm",distanceValue]];
    }
    else 
    {
        [_distanceLabel setText:[NSString stringWithFormat:@"%.fm", distanceValue*1000]];
    }

    [_commentsButton setTitle:[NSString stringWithFormat:@"评价（%d）",model.evaluation_counts.intValue]
                    forState:UIControlStateNormal];
    if (model.business_hours_from == nil ||model.business_hours_to == nil ||[model.business_hours_from isEqualToString:@""] ||[model.business_hours_to isEqualToString:@""])
    {
        _businessTimeLabel.text = @"营业时间：9:30~17:30";
    }
    else
    {
        [_businessTimeLabel setText:[NSString stringWithFormat:@"营业时间：%@~%@",model.business_hours_from,model.business_hours_to]];
    }
    
    [_startRatingView setScore:model.average_score.floatValue/5.0 withAnimation:YES];
    _scoreLabel.text = [NSString stringWithFormat:@"%.1f分",model.average_score.floatValue];
    }

- (IBAction)didNaviButtonTouch
{
    if ([self.delegate respondsToSelector:@selector(didNaviButtonTouched)])
    {
        [self.delegate didNaviButtonTouched];
    }
}

- (IBAction)didPhoneCallButtonTouch
{
    if ([self.delegate respondsToSelector:@selector(didPhoneCallButtonTouched)])
    {
        [self.delegate didPhoneCallButtonTouched];
    }
}

- (IBAction)didCommentsButtonTouch
{
    if ([self.delegate respondsToSelector:@selector(didCommentsButtonTouched)])
    {
        [self.delegate didCommentsButtonTouched];
    }
}
- (IBAction)didCarWashDetailButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didCarWashDetailButtonTouched)])
    {
        [self.delegate didCarWashDetailButtonTouched];
    }
}

@end
