//
//  RechargeTypeCell.h
//  优快保
//
//  Created by cts on 15/3/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeTypeCell : UITableViewCell
{
        
}
@property (strong, nonatomic) IBOutlet UIImageView *selectIcon;

@property (strong, nonatomic) IBOutlet UILabel *payTypeNameLabel;


- (void)setDisplayInfoWithPayType:(NSInteger)typeIndex;

@end
