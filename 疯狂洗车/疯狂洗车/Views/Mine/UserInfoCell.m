//
//  UserInfoCell.m
//  优快保
//
//  Created by cts on 15/4/3.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "UserInfoCell.h"

@implementation UserInfoCell

- (void)awakeFromNib {
    // Initialization code
    
    _unReadLabel.layer.masksToBounds = YES;
    _unReadLabel.layer.cornerRadius = 8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDisplayUserInfo:(UserInfo*)userInfo withUnreadNumber:(NSInteger)unreadNumber
{
    if (_userInfo.member_id == nil)
    {
        _mobileLabel.hidden = YES;
        _userReminderLabel.text = @"";
        _unLoginLabel.hidden = NO;
        _unReadLabel.hidden = YES;
    }
    else
    {
        if (unreadNumber > 0)
        {
            _unReadLabel.hidden = NO;
            if (unreadNumber > 9)
            {
                _unReadLabelWidthConstraint.constant = 25;
                _unReadLabel.layer.cornerRadius = 8;
                if (unreadNumber > 99)
                {
                    _unReadLabel.text = @"99+";

                }
                else
                {
                    _unReadLabel.text = [NSString stringWithFormat:@"%d",(int)unreadNumber];
                }



            }
            else
            {
                _unReadLabelWidthConstraint.constant = 20;
                _unReadLabel.layer.cornerRadius = 20/2;
                _unReadLabel.text = [NSString stringWithFormat:@"%d",(int)unreadNumber];


            }
        }
        else
        {
            _unReadLabel.hidden = YES;
        }
        _mobileLabel.text = userInfo.member_phone;
        _mobileLabel.hidden = NO;
        _userReminderLabel.text = [NSString stringWithFormat:@"余额: %@",userInfo.account_remainder];
        _unLoginLabel.hidden = YES;
    }
   
}



- (IBAction)didUserCarButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didUserCarButtonTouched)])
    {
        [self.delegate didUserCarButtonTouched];
    }
}

- (IBAction)didMessageButtonTouch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didMessageButtonTouched)])
    {
        [self.delegate didMessageButtonTouched];
    }
}
- (IBAction)didOrderButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didOrderButtonTouched)])
    {
        [self.delegate didOrderButtonTouched];
    }
}

@end
