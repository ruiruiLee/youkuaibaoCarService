//
//  MoreController.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/28.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"

//设置页面
@interface MoreController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView  *_menuTable;
}
@end
