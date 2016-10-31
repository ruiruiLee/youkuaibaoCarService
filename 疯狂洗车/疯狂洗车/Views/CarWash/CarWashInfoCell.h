//
//  CarWashInfoCell.h
//  优快保
//
//  Created by cts on 15/5/13.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarWashModel.h"
#import "TQStarRatingView.h"
#import "OldPriceLabel.h"

@protocol CarWashInfoCellDelegate <NSObject>

- (void)didNaviButtonTouched;

- (void)didPhoneButtonTouched;

- (void)didCommentButtonTouched;

- (void)didCarWashDetailButtonTouched;

@end


@interface CarWashInfoCell : UITableViewCell
{
    IBOutlet UIImageView *_carWashImageView;
        
    IBOutlet UILabel *_nameLabel;
    
    IBOutlet UILabel *_distanceLabel;
    
    IBOutlet UILabel *_addressLabel;
    
    IBOutlet TQStarRatingView *_startRatingView;
    
    IBOutlet UILabel *_sorceLabel;
    
    IBOutlet UIButton *_naviButton;
    
    IBOutlet UIButton *_phoneButton;
    
    IBOutlet UIButton *_commentButton;
    
    IBOutlet UILabel  *_timeLabel;
    
    IBOutlet UILabel *_carPriceLabel;
    
    IBOutlet OldPriceLabel *_carOldPriceLabel;
    
    IBOutlet UILabel *_suvPriceLabel;
    
    IBOutlet OldPriceLabel *_suvOldPriceLabel;
    
    IBOutlet UILabel *_openStatusLabel;
}

- (void)setDisplayInfo:(CarWashModel*)model;

@property (assign, nonatomic) id <CarWashInfoCellDelegate> delegate;

@end
