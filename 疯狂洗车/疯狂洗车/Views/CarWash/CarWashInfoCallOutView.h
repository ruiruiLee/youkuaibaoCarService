//
//  CarWashInfoCallOutView.h
//  优快保
//
//  Created by cts on 15/5/4.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarWashModel.h"
#import "OldPriceLabel.h"
#import "CarWashNameBgView.h"

@interface CarWashInfoCallOutView : UIView
{
    CarWashNameBgView *_nameBgView;
    UILabel *_carNameLabel;
        
    UILabel *_priceLabel;
    
    OldPriceLabel *_oldPriceLabel;
}

- (id)initWithFrame:(CGRect)frame
       withClubMode:(BOOL)isClub;

- (void)setDisplayCarWashInfo:(CarWashModel*)model;


@property (assign , nonatomic) BOOL isSelected;

@property (assign , nonatomic) BOOL isClubMode;


@end
