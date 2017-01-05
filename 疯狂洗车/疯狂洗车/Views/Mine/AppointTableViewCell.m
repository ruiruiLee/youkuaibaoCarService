//
//  AppointTableViewCell.m
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/13.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "AppointTableViewCell.h"

@implementation AppointTableViewCell
@synthesize btnPay;
@synthesize btnCancel;
@synthesize lbCarNo;
@synthesize lbServiceAdd;
@synthesize lbServiceName;
@synthesize lbServiceTime;
@synthesize lbServiceType;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    btnCancel.layer.borderColor = kClubLightGrayColor.CGColor;
    btnCancel.layer.borderWidth = 1;
    btnCancel.layer.cornerRadius = 4;
    
    btnPay.layer.cornerRadius = 4;
    
    self.logo.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didAppointCanceledButtonTouched{
    
    if ([self.delegate respondsToSelector:@selector(didAppointCanceledButtonTouched:)])
    {
        [self.delegate didAppointCanceledButtonTouched:self.indexPathRow];
    }
}

- (IBAction)didAppointPayButtonTouched:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didAppointPayButtonTouched:)])
    {
        [self.delegate didAppointPayButtonTouched:self.indexPathRow];
    }
}


@end
