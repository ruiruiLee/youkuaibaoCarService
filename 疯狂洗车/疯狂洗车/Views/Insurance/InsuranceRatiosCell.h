//
//  InsuranceRatiosCell.h
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsuranceRatioItemModel.h"

@interface InsuranceRatiosCell : UITableViewCell
{
    
    IBOutlet UILabel *_ratioContentLabel;
}

- (void)setDisplayInsuranceRationItemInfo:(InsuranceRatioItemModel*)model;

@end
