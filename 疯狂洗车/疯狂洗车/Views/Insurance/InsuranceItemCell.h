//
//  InsuranceItemCell.h
//  优快保
//
//  Created by cts on 15/7/8.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceHelper.h"
#import "UIImageView+WebCache.h"
#import "InsuranceInfoModel.h"

@protocol InsuranceItemCellDelegate <NSObject>

- (void)didOpreationButtonTouched:(NSIndexPath*)indexPath;

- (void)didPhoneCallButtonTouched:(NSIndexPath*)indexPath;


@end

@interface InsuranceItemCell : UITableViewCell
{
    
    IBOutlet UIImageView *_insuranceComImageView;
    
    IBOutlet UILabel     *_insuranceNameLabel;
    
    IBOutlet UILabel     *_insuranceStatusLabel;
    
    IBOutlet UILabel     *_insuranceContentLabel;
    
    IBOutlet UILabel     *_insruanceRationLabel;
    
    IBOutlet UILabel     *_presentLabel;
    
    IBOutlet UIButton    *_opreationButton;
    
    IBOutlet UIButton    *_phoneCallButton;
}

- (void)setDisplayInsuranceInfo:(InsuranceInfoModel*)model;

@property (assign, nonatomic) id <InsuranceItemCellDelegate> delegate;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (strong, nonatomic) IBOutlet UIView *bottomCornerView;

@property (strong, nonatomic) IBOutlet UIView *bottomCubeView;

@end
