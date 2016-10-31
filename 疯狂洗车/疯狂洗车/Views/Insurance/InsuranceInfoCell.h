//
//  InsuranceInfoCell.h
//  优快保
//
//  Created by cts on 15/7/8.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsuranceGroupModel.h"

@protocol InsuranceInfoCellDelegate <NSObject>

- (void)didEditButtonTouched:(NSIndexPath*)indexPath;

@end

@interface InsuranceInfoCell : UITableViewCell
{
    
    IBOutlet UIButton    *_editButton;
    
    IBOutlet UIImageView *_isBoughtImageView;
    
    IBOutlet UILabel  *_carNoLabel;
    
    IBOutlet UILabel  *_customerNameLabel;
    
    IBOutlet UILabel  *_recIDLabel;
    
    IBOutlet UILabel  *_engineIdLabel;
    
    IBOutlet UILabel  *_idCardNoLabel;
    
    IBOutlet UILabel  *_phoneLabel;
    
    IBOutlet UILabel  *_insuranceStatusLabel;
    
    IBOutlet UILabel  *_insuranceIdLabel;
}

- (void)setDisplayInsuranceGroupInfo:(InsuranceGroupModel*)model;


@property (assign, nonatomic) id <InsuranceInfoCellDelegate> delegate;

@property (strong, nonatomic) NSIndexPath *indexPath;
@end
