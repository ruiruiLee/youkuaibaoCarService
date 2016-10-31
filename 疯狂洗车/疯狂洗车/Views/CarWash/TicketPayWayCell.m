//
//  PayWayCell.m
//  优快保
//
//  Created by cts on 15/5/13.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "TicketPayWayCell.h"

@implementation TicketPayWayCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInfoWithName:(NSString*)name withExtraInfo:(NSString*)extraInfo
{
    _payNameLabel.text = name;
}


- (IBAction)didTicketSelectButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didTicketSelectButtonTouched)])
    {
        [self.delegate didTicketSelectButtonTouched];
    }
}

@end
