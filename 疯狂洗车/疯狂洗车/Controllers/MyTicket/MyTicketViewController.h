//
//  MyTicketViewController.h
//  优快保
//
//  Created by cts on 15/5/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"

#import "TicketModel.h"
#import "HeaderFooterTableView.h"

#import "WebServiceHelper.h"

@protocol MyTicketDelegate <NSObject>

- (void)didFinishTicketSelect:(TicketModel*)model;

@end

//用户优惠券列表
@interface MyTicketViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet HeaderFooterTableView *_ticketListTableView;
    
    NSMutableArray       *_ticketArray;
    
    IBOutlet UIImageView *_noTickeyImageView;
    
//    IBOutlet UIView             *_topView;
    
    IBOutlet UISegmentedControl *_segmentControl;
}

@property (strong, nonatomic) NSString *serviceType;//优惠券类型

@property (strong, nonatomic) NSString *targetCarWashID;//是否存在目标车场，用于是否只查询目标车场优惠券

@property (assign, nonatomic) id <MyTicketDelegate> delegate;

@end
