//
//  MineTicketCell.h
//  优快保
//
//  Created by cts on 15/5/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTicketCell : UITableViewCell
{
    
}
@property (strong, nonatomic) IBOutlet UILabel *ticketNumberLabel  ;

@property (strong, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (strong, nonatomic) IBOutlet UIView *redIconView;

@property (strong, nonatomic) IBOutlet UILabel *lbTitle;

@property (strong, nonatomic) IBOutlet UIImageView *logo;

@end
