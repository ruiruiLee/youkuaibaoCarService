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
#import "CarWashModel.h"

@interface CarWashListCell : UITableViewCell
{
    
}
@property (strong, nonatomic) IBOutlet UIImageView  *iconView;
@property (strong, nonatomic) IBOutlet UILabel      *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel      *commentLabel;
@property (strong, nonatomic) IBOutlet UILabel      *regonNameLabel;
@property (strong, nonatomic) IBOutlet UILabel      *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel      *nowPriceLabel;

@property (strong, nonatomic) IBOutlet TQStarRatingView *starRatingView;

- (void)setDisplayCarWashInfo:(CarWashModel*)model;


@end
