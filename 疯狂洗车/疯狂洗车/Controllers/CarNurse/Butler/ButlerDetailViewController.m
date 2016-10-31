//
//  CarNurseDetailViewController.m
//  优快保
//
//  Created by cts on 15/6/11.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "ButlerDetailViewController.h"
#import "MBProgressHUD+Add.h"
#import "UIImageView+WebCache.h"
#import "WebServiceHelper.h"
#import "CarInfos.h"
#import "UIView+Toast.h"
#import "CarNurseModel.h"
#import "CarNurseView.h"
#import "CarSelectView.h"
#import "AddNewCarController.h"
#import "CommentsListController.h"
#import "CarNurseListCell.h"
#import "ButlerOrderViewController.h"
#import "CarNurseServiceModel.h"
#import "CLLocation+YCLocation.h"

@interface ButlerDetailViewController ()<ButlerViewDelegate,AddNewCarDelegate>
{
    CarInfos *_selectedCar;
    
    NSMutableArray            *_myCarsArray;
    
    int _pageIndex;
    
    int _pageSize;

}

@end

@implementation ButlerDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _myCarsArray = [NSMutableArray array];
    
    
    if ([self.service_type isEqualToString:@"1"])
    {
        [self setTitle:@"保养"];
    }
    else if ([self.service_type isEqualToString:@"2"])
    {
        [self setTitle:@"划痕"];
    }
    else if ([self.service_type isEqualToString:@"3"])
    {
        [self setTitle:@"美容"];
    }
    else
    {
        [self setTitle:@"车保姆"];
    }

    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    [rightBtn setTitle:@"客服" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn setTitleColor:self.isClubController?[UIColor whiteColor]:[UIColor colorWithRed:205.0/255.0
                                            green:85.0/255.0
                                             blue:20.0/255.0
                                            alpha:1.0]
                   forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(makePhoneCall) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];

    
    if (_userInfo.member_id != nil)
    {
        [self loadMoreCars];
    }
    else
    {
        [self loadCarServicesByCarNurseModel:self.selectedCarNurse];
    }
    
    [self addCommentNotification];
}

- (void)addCommentNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishAddCommented)
                                                 name:kAddCommentsSuccess
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLoginByCheckCodeSuccess)
                                                 name:kLoginByCheckCodeSuccessNotifaction
                                               object:nil];
}

- (void)loadMoreCars
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _selectedCar = nil;
    [WebService requestJsonArrayOperationWithParam:@{@"member_id": _userInfo.member_id,
                                                     @"page_index": [NSNumber numberWithInteger:_pageIndex],
                                                     @"page_size": [NSNumber numberWithInteger:20]}
                                            action:@"car/service/list"
                                        modelClass:[CarInfos class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (_pageIndex == 1)
         {
             if (_myCarsArray.count > 0)
             {
                 [_myCarsArray removeAllObjects];
             }
             [_myCarsArray addObjectsFromArray:array];
         }
         else
         {
             [_myCarsArray addObjectsFromArray:array];
         }
         if ([_myCarsArray count] < 20*_pageIndex)
         {
             
         }
         else
         {
             _pageIndex += 1;
         }
         
         [self loadCarServicesByCarNurseModel:self.selectedCarNurse];
         
     }
                                 exceptionResponse:^(NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

- (void)loadCarServicesByCarNurseModel:(CarNurseModel*)model
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *submitDic = nil;
    
    
    if (_userInfo.member_id)
    {
        submitDic = @{@"car_wash_id":model.car_wash_id,
                      @"service_type":self.service_type,
                      @"member_id":_userInfo.member_id};
        
    }
    else
    {
        submitDic = @{@"car_wash_id":model.car_wash_id,
                      @"service_type":self.service_type};
        
    }
    
    [WebService requestJsonArrayOperationWithParam:submitDic
                                            action:@"carWash/service/getService"
                                        modelClass:[CarNurseServiceModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (status.intValue > 0 && array.count > 0)
         {
             NSMutableArray *resultArray = [NSMutableArray array];
             NSMutableArray *moreArray = [NSMutableArray array];

             for (int a = 0; a<array.count; a++)
             {
                 CarNurseServiceModel *model = array[a];
                 if ([model.service_type isEqualToString:self.service_type])
                 {
                     [resultArray addObject:model];
                 }
                 else
                 {
                     [moreArray addObject:model];
                 }

             }
             

             
             model.serviceArray = resultArray;
             [self setUpCarNurseDisplayInfo];
         }
         else
         {
             [MBProgressHUD showError:@"该车场暂无车服务" toView:self.view];
         }
     }
                                 exceptionResponse:^(NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [MBProgressHUD showError:@"获取数据失败" toView:self.view];
         
     }];
}

- (void)setUpCarNurseDisplayInfo
{
    if (_butlerView == nil)
    {
        _butlerView = [[NSBundle mainBundle] loadNibNamed:@"ButlerView"
                                                     owner:self
                                                   options:nil][0];
        
        _butlerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
    }
    [self.view addSubview:_butlerView];
    _butlerView.targetType = self.service_type;
    [_butlerView setDisplayCarNurseInfo:self.selectedCarNurse withUserCars:_myCarsArray];
    _butlerView.delegate = self;
}


#pragma mark - CarNurseViewDelegate Method
#pragma mark

- (void)didSelectOrAddMoreCar
{
    if (_userInfo.member_id == nil)
    {
        id viewController = [QuickLoginViewController sharedLoginByCheckCodeViewControllerWithProtocolEnable:nil];
        
        [self presentViewController:viewController animated:YES completion:^
         {
             [[[UIApplication sharedApplication] keyWindow] makeToast:@"请先登录"];
         }];
        return;
    }
    if (_myCarsArray.count > 2)
    {
        NSArray *recentCars = [_myCarsArray subarrayWithRange:NSMakeRange(2, _myCarsArray.count-2)];
        [CarSelectView showCarSelectViewWithCars:recentCars ForTarget:self];
        
    }
    else
    {
        AddNewCarController *controller = ALLOC_WITH_CLASSNAME(@"AddNewCarController");
        controller.delegate = self;
        controller.shouldComplete = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didAddButtonTouched
{
    AddNewCarController *controller = ALLOC_WITH_CLASSNAME(@"AddNewCarController");
    controller.delegate = self;
    controller.shouldComplete = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didSelectACar:(CarInfos*)carInfo
{
    
    NSInteger index = 0;
    
    CarInfos *target = carInfo;
    
    for (int x = 0; x<_myCarsArray.count; x++)
    {
        CarInfos *tmpCars = _myCarsArray[x];
        if ([tmpCars.car_id isEqualToString:target.car_id])
        {
            index = x;
        }
    }
    
    [_myCarsArray removeObjectAtIndex:index];
    [_myCarsArray insertObject:target atIndex:0];
    
    [self setUpCarNurseDisplayInfo];
}

- (void)didFinishAddNewCar
{
    _pageIndex = 1;
    [self loadMoreCars];
}

- (void)didPayOrderButtonTouched
{
    if (_userInfo.member_id == nil)
    {
        id viewController = [QuickLoginViewController sharedLoginByCheckCodeViewControllerWithProtocolEnable:nil];
        
        [self presentViewController:viewController animated:YES completion:^
         {
             [[[UIApplication sharedApplication] keyWindow] makeToast:@"请先登录"];
         }];
        return;
    }
    if (_butlerView.selectCarServiceModel == nil)
    {
        return;
    }
    if (_butlerView.selectedCar == nil)
    {
        [Constants showMessage:@"您还没有添加您的车辆，请先补充您的车辆信息"
                      delegate:self
                           tag:531
                  buttonTitles:@"取消",@"马上补充", nil];
        return;
    }
    if (_butlerView.selectedCar.car_xilie == nil||[_butlerView.selectedCar.car_xilie isEqualToString:@""] || [_butlerView.selectedCar.car_type isEqualToString:@""] || _butlerView.selectedCar.car_type == nil)
    {
        _selectedCar = _butlerView.selectedCar;
        [Constants showMessage:@"您的车辆资料不完整，请先补充您的车辆信息"
                      delegate:self
                           tag:531
                  buttonTitles:@"取消",@"马上补充", nil];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.view.userInteractionEnabled = NO;
    
    [Constants checkAndSupplyCarInfo:_butlerView.selectedCar
                      normalResponse:^(CarInfos *result)
     {
         NSDictionary *submitDic = @{@"car_id":result.car_id,
                                     @"car_wash_id":self.selectedCarNurse.car_wash_id,
                                     @"member_id":_userInfo.member_id,
                                     @"service_type":_butlerView.selectCarServiceModel.service_type,
                                     @"service_id":_butlerView.selectCarServiceModel.service_id,
                                     @"is_super":self.isClubController?@"1":@"0"};
         [WebService requestJsonOperationWithParam:submitDic
                                            action:@"order/service/baseCheck"
                                    normalResponse:^(NSString *status, id data)
          {
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              self.view.userInteractionEnabled = YES;
              if (status.intValue > 0)
              {
                  ButlerOrderViewController *viewController = [[ButlerOrderViewController alloc] initWithNibName:@"ButlerOrderViewController"
                                                                                                          bundle:nil];
                  viewController.carNurse = self.selectedCarNurse;
                  viewController.serviceCar = _butlerView.selectedCar;
                  viewController.serviceWay = SerivceWayDaodian;
                  viewController.serviceModel = _butlerView.selectCarServiceModel;
                  viewController.defaultTicketModel = [self loadDefaultTicketFromService];
                  
                  [self.navigationController pushViewController:viewController animated:YES];
              }
              else
              {
                  [MBProgressHUD showError:@"错误，无法验证您的车辆是否能使用该服务"
                                    toView:self.view];
              }
          }
                                 exceptionResponse:^(NSError *error)
         {
                                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                     self.view.userInteractionEnabled = YES;
                                     [MBProgressHUD showError:[error domain]
                                                       toView:self.view];
          }];
     }
                   exceptionResponse:^{
                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                       self.view.userInteractionEnabled = YES;
                       _selectedCar = _butlerView.selectedCar;
                       [Constants showMessage:@"您的车辆资料不完整，请先补充您的车辆信息"
                                     delegate:self
                                          tag:531
                                 buttonTitles:@"取消",@"马上补充", nil];
     }];



}

- (void)didBookOrderButtonTouched
{
    if (_userInfo.member_id == nil)
    {
        id viewController = [QuickLoginViewController sharedLoginByCheckCodeViewControllerWithProtocolEnable:nil];
        
        [self presentViewController:viewController animated:YES completion:^
         {
             [[[UIApplication sharedApplication] keyWindow] makeToast:@"请先登录"];
         }];
        return;
    }
    if (_butlerView.selectCarServiceModel == nil)
    {
        return;
    }
    if (_butlerView.selectedCar == nil)
    {
        [Constants showMessage:@"您还没有添加您的车辆，请先补充您的车辆信息"
                      delegate:self
                           tag:531
                  buttonTitles:@"取消",@"马上补充", nil];
        return;
    }
    if (_butlerView.selectedCar.car_xilie == nil||[_butlerView.selectedCar.car_xilie isEqualToString:@""] || [_butlerView.selectedCar.car_type isEqualToString:@""] || _butlerView.selectedCar.car_type == nil)
    {
        _selectedCar = _butlerView.selectedCar;
        [Constants showMessage:@"您的车辆资料不完整，请先补充您的车辆信息"
                      delegate:self
                           tag:531
                  buttonTitles:@"取消",@"马上补充", nil];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.view.userInteractionEnabled = NO;
    
    [Constants checkAndSupplyCarInfo:_butlerView.selectedCar
                      normalResponse:^(CarInfos *result)
     {
         NSDictionary *submitDic = @{@"car_id":result.car_id,
                                     @"car_wash_id":self.selectedCarNurse.car_wash_id,
                                     @"member_id":_userInfo.member_id,
                                     @"service_type":_butlerView.selectCarServiceModel.service_type,
                                     @"service_id":_butlerView.selectCarServiceModel.service_id,
                                     @"is_super":self.isClubController?@"1":@"0"};
         [WebService requestJsonOperationWithParam:submitDic
                                            action:@"order/service/baseCheck"
                                    normalResponse:^(NSString *status, id data)
          {
              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
              self.view.userInteractionEnabled = YES;
              if (status.intValue > 0)
              {
                  ButlerOrderViewController *viewController = [[ButlerOrderViewController alloc] initWithNibName:@"ButlerOrderViewController"
                                                                                                          bundle:nil];
                  viewController.carNurse = self.selectedCarNurse;
                  viewController.serviceCar = _butlerView.selectedCar;
                  viewController.serviceWay = SerivceWayShangmen;
                  viewController.serviceModel = _butlerView.selectCarServiceModel;
                  viewController.defaultTicketModel = [self loadDefaultTicketFromService];
                  
                  [self.navigationController pushViewController:viewController animated:YES];
              }
              else
              {
                  [MBProgressHUD showError:@"错误，无法验证您的车辆是否能使用该服务"
                                    toView:self.view];
              }
          }
                                 exceptionResponse:^(NSError *error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             self.view.userInteractionEnabled = YES;
             [MBProgressHUD showError:[error domain]
                               toView:self.view];
          }];
         
     }
                   exceptionResponse:^{
                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                       self.view.userInteractionEnabled = YES;
                       _selectedCar = _butlerView.selectedCar;
                       [Constants showMessage:@"您的车辆资料不完整，请先补充您的车辆信息"
                                     delegate:self
                                          tag:531
                                 buttonTitles:@"取消",@"马上补充", nil];
     }];



}

- (TicketModel*)loadDefaultTicketFromService
{
    if ([_butlerView.selectCarServiceModel.code_id isEqualToString:@""] ||
        _butlerView.selectCarServiceModel.code_id == nil)
    {
        return nil;
    }
    else
    {
        TicketModel *ticket = [[TicketModel alloc] init];
        ticket.code_id = _butlerView.selectCarServiceModel.code_id;
        ticket.code_content = _butlerView.selectCarServiceModel.code_content;
        ticket.price = _butlerView.selectCarServiceModel.price;
        ticket.consume_type = _butlerView.selectCarServiceModel.consume_type;
        ticket.create_time = _butlerView.selectCarServiceModel.create_time;
        ticket.service_type = _butlerView.selectCarServiceModel.service_type;
        ticket.code_name = _butlerView.selectCarServiceModel.code_name;
        ticket.begin_time = _butlerView.selectCarServiceModel.begin_time;
        ticket.end_time = _butlerView.selectCarServiceModel.end_time;
        ticket.remain_times = _butlerView.selectCarServiceModel.remain_times;
        ticket.code_desc = _butlerView.selectCarServiceModel.code_desc;
        ticket.comp_id = _butlerView.selectCarServiceModel.comp_id;
        ticket.comp_name = _butlerView.selectCarServiceModel.comp_name;
        ticket.pay_flag = _butlerView.selectCarServiceModel.pay_flag;
        ticket.times_limit = _butlerView.selectCarServiceModel.times_limit;
        return ticket;
    }

}

//新的



- (void)didCarNurseNaviButtonTouched
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择导航方式："
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"高德地图", nil];
    [actionSheet showInView:self.view];
}

- (void)didCarNursePhoneCallTouched
{
    if ([Constants canMakePhoneCall])
    {
        [Constants showMessage:@"确认致电该车保姆？"
                      delegate:self
                           tag:530
                  buttonTitles:@"取消",@"好的", nil];
    }
    else
    {
        [Constants showMessage:@"您的设备无法拨打电话"];
    }
}

- (void)didCarNurseCommentButtonTouched
{
    CommentsListController *controller = ALLOC_WITH_CLASSNAME(@"CommentsListController");
    controller.commentType = 1;
    controller.isButler = YES;
    [controller setCarWashInfo:self.selectedCarNurse];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 打电话


- (void)callCustomService
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.selectedCarNurse.phone]]];
}

#pragma mark - 打电话
#pragma mark

- (void)makePhoneCall
{
    if ([Constants canMakePhoneCall])
    {
        NSString *messageString = [NSString stringWithFormat:@"致电客服%@",_kefudianhuaNumber];
        [Constants showMessage:messageString
                      delegate:self
                           tag:532
                  buttonTitles:@"取消",@"确认", nil];
    }
    else
    {
        [Constants showMessage:@"您的设备无法拨打电话"];
    }
    

}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 530 && buttonIndex ==1)
    {
        [self callCustomService];
    }
    if (alertView.tag == 531 && buttonIndex == 1)
    {
        AddNewCarController *viewController = [[AddNewCarController alloc] initWithNibName:@"AddNewCarController" bundle:nil];
        viewController.delegate  = self;
        viewController.carInfo = _selectedCar;
        viewController.shouldComplete = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    if (alertView.tag == 532 && buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_kefudianhuaNumber]]];
    }
}

- (void)didFinishEditCar:(CarInfos*)result
{
    _pageIndex = 1;
    [self loadMoreCars];
}

#pragma mark - 导航
#pragma mark

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            BOOL hasGaodeMap = NO;
            
            if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]])
            {
                hasGaodeMap = YES;
            }
            if (hasGaodeMap)
            {
                NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&lat=%f&lon=%f&dev=1&style=2",@"优快保",
                                        @"fengkuangxiche",
                                        @"终点",
                                        [self.selectedCarNurse.latitude doubleValue],
                                        [self.selectedCarNurse.longitude doubleValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
            }
            else
            {
                [Constants showMessage:@"请先到AppStore安装高德地图后使用此功能！"];
            }
        }
            break;
        default:
            break;
    }
}


#pragma mark - 评价代码
#pragma mark 

- (void)didFinishAddCommented
{
    _pageIndex = 1;
    _pageSize = 20;
    
    self.selectedCarNurse.evaluation_counts = [NSString stringWithFormat:@"%d",self.selectedCarNurse.evaluation_counts.intValue + 1];
    [self setUpCarNurseDisplayInfo];
}

-(void)didLoginByCheckCodeSuccess
{
    _pageIndex = 1;
    _pageSize = 20;
    [self loadMoreCars];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAddCommentsSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kPaySuccessNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kWXPaySuccessNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLoginByCheckCodeSuccessNotifaction
                                                  object:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
