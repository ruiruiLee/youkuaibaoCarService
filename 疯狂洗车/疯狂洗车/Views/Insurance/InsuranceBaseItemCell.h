//
//  InsuranceBaseItemCell.h
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsuranceBaseItemModel.h"

@interface InsuranceBaseItemCell : UITableViewCell
{
    
    IBOutlet UILabel *_insuranceTitleName;
    
    IBOutlet UILabel *_insurancePriceLabel;
}

- (void)setDisplayInsuranceBaseItemInfo:(InsuranceBaseItemModel*)model;
@end
