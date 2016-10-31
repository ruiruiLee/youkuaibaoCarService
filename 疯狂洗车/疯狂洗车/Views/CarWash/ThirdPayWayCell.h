//
//  PayWayCell.h
//  优快保
//
//  Created by cts on 15/5/13.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ThirdPayWayCell : UITableViewCell
{

    IBOutlet UIImageView *_thirdPayImageView;
}


- (void)setDisplayInfoWithName:(NSString*)name withThirdType:(NSInteger)type;

@property (strong, nonatomic) IBOutlet UILabel *payNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *selectIcon;

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) IBOutlet UIView *bottomSepView;


@end
