//
//  CarWashListCell.m
//  优快保
//
//  Created by 朱伟铭 on 15/1/29.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "RecommendListCell.h"
#import "UIImageView+WebCache.h"

@implementation RecommendListCell

- (void)awakeFromNib
{
    // Initialization code

    self.iconView.layer.borderWidth = 1;
    self.iconView.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:0.5].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayRecommendInfo:(CarNurseModel*)model
{
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.logo]
                     placeholderImage:[UIImage imageNamed:@"img_default_logo"]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if (error == nil)
         {
             [self.iconView setImage:[Constants imageByScalingAndCroppingForSize:self.iconView.bounds.size
                                                                      withTarget:image]];
         }
     }];
    self.titleLabel.text = model.service_name;

    if ([model.service_type isEqualToString:@"0"])
    {
        [self.nowPriceLabel setText:[NSString stringWithFormat:@"￥%@", model.car_member_price]];
        [self.oldPriceLabel setText:[NSString stringWithFormat:@"￥%@", model.car_original_price]];
    }
    else
    {
        
        [self.nowPriceLabel setText:[NSString stringWithFormat:@"￥%@", model.member_price]];
        [self.oldPriceLabel setText:[NSString stringWithFormat:@"￥%@", model.original_price]];
    }
    
    if ([model.service_type isEqualToString:@"5"])
    {
        self.iconView.layer.masksToBounds = YES;
        self.iconView.layer.cornerRadius = 85/2.0;
    }
    else
    {
        self.iconView.layer.masksToBounds = YES;
        self.iconView.layer.cornerRadius = 5;
    }
    [self.regonNameLabel setText:model.short_name == nil?model.name:model.short_name];
    
    double distanceValue = model.distance.doubleValue;
    if (distanceValue >= 100)
    {
        self.distanceLabel.adjustsFontSizeToFitWidth = YES;
        [self.distanceLabel  setText:@"大于100km"];
    }
    else if (distanceValue >= 1)
    {
        [self.distanceLabel setText:[NSString stringWithFormat:@"%.1fkm", distanceValue]];
    }
    else
    {
        [self.distanceLabel  setText:[NSString stringWithFormat:@"%.fm", distanceValue*1000]];
    }
    
    [self.starRatingView setScore:model.average_score.floatValue/5.0 withAnimation:NO];


}

@end
