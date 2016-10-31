//
//  MyOrdersController.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/28.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "HeaderFooterTableView.h"

//我的订单页面
@interface MyOrdersController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet HeaderFooterTableView    *_listTable;
    
    
    IBOutlet UISegmentedControl *_orderTypeSegment;
        
    IBOutlet UIView *_noOrderView;
}

@end
