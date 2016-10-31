//
//  RechargeRecordCell.h
//  优快保
//
//  Created by cts on 15/6/2.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeRecordModel.h"

@interface RechargeRecordCell : UITableViewCell
{
    
    IBOutlet UILabel *_timeLabel;
    
    IBOutlet UIView *_recordInfoView;
    
    IBOutlet UILabel *_rechargeLabel;
    
    IBOutlet UILabel *_rechargeWayLabel;
    
    IBOutlet UILabel *_rechargeStatusLabel;
}

- (void)setDisplayInfo:(RechargeRecordModel*)model;

@end
