//
//  QuickRescueCell.h
//  优快保
//
//  Created by cts on 15/5/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"



@protocol QuickRescueCellDelegate <NSObject>

- (void)didQuickRescuePhoneButtonTouched;

- (void)didQuickRescueCommentButtonTouched;


@end

@interface QuickRescueCell : UITableViewCell
{
    
    IBOutlet UIButton *_quickRescuePhoneButton;
}

@property (strong, nonatomic) IBOutlet UILabel     *carWashNameLabel;

@property (strong, nonatomic) IBOutlet UIImageView *carWashImageView;

@property (strong, nonatomic) IBOutlet UILabel *carWashAddressLabel;

@property (strong, nonatomic) IBOutlet UILabel *carWashDistanceLabel;

@property (strong, nonatomic) IBOutlet UILabel *carWashTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;

@property (strong, nonatomic) IBOutlet TQStarRatingView *starRatingView;

@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) IBOutlet UIButton *commentButton;

@property (strong, nonatomic) IBOutlet UILabel *openStatusLabel;

@property (assign, nonatomic) id <QuickRescueCellDelegate> delegate;

@end
