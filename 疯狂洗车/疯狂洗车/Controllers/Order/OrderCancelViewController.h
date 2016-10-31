//
//  OrderCancelViewController.h
//  优快保
//
//  Created by cts on 15/5/16.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderDetailModel.h"
#import "WebServiceHelper.h"
#import "MBProgressHUD+Add.h"
#import "ButlerMapViewController.h"

//订单取消页面
@interface OrderCancelViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_reasonArray;
    
    IBOutlet UITableView *_contextTableView;
    
    IBOutlet UIButton *_submitButton;
    
}

@property (strong, nonatomic) OrderDetailModel *orderModel;

@end
