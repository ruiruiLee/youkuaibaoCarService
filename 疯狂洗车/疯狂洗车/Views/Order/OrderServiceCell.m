//
//  OrderServiceCell.m
//  优快保
//
//  Created by cts on 15/5/15.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "OrderServiceCell.h"

@implementation OrderServiceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayInfo:(OrderDetailModel*)model
{
    
    _orderPriceLabel.text = [NSString stringWithFormat:@"¥%@",model.member_price];

    
    _payWayLabel.text = [Constants getPayWayDescription:model.pay_type];


    if ([model.service_type isEqualToString:@"0"] || model.service_type == nil)
    {
        [_serviceTypeLabel setText:@"洗车服务"];
    }
    else if ([model.service_type isEqualToString:@"1"])
    {
        [_serviceTypeLabel setText:@"保养服务"];
    }
    else if ([model.service_type isEqualToString:@"2"])
    {
        [_serviceTypeLabel setText:@"划痕服务"];
    }
    else if ([model.service_type isEqualToString:@"3"])
    {
        [_serviceTypeLabel setText:@"美容服务"];
    }
    else if ([model.service_type isEqualToString:@"4"])
    {
        [_serviceTypeLabel setText:@"救援服务"];
    }
    else if ([model.service_type isEqualToString:@"5"])
    {
        [_serviceTypeLabel setText:@"车保姆服务"];
    }
    else if ([model.service_type isEqualToString:@"6"])
    {
        [_serviceTypeLabel setText:@"速援服务"];
    }
    else if ([model.service_type isEqualToString:@"7"])
    {
        [_serviceTypeLabel setText:@"理赔送修"];
    }
    else if ([model.service_type isEqualToString:@"8"])
    {
        [_serviceTypeLabel setText:@"年检代办"];
    }
    else
    {
        [_serviceTypeLabel setText:@"其他服务"];
    }
    
    [_orderTimeLabel setText:model.create_time];
    
    if (model.car_no == nil || [model.car_no isEqualToString:@""])
    {
        [_orderCarLabel setText:[NSString stringWithFormat:@"[%@] ",[model.car_type isEqualToString:@"1"] ? @"轿车" : @"SUV"]];
    }
    else
    {
        [_orderCarLabel setText:[NSString stringWithFormat:@"[%@] %@·%@ %@",
                                 [model.car_type isEqualToString:@"1"] ? @"轿车" : @"SUV" ,
                                 [model.car_no substringWithRange:NSMakeRange(0, 2)],
                                 [model.car_no substringWithRange:NSMakeRange(2, model.car_no.length-2)],
                                 model.car_xilie == nil?@"":model.car_xilie
                                 ]];
    }
    
    
    
    if ([model.pay_type isEqualToString:@"4"])
    {
        if (model.paid_status.intValue > 0)
        {
            if ([model.order_state isEqualToString:@"2"])
            {
                [_orderStatusLabel setText:@"交易完成"];

            }
            else
            {
                [_orderStatusLabel setText:@"交易完成"];
            }
            if (![model.evaluation_id isEqualToString:@""])
            {
                [_orderStatusLabel setText:@"交易完成"];
            }
            else
            {
                [_orderStatusLabel setText:@"交易完成"];
            }
        }
        else
        {
            if ([model.order_state isEqualToString:@"-1"])
            {
                [_orderStatusLabel setText:@"等待审核"];
            }
            else if ([model.order_state isEqualToString:@"-2"])
            {
                [_orderStatusLabel setText:@"取消成功"];
                
            }
            else
            {
                [_orderStatusLabel setText:@"未支付"];
            }
        }
    }
    else if ([model.order_state isEqualToString:@"2"])
    {
        [_orderStatusLabel setText:@"交易完成"];
        if (![model.evaluation_id isEqualToString:@""])
        {
            [_orderStatusLabel setText:@"交易完成"];
        }
        else
        {
            [_orderStatusLabel setText:@"交易完成"];
        }
    }
    else if ([model.order_state isEqualToString:@"1"])
    {
        [_orderStatusLabel setText:@"交易完成"];
    }
    else if ([model.order_state isEqualToString:@"0"])
    {
        [_orderStatusLabel setText:@"已支付"];
        
    }
    else if ([model.order_state isEqualToString:@"-1"])
    {
        [_orderStatusLabel setText:@"等待审核"];
        
    }
    else
    {
        [_orderStatusLabel setText:[NSString stringWithFormat:@"已退单"]];
    }
}
@end
