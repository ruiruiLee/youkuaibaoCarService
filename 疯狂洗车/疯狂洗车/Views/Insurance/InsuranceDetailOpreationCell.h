//
//  InsuranceDetailOpreationCell.h
//  
//
//  Created by cts on 15/9/15.
//
//

#import <UIKit/UIKit.h>

#import "OldPriceLabel.h"

#import "InsuranceDetailItemModel.h"

@protocol InsuranceDetailOpreationCellDelegate <NSObject>

- (void)didDetailOpreationPhoneButtonTouched;

- (void)didDetailOpreationOrderButtonTouched;

@end

@interface InsuranceDetailOpreationCell : UITableViewCell
{
    IBOutlet UILabel *_totalTitleLabel;
    
    IBOutlet UILabel *_totalPriceLabel;
    
    IBOutlet UILabel *_newPriceLabel;
    
    IBOutlet OldPriceLabel *_oldPriceLabel;
    
    IBOutlet UIView  *_giftView;
    
    IBOutlet UILabel *_giftContentLabel;
}


@property (assign, nonatomic) id <InsuranceDetailOpreationCellDelegate> delegate;


- (void)setDisplayInsuranceInfo:(InsuranceDetailItemModel*)model;

@end
