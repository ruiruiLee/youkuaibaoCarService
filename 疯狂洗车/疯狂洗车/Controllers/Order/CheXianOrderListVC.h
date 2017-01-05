//
//  CheXianOrderListVC.h
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/26.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "BaseViewController.h"
#import "HeaderFooterTableView.h"

@interface CheXianOrderListVC : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet HeaderFooterTableView    *_listTable;
    
    IBOutlet UIView *_noOrderView;
}

@end
