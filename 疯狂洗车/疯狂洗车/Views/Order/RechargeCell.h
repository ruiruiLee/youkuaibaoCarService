//
//  RechargeCell.h
//  优快保
//
//  Created by cts on 15/3/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeCell : UITableViewCell
{
    
    IBOutlet UILabel *_rechargeLabel;
    
    IBOutlet UILabel *_rechargeSendLabel;
}


@property (strong, nonatomic) IBOutlet UIImageView *selectIcon;

- (void)setDisplayInfoWithRechargeValue:(NSString*)rechargeValue
                           andSendValue:(NSString*)giftValue;

@end
