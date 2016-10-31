//
//  InsuranceOrderConfirmView.h
//  疯狂洗车
//
//  Created by cts on 15/12/17.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsurancePayInfoModel.h"
#import "TicketModel.h"


@protocol InsuranceOrderConfirmViewDelegate <NSObject>

- (void)didInsuranceOrderConfirmViewDismissAfterConfirm;

@end

@interface InsuranceOrderConfirmView : UIView
{
    IBOutlet UILabel *_jqccsyPriceLabel;
    
    IBOutlet UILabel *_reducePriceLabel;
    
    IBOutlet UILabel *_payPriceLabel;
    
    IBOutlet UILabel *_ticketPriceLabel;
    
    IBOutlet UIView *_displayInfoView;
}
- (void)showAndSetUpWithPayInfoModel:(InsurancePayInfoModel*)model
                      withTicketInfo:(TicketModel*)tickerModel;


@property (assign, nonatomic) id <InsuranceOrderConfirmViewDelegate> delegate;


@end
