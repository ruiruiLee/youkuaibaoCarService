//
//  AddCarsCell.m
//  优快保
//
//  Created by 朱伟铭 on 15/1/29.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "AddCarsCell.h"

@implementation AddCarsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)didAddButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didAddCarButtonTouched)])
    {
        [self.delegate didAddCarButtonTouched];
    }
}

@end
