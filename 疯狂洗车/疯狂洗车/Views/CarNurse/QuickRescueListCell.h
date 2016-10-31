//
//  QuickRescueListCell.h
//  疯狂洗车
//
//  Created by cts on 15/12/8.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "OldPriceLabel.h"
#import "CarNurseModel.h"



@interface QuickRescueListCell : UITableViewCell
{
    IBOutlet UIImageView *_carNurseImageView;
    
    IBOutlet UILabel *_titleLabel;
    
    IBOutlet UILabel *_addressLabel;
    
    IBOutlet UILabel *_priceLabel;
    
    IBOutlet OldPriceLabel *_oldPriceLabel;
    
    IBOutlet UILabel *_distanceLabel;
    
    IBOutlet UILabel *_commentLabel;
    
    IBOutlet UIView *_labelDisplayView;
    
    IBOutlet NSLayoutConstraint *_labelDisplayViewWidthConstraint;
    
    IBOutlet UILabel *_moreLabelItem;
    
    int              _maxLableItemCount;
    
    int              _LableItemPadding;

}

- (void)setDisplayInfo:(CarNurseModel*)model;

@end
