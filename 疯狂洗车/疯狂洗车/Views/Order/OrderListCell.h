//
//  OederListCell.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/29.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OrderListCell : UITableViewCell < UIAlertViewDelegate >
{
    IBOutlet UILabel    *_titleLabel;
    
    IBOutlet UILabel    *_carNoLabel;
    
    IBOutlet UILabel    *_stateLabel;
    
    IBOutlet UILabel    *_timeLabel;
    
    IBOutlet UILabel    *_commentsLabel;
    
    IBOutlet UILabel    *_priceLabel;
    
    IBOutlet UILabel    *_payWayLabel;
}

@property (nonatomic, assign) OrderListModel *info;
@property (strong, nonatomic) IBOutlet UIView *bottomLine;



@end