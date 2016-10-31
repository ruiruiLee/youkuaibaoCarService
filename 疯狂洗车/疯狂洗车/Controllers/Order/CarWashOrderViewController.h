//
//  CarWashOrderViewController.h
//  优快保
//
//  Created by cts on 15/5/13.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "CarWashModel.h"
#import "TicketModel.h"
#import "PayModel.h"

//洗车车场详情及下单页面
@interface CarWashOrderViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *_contextTableView;
    
    IBOutlet UIView *_submitView;
    
    IBOutlet UILabel *_priceLabel;
    
    IBOutlet UIButton *_submitButton;
    
    NSMutableArray    *_ticketArray;
    
    NSString          *_ticketName;
}

@property (nonatomic, strong) CarWashModel *carWashInfo;

@property (strong, nonatomic) TicketModel  *selectTicketModel;

@property (strong, nonatomic) TicketModel  *defaultTicketModel;



@end
