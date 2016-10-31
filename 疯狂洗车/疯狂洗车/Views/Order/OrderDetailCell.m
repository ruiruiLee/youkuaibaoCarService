//
//  OrderServiceCell.m
//  优快保
//
//  Created by cts on 15/5/15.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "OrderDetailCell.h"

@implementation OrderDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInfo:(OrderDetailModel*)model
{
    if ([model.service_mode isEqualToString:@"1"])
    {
        _serviceWayLabel.text = @"到店服务";
    }
    else
    {
        _serviceWayLabel.text = [model.service_addr isEqualToString:@""]?@"":model.service_addr;
    }
    
    _bookTimeLabel.text = [model.service_time isEqualToString:@""]?@"":model.service_time;
    
    _moreRequestLabel.text = model.more_requiry;
}
@end
