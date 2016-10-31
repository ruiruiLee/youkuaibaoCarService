//
//  InsuranceBottomCustomOpreationView.h
//  
//
//  Created by cts on 15/10/20.
//
//

#import <UIKit/UIKit.h>

@protocol InsuranceBottomCustomOpreationViewDelegate <NSObject>

- (void)didCustomOpreationPhoneButtonTouched;

- (void)didCustomOpreationEditButtonTouched;

- (void)didCustomOpreationPayButtonTouched;



@end

@interface InsuranceBottomCustomOpreationView : UIView
{
    
    IBOutlet UIButton *_customEditButton;
    
    IBOutlet UIButton *_customPhoneButton;
    
    IBOutlet UIButton *_customPayButton;
    
    IBOutlet UIView *_orderFinishView;
    
    IBOutlet UIButton *_orderPhoneButton;
}

@property (assign, nonatomic) id <InsuranceBottomCustomOpreationViewDelegate> delegate;

- (void)shouldShowOrHideOrderFinishView:(BOOL)shouldShow;

@end
