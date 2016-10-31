//
//  MineTicketCell.m
//  优快保
//
//  Created by cts on 15/5/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "MineTicketCell.h"

@implementation MineTicketCell

- (void)awakeFromNib
{
    // Initialization code
    
    self.redIconView.layer.masksToBounds = YES;
    self.redIconView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
