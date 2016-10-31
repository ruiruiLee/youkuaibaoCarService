//
//  LeftMenuCell.h
//  优快保
//
//  Created by cts on 15/3/31.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuCell : UITableViewCell
{
    
    IBOutlet UILabel *_messageLabel;
    
}

@property (strong, nonatomic) IBOutlet UIImageView *menuIcon;

@property (strong, nonatomic) IBOutlet UILabel *menuTitle;

@property (strong, nonatomic) IBOutlet UIView *bottomSepView;

@property (strong, nonatomic) IBOutlet UIView *topBorderView;

@property (strong, nonatomic) IBOutlet UIView *bottomBorderView;

@property (strong, nonatomic) IBOutlet UILabel *rightTitleLabel;
- (void)showMessageCount:(int)count;
@end
