//
//  InsuranceMoreInfoCell.m
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "ServiceMoreRequestCell.h"

@implementation ServiceMoreRequestCell

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
        [_cellIconImageView setImage:[UIImage imageNamed:@"img_vipRepair_address"]];
    }
    else if (cellType == 1)
    {
        [_cellIconImageView setImage:[UIImage imageNamed:@"img_vipRepair_time"]];
    }
    else
    {
        [_cellIconImageView setImage:[UIImage imageNamed:@"img_vipRepair_more"]];
    }
}

- (void)setDisplayMoreInfoWithServiceModeRequest:(ServiceModeRequestModel*)serviceModeRequestModel
{
    _cellContentField.placeholder = serviceModeRequestModel.placeHolderText;
    _cellContentField.text = serviceModeRequestModel.valueString == nil?@"":serviceModeRequestModel.valueString;
    
    if (serviceModeRequestModel.modelType == ServiceModeRequestTypeTime)
    {
        [_cellIconImageView setImage:[UIImage imageNamed:@"img_vipRepair_time"]];
    }
    else if (serviceModeRequestModel.modelType == ServiceModeRequestTypeAddress)
    {
        [_cellIconImageView setImage:[UIImage imageNamed:@"img_vipRepair_address"]];
    }
    else
    {
        [_cellIconImageView setImage:[UIImage imageNamed:@"img_carNurse_more"]];
    }
}

@end
