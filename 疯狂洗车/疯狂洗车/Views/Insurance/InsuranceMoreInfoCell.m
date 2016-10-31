//
//  InsuranceMoreInfoCell.m
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "InsuranceMoreInfoCell.h"

@implementation InsuranceMoreInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayMoreInfo:(NSString*)conetnt
              withCellType:(NSInteger)cellType
        andPlaceHolderText:(NSString*)placeHolderText
{
    _cellContentField.placeholder = placeHolderText;
    _cellContentField.text = conetnt == nil?@"":conetnt;
    
    if (cellType == 0)
    {
        [_cellIconImageView setImage:[UIImage imageNamed:@"img_carNurse_address"]];
    }
    else if (cellType == 1)
    {
        [_cellIconImageView setImage:[UIImage imageNamed:@"img_carNurse_time"]];
    }
    else
    {
        [_cellIconImageView setImage:[UIImage imageNamed:@"img_carNurse_more"]];
    }
    
}
@end
