//
//  CarNurseOrderViewController.h
//  优快保
//
//  Created by cts on 15/4/4.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "CarNurseModel.h"
#import "CarInfos.h"
#import "CarNurseServiceModel.h"
#import "TicketModel.h"

typedef enum
{
    SerivceWayDaodian,
    SerivceWayShangmen
}SerivceWay;

//车服务下单页面（老）
@interface CarNurseOrderViewController : BaseViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
    IBOutlet UIView *_serviceOrderView;

    IBOutlet UILabel *_carNurseNameLabel;
    
    UIScrollView     *_backGroundView;

    IBOutlet UIView  *_contentView;
    
    IBOutlet UIView *_bottomSubmitView;
    
    IBOutlet UILabel *_serviceCarLabel;
    
    IBOutlet UILabel *_serviceTypeAndWayLabel;
    
    IBOutlet UILabel *_serviceContextLabel;
    
    IBOutlet UILabel *_servicePartsLabel;
    
    IBOutlet UIView      *_serviceTimeView;
    IBOutlet UITextField *_serviceTimeField;
    
    IBOutlet UIView      *_serviceAddressView;
    IBOutlet UITextField *_serviceAddressField;
    
    IBOutlet UITextField *_moreRequestField;
    
    IBOutlet UIView      *_payWayView;
    
    IBOutlet UILabel     *_priceLabel;
    
#pragma mark - 余额和券
    
    IBOutlet UILabel        *_yueLabel;
    
    IBOutlet UILabel        *_yuePayTitle;
    
    IBOutlet UIImageView    *_yuePaySelectIcon;
    
    IBOutlet UILabel        *_ticketPayTitle;
    
    IBOutlet UIImageView    *_ticketPaySelectIcon;
    
    IBOutlet UILabel        *_ticketNameLabel;
    
    IBOutlet UILabel        *_ticketPriceLabel;
    IBOutlet UILabel        *_ticketTypeLabel;
    
    IBOutlet UILabel        *_ticketNumberTitle;
    
    IBOutlet UILabel        *_ticketNumberLabel;
    
    BOOL                     _ticketEnable;
    
    BOOL                     _ticketSelected;
    
    BOOL                     _remainderSelected;

    
#pragma mark -  支付方式
    IBOutlet UILabel        *_aliPayTitle;
    
    IBOutlet UIImageView    *_aliPaySelectIcon;
    
    IBOutlet UILabel        *_weixinPayTitle;
    
    IBOutlet UIImageView    *_weixinPaySelectIcon;
    
    IBOutlet UILabel        *_unionPayTitle;
    
    IBOutlet UIImageView    *_unionPaySelectIcon;
    
    IBOutlet UIView         *_moreRequestView;
    
}

@property (assign, nonatomic) SerivceWay serviceWay;

@property (strong, nonatomic) CarNurseModel *carNurse;

@property (strong, nonatomic) CarInfos   *serviceCar;

@property (strong, nonatomic) CarNurseServiceModel *serviceModel;

@property (strong, nonatomic) TicketModel *selectTicketModel;

@property (strong, nonatomic) TicketModel *defaultTicketModel;


@property (assign, nonatomic) BOOL      isForRecuse;


@end
