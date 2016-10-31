//
//  RechargeCell.m
//  优快保
//
//  Created by cts on 15/3/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "RechargeActivityCell.h"

@implementation RechargeActivityCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInfoWithActivity:(NSString*)activityDesc
{
    _rechargeLabel.text = activityDesc;

}

@end
