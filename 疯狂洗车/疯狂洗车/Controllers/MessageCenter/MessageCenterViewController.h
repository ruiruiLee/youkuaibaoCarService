//
//  MessageCenterViewController.h
//  优快保
//
//  Created by cts on 15/7/13.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageModel.h"

//消息中心列表
@interface MessageCenterViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray       *_messageArray;//消息中心数据列表
    
    IBOutlet UITableView *_messageListTableView;
    
    IBOutlet UIImageView *_emptyImageView;
}

@end
