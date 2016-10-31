//
//  MyTicketCell.h
//  优快保
//
//  Created by cts on 15/5/21.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TicketModel.h"

@interface MyTicketCell : UITableViewCell
{
    IBOutlet UIView      *_ticketView;
    
    IBOutlet UILabel     *_componyNameLabel;
    
    IBOutlet UILabel     *_ticketNameLabel;
    
    IBOutlet UILabel     *_priceTitleLabel;
    IBOutlet UILabel     *_ticketPriceLabel;
    
    IBOutlet UILabel     *_ticketTimeTitle;
    IBOutlet UILabel     *_ticketTimeLabel;
    
    IBOutlet UILabel     *_ticketEndTimeLabel;
    IBOutlet UIView      *_ticketInfoView;
    
    IBOutlet UILabel     *_payFlagLabel;
    
    IBOutlet UIImageView *_ticketAbilitySoonIcon;
    
    IBOutlet UIImageView *_ticketStatusImageView;
}

- (void)setDisplayInfo:(TicketModel*)model;

@end
