//
//  CarBrandCell.m
//  优快保
//
//  Created by cts on 15/3/21.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "CarBrandCell.h"
#import "UIImageView+WebCache.h"


@implementation CarBrandCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInfo:(CarBrandModel*)brandModel
{
    _brandNameLabel.text = brandModel.NAME;
    [_brandIcon sd_setImageWithURL:[NSURL URLWithString:brandModel.LOGO]];
}

@end
