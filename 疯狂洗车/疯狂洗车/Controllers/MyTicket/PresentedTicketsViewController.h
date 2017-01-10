//
//  PresentedTicketsViewController.h
//  疯狂洗车
//
//  Created by LiuZach on 2017/1/7.
//  Copyright © 2017年 龚杰洪. All rights reserved.
//

#import "BaseViewController.h"
#import "HeaderFooterTableView.h"
#import "WebServiceHelper.h"
#import "TicketModel.h"

@interface PresentedTicketsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet HeaderFooterTableView *_ticketListTableView;
    
    NSMutableArray       *_ticketArray;//优惠券列表
    NSMutableArray       *_selectedTicketArray;//选中优惠券列表
    
    IBOutlet UIImageView *_noTickeyImageView;
    
    IBOutlet UIView *_incomeBar;
    IBOutlet UIButton *_btnSubmit;
    IBOutlet UILabel *_lbExplain;
    IBOutlet UITextField *_tfTextField;
    
    IBOutlet NSLayoutConstraint *_inputBarConstant;
}




@end
