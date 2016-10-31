//
//  OrderServiceCell.h
//  优快保
//
//  Created by cts on 15/5/15.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"

@interface OrderServiceCell : UITableViewCell
{
    
    IBOutlet UILabel *_serviceTypeLabel;
    
    IBOutlet UILabel *_orderStatusLabel;
    
    IBOutlet UILabel *_orderPriceLabel;
    
    IBOutlet UILabel *_orderCarLabel;
        
    IBOutlet UILabel *_orderTimeLabel;
    
    IBOutlet UILabel *_payWayLabel;
}


- (void)setDisplayInfo:(OrderDetailModel*)model;

@end
