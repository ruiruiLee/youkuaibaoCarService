//
//  InsuranceAVOrderViewController.h
//  
//
//  Created by cts on 15/10/28.
//
//

#import "BaseViewController.h"

#import "TicketModel.h"
#import "PayModel.h"
#import "CarReviewModel.h"

//保险用户年检代办下单页面
@interface InsuranceAVOrderViewController : BaseViewController
{
    
    IBOutlet UITableView *_contextTableView;
    
    IBOutlet UIView      *_bottomSubmitView;
    
    IBOutlet UILabel     *_priceLabel;
    
    IBOutlet UIButton *_submitButton;

    NSMutableArray    *_ticketArray;
    
    NSString          *_ticketName;
}



@end
