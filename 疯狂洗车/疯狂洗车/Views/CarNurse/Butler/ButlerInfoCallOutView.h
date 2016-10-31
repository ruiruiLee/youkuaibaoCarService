//
//  CarWashInfoCallOutView.h
//  优快保
//
//  Created by cts on 15/5/4.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarNurseModel.h"
#import "OldPriceLabel.h"
#import "CarWashNameBgView.h"
#import "TQStarRatingView.h"

@interface ButlerInfoCallOutView : UIView
{
    CarWashNameBgView *_nameBgView;
    
    UIImageView *_headerImageView;
    UILabel *_carNameLabel;
    
    UILabel *_serviceDesLabel;
}

- (id)initWithFrame:(CGRect)frame
       withClubMode:(BOOL)isClub;

- (void)setDisplayCarWashInfo:(CarNurseModel*)model;


@property (assign , nonatomic) BOOL isSelected;

@property (assign , nonatomic) BOOL isClubMode;


@end
