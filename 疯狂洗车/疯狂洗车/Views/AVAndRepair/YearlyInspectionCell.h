//
//  YearlyInspectionCell.h
//  疯狂洗车
//
//  Created by cts on 15/12/4.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarReviewModel.h"
#import "CarNurseModel.h"


@protocol YearlyInspectionCellDelegate <NSObject>

- (void)didIntroductionButtonTouched;

- (void)didPhoneButtonTouched;


@end

@interface YearlyInspectionCell : UITableViewCell
{
    
    IBOutlet UIImageView *_yearlyInspectionImageView;
}

@property (assign,nonatomic) id <YearlyInspectionCellDelegate> delegate;


- (void)setDisplayInfo:(CarReviewModel*)model;

- (void)setDisplayCarNurseInfo:(CarNurseModel*)model;


@end
