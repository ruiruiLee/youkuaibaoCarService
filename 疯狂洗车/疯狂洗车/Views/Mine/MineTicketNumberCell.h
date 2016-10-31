//
//  MineTicketNumberCell.h
//  优快保
//
//  Created by cts on 15/5/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTicketNumberCell : UITableViewCell
{
    
    IBOutlet UIImageView *_ticketImageView;
    
    IBOutlet UILabel     *_ticketNameLabel;
    
    IBOutlet UILabel     *_ticketNumberLabel;
    
    
    
}

- (void)setDisplayInfoWithTicketType:(NSInteger)ticketType
                     andTicketNumber:(int)ticketNumber;

@end
