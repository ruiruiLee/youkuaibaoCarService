//
//  PayWayCell.h
//  优快保
//
//  Created by cts on 15/5/13.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PayWayCell : UITableViewCell
{
            
    IBOutlet UILabel  *_yueLabel;
    IBOutlet UILabel  *_yueTitle;
}


- (void)setDisplayInfoWithName:(NSString*)name withExtraInfo:(NSString*)extraInfo;

@property (strong, nonatomic) IBOutlet UILabel *payNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *selectIcon;

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) IBOutlet UIView *bottomSepView;


@end
