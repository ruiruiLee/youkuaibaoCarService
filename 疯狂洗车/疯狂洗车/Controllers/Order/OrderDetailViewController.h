//
//  OrderDetailViewController.h
//  优快保
//
//  Created by cts on 15/5/15.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "CarWashModel.h"
#import "OrderDetailModel.h"
#import "OrderListModel.h"
#import "CarNurseServiceModel.h"
#import "TQStarRatingView.h"

//订单详情页面
@interface OrderDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITableView *_contextTableView;
    
    IBOutlet TQStarRatingView *_starRatingView;
    
    IBOutlet UILabel *_scoreLabel;
    
    IBOutlet UILabel *_commentLabel;
}

@property (strong, nonatomic) OrderDetailModel *orderModel;

@property (strong, nonatomic) OrderListModel *orderListModel;

@property (assign, nonatomic) BOOL     isCarWashOrder;

@end
