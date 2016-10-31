//
//  MessageContentDetailViewController.h
//  优快保
//
//  Created by cts on 15/7/14.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageModel.h"

//消息中心的消息的详细内容显示
@interface MessageContentDetailViewController : BaseViewController
{
    IBOutlet UILabel *_messageAuthor;
    
    IBOutlet UILabel *_createTimeLabel;
    
    IBOutlet UILabel *_messageContentLabel;

}

@property (strong, nonatomic) MessageModel *model;

@end
