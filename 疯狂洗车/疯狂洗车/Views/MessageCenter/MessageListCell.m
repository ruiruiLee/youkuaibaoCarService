//
//  MessageListCell.m
//  优快保
//
//  Created by cts on 15/7/13.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "MessageListCell.h"

@implementation MessageListCell

- (void)awakeFromNib {
    // Initialization code
    
    _unreadPoint.layer.masksToBounds = YES;
    _unreadPoint.layer.cornerRadius = 9/2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayMessageInfo:(MessageModel*)model
{
    if ([model.msg_type isEqualToString:@"0"])
    {
        _messageAuthor.text   = [NSString stringWithFormat:@"系统消息："];
    }
    else
    {
        _messageAuthor.text   = [NSString stringWithFormat:@"%@：",model.msg_type];
    }
    
    if ([model.is_read isEqualToString:@"0"])
    {
        _unreadPoint.hidden = NO;
    }
    else
    {
        _unreadPoint.hidden = YES;
    }
    
    _createTimeLabel.text = model.create_time;
    
    _messageContentLabel.text = model.msg_content;
}

@end
