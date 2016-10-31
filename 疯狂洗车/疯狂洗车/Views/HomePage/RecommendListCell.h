//
//  CarWashListCell.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/29.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"
#import "CarNurseModel.h"
#import "OldPriceLabel.h"
#import "TQStarRatingView.h"

@interface RecommendListCell : UITableViewCell
{
    
}
@property (strong, nonatomic) IBOutlet UIImageView  *iconView;

@property (strong, nonatomic) IBOutlet UILabel      *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel      *regonNameLabel;
@property (strong, nonatomic) IBOutlet TQStarRatingView *starRatingView;

@property (strong, nonatomic) IBOutlet UILabel      *distanceLabel;

@property (strong, nonatomic) IBOutlet UILabel      *nowPriceLabel;

@property (strong, nonatomic) IBOutlet OldPriceLabel      *oldPriceLabel;

- (void)setDisplayRecommendInfo:(CarNurseModel*)model;


@end
