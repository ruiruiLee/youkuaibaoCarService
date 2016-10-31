//
//  LeftMenuCell.m
//  优快保
//
//  Created by cts on 15/3/31.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "LeftMenuCell.h"

@implementation LeftMenuCell

- (void)awakeFromNib
{
    // Initialization code
    _messageLabel.layer.masksToBounds = YES;
    _messageLabel.layer.cornerRadius = 19/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showMessageCount:(int)count
{
    if (count > 0)
    {
        _messageLabel.hidden = NO;
        
        _messageLabel.text = [NSString stringWithFormat:@"%d",count];
    }
    else
    {
        _messageLabel.hidden = YES;
    }
}

@end
