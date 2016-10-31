//
//  AccidentRescueViewController.h
//  疯狂洗车
//
//  Created by cts on 15/11/23.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "BaseViewController.h"
#import "CarNurseModel.h"
#import "CarInfos.h"
#import "CarNurseServiceModel.h"
#import "TicketModel.h"

//救援服务下单页面
@interface AccidentRescueViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITableView *_contextTableView;
    
    IBOutlet UIView *_bottomSubmitView;
    
    IBOutlet UILabel *_priceLabel;
}

@property (strong, nonatomic) CarNurseModel *carNurse;

@property (strong, nonatomic) CarInfos   *serviceCar;

@property (strong, nonatomic) CarNurseServiceModel *serviceModel;

@property (strong, nonatomic) TicketModel *selectTicketModel;

@property (strong, nonatomic) TicketModel *defaultTicketModel;

@property (strong, nonatomic) NSString    *service_type;


@end
