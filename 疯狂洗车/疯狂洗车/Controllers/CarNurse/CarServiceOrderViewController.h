//
//  CarServiceOrderViewController.h
//  疯狂洗车
//
//  Created by cts on 15/11/11.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "BaseViewController.h"
#import "CarNurseModel.h"
#import "CarInfos.h"
#import "CarNurseServiceModel.h"
#import "TicketModel.h"

//车服务下单页页面

@interface CarServiceOrderViewController : BaseViewController
{
    
}

@property (assign, nonatomic) BOOL isShangMen;//服务方式

@property (strong, nonatomic) CarNurseModel *carNurse;//车场

@property (strong, nonatomic) CarInfos   *serviceCar;//服务车辆

@property (strong, nonatomic) CarNurseServiceModel *serviceModel;//服务

@property (strong, nonatomic) TicketModel *defaultTicketModel;//服务器推荐的优惠券


@end
