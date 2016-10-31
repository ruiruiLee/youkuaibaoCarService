//
//  MineViewController.h
//  优快保
//
//  Created by cts on 15/4/3.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInfo.h"
#import "WebServiceHelper.h"
#import "MineViewController.h"
#import "UserTicketModel.h"

//我的页面,用于显示用户信息
@interface MineViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *_mineTableView;
    
    NSMutableArray *_userTicketArray;
}

@end
