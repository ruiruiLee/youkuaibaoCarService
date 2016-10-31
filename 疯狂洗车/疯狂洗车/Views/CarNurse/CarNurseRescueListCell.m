//
//  CarWashListCell.m
//  优快保
//
//  Created by 朱伟铭 on 15/1/29.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CarNurseRescueListCell.h"
#import "UIImageView+WebCache.h"


@implementation CarNurseRescueListCell

- (void)awakeFromNib {
    // Initialization code
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = 7;
    
    self.iconView.layer.borderWidth = 1;
    self.iconView.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:0.5].CGColor;
    if (SCREEN_WIDTH <= 320)
    {
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _regonNameLabel.font = [UIFont systemFontOfSize:11];
        _commentLabel.font = [UIFont systemFontOfSize:11];
        _distanceLabel.font = [UIFont systemFontOfSize:11];
    }
    else
    {
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _regonNameLabel.font = [UIFont systemFontOfSize:13];
        _commentLabel.font = [UIFont systemFontOfSize:13];
        _distanceLabel.font = [UIFont systemFontOfSize:13];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayCarNurseInfo:(CarNurseModel *)model
{
    self.titleLabel.text = model.short_name;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.logo]
                     placeholderImage:[UIImage imageNamed:@"img_default_logo"]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if (error == nil)
         {
             [self.iconView setImage:[Constants imageByScalingAndCroppingForSize:CGSizeMake(85, 85) withTarget:image]];
         }
     }];
    
    [self.regonNameLabel setText:model.address];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.member_price];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.original_price];
    _commentLabel.text = [NSString stringWithFormat:@"%d人评价",model.evaluation_counts.intValue];

    double distanceValue = model.distance.doubleValue;
    if (distanceValue >= 1000)
    {
        self.distanceLabel.adjustsFontSizeToFitWidth = YES;
        [self.distanceLabel  setText:@"大于1000km"];
    }
    else if (distanceValue >= 1)
    {
        [self.distanceLabel setText:[NSString stringWithFormat:@"%dkm", (int)distanceValue]];
    }
    else
    {
        [self.distanceLabel  setText:[NSString stringWithFormat:@"%.fm", distanceValue*1000]];
    }
    
    [self.starRatingView setScore:model.average_score.floatValue/5.0 withAnimation:NO];

}


- (void)setDisplayInsuranceCarNurseInfo:(CarNurseModel *)model
{
    [self setDisplayCarNurseInfo:model];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.display_mei_bao_price];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.display_mei_bao_original_price];
}
@end
