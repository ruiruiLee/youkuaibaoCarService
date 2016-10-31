//
//  OrderRealPayInfoCell.m
//  疯狂洗车
//
//  Created by cts on 15/12/22.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "OrderRealPayInfoCell.h"

@implementation OrderRealPayInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpDisplayPayInfoPrice:(float)priceValue
                  andTicketPrice:(float)ticketValue
               andRemainderPrice:(float)remainderValue
                     andPayPrice:(float)payValue
{
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",priceValue];
    _ticketPriceLabel.text = [NSString stringWithFormat:@"-%.2f",ticketValue];
    _remainderPriceLabel.text = [NSString stringWithFormat:@"-%.2f",remainderValue];
    _payPriceLabel.text = [NSString stringWithFormat:@"¥%.2f",payValue];
}

@end
