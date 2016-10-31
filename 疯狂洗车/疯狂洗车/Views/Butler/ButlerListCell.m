//
//  ButlerListCell.m
//  优快保
//
//  Created by cts on 15/6/12.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "ButlerListCell.h"
#import "UIImageView+WebCache.h"

@implementation ButlerListCell

- (void)awakeFromNib {
    // Initialization code
    
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 85/2.0;
    
    _headImageView.layer.borderWidth = 0.7;
    _headImageView.layer.borderColor = [UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:0.5].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayButlerInfo:(CarNurseModel*)model
{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.logo]
                          placeholderImage:[UIImage imageNamed:@"img_bulterHeader_default"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if (error == nil)
         {
             [_headImageView setImage:[Constants imageByScalingAndCroppingForSize:CGSizeMake(85, 85) withTarget:image]];
         }
     }];
    
    
    _butlerNameLabel.text = model.name;
    _serviceTimeLabel.text = [NSString stringWithFormat:@"服务次数：%d次",model.service_count.intValue];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",model.member_price];
    _oldPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.original_price];
    _commentCountLabel.text = [NSString stringWithFormat:@"%d人评价",model.evaluation_counts.intValue];
    [_starRatingView setScore:model.average_score.floatValue/5.0 withAnimation:YES];

    
    double distanceValue = model.distance.doubleValue;
    if (distanceValue >= 1000)
    {
        _distanceLabel.adjustsFontSizeToFitWidth = YES;
        [_distanceLabel setText:@"大于1000km"];
    }
    else if (distanceValue >= 1)
    {
        [_distanceLabel setText:[NSString stringWithFormat:@"%dkm", (int)distanceValue]];
    }
    else
    {
        [_distanceLabel setText:[NSString stringWithFormat:@"%.fm", distanceValue*1000]];
    }
}

@end
