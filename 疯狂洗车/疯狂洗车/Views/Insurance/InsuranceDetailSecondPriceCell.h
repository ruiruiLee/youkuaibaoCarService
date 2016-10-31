//
//  InsuranceDetailSecondPriceCell.h
//  
//
//  Created by cts on 15/9/15.
//
//

#import <UIKit/UIKit.h>
#import "InsuranceBaseItemModel.h"

@interface InsuranceDetailSecondPriceCell : UITableViewCell
{
    
    IBOutlet UILabel *_senondNameLabel;
    
    IBOutlet UILabel *_secondPriceLabel;
}

- (void)setDisplayInfo:(InsuranceBaseItemModel*)model;

@end
