//
//  CarNurseInfoCell.m
//  优快保
//
//  Created by cts on 15/4/16.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "ButlerInfoCell.h"
#import "UIImageView+WebCache.h"


@implementation ButlerInfoCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _circleView1.layer.masksToBounds =
    _circleView2.layer.masksToBounds =
    _circleView3.layer.masksToBounds =
    _circleView4.layer.masksToBounds = YES;
    
    _circleView1.layer.cornerRadius =
    _circleView2.layer.cornerRadius =
    _circleView3.layer.cornerRadius =
    _circleView4.layer.cornerRadius = 8;
    
    if (SCREEN_WIDTH < 375)
    {
        _titleStringLabel.font = [UIFont systemFontOfSize:11];
        _carNurseNameLabel.font = [UIFont systemFontOfSize:16];
        _carNuresAddressLabel.font = [UIFont systemFontOfSize:14];
        _carNurseTimeLabel.font = [UIFont systemFontOfSize:14];
    }
    else
    {
        _titleStringLabel.font = [UIFont systemFontOfSize:12];
        _carNurseNameLabel.font = [UIFont systemFontOfSize:18];
        _carNuresAddressLabel.font = [UIFont systemFontOfSize:16];
        _carNurseTimeLabel.font = [UIFont systemFontOfSize:16];
    }
    
    _carWashImageView.layer.borderWidth = 1;
    _carWashImageView.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:0.5].CGColor;
    _carWashImageView.layer.masksToBounds = YES;
    _carWashImageView.layer.cornerRadius = 85/2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayCarNurseInfo:(CarNurseModel*)model
{
    _carNurseNameLabel.text = model.name;
    [_carNuresAddressLabel setText:[NSString stringWithFormat:@"服务次数：%d次",model.service_count.intValue]];
    
    [_commentsButton setTitle:[NSString stringWithFormat:@"评论（%d）",model.evaluation_counts.intValue]
                    forState:UIControlStateNormal];
    
    if ([model.phone isEqualToString:@""] || model.phone == nil)
    {
        _butlerPhoneLabel.hidden = YES;
    }
    else
    {
        _butlerPhoneLabel.hidden = NO;
        _butlerPhoneLabel.text = [NSString stringWithFormat:@"联系电话：%@",model.phone];
    }
    
    if (model.business_hours_from == nil ||model.business_hours_to == nil ||[model.business_hours_from isEqualToString:@""] ||[model.business_hours_to isEqualToString:@""])
    {
        _carNurseTimeLabel.text = @"营业时间：9:30~17:30";
    }
    else
    {
        [_carNurseTimeLabel setText:[NSString stringWithFormat:@"营业时间：%@~%@",
                                     model.business_hours_from,
                                     model.business_hours_to]];
    }
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
    _introductionLabel.text = model.introduction;
    [_startRatingView setScore:model.average_score.floatValue/5.0 withAnimation:YES];
    _scoreLabel.text = [NSString stringWithFormat:@"%.1f分",model.average_score.floatValue];
    
    [_carWashImageView sd_setImageWithURL:[NSURL URLWithString:model.logo]
                     placeholderImage:[UIImage imageNamed:@"car_wash_list_default_image"]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if (error == nil)
         {
             [_carWashImageView setImage:[Constants imageByScalingAndCroppingForSize:_carWashImageView.bounds.size
                                                                          withTarget:image]];
         }
     }];

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

@end
