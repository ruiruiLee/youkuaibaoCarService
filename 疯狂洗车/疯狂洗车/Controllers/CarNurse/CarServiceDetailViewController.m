//
//  CarServiceDetailViewController.m
//  疯狂洗车
//
//  Created by cts on 15/11/9.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "CarServiceDetailViewController.h"
#import "CarNurseView.h"
#import "QuickRescueView.h"
#import "ButlerView.h"
#import "MBProgressHUD+Add.h"
#import "UIImageView+WebCache.h"
#import "WebServiceHelper.h"
#import "CarInfos.h"
#import "UIView+Toast.h"
#import "CarNurseModel.h"
#import "CarNurseView.h"
#import "SupportCarModel.h"
#import "CarSelectView.h"
#import "AddNewCarController.h"
#import "CommentsListController.h"
#import "CarNurseListCell.h"
#import "CarServiceOrderViewController.h"
#import "CarNurseRescueOrderViewController.h"
#import "CarNurseServiceModel.h"
#import "CLLocation+YCLocation.h"
#import "PhotoBroswerVC.h"
#import "TicketModel.h"
#import "MapNavigationViewController.h"
#import "ServiceGroupModel.h"

@interface CarServiceDetailViewController ()<UIActionSheetDelegate,QuickRescueViewDelegate,CarNurseViewDelegate,ButlerViewDelegate,AddNewCarDelegate>
{
    CarNurseView    *_carNurseView;
    
    QuickRescueView *_carRescueView;
    
    ButlerView *_butlerView;

    CarInfos *_selectedCar;
    
    NSMutableArray            *_myCarsArray;
    
    NSMutableArray            *_supportCarsArray;
    
    int _pageIndex;
    
    int _pageSize;
    
    BOOL        _isRescueService;
}

@end

@implementation CarServiceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _myCarsArray = [NSMutableArray array];
    
    if ([self.service_type isEqualToString:@"1"] || [self.service_type isEqualToString:@"2"] || [self.service_type isEqualToString:@"3"])
    {
        [self setTitle:@"车服务"];
    }
    else if ([self.service_type isEqualToString:@"4"])
    {
        [self setTitle:@"救援"];
        _isRescueService = YES;
    }
    else if ([self.service_type isEqualToString:@"6"])
    {
        [self setTitle:@"速援"];
        _isRescueService = YES;
    }
    else if (self.service_type.intValue == 20)
    {
        [self setTitle:@"4S店服务"];
    }
    else
    {
        [self setTitle:@"车保姆"];
    }
    
    UIButton *rightButotn = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 74, 32)];
    [rightButotn setTitle:@"车场介绍" forState:UIControlStateNormal];
    rightButotn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButotn setTitleColor:self.isClubController?[UIColor whiteColor]:[UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0]
                      forState:UIControlStateNormal];
    
    [rightButotn addTarget:self action:@selector(didRightButtonTouch)
          forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButotn];
    [self.navigationItem setRightBarButtonItems:@[rightItem]];
    
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

#pragma mark - 注册提交评价和登录的通知监听 Method

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

#pragma mark - 读取该车场支持的用户车辆(暂废) Method
//该接口暂废，逻辑已由根据用户返回车场服务替换
- (void)loadSupportCarNormalResponse:(void(^)(void))normalResponse
                   exceptionResponse:(void(^)(void))exceptionResponse
{
    NSDictionary *submitDic = @{@"car_wash_id":self.selectedCarNurse.car_wash_id,
                                @"service_type":self.service_type};
    [WebService requestJsonArrayOperationWithParam:submitDic
                                            action:@"carWash/service/getSupportCar"
                                        modelClass:[SupportCarModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         if (status.intValue > 0 && array.count > 0)
         {
             _supportCarsArray = array;
             normalResponse();
             return ;
         }
         else
         {
             exceptionResponse();
             return ;
         }
     }
                                 exceptionResponse:^(NSError *error) {
                                     exceptionResponse();
                                     return ;
                                 }];
}

#pragma mark - 过滤车列表 Method

- (NSMutableArray*)filterCarBySupportCar:(NSMutableArray*)targetArray
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (int x = 0; x<targetArray.count; x++)
    {
        CarInfos *model = targetArray[x];
        BOOL shouldAdd = NO;
        for (int y = 0; y < _supportCarsArray.count; y++)
        {
            SupportCarModel *tmpModel = _supportCarsArray[y];
            
            if ([tmpModel.brand_name isEqualToString:model.car_brand] && [tmpModel.series_name isEqualToString:model.car_xilie])
            {
                shouldAdd = YES;
                break;
            }
        }
        
        if (shouldAdd)
        {
            [resultArray addObject:model];
        }
    }
    
    return resultArray;
}

#pragma mark - 获取用户车辆 Method

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


#pragma mark - 根据用户获取该车场下的所有车服务 Method

- (void)loadCarServicesByCarNurseModel:(CarNurseModel*)model
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *submitDic = nil;
    
    
    if (_userInfo.member_id)
    {
        submitDic = @{@"car_wash_id":model.car_wash_id,
                      @"service_type":self.service_type,
                      @"member_id":_userInfo.member_id,
                      @"super_service":@"0"};
        
    }
    else
    {
        submitDic = @{@"car_wash_id":model.car_wash_id,
                      @"service_type":self.service_type,
                      @"super_service":@"0"};
        
    }
    
    //请求车场详情补充车场图片
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"carWash/service/detail"
                               normalResponse:^(NSString *status, id data)
     {
         if (status.intValue > 0 && ![data isKindOfClass:[NSNull class]])
         {
             CarNurseModel *model = [[CarNurseModel alloc] initWithDictionary:data];
             self.selectedCarNurse.photo_addrs = model.photo_addrs;
         }
         else
         {
             
         }
     }
                            exceptionResponse:^(NSError *error)
     {
     }];
    //请求车场服务
    [WebService requestJsonArrayOperationWithParam:submitDic
                                            action:@"carWash/service/getService"
                                        modelClass:[CarNurseServiceModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         if (status.intValue > 0 && array.count > 0)
         {
             NSMutableArray *resultArray =  [self filterCarNurseServiceModels:array];
             model.serviceArray = resultArray;
             [self setUpCarServiceDisplayInfo];
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

#pragma mark - 车场车服务分组 Method

- (NSMutableArray*)filterCarNurseServiceModels:(NSMutableArray*)targetArray
{
    if(_isRescueService)//当该车场为救援车场时，将该车场提供的与救援无关的服务去除
    {
        NSMutableArray *resultArray = [NSMutableArray array];
        NSMutableArray *moreArray = [NSMutableArray array];
        
        for (int x = 0; x<targetArray.count; x++)
        {
            CarNurseServiceModel *model = targetArray[x];
            if ([model.service_type isEqualToString:self.service_type])
            {
                [resultArray addObject:model];
            }
            else if ([model.service_type isEqualToString:@"1"] ||
                     [model.service_type isEqualToString:@"2"] ||
                     [model.service_type isEqualToString:@"3"] ||
                     [model.service_type isEqualToString:@"5"] )
            {
                
            }
            else
            {
                [moreArray addObject:model];
            }
        }
        [resultArray addObjectsFromArray:moreArray];
        
        return resultArray;

    }
    else//按照保养、划痕、美容分组车服务
    {
        NSMutableArray *resultArray = [NSMutableArray array];
//        ServiceGroupModel *baoYangGroupModel = [[ServiceGroupModel alloc] init];
//        baoYangGroupModel.serviceType = @"1";
//        ServiceGroupModel *huaHenGroupModel = [[ServiceGroupModel alloc] init];
//        huaHenGroupModel.serviceType = @"2";
//        ServiceGroupModel *meiRongGroupModel = [[ServiceGroupModel alloc] init];
//        meiRongGroupModel.serviceType = @"3";
        ServiceGroupModel *groupModel = [[ServiceGroupModel alloc] init];
        groupModel.serviceType = self.service_type;
        for (int i = 0; i < targetArray.count; i++) {
            CarNurseServiceModel *model = targetArray[i];
            if(model.service_type.intValue == groupModel.serviceType.intValue){
                [groupModel.subServiceArray addObject:model];
            }
        }
        
        [resultArray addObject:groupModel];
        
//        NSMutableArray *groupArray = [NSMutableArray arrayWithArray:@[baoYangGroupModel,meiRongGroupModel,huaHenGroupModel]];
//        for (int x = 0; x<targetArray.count; x++)
//        {
//            CarNurseServiceModel *model = targetArray[x];
//            
//            for (int y = 0; y<groupArray.count; y++)
//            {
//                ServiceGroupModel *groupModel = groupArray[y];
//                if (model.service_type.intValue == groupModel.serviceType.intValue)
//                {
//                    [groupModel.subServiceArray addObject:model];
//                }
//            }
//        }
//        if (self.service_type.intValue == 20)
//        {
//            for (int x = 0; x<groupArray.count; x++)
//            {
//                ServiceGroupModel *groupModel = groupArray[x];
//                if (groupModel.subServiceArray.count > 0)
//                {
//                    [resultArray addObject:groupModel];
//                }
//            }
//        }
//        else
//        {
//            for (int x = 0; x<groupArray.count; x++)
//            {
//                ServiceGroupModel *groupModel = groupArray[x];
//
//                if (groupModel.subServiceArray.count > 0)
//                {
//                    if (groupModel.serviceType.intValue == self.service_type.intValue)
//                    {
//                        [resultArray insertObject:groupModel atIndex:0];
//                    }
//                    else
//                    {
//                        [resultArray addObject:groupModel];
//                    }
//                }
//            }
//        }
        return resultArray;
    }
}

#pragma mark - 生成显示服务/救援界面 Method

- (void)setUpCarServiceDisplayInfo//根据service_type 和 isSuperService 判断具体生成/更新哪个详情View
{
    if ([self.service_type isEqualToString:@"4"] || [self.service_type isEqualToString:@"6"] )
    {
        [self setUpCarRescueDisplayInfo];
    }
    else if ([self.service_type isEqualToString:@"5"])
    {
        [self setUpButlerDisplayInfo];
    }
    else
    {
        [self setUpCarNurseDisplayInfo];
    }


}

#pragma mark - 初始化或刷新车场详情 Method

- (void)setUpCarNurseDisplayInfo
{
    _isRescueService = NO;
    if (_carNurseView == nil)
    {
        _carNurseView = [[NSBundle mainBundle] loadNibNamed:@"CarNurseView"
                                                      owner:self
                                                    options:nil][0];
        _carNurseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
        _carNurseView.is4SService = self.service_type.intValue == 20?YES:NO;
        [self.view addSubview:_carNurseView];
        
    }
    _carNurseView.targetType = self.service_type;
    [_carNurseView setDisplayCarNurseInfo:self.selectedCarNurse withUserCars:_myCarsArray];
    _carNurseView.delegate = self;
}
#pragma mark - 初始化或刷新救援车场详情 Method

- (void)setUpCarRescueDisplayInfo
{
    _isRescueService = YES;
    if (_carRescueView == nil)
    {
        _carRescueView = [[NSBundle mainBundle] loadNibNamed:@"QuickRescueView"
                                                            owner:self
                                                          options:nil][0];
        _carRescueView.isForRescue = YES;
        _carRescueView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
    }
    [self.view addSubview:_carRescueView];
    _carRescueView.targetType = self.service_type;
    [_carRescueView setDisplayCarNurseInfo:self.selectedCarNurse withUserCars:_myCarsArray];
    _carRescueView.delegate = self;
}
#pragma mark - 初始化或刷新车保姆车场详情 Method

- (void)setUpButlerDisplayInfo
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

#pragma mark - CarNurseViewDelegate/QuickRescueViewDelegate Method
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
    
    [self setUpCarServiceDisplayInfo];
}

- (void)didFinishAddNewCar
{
    _pageIndex = 1;
    [self loadMoreCars];
}


- (void)didAddButtonTouched
{
    AddNewCarController *controller = ALLOC_WITH_CLASSNAME(@"AddNewCarController");
    controller.delegate = self;
    controller.shouldComplete = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didPayOrderButtonTouched
{
    CarServiceType  targetServiceType = CarServiceTypeXiChe;
    
    if (_isRescueService)
    {
        targetServiceType = CarServiceTypeJiuYuan;
    }
    else if ([self.service_type isEqualToString:@"5"])
    {
        targetServiceType = CarServiceTypeCheBaoMu;
    }
    else
    {
        targetServiceType = CarServiceTypeCheFuWu;
    }
    
    [self checkUserSelectIsAviableWithServiceType:targetServiceType
                                   normalResponse:^(CarInfos *targetCar,
                                                    NSString *targetService_type,
                                                    NSString *targetService_id)
     {
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         self.view.userInteractionEnabled = NO;
         
         
         [Constants checkAndSupplyCarInfo:targetCar
                           normalResponse:^(CarInfos *result)
          {
              NSDictionary *submitDic = @{@"car_id":result.car_id,
                                          @"car_wash_id":self.selectedCarNurse.car_wash_id,
                                          @"member_id":_userInfo.member_id,
                                          @"service_type":targetService_type,
                                          @"service_id":targetService_id,
                                          @"is_super":self.isClubController?@"1":@"0"};
              [WebService requestJsonOperationWithParam:submitDic
                                                 action:@"order/service/baseCheck"
                                         normalResponse:^(NSString *status, id data)
               {
                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                   self.view.userInteractionEnabled = YES;
                   if (status.intValue > 0)
                   {
                       if (_isRescueService)
                       {
                           CarNurseRescueOrderViewController *viewController = [[CarNurseRescueOrderViewController alloc] initWithNibName:@"CarNurseRescueOrderViewController"
                                                                                                                                   bundle:nil];
                           viewController.carNurse = self.selectedCarNurse;
                           viewController.serviceCar = _carRescueView.selectedCar;
                           viewController.serviceModel = _carRescueView.selectCarServiceModel;
                           viewController.defaultTicketModel = [self loadDefaultRescueTicketFromService];
                           
                           [self.navigationController pushViewController:viewController animated:YES];
                       }
                       else
                       {
                           CarServiceOrderViewController *viewController = [[CarServiceOrderViewController alloc] initWithNibName:@"CarServiceOrderViewController"
                                                                                                                       bundle:nil];
                           viewController.carNurse = self.selectedCarNurse;
                           viewController.serviceCar = result;
                           viewController.isShangMen = NO;
                           viewController.serviceModel = _carNurseView.selectCarServiceModel;
                           viewController.isClubController = self.isClubController;
                           
                           viewController.defaultTicketModel = [self loadDefaultTicketFromService];
                           
                           [self.navigationController pushViewController:viewController animated:YES];
                       }
                   }
                   else
                   {
                       [MBProgressHUD showError:@"错误，无法验证您的车辆是否能使用该服务"
                                         toView:self.view];
                   }
               }
                                      exceptionResponse:^(NSError *error) {
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          self.view.userInteractionEnabled = YES;
                                          [MBProgressHUD showError:[error domain]
                                                            toView:self.view];
                                      }];
          }
                        exceptionResponse:^{
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            self.view.userInteractionEnabled = YES;
                            _selectedCar = targetCar;
                            [Constants showMessage:@"您的车辆资料不完整，请先补充您的车辆信息"
                                          delegate:self
                                               tag:531
                                      buttonTitles:@"取消",@"马上补充", nil];
                            return;
                        }];

     }
                                exceptionResponse:^{
                                    
                                }];

}

- (void)didBookOrderButtonTouched
{
    CarServiceType  targetServiceType = CarServiceTypeXiChe;
    
    if (_isRescueService)
    {
        targetServiceType = CarServiceTypeJiuYuan;
    }
    else if ([self.service_type isEqualToString:@"5"])
    {
        targetServiceType = CarServiceTypeCheBaoMu;
    }
    else
    {
        targetServiceType = CarServiceTypeCheFuWu;
    }

    
    [self checkUserSelectIsAviableWithServiceType:targetServiceType
                                   normalResponse:^(CarInfos *targetCar, NSString *targetService_type, NSString *targetService_id)
     {
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         self.view.userInteractionEnabled = NO;
         
         [Constants checkAndSupplyCarInfo:targetCar
                           normalResponse:^(CarInfos *result)
          {
              NSDictionary *submitDic = @{@"car_id":result.car_id,
                                          @"car_wash_id":self.selectedCarNurse.car_wash_id,
                                          @"member_id":_userInfo.member_id,
                                          @"service_type":targetService_type,
                                          @"service_id":targetService_id,
                                          @"is_super":self.isClubController?@"1":@"0"};
              [WebService requestJsonOperationWithParam:submitDic
                                                 action:@"order/service/baseCheck"
                                         normalResponse:^(NSString *status, id data)
               {
                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                   self.view.userInteractionEnabled = YES;
                   if (status.intValue > 0)
                   {
                       if (_isRescueService)
                       {
                           CarNurseRescueOrderViewController *viewController = [[CarNurseRescueOrderViewController alloc] initWithNibName:@"CarNurseRescueOrderViewController"
                                                                                                                                   bundle:nil];
                           viewController.carNurse = self.selectedCarNurse;
                           viewController.serviceCar = _carRescueView.selectedCar;
                           viewController.serviceModel = _carRescueView.selectCarServiceModel;
                           viewController.defaultTicketModel = [self loadDefaultRescueTicketFromService];
                           [self.navigationController pushViewController:viewController animated:YES];
                           
                       }
                       else
                       {
                           CarServiceOrderViewController *viewController = [[CarServiceOrderViewController alloc] initWithNibName:@"CarServiceOrderViewController"
                                                                                                                           bundle:nil];
                           viewController.carNurse = self.selectedCarNurse;
                           viewController.serviceCar = result;
                           viewController.isShangMen = YES;
                           viewController.serviceModel = _carNurseView.selectCarServiceModel;
                           viewController.isClubController = self.isClubController;
                           viewController.defaultTicketModel = [self loadDefaultTicketFromService];
                           [self.navigationController pushViewController:viewController animated:YES];
                       }
                       
                       
                       
                   }
                   else
                   {
                       [MBProgressHUD showError:@"错误，无法验证您的车辆是否能使用该服务"
                                         toView:self.view];
                   }
               }
                                      exceptionResponse:^(NSError *error) {
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          self.view.userInteractionEnabled = YES;
                                          [MBProgressHUD showError:[error domain]
                                                            toView:self.view];
                                      }];
              
              
          }
                        exceptionResponse:^{
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            self.view.userInteractionEnabled = YES;
                            _selectedCar = _carNurseView.selectedCar;
                            [Constants showMessage:@"您的车辆资料不完整，请先补充您的车辆信息"
                                          delegate:self
                                               tag:531
                                      buttonTitles:@"取消",@"马上补充", nil];
                            return;
                        }];
         

    }
                                exceptionResponse:^{
        
    }];
    
   }

- (TicketModel*)loadDefaultTicketFromService
{
    if ([_carNurseView.selectCarServiceModel.code_id isEqualToString:@""] ||
        _carNurseView.selectCarServiceModel.code_id == nil)
    {
        return nil;
    }
    else
    {
        TicketModel *ticket = [[TicketModel alloc] init];
        ticket.code_id = _carNurseView.selectCarServiceModel.code_id;
        ticket.code_content = _carNurseView.selectCarServiceModel.code_content;
        ticket.price = _carNurseView.selectCarServiceModel.price;
        ticket.consume_type = _carNurseView.selectCarServiceModel.consume_type;
        ticket.create_time = _carNurseView.selectCarServiceModel.create_time;
        ticket.service_type = _carNurseView.selectCarServiceModel.service_type;
        ticket.code_name = _carNurseView.selectCarServiceModel.code_name;
        ticket.begin_time = _carNurseView.selectCarServiceModel.begin_time;
        ticket.end_time = _carNurseView.selectCarServiceModel.end_time;
        ticket.remain_times = _carNurseView.selectCarServiceModel.remain_times;
        ticket.code_desc = _carNurseView.selectCarServiceModel.code_desc;
        ticket.comp_id = _carNurseView.selectCarServiceModel.comp_id;
        ticket.comp_name = _carNurseView.selectCarServiceModel.comp_name;
        ticket.pay_flag = _carNurseView.selectCarServiceModel.pay_flag;
        ticket.times_limit = _carNurseView.selectCarServiceModel.times_limit;
        return ticket;
    }
}

- (TicketModel*)loadDefaultRescueTicketFromService
{
    if ([_carRescueView.selectCarServiceModel.code_id isEqualToString:@""] ||
        _carRescueView.selectCarServiceModel.code_id == nil)
    {
        return nil;
    }
    else
    {
        TicketModel *ticket = [[TicketModel alloc] init];
        ticket.code_id = _carRescueView.selectCarServiceModel.code_id;
        ticket.code_content = _carRescueView.selectCarServiceModel.code_content;
        ticket.price = _carRescueView.selectCarServiceModel.price;
        ticket.consume_type = _carRescueView.selectCarServiceModel.consume_type;
        ticket.create_time = _carRescueView.selectCarServiceModel.create_time;
        ticket.service_type = _carRescueView.selectCarServiceModel.service_type;
        ticket.code_name = _carRescueView.selectCarServiceModel.code_name;
        ticket.begin_time = _carRescueView.selectCarServiceModel.begin_time;
        ticket.end_time = _carRescueView.selectCarServiceModel.end_time;
        ticket.remain_times = _carRescueView.selectCarServiceModel.remain_times;
        ticket.code_desc = _carRescueView.selectCarServiceModel.code_desc;
        ticket.comp_id = _carRescueView.selectCarServiceModel.comp_id;
        ticket.comp_name = _carRescueView.selectCarServiceModel.comp_name;
        ticket.pay_flag = _carRescueView.selectCarServiceModel.pay_flag;
        ticket.times_limit = _carRescueView.selectCarServiceModel.times_limit;
        return ticket;
    }
}

//点击导航键
- (void)didCarNurseNaviButtonTouched
{
    MapNavigationViewController *viewController = [[MapNavigationViewController alloc] initWithNibName:@"MapNavigationViewController" bundle:nil];
    viewController.carNurseModel = self.selectedCarNurse;
    viewController.isClubController = self.isClubController;
    [self.navigationController pushViewController:viewController animated:YES];
}

//点击电话键
- (void)didCarNursePhoneCallTouched
{
    if ([Constants canMakePhoneCall])
    {
        [Constants showMessage:@"确认致电该车场？"
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
    [controller setCarWashInfo:self.selectedCarNurse];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)didCarNurseDetailButtonTouched
{
    [self didRightButtonTouch];
}

#pragma mark - 打电话


- (void)callCustomService
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.selectedCarNurse.phone]]];
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
}

- (void)didFinishEditCar:(CarInfos*)result
{
    _pageIndex = 1;
    [self loadMoreCars];
}

#pragma mark - 车场介绍
#pragma mark

- (void)didRightButtonTouch
{
    
//    __weak typeof(self) weakSelf=self;
    
//    http://ibwxt.leanapp.cn/?#!/ruleuse?memberId=117 
    
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypePush index:0 photoModelBlock:^NSArray *{
        
        
        NSArray *networkImages= nil;
        if ([self.selectedCarNurse.photo_addrs isEqualToString:@""] || self.selectedCarNurse.photo_addrs == nil)
        {
            networkImages = @[self.selectedCarNurse.logo];
        }
        else
        {
            networkImages= [self.selectedCarNurse.photo_addrs componentsSeparatedByString:@","];
            if (networkImages.count <= 0 )
            {
                networkImages = @[self.selectedCarNurse.logo];
            }
            
        }
        
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:networkImages.count];
        for (NSUInteger i = 0; i< networkImages.count; i++) {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.title = @"车场介绍";
            if ([self.selectedCarNurse.introduction isEqualToString:@""] || self.selectedCarNurse.introduction == nil)
            {
                pbModel.desc = @"暂无描述";
            }
            else
            {
                pbModel.desc = self.selectedCarNurse.introduction;
            }
            pbModel.image_HD_U = networkImages[i];
            
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
}

#pragma mark - 评价代码
#pragma mark

- (void)didFinishAddCommented
{
    _pageIndex = 1;
    _pageSize = 20;
    
    self.selectedCarNurse.evaluation_counts = [NSString stringWithFormat:@"%d",self.selectedCarNurse.evaluation_counts.intValue + 1];
    [self setUpCarServiceDisplayInfo];
}

-(void)didLoginByCheckCodeSuccess
{
    _pageIndex = 1;
    _pageSize = 20;
    [self loadMoreCars];
}


#pragma mark - 验证用户的选择是否可行

- (void)checkUserSelectIsAviableWithServiceType:(CarServiceType)carServiceType
                                 normalResponse:(void(^)(CarInfos *targetCar, NSString *targetService_type, NSString *targetService_id ))normalResponse
                              exceptionResponse:(void(^)(void))exceptionResponse
{

    if (_userInfo.member_id == nil)
    {
        id viewController = [QuickLoginViewController sharedLoginByCheckCodeViewControllerWithProtocolEnable:nil];
        
        [self presentViewController:viewController animated:YES completion:^
         {
             [[[UIApplication sharedApplication] keyWindow] makeToast:@"请先登录"];
         }];
        exceptionResponse();
        return;
    }
    if (carServiceType == CarServiceTypeJiuYuan)
    {
        if (_carRescueView.selectCarServiceModel == nil)
        {
            exceptionResponse();
            return;
        }
        if (_carRescueView.selectedCar == nil)
        {
            [Constants showMessage:@"您还没有添加您的车辆，请先补充您的车辆信息"
                          delegate:self
                               tag:531
                      buttonTitles:@"取消",@"马上补充", nil];
            exceptionResponse();
            return;
        }
        if (_carRescueView.selectedCar.car_xilie == nil||
            [_carRescueView.selectedCar.car_xilie isEqualToString:@""] ||
            [_carRescueView.selectedCar.car_type isEqualToString:@""] ||
            _carRescueView.selectedCar.car_type == nil)
        {
            _selectedCar = _carRescueView.selectedCar;
            [Constants showMessage:@"您的车辆资料不完整，请先补充您的车辆信息"
                          delegate:self
                               tag:531
                      buttonTitles:@"取消",@"马上补充", nil];
            return;
        }
        
        normalResponse (_carRescueView.selectedCar,
                        [NSString stringWithFormat:@"%@",_carRescueView.selectCarServiceModel.service_type],
                        [NSString stringWithFormat:@"%@",_carRescueView.selectCarServiceModel.service_id]);
        return;
    }
    else if (carServiceType == CarServiceTypeCheFuWu)
    {
        if (_carNurseView.selectCarServiceModel == nil)
        {
            [Constants showMessage:@"您还没有选择服务"];
            exceptionResponse();
            return;
        }
        if (_carNurseView.selectedCar == nil)
        {
            [Constants showMessage:@"您还没有添加您的车辆，请先补充您的车辆信息"
                          delegate:self
                               tag:531
                      buttonTitles:@"取消",@"马上补充", nil];
            exceptionResponse();
            return;
        }
        if (_carNurseView.selectedCar.car_xilie == nil||
            [_carNurseView.selectedCar.car_xilie isEqualToString:@""] ||
            [_carNurseView.selectedCar.car_type isEqualToString:@""] ||
            _carNurseView.selectedCar.car_type == nil)
        {
            _selectedCar = _carNurseView.selectedCar;
            [Constants showMessage:@"您的车辆资料不完整，请先补充您的车辆信息"
                          delegate:self
                               tag:531
                      buttonTitles:@"取消",@"马上补充", nil];
            exceptionResponse();
            return;
        }
        normalResponse (_carNurseView.selectedCar,
                        [NSString stringWithFormat:@"%@",_carNurseView.selectCarServiceModel.service_type],
                        [NSString stringWithFormat:@"%@",_carNurseView.selectCarServiceModel.service_id]);
        return;
    }
    else
    {
        [Constants showMessage:@"未知服务，无法操作"];
        return;
    }
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
