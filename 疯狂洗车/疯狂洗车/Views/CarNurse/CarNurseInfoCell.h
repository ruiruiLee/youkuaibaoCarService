//
//  CarNurseInfoCell.h
//  优快保
//
//  Created by cts on 15/4/16.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarNurseModel.h"
#import "TQStarRatingView.h"

@protocol CarNurseInfoDelegate <NSObject>

- (void)didNaviButtonTouched;

- (void)didPhoneCallButtonTouched;

- (void)didCommentsButtonTouched;

- (void)didCarWashDetailButtonTouched;



@end

@interface CarNurseInfoCell : UITableViewCell
{
    
    IBOutlet UIImageView *_carNurseImageView;
    
    IBOutlet UILabel     *_carNurseNameLabel;
    
    IBOutlet UILabel     *_carNurseAddressLabel;
    
    IBOutlet UILabel     *_distanceLabel;
    
    IBOutlet UIButton    *_naviButton;
    
    IBOutlet UIButton    *_phonCallButton;
    
    IBOutlet TQStarRatingView *_startRatingView;
    
    IBOutlet UILabel          *_scoreLabel;
    
    IBOutlet UIButton    *_commentsButton;
    
    IBOutlet UILabel     *_businessTimeLabel;
    
    IBOutlet UILabel     *_openStatusLabel;
}

- (void)setDisplayCarNurseInfo:(CarNurseModel*)model;


@property (assign, nonatomic) id <CarNurseInfoDelegate> delegate;
@end
