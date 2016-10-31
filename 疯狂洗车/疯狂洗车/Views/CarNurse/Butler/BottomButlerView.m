//
//  BottomCarWashView.m
//  优快保
//
//  Created by cts on 15/3/27.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BottomButlerView.h"

@implementation BottomButlerView

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    _orderButton.layer.masksToBounds = YES;
    _orderButton.layer.cornerRadius = 5;

    
    
    //添加四个边阴影
    
    _displayInfoView.layer.masksToBounds = NO;
    _displayInfoView.layer.cornerRadius = 5;
    
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.layer.cornerRadius = 75.0/2.0;
    _headerImageView.layer.borderWidth = 3;
    _headerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
}

- (IBAction)didOrderButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didOrderButtonTouched:shouldOrderTime:)])
    {
        [self.delegate didOrderButtonTouched:self.itemIndex shouldOrderTime:NO];
    }
}

- (void)setDisplayCarNurseInfo:(CarNurseModel*)model
{
    
    [_titleLabel setText:model.short_name];
    [_addressLabel setText:model.address];
    
    double distanceValue = model.distance.doubleValue;
    if (distanceValue >= 100)
    {
        _distanceLabel.adjustsFontSizeToFitWidth = YES;
        
        [_distanceLabel  setText:@"大于100km"];
    }
    else if (distanceValue >= 1)
    {
        [_distanceLabel setText:[NSString stringWithFormat:@"%.1fkm", distanceValue]];
    }
    else
    {
        [_distanceLabel  setText:[NSString stringWithFormat:@"%.fm", distanceValue*1000]];
    }
    _serviceNameLabel.text = model.service_types;
    [_newPriceLabel setText:[NSString stringWithFormat:@"￥%@", model.member_price]];
    [_oldPriceLabel setText:[NSString stringWithFormat:@"￥%@", model.original_price]];
    [_startRatingView setScore:model.average_score.floatValue/5.0 withAnimation:NO];
    
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:model.logo]
                        placeholderImage:[UIImage imageNamed:@"img_default_logo"]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if (error == nil)
         {
             [_headerImageView setImage:[Constants imageByScalingAndCroppingForSize:_headerImageView.frame.size withTarget:image]];
         }
     }];
}

- (IBAction)didTapOnStarRattingView
{
    if ([self.delegate respondsToSelector:@selector(didTapedOnStarRattingView:)])
    {
        [self.delegate didTapedOnStarRattingView:self.itemIndex];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
