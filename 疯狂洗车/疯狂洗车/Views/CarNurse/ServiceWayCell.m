//
//  ServiceWayCell.m
//  优快保
//
//  Created by cts on 15/4/7.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "ServiceWayCell.h"

@implementation ServiceWayCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didServiceWayIntroduceButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didServiceWayIntroduceButtonTouched:)])
    {
        [self.delegate didServiceWayIntroduceButtonTouched:self.cellIndex];
    }
}


@end
