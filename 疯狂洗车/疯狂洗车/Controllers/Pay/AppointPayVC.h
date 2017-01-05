//
//  AppointPayVC.h
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/13.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "BaseViewController.h"
#import "AppointInfo.h"

@interface AppointPayVC : BaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    AppointInfo *_appointModel;
    
    BOOL _ticketPayStatus;//yes 优惠券支付； no，不使用
    BOOL _balancePayStatus;//yes 余额支付； no，不使用
}

@property (nonatomic, strong) IBOutlet UILabel *lbOrderInfo;//订单信息
@property (nonatomic, strong) IBOutlet UITextField *tfAmount;

@property (nonatomic, strong) IBOutlet UILabel *lbTicketName;
@property (nonatomic, strong) IBOutlet UIButton *btnTicketSelect;
@property (nonatomic, strong) IBOutlet UILabel *lbTicketTitle;
@property (nonatomic, strong) IBOutlet UIImageView *imageShut;
@property (nonatomic, strong) IBOutlet UIButton *btnTicketShow;
@property (nonatomic, strong) IBOutlet UILabel *lbBalance;
@property (nonatomic, strong) IBOutlet UIButton *btnBalanceSelect;
@property (nonatomic, strong) IBOutlet UILabel *lbBalanceTitle;

@property (nonatomic, strong) IBOutlet UILabel *lbNoTicket;
@property (nonatomic, strong) IBOutlet UILabel *lbNoBalance;

@property (nonatomic, strong) IBOutlet UILabel *lbSubAmount;
@property (nonatomic, strong) IBOutlet UILabel *lbTicketPay;
@property (nonatomic, strong) IBOutlet UILabel *lbBalancePay;
@property (nonatomic, strong) IBOutlet UILabel *lbActualPay;

@property (nonatomic, strong) IBOutlet UIButton *btnPay;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *screenWidth;

@property (nonnull, strong) IBOutlet UITableView *tableview;

- (void) setAppointModel:(AppointInfo *) model;

@end
