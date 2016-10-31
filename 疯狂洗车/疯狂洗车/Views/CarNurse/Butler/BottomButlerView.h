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
#import "UIImageView+WebCache.h"
#import "OldPriceLabel.h"

@protocol BottomButlerDelegate <NSObject>

- (void)didOrderButtonTouched:(NSInteger)index shouldOrderTime:(BOOL)isOrderTime;

- (void)didTapedOnStarRattingView:(NSInteger)index;

@end

@interface BottomButlerView : UIView
{
    IBOutlet UILabel *_newPriceLabel;
    
    IBOutlet OldPriceLabel *_oldPriceLabel;
    
    IBOutlet UILabel *_serviceNameLabel;
    
    IBOutlet UILabel *_titleLabel;
    
    IBOutlet UILabel *_addressLabel;
    
    IBOutlet TQStarRatingView *_startRatingView;
    
    IBOutlet UILabel *_distanceLabel;
    
    IBOutlet UIImageView *_headerImageView;
    
}


@property (strong, nonatomic) IBOutlet UIButton *orderButton;

@property (assign, nonatomic) id <BottomButlerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *displayInfoView;
@property (nonatomic) NSInteger  itemIndex;

- (void)setDisplayCarNurseInfo:(CarNurseModel*)model;

@end
