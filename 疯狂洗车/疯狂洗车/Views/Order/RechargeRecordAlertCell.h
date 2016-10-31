//
//  RechargeRecordAlertCell.h
//  优快保
//
//  Created by cts on 15/6/2.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RechargeRecordAlertCellDelegate <NSObject>

- (void)didCloseRechargeRecordAlertTouched;

@end

@interface RechargeRecordAlertCell : UITableViewCell
{
    
    IBOutlet UILabel *_alertLabel;
}


@property (assign, nonatomic) id <RechargeRecordAlertCellDelegate> delegate;

@end
