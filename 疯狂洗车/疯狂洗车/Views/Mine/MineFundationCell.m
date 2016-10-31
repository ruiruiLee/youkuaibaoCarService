//
//  MineFundationCell.m
//  疯狂洗车
//
//  Created by cts on 15/12/7.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "MineFundationCell.h"

@implementation MineFundationCell

- (void)awakeFromNib {
    // Initialization code
    
    _messageLabel.layer.masksToBounds = YES;
    _messageLabel.layer.cornerRadius = 17/2.0;
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
