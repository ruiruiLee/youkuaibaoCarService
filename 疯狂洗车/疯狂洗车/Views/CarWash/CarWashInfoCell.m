//
//  CarWashInfoCell.m
//  优快保
//
//  Created by cts on 15/5/13.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CarWashInfoCell.h"
#import "UIImageView+WebCache.h"


@implementation CarWashInfoCell

- (void)awakeFromNib
{
    // Initialization code
    
    _carWashImageView.layer.masksToBounds = YES;
    _carWashImageView.layer.cornerRadius = 7;
    _carWashImageView.layer.borderWidth = 1;
    _carWashImageView.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:0.5].CGColor;
    
    if (SCREEN_WIDTH < 375)
    {
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _addressLabel.font = [UIFont systemFontOfSize:12];

        _timeLabel.font = [UIFont systemFontOfSize:13];
    }
    else
    {
        _nameLabel.font = [UIFont systemFontOfSize:18];
        _addressLabel.font = [UIFont systemFontOfSize:13];

        _timeLabel.font = [UIFont systemFontOfSize:16];
    }
    
    _openStatusLabel.layer.masksToBounds = YES;
    _openStatusLabel.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInfo:(CarWashModel *)model
{
    [_nameLabel setText:model.name];
    [_addressLabel setText:model.address];

    
    double distanceValue = model.distance.doubleValue;
    if (distanceValue >= 100)
    {
        _distanceLabel.adjustsFontSizeToFitWidth = YES;
        [_distanceLabel setText:@"大于100km"];
    }
    else if (distanceValue >= 1)
    {
        [_distanceLabel setText:[NSString stringWithFormat:@"%.1fkm", distanceValue]];
    }
    else 
    {
        [_distanceLabel setText:[NSString stringWithFormat:@"%.fm", distanceValue*1000]];
    }
    
    if (model.business_hours_from == nil ||model.business_hours_to == nil ||[model.business_hours_from isEqualToString:@""] ||[model.business_hours_to isEqualToString:@""])
    {
        _timeLabel.text = @"营业时间：";
    }
    else
    {
        [_timeLabel setText:[NSString stringWithFormat:@"营业时间：%@~%@",model.business_hours_from,model.business_hours_to]];
    }
    
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

    
    _carPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.car_member_price];
    _carOldPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.car_original_price];
    _suvPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.suv_member_price];
    _suvOldPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.suv_original_price];

    
    [_startRatingView setScore:model.average_score == nil? 0:model.average_score.floatValue/5.0
                withAnimation:NO];
    _sorceLabel.text = [NSString stringWithFormat:@"%.1f分",model.average_score.floatValue];

    [_commentButton setTitle:[NSString stringWithFormat:@"评价（%d）",model.evaluation_counts.intValue]
                    forState:UIControlStateNormal];

    
    [_carWashImageView sd_setImageWithURL:[NSURL URLWithString:model.logo]
                         placeholderImage:[UIImage imageNamed:@"img_default_logo"]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if (error == nil)
         {
             [_carWashImageView setImage:[Constants imageByScalingAndCroppingForSize:_carWashImageView.bounds.size
                                                                          withTarget:image]];
         }
     }];

}


- (IBAction)didNaviButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didNaviButtonTouched)])
    {
        [self.delegate didNaviButtonTouched];
    }
}

- (IBAction)didPhoneButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didPhoneButtonTouched)])
    {
        [self.delegate didPhoneButtonTouched];
    }
}

- (IBAction)didCommentButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didCommentButtonTouched)])
    {
        [self.delegate didCommentButtonTouched];
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
