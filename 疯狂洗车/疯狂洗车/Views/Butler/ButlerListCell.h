//
//  ButlerListCell.h
//  优快保
//
//  Created by cts on 15/6/12.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"
#import "CarNurseModel.h"
#import "OldPriceLabel.h"


@interface ButlerListCell : UITableViewCell
{
    IBOutlet UIImageView *_headImageView;
    
    IBOutlet UILabel *_butlerNameLabel;
    
    IBOutlet UILabel *_distanceLabel;
    
    IBOutlet UILabel *_serviceTimeLabel;
    
    IBOutlet UILabel *_priceLabel;
    
    IBOutlet OldPriceLabel *_oldPriceLabel;
    
    IBOutlet UILabel *_commentCountLabel;
    
    IBOutlet TQStarRatingView *_starRatingView;
}

- (void)setDisplayButlerInfo:(CarNurseModel*)model;

@end
