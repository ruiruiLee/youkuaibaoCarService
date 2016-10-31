//
//  OederListCell.m
//  优快保
//
//  Created by 朱伟铭 on 15/1/29.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "OrderListCell.h"

@implementation OrderListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInfo:(OrderListModel *)info
{
    _info = info;
    [_titleLabel setText:info.car_wash_name];
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",info.member_price];
    
    
    _payWayLabel.text = [Constants getPayWayDescription:info.pay_type];
    
    if ([info.service_type isEqualToString:@"0"] || info.service_type == nil)
    {
        [_commentsLabel setText:@"洗车服务"];
    }
    else if ([info.service_type isEqualToString:@"1"])
    {
        [_commentsLabel setText:@"保养服务"];
    }
    else if ([info.service_type isEqualToString:@"2"])
    {
        [_commentsLabel setText:@"划痕服务"];
    }
    else if ([info.service_type isEqualToString:@"3"])
    {
        [_commentsLabel setText:@"美容服务"];
    }
    else if ([info.service_type isEqualToString:@"4"])
    {
        [_commentsLabel setText:@"救援服务"];
    }
    else if ([info.service_type isEqualToString:@"5"])
    {
        [_commentsLabel setText:@"车保姆服务"];
    }
    else if ([info.service_type isEqualToString:@"6"])
    {
        [_commentsLabel setText:@"速援服务"];
    }
    else if ([info.service_type isEqualToString:@"7"])
    {
        [_commentsLabel setText:@"理赔送修"];
    }
    else if ([info.service_type isEqualToString:@"8"])
    {
        [_commentsLabel setText:@"年检代办"];
    }
    else
    {
        [_commentsLabel setText:@"其他"];
    }

    [_timeLabel setText:_info.create_time];
    
    if (_info.car_no == nil || [_info.car_no isEqualToString:@""])
    {
        [_carNoLabel setText:[NSString stringWithFormat:@"[%@] ",[_info.car_type isEqualToString:@"1"] ? @"轿车" : @"SUV"]];
    }
    else
    {
        [_carNoLabel setText:[NSString stringWithFormat:@"[%@] %@·%@",[_info.car_type isEqualToString:@"1"] ? @"轿车" : @"SUV",[_info.car_no substringWithRange:NSMakeRange(0, 2)],[_info.car_no substringWithRange:NSMakeRange(2, _info.car_no.length-2)] ]];
    }
    
    
    
    if ([info.pay_type isEqualToString:@"4"])
    {
        if (info.paid_status.intValue > 0)
        {
            if ([info.order_state isEqualToString:@"1"])
            {
                [_stateLabel setText:@"交易完成"];

            }
            else
            {
                [_stateLabel setText:@"已支付"];

            }
        }
        else
        {
            if ([info.order_state isEqualToString:@"-1"])
            {
                [_stateLabel setText:@"等待审核"];
            }
            else if ([info.order_state isEqualToString:@"-2"])
            {
                [_stateLabel setText:@"已退单"];
                
            }
            else
            {
                [_stateLabel setText:@"未支付"];

            }
        }
    }
    else if ([info.order_state isEqualToString:@"1"])
    {
        [_stateLabel setText:@"交易完成"];
    }
    else if ([info.order_state isEqualToString:@"0"])
    {
        [_stateLabel setText:@"已支付"];

    }
    else if ([info.order_state isEqualToString:@"-1"])
    {
        [_stateLabel setText:@"等待审核"];

    }
    else
    {   
        [_stateLabel setText:[NSString stringWithFormat:@"已退单"]];
    }
}




@end
