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

@protocol ButlerInfoCellDelegate <NSObject>

- (void)didNaviButtonTouched;

- (void)didPhoneCallButtonTouched;

- (void)didCommentsButtonTouched;



@end

@interface ButlerInfoCell : UITableViewCell
{
    IBOutlet UILabel     *_titleStringLabel;
    IBOutlet UIView      *_circleView1;
    
    IBOutlet UIView      *_circleView2;
    
    IBOutlet UIView      *_circleView3;
    
    IBOutlet UIView      *_circleView4;
    
    IBOutlet UILabel     *_carNurseNameLabel;
    
    IBOutlet UILabel     *_carNurseDecLabel;
    
    IBOutlet UILabel     *_butlerPhoneLabel;
    
    IBOutlet UIButton    *_phonCallButton;
    
    IBOutlet TQStarRatingView *_startRatingView;
    
    IBOutlet UILabel     *_scoreLabel;
    
    IBOutlet UIButton    *_commentsButton;
    
    IBOutlet UIImageView *_carWashImageView;
    
    IBOutlet UILabel     *_carNuresAddressLabel;
    
    IBOutlet UILabel     *_distanceLabel;
    
    IBOutlet UILabel     *_introductionLabel;
    
    IBOutlet UILabel     *_carNurseTimeLabel;
}

- (void)setDisplayCarNurseInfo:(CarNurseModel*)model;


@property (assign, nonatomic) id <ButlerInfoCellDelegate> delegate;
@end
