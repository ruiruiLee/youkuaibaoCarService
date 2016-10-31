//
//  CarWashListCell.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/29.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"
#import "OldPriceLabel.h"
#import "CarNurseModel.h"

@interface CarNurseRescueListCell : UITableViewCell
{
    IBOutlet UILabel *_commentLabel;
}
@property (strong, nonatomic) IBOutlet UIImageView  *iconView;

@property (strong, nonatomic) IBOutlet UILabel      *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel      *regonNameLabel;

@property (strong, nonatomic) IBOutlet UILabel      *distanceLabel;

@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet OldPriceLabel *oldPriceLabel;

@property (strong, nonatomic) IBOutlet TQStarRatingView *starRatingView;

- (void)setDisplayCarNurseInfo:(CarNurseModel*)model;

- (void)setDisplayInsuranceCarNurseInfo:(CarNurseModel *)model;

@end
