//
//  OrderRealPayInfoCell.h
//  疯狂洗车
//
//  Created by cts on 15/12/22.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderRealPayInfoCell : UITableViewCell
{
    
    IBOutlet UILabel *_priceLabel;
    
    IBOutlet UILabel *_ticketPriceLabel;
    
    IBOutlet UILabel *_remainderPriceLabel;
    
    IBOutlet UILabel *_payPriceLabel;
}

- (void)setUpDisplayPayInfoPrice:(float)priceValue
                  andTicketPrice:(float)ticketValue
               andRemainderPrice:(float)remainderValue
                     andPayPrice:(float)payValue;


@end
