//
//  PayWayCell.m
//  优快保
//
//  Created by cts on 15/5/13.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "PayWayCell.h"

@implementation PayWayCell

- (void)awakeFromNib
{
    // Initialization code
    _yueLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInfoWithName:(NSString*)name withExtraInfo:(NSString*)extraInfo
{
    _payNameLabel.text = name;
    
    if (extraInfo == nil)
    {
        _yueLabel.hidden = YES;
        _yueTitle.hidden = YES;
    }
    else
    {
        _yueLabel.hidden = NO;
        _yueTitle.hidden = NO;
        _yueLabel.text = [NSString stringWithFormat:@"%.2f",extraInfo.floatValue];
        
    }
}



@end
