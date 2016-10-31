//
//  BottomSwipeCell.h
//  优快保
//
//  Created by 朱伟铭 on 15/2/1.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"

@protocol BottomSwipeDelegate <NSObject>

- (void)didOrderButtonTouched:(NSInteger)index shouldOrderTime:(BOOL)isOrderTime;

@end

@interface BottomSwipeCell : UICollectionViewCell
{
    
}
@property (strong, nonatomic) IBOutlet UIButton *leftBtn;
@property (strong, nonatomic) IBOutlet UIButton *rightBtn;
@property (strong, nonatomic) IBOutlet UILabel  *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel  *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel  *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel  *jiaochePriceLabel;
@property (strong, nonatomic) IBOutlet UILabel  *jiaocheOldPrice;
@property (strong, nonatomic) IBOutlet UILabel  *suvPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel  *oldSuvLabel;
@property (strong, nonatomic) IBOutlet UIButton *orderButton;
@property (strong, nonatomic) IBOutlet UIButton *bookButton;
@property (strong, nonatomic) IBOutlet TQStarRatingView *startRatingView;

@property (assign, nonatomic) id <BottomSwipeDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *displayInfoView;
@property (nonatomic) NSInteger  itemIndex;

@end
