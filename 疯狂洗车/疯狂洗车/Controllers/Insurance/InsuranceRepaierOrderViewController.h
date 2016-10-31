//
//  InsuranceRepaierOrderViewController.h
//  疯狂洗车
//
//  Created by cts on 15/11/3.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "BaseViewController.h"
#import "CarReviewModel.h"

//保险用户免费送修下单页面

@interface InsuranceRepaierOrderViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *_contextTableView;
}

@property (nonatomic, strong) CarReviewModel *carReviewModel;


@end
