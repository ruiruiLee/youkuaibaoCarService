//
//  AppointSuccessVC.h
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/13.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "BaseViewController.h"
#import "ServiceTypeTableViewCell.h"

@interface AppointSuccessVC : BaseViewController

@property (nonatomic, strong) IBOutlet UILabel *lbSAerviceName;
@property (nonatomic, strong) IBOutlet UILabel *lbServiceType;
@property (nonatomic, strong) IBOutlet UILabel *lbServiceTime;
@property (nonatomic, strong) IBOutlet UILabel *lbCarNo;

@property (nonatomic, strong) IBOutlet UIButton *btnReturnHome;
@property (nonatomic, strong) IBOutlet UIButton *btnAppointList;

@property (nonatomic, strong) NSDictionary *successDic;
@property (nonatomic, strong) NSString *carNo;//chepai
@property (nonatomic, assign) ServiceType service_type;//yuyue fang shi
@property (nonatomic, assign) NSInteger fuwuType;//fuwu lei xing

@end
