//
//  BottomCarWashView.h
//  优快保
//
//  Created by cts on 15/3/27.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"
#import "CarNurseModel.h"
#import "OldPriceLabel.h"

@protocol BottomCarNurseDelegate <NSObject>

- (void)didOrderButtonTouched:(NSInteger)index shouldOrderTime:(BOOL)isOrderTime;

- (void)didTapedOnStarRattingView:(NSInteger)index;

@end

@interface BottomCarNurseView : UIView
{
    IBOutlet UILabel *_newPriceLabel;
        
    IBOutlet OldPriceLabel *_oldPriceLabel;
    
    IBOutlet UILabel *_beginTitleLabel;
    
    IBOutlet UILabel *_serviceNameLabel;
    
    IBOutlet UILabel *_titleLabel;
    
    IBOutlet UILabel *_addressLabel;
    
    IBOutlet TQStarRatingView *_startRatingView;
    
    IBOutlet UILabel *_distanceLabel;
}


@property (strong, nonatomic) IBOutlet UIButton *orderButton;

@property (assign, nonatomic) id <BottomCarNurseDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *displayInfoView;
@property (nonatomic) NSInteger  itemIndex;

- (void)setDisplayCarNurseInfo:(CarNurseModel*)model;

- (void)setDisplayInsuranceCarNurseInfo:(CarNurseModel*)model;

@end
