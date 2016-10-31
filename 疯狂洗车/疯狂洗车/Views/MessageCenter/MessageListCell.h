//
//  MessageListCell.h
//  优快保
//
//  Created by cts on 15/7/13.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"


@interface MessageListCell : UITableViewCell
{
    
    IBOutlet UILabel *_messageAuthor;
    
    IBOutlet UILabel *_createTimeLabel;
    
    IBOutlet UILabel *_messageContentLabel;
    
    IBOutlet UIView *_unreadPoint;
}

- (void)setDisplayMessageInfo:(MessageModel*)model;

@end
