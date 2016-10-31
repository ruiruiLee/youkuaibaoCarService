//
//  OrderCarWashCell.m
//  优快保
//
//  Created by cts on 15/5/15.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "OrderCarWashCell.h"
#import "UIImageView+WebCache.h"


@implementation OrderCarWashCell

- (void)awakeFromNib {
    // Initialization code
    if (SCREEN_WIDTH < 375)
    {
        _carWashNameLabel.font = [UIFont systemFontOfSize:14];
        
        _carWashTimeLabel.font = [UIFont systemFontOfSize:12];
    }
    else
    {
        _carWashNameLabel.font = [UIFont systemFontOfSize:18];
        
        _carWashTimeLabel.font = [UIFont systemFontOfSize:16];
    }
    
    _carWashImageView.layer.borderWidth = 1;
    _carWashImageView.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:0.5].CGColor;
    _carWashImageView.layer.masksToBounds = YES;
    _carWashImageView.layer.cornerRadius = 5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInfo:(OrderDetailModel *)model
{
    
    [_carWashImageView sd_setImageWithURL:[NSURL URLWithString:model.logo]
                         placeholderImage:[UIImage imageNamed:@"img_default_logo"]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if (error == nil)
         {
             [_carWashImageView setImage:[Constants imageByScalingAndCroppingForSize:CGSizeMake(85, 85)
                                                                          withTarget:image]];
         }
     }];
    
    _carWashNameLabel.text = model.car_wash_name;
    _carWashAddressLabel.text = model.car_wash_address;
    
    

    if (model.business_hours_from == nil ||model.business_hours_to == nil ||[model.business_hours_from isEqualToString:@""] ||[model.business_hours_to isEqualToString:@""])
    {
        _carWashTimeLabel.text = @"营业时间：9:30~17:30";
    }
    else
    {
        [_carWashTimeLabel setText:[NSString stringWithFormat:@"营业时间：%@~%@",model.business_hours_from,model.business_hours_to]];
    }

}

@end
