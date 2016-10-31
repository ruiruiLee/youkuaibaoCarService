//
//  OrderCarWashCell.h
//  优快保
//
//  Created by cts on 15/5/15.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailModel.h"

@interface OrderCarWashCell : UITableViewCell
{
    
    IBOutlet UILabel *_carWashNameLabel;
    
    IBOutlet UILabel *_carWashAddressLabel;

    IBOutlet UIImageView *_carWashImageView;

    IBOutlet UILabel *_carWashTimeLabel;
}

- (void)setDisplayInfo:(OrderDetailModel*)model;

@end
