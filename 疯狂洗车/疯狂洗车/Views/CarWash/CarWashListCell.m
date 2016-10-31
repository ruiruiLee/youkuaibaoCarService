//
//  CarWashListCell.m
//  优快保
//
//  Created by 朱伟铭 on 15/1/29.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CarWashListCell.h"
#import "UIImageView+WebCache.h"

@implementation CarWashListCell

- (void)awakeFromNib {
    // Initialization code
    
    _iconView.layer.borderWidth = 1;
    _iconView.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:0.5].CGColor;
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius  = 7;
    if (SCREEN_WIDTH < 375)
    {
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.regonNameLabel.font = [UIFont systemFontOfSize:12];
        
    }
    else
    {
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        self.regonNameLabel.font = [UIFont systemFontOfSize:13];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayCarWashInfo:(CarWashModel*)model
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
    
    [self.titleLabel setText:model.short_name == nil?model.name:model.short_name];
    [self.regonNameLabel setText:model.address];
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
    [self.commentLabel setText:[NSString stringWithFormat:@"%d人评价",model.evaluation_counts.intValue]];
    [self.nowPriceLabel setText:[NSString stringWithFormat:@"￥%@", model.car_member_price]];
    [self.starRatingView setScore:model.average_score.floatValue/5.0 withAnimation:NO];
    

}

@end
