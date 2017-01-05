//
//  MyAppointVC.h
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/13.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "HeaderFooterTableView.h"

@interface MyAppointVC : BaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet HeaderFooterTableView    *_listTable;
    
    IBOutlet UIView *_noAppointView;
}


@end
