//
//  InsuranceListViewController.h
//  优快保
//
//  Created by cts on 15/7/8.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "WebServiceHelper.h"
#import "HeaderFooterTableView.h"

//用户报价方案列表，尽在用户提交过或提交了报价方案后显示
@interface InsuranceListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet HeaderFooterTableView *_listTableView;
}


@end
