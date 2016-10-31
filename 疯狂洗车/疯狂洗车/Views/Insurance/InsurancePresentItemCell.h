//
//  InsuranceBaseItemCell.h
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsurancePresentItemModel.h"

@interface InsurancePresentItemCell : UITableViewCell
{
    
    IBOutlet UILabel *_insuranceTitleName;
    
    IBOutlet UILabel *_insurancePriceLabel;
}

- (void)setDisplayInsurancePresentItemModel:(InsurancePresentItemModel*)model;

@end
