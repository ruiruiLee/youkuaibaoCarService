//
//  InsuranceDetailBasePriceCell.h
//  
//
//  Created by cts on 15/9/15.
//
//

#import <UIKit/UIKit.h>

#import "InsuranceBaseItemModel.h"

@interface InsuranceDetailBasePriceCell : UITableViewCell
{
    
    IBOutlet UILabel *_infoNameLabel;
    
    IBOutlet UILabel *_priceLabel;
}

- (void)setDisplayInfo:(InsuranceBaseItemModel*)model;

@end
