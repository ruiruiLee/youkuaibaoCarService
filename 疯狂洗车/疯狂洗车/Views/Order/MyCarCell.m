//
//  MyCarCell.m
//  优快保
//
//  Created by cts on 15/3/20.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "MyCarCell.h"

@implementation MyCarCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInfo:(NSString*)title
           andNewPrice:(NSString*)newPriceString
           andOldPrice:(NSString*)oldPriceString
{
    _carTypeLabel.text = title;
    _newPriceLabel.text = [NSString stringWithFormat:@"￥%@",newPriceString];
    _oldPriceLabel.text = [NSString stringWithFormat:@"￥%@",oldPriceString];
}

- (IBAction)didMyCarSelectButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didMyCarButtonSelectButtonTouched:)])
    {
        [self.delegate didMyCarButtonSelectButtonTouched:self.indexPath];
    }
}


@end
