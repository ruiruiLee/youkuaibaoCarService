//
//  MyCarCell.m
//  优快保
//
//  Created by cts on 15/3/20.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "MyCarDetailCell.h"

@implementation MyCarDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInfo:(CarInfos*)carsModel
{
    NSString *carTitle = [NSString stringWithFormat:@"[%@] %@·%@",[carsModel.car_type isEqualToString:@"1"]?@"轿车" : @"SUV",[carsModel.car_no substringWithRange:NSMakeRange(0, 2)],[carsModel.car_no substringWithRange:NSMakeRange(2, carsModel.car_no.length-2)]];
    NSString *carBrandTitle = [NSString stringWithFormat:@"%@ %@",carsModel.car_brand == nil ?@"无品牌信息":carsModel.car_brand,carsModel.car_xilie == nil?@"":carsModel.car_xilie ];

    _carDetailLabel.text = carTitle;
    
    _carBrandLabel.text = carBrandTitle;

}


- (IBAction)didMyCarSelectButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didMyCarButtonSelectButtonTouched:)])
    {
        [self.delegate didMyCarButtonSelectButtonTouched:self.indexPath];
    }
}


@end
