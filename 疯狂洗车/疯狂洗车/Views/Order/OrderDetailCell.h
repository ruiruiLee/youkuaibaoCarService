//
//  OrderServiceCell.h
//  优快保
//
//  Created by cts on 15/5/15.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"

@interface OrderDetailCell : UITableViewCell
{
    
    IBOutlet UILabel *_bookTimeLabel;
            
    IBOutlet UILabel *_serviceWayLabel;
    
    IBOutlet UILabel *_moreRequestLabel;
}


- (void)setDisplayInfo:(OrderDetailModel*)model;

@end
