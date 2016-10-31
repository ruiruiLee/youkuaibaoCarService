//
//  InsuranceBaseItemCell.h
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsurancePayInfoModel.h"

@interface InsuranceAgentCell : UITableViewCell
{
    
    IBOutlet UILabel *_insuranceTitleName;
    
    IBOutlet UILabel *_insurancePriceLabel;
}

- (void)setDisplayInsurancePresentItemModel:(InsurancePayInfoModel*)model withIndex:(NSInteger)index;

@end
