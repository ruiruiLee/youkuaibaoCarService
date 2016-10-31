//
//  RechargeCell.h
//  优快保
//
//  Created by cts on 15/3/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeActivityCell : UITableViewCell
{
    
    IBOutlet UILabel *_rechargeLabel;
    
}


@property (strong, nonatomic) IBOutlet UIImageView *selectIcon;

- (void)setDisplayInfoWithActivity:(NSString*)activityDesc;

@end
