//
//  InsuranceDetailOthersCell.h
//  
//
//  Created by cts on 15/9/15.
//
//

#import <UIKit/UIKit.h>
#import "InsuranceDetailOthersItemModel.h"

@interface InsuranceDetailOthersCell : UITableViewCell
{
    IBOutlet UILabel *_othersTitleLabel;
    
    IBOutlet UILabel *_othersContentLabel;
    
    IBOutlet UILabel *_othersDescLabel;
}

- (void)setDisplayInsuranceInfo:(InsuranceDetailOthersItemModel*)model;

@end
