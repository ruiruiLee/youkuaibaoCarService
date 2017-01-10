//
//  PresentedTicketsTableViewCell.h
//  疯狂洗车
//
//  Created by LiuZach on 2017/1/7.
//  Copyright © 2017年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTicketCell.h"


@class PresentedTicketsTableViewCell;

@protocol PresentedTicketsTableViewCellDelegate <NSObject>

- (void) notifyItemSelected:(PresentedTicketsTableViewCell *) cell selectedFlag:(BOOL) flag indexPath:(NSIndexPath*)indexPath;

@end

@interface PresentedTicketsTableViewCell : MyTicketCell
{
    IBOutlet UIButton *_btnSelected;
}

@property (nonatomic, assign) id<PresentedTicketsTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (IBAction)doBtnItemSelected:(id)sender;
- (void) setItemSelected:(BOOL) flag;

- (BOOL) getItemSelectedStatus;

@end
