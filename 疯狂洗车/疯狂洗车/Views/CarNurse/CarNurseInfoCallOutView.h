//
//  CarWashInfoCallOutView.h
//  优快保
//
//  Created by cts on 15/5/4.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarNurseModel.h"
#import "OldPriceLabel.h"
#import "CarWashNameBgView.h"

@interface CarNurseInfoCallOutView : UIView
{
    CarWashNameBgView *_nameBgView;
    UILabel *_carNameLabel;
        
    UILabel *_priceLabel;
    
    UILabel *_supportServiceLabel;
    
    OldPriceLabel *_oldPriceLabel;
}

- (id)initWithFrame:(CGRect)frame
       withClubMode:(BOOL)isClub;

- (void)setDisplayCarWashInfo:(CarNurseModel*)model;

- (void)setDisplayInsuranceCarWashInfo:(CarNurseModel*)model;


@property (assign , nonatomic) BOOL isSelected;

@property (assign , nonatomic) BOOL isClubMode;

@end
