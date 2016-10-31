//
//  UserInfoCell.h
//  优快保
//
//  Created by cts on 15/4/3.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserInfoCellDelegate <NSObject>


- (void)didUserCarButtonTouched;

- (void)didMessageButtonTouched;

- (void)didOrderButtonTouched;



@end

@interface UserInfoCell : UITableViewCell
{
    
    IBOutlet UILabel  *_mobileLabel;
    
    IBOutlet UILabel  *_userReminderLabel;
    
    IBOutlet UILabel  *_unLoginLabel;
    
    IBOutlet UILabel  *_unReadLabel;
    
    IBOutlet NSLayoutConstraint *_unReadLabelWidthConstraint;
}

@property (assign, nonatomic) id <UserInfoCellDelegate> delegate;

- (void)setDisplayUserInfo:(UserInfo*)userInfo withUnreadNumber:(NSInteger)unreadNumber;
@end
