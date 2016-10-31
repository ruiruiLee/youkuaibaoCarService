//
//  PayWayCell.h
//  优快保
//
//  Created by cts on 15/5/13.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TicketPayWayCellDelegate <NSObject>

- (void)didTicketSelectButtonTouched;

@end

@interface TicketPayWayCell : UITableViewCell
{

}


- (void)setDisplayInfoWithName:(NSString*)name withExtraInfo:(NSString*)extraInfo;

@property (strong, nonatomic) IBOutlet UILabel *payNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *selectIcon;

@property (strong, nonatomic) IBOutlet UILabel *ticketNameLabel;



@property (strong, nonatomic) IBOutlet UILabel *ticketNumberTitle;
@property (strong, nonatomic) IBOutlet UILabel *ticketNumberLabel;

@property (strong, nonatomic) IBOutlet UILabel *ticketPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *ticketTypeLabel;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (assign, nonatomic) id <TicketPayWayCellDelegate> delegate;


@end
