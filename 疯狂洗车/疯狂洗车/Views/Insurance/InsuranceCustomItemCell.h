//
//  InsuranceCustomItemCell.h
//  疯狂洗车
//
//  Created by cts on 15/11/19.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsuranceCustomSelectModel.h"


@interface InsuranceCustomItemCell : UITableViewCell
{
    IBOutlet UILabel *_insuranceNameLabel;
    
    IBOutlet UILabel *_insuranceBuyProbabilityLabel;
    
    IBOutlet UILabel *_insuranceSelectValueLabel;
    
    IBOutlet UIImageView *_rightArrowImageView;
}

- (void)setDisplayCustomItemInfo:(InsuranceCustomSelectModel*)model;

@end
