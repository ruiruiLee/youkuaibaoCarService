//
//  BaseAppointVC.h
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/15.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "BaseViewController.h"
#import "CarNurseModel.h"
#import "MyTicketViewController.h"

@interface BaseAppointVC : BaseViewController

@property (strong, nonatomic) NSString *service_type;

@property (strong, nonatomic) CarNurseModel *selectedCarNurse;

@end
