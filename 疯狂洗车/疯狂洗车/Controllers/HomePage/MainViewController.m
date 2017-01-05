//
//  MainViewController.m
//  优快保
//
//  Created by cts on 15/6/11.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "MainViewController.h"
#import "WebServiceHelper.h"
#import "CLLocation+YCLocation.h"
#import "CityModel.h"
#import "DBManager.h"
#import "RDVTabBarController.h"
#import "MBProgressHUD+Add.h"
#import "UIView+Toast.h"
#import "ButlerMapViewController.h"
#import "CrazyCarWashMapViewController.h"
#import "CycleScrollView.h"
#import "ADVModel.h"
#import "UIImageView+WebCache.h"
#import "CityNoServiceViewController.h"
#import "ActivitysController.h"
#import "RecommendListCell.h"
#import "CarWashOrderViewController.h"
#import "CarServiceDetailViewController.h"
#import "ButlerDetailViewController.h"
#import "CarServiceDetailViewController.h"
#import "WeatherModel.h"
#import "ButlerOrderModel.h"
#import "OrderSuccessViewController.h"
#import "InsuranceViewController.h"
#import "InsuranceHomeModel.h"
#import "MainAdvView.h"
#import "CitySelecterViewController.h"
#import "CrazyCarWashMapViewController.h"
#import "FourSMapViewController.h"
#import "InsuranceRepaierOrAVViewController.h"
#import "HomeBulterMenuView.h"
#import "AccidentRescueViewController.h"
#import "InsuranceListViewController.h"
#import "InsuranceSubmitViewController.h"
#import "InsuranceHelper.h"
#import "InsuranceHomeViewController.h"
#import "InsuranceIntroductionViewController.h"
#import "InsuranceAVOrderViewController.h"
#import "InsuranceRepaierOrderViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>

#import "PopView.h"
#import "define.h"
#import "RescueAppointVC.h"

#import "CheXiaoBaoViewController.h"
#import "BaseAppointVC.h"


//#import <AVFoundation/AVFoundation.h>


@interface MainViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,MainAdvViewDelegate,HomeBulterMenuViewDelegate,AMapSearchDelegate, PopViewDelegate>
{
    UIButton                    *_leftButton;//城市选择按钮
    
    UIButton                    *_rightButton;//礼包按钮
    
    CycleScrollView             *_headerScrollView;//顶部banner
    
    NSMutableArray              *_headerModelArray;//顶部banner数据

    IBOutlet UIView             *_bottomView;//推荐车场View
    
    IBOutlet UITableView        *_recommendTableView;//推荐车场TableView
    
    NSMutableArray              *_recommendArray;//推荐车场数据

    IBOutlet UIButton           *_refreshButton;//推荐车场刷新按钮
    
    NSInteger                    _pageIndex;
    
    BOOL                         _canLoadMore;
        
    BOOL                         _advHaveShow;
    
    BOOL                         _viewControllerIsShow;
    
    
    UIButton                    *_showWeatherButton;
    

#pragma mark - 天气
    AMapSearchAPI               *_searchAPI;

    IBOutlet UIView             *_weatherView;
    
    IBOutlet UIButton           *_hideWeatherButton;
    
    IBOutlet UILabel            *_currentCityLabel;
    
    IBOutlet UILabel            *_todayDayLabel;
    
    IBOutlet UILabel            *_todayWeatherLabel;
    
    
    IBOutlet UILabel            *_secondDayLabel;
    
    IBOutlet UILabel            *_secondWeatherLabel;
    
    IBOutlet UILabel            *_thirdDayLabel;
    
    IBOutlet UILabel            *_thirdWeatherLabel;
}
@end

@implementation MainViewController

static NSString *recommendListCellReuse = @"RecommendListCell";


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _headerModelArray = [NSMutableArray array];
    
    _recommendArray = [NSMutableArray array];
    
    [self setTitle:@"优快保"];
    
    _showWeatherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _showWeatherButton.frame = CGRectMake(SCREEN_WIDTH/2-60,2, 120, 60);
    
    _showWeatherButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    [_showWeatherButton setImage:[UIImage imageNamed:@"img_weather_arrow_down_gray"]
                        forState:UIControlStateNormal];
    [_showWeatherButton setImage:[UIImage imageNamed:@"img_weather_arrow_down_white"]
                        forState:UIControlStateHighlighted];
    [_showWeatherButton setImage:[UIImage imageNamed:@"img_weather_arrow_up_gray"]
                        forState:UIControlStateSelected];
    [_showWeatherButton addTarget:self
                           action:@selector(didShowWeatherButtonTouched:)
                 forControlEvents:UIControlEventTouchUpInside];

    _showWeatherButton.userInteractionEnabled = NO;

    _agentHeaderImageView.layer.masksToBounds = YES;
    _agentHeaderImageView.layer.cornerRadius = 40/2;
    _agentHeaderImageView.layer.borderWidth = 1.0;
    _agentHeaderImageView.layer.borderColor = [UIColor colorWithRed:204/255.0
                                                              green:204/255.0
                                                               blue:204/255.0
                                                              alpha:1.0].CGColor;
    _pageIndex = 1;
    _canLoadMore = YES;
        
    [_recommendTableView registerNib:[UINib nibWithNibName:recommendListCellReuse
                                                    bundle:[NSBundle mainBundle]]
              forCellReuseIdentifier:recommendListCellReuse];

    
    _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 36)];
    [_leftButton setTitle:@"城市" forState:UIControlStateNormal];
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_leftButton setTitleColor:[UIColor colorWithRed:235.0/255.0
                                               green: 84.0/255.0
                                                blue:  1.0/255.0
                                               alpha:1.0] forState:UIControlStateNormal];

    
    [_leftButton addTarget:self action:@selector(didLeftButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 36)];
    [_rightButton setTitle:@"礼包" forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"img_main_gift"]
                  forState:UIControlStateNormal];
    [_rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 3)];
    [_rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, -2)];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_rightButton setTitleColor:[UIColor colorWithRed:235.0/255.0
                                               green:  84.0/255.0
                                                blue:   1.0/255.0
                                               alpha:1.0] forState:UIControlStateNormal];
    _rightButton.exclusiveTouch = YES;
    
    [_rightButton addTarget:self action:@selector(didRightButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];


    _weatherView.transform = CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT);

    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserInfoKey])
    {
        [_appDelegate startMSGRefrishTimer];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logoutSuccess)
                                                 name:kLogoutSuccessNotifaction
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveCitySettingNotification:)
                                                 name:kFinishCitySettingNotifaction
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveLoginSuccessNotification:)
                                                 name:kLoginSuccessNotifaction
                                               object:nil];
    

    
    [_contextScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, _contextScrollView.frame.size.height)];
    

    if (_userCityModel && _appconfig)
    {
        [self didReceviceCityAndCongifNotification:nil];

    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceviceCityAndCongifNotification:)
                                                     name:NOTELocationLaunchSuccess
                                                   object:nil];
    }
    
    [self shouldShowAgentView:NO
     andShowExtraFunctionView:NO
     andShouldShowColorCenter:NO];
    
    [_contextScrollView addHeaderWithTarget:self action:@selector(obtainAppInfo)];
}


- (void)obtainAppInfo
{
    [self didReceviceCityAndCongifChangeNotification:nil];
    [_contextScrollView headerEndRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_bg"]
                                                  forBarMetrics:0];
    _viewControllerIsShow = YES;
    if (!_advHaveShow && [[NSUserDefaults standardUserDefaults] objectForKey:kLastUserCity] && _viewControllerIsShow)
    {
        if (_mainAdvModel == nil)
        {
            [self updateMainAdvData:^{
                [self openMainAdvOpreation];
            } failRespone:^{
                _advHaveShow = YES;
                _rightButton.hidden = YES;
            }];
        }
        else
        {
            [self openMainAdvOpreation];
        }
        
    }
    else if (!_advHaveShow)
    {
        
    }

    [super viewWillAppear:animated];
    [self.navigationController.view addSubview:_showWeatherButton];
    _showWeatherButton.hidden = NO;

    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityNameKey])
    {
        [_leftButton setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityNameKey]
                     forState:UIControlStateNormal];
    }
}

//首页大礼包
- (void)updateMainAdvData:(void(^)(void))successRespone
              failRespone:(void(^)(void))failRescpone
{
    NSDictionary *submitDic = @{@"city_id":_userCityModel.CITY_ID,
                                @"app_type":@2,
                                @"member_id":_userInfo.member_id?_userInfo.member_id:@""};
    [WebService requestJsonModelWithParam:submitDic
                                   action:@"system/service/getMainAdv"
                               modelClass:[MainAdvModel class]
                           normalResponse:^(NSString *status, id data, JsonBaseModel *model)
     {
         _mainAdvModel = (MainAdvModel*)model;
         successRespone();
         return ;
     }
                        exceptionResponse:^(NSError *error) {
                            [MBProgressHUD showError:[error domain]
                                              toView:self.view];
                            failRescpone();
                            return ;
                        }];

}

- (void)openMainAdvOpreation
{
    if (_viewControllerIsShow)
    {
        _advHaveShow = YES;
        
        if (_mainAdvModel.adv_list.count  > 0)
        {
            if (_mainAdvModel.is_forced.intValue > 0)
            {
                _rightButton.hidden = YES;
                [MainAdvView showMainAdvViewWithTarget:self];
            }
        }
        else
        {
            _rightButton.hidden = YES;
        }
    }
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _viewControllerIsShow = NO;
    _showWeatherButton.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_headerScrollView resetContentOffset];
   
//    if (_userInfo.member_id && !_activityModel && _userInfo.city_id)
//    {
//        [self updateActivityConfigWithCityID:_userInfo.city_id];
//    }
    if (self.shouldGoToMine)
    {
        self.shouldGoToMine = NO;
        self.rdv_tabBarController.selectedIndex = 2;
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kLastUserCity])
    {
        CitySelecterViewController *viewController = [[CitySelecterViewController alloc] initWithNibName:@"CitySelecterViewController" bundle:nil];
        viewController.forbidBack = YES;
        viewController.isFirstLaunch = YES;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recommendArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (SCREEN_HEIGHT <= 568)
    {
        return 100;
    }
    else
    {
        return 115.0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendListCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendListCellReuse];
    
    if (cell == nil)
    {
        cell = [[RecommendListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:recommendListCellReuse];
    }
    
    CarNurseModel *model = _recommendArray[indexPath.row];
    
    [cell setDisplayRecommendInfo:model];
    
    return cell;
}


#pragma mark - UITableViewDelegate
#pragma mark 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    CarNurseModel *model = _recommendArray[indexPath.row];
    if ([model.service_type isEqualToString:@"0"])
    {
        CarWashOrderViewController *controller = ALLOC_WITH_CLASSNAME(@"CarWashOrderViewController");
        controller.carWashInfo = model;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if ([model.service_type isEqualToString:@"5"])
    {
        CarNurseModel *targetModel = model;
        if ([_appDelegate.gpsLocationManager getTheServiceStatus:5])
        {
            if (!_userInfo.member_id)
            {
                CarServiceDetailViewController *viewController = ALLOC_WITH_CLASSNAME(@"CarServiceDetailViewController");
                viewController.selectedCarNurse = targetModel;
                viewController.service_type = [NSString stringWithFormat:@"%@",targetModel.service_type];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else
            {
                NSDictionary *submitDic = @{@"member_id":_userInfo.member_id,
                                            @"longitude":[NSNumber numberWithDouble:_publicUserCoordinate.longitude],
                                            @"latitude":[NSNumber numberWithDouble:_publicUserCoordinate.latitude]};
                [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
                self.view.userInteractionEnabled = NO;
                [WebService requestJsonModelWithParam:submitDic
                                               action:@"order/service/getNannyOrder"
                                           modelClass:[ButlerOrderModel class]
                                       normalResponse:^(NSString *status, id data, JsonBaseModel *model)
                 {
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     self.view.userInteractionEnabled = YES;
                     if (status.intValue > 0 && ![data isEqual:@{}])
                     {
                         _userButlerOrder = (ButlerOrderModel*)model;
                         ButlerMapViewController *viewController = [[ButlerMapViewController alloc] initWithNibName:@"ButlerMapViewController"
                                                                                                             bundle:nil];
                         viewController.service_type = @"5";
                         viewController.isNannyServicing = YES;
                         [self.navigationController pushViewController:viewController
                                                              animated:YES];
                     }
                     else
                     {
                         ButlerDetailViewController *viewController = ALLOC_WITH_CLASSNAME(@"ButlerDetailViewController");
                         viewController.selectedCarNurse = targetModel;
                         viewController.service_type = [NSString stringWithFormat:@"%@",targetModel.service_type];
                         [self.navigationController pushViewController:viewController animated:YES];
                     }
                 }
                                    exceptionResponse:^(NSError *error)
                 {
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     self.view.userInteractionEnabled = YES;
                     ButlerDetailViewController *viewController = ALLOC_WITH_CLASSNAME(@"ButlerDetailViewController");
                     viewController.selectedCarNurse = model;
                     viewController.service_type = [NSString stringWithFormat:@"%@",model.service_type];
                     [self.navigationController pushViewController:viewController animated:YES];
                 }];
            }
        }
    }
    else
    {
        if(![model.car_wash_id isEqualToString:Owner_CarWah_ID]){
            CarServiceDetailViewController *viewController = ALLOC_WITH_CLASSNAME(@"CarServiceDetailViewController");
            viewController.selectedCarNurse = model;
            viewController.service_type = [NSString stringWithFormat:@"%@",model.service_type];
            [self.navigationController pushViewController:viewController animated:YES];
        }else{
            BaseAppointVC *vc = [[BaseAppointVC alloc] initWithNibName:nil bundle:nil];
            vc.service_type = model.service_type;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


#pragma mark - 广告部分的代码
#pragma mark 

- (void)obtainAdverInfo
{
        if (_userCityModel)
        {
            if (_headerScrollView != nil)
            {
                if ([_headerScrollView.advCityID isEqualToString:_userCityModel.CITY_ID])
                {
                    return;
                }
                else
                {
                    [_headerScrollView removeFromSuperview];
                    _headerScrollView = nil;
                }

            }
            float headerHeight = SCREEN_WIDTH/3.0;
            _headerScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerHeight)
                                                     animationDuration:3.0];
            _headerScrollView.advCityID = _userCityModel.CITY_ID;
            NSDictionary *submitDic = @{@"city_id":_userCityModel.CITY_ID};
            NSLog(@"%@", @"告部分的代码");
            [WebService requestJsonArrayOperationWithParam:submitDic
                                                    action:@"system/service/getAdv"
                                                modelClass:[ADVModel class]
                                            normalResponse:^(NSString *status, id data, NSMutableArray *array)
             {
                 if (status.intValue > 0 && array.count > 0)
                 {
                     
                     [_topAdvView addSubview:_headerScrollView];
                     
                     _headerModelArray = array;
                     
                     NSInteger count = _headerModelArray.count;
                     
                     NSArray *tmpArr = _headerModelArray;
                     
                     
                     _headerScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex)
                     {
                         NSMutableArray *viewsArray = [NSMutableArray array];
                         for (int i = 0; i < tmpArr.count; i ++)
                         {
                             ADVModel *headerModel = tmpArr[i];
                             UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,_topAdvView.frame.size.width, _topAdvView.frame.size.height)];
                             imageView.clipsToBounds = YES;
                             [imageView sd_setImageWithURL:[NSURL URLWithString:headerModel.photo_addr]
                                          placeholderImage:[UIImage imageNamed:@"img_home_top_default"]
                                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                              {
                                  if (error == nil)
                                  {
                                      [imageView setImage:image];
                                  }
                             }];
                             [imageView setUserInteractionEnabled:YES];
                             [viewsArray addObject:imageView];
                             
                         }
                         if (pageIndex == viewsArray.count)
                         {
                             return viewsArray[0];
                         }
                         else
                         {
                             return viewsArray[pageIndex];
                         }
                     };
                     
                     _headerScrollView.totalPagesCount = ^NSInteger(void)
                     {
                         return count;
                     };
                     __weak id weakSelf = self;
                     _headerScrollView.TapActionBlock = ^(NSInteger pageIndex)
                     {
                         [weakSelf didTouchOnADV:pageIndex];
                     };
                     
                     _defaultADVImageView.hidden = YES;
                 }
                 else
                 {
                     
                 }
             }
                                         exceptionResponse:^(NSError *error) {
                                             
                                         }];
        }
}



#pragma mark - 打电话
#pragma mark

- (IBAction) makeCheXiaoBao:(UIButton *) sender
{
    if (!_userInfo.member_id)
    {
        id viewController = [QuickLoginViewController sharedLoginByCheckCodeViewControllerWithProtocolEnable:nil];
        
        [self presentViewController:viewController animated:YES completion:^
         {
             [[[UIApplication sharedApplication] keyWindow] makeToast:@"请先登录"];
         }];
        
        return;
    }
    
    CheXiaoBaoViewController *vc = [[CheXiaoBaoViewController alloc] initWithNibName:@"CheXiaoBaoViewController" bundle:nil];
    [vc setTitle:@"车小保"];
    NSString *url = [NSString stringWithFormat:CHE_XIAO_BAP_URL, BASE_Uri_FOR_WEB, _userInfo.member_id];
    vc.webUrl = url;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)makePhoneCall
{
        if ([Constants canMakePhoneCall])
        {
            NSString *messageString = [NSString stringWithFormat:@"致电客服%@",_kefudianhuaNumber];
            [Constants showMessage:messageString
                          delegate:self
                               tag:530
                      buttonTitles:@"取消",@"确认", nil];
        }
        else
        {
            [Constants showMessage:@"您的设备无法拨打电话"];
        }
}

- (void)makeSuperServicePhoneCall
{

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 530 && buttonIndex == 1)
    {
        [self callCustomService];
    }
    if (alertView.tag == 611 && buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_agentModel.agent_phone]]];
    }
    if(alertView.tag == 531 && buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",SERVICE_PHONE]]];
    }
}

- (void)callCustomService
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_kefudianhuaNumber]]];
}

#pragma mark - 顶部按钮
#pragma mark

#pragma mark - 选择城市

- (void)didLeftButtonTouch
{
    id controller = ALLOC_WITH_CLASSNAME(@"CitySelecterViewController");
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 展示礼包

- (void)didRightButtonTouch
{    
    _rightButton.hidden = YES;
    [MainAdvView showMainAdvViewWithTarget:self];
}

#pragma mark - 页面选择按钮的代码
#pragma mark
- (IBAction)didTopOnDobuleView:(UITapGestureRecognizer *)sender
{
    CGPoint touchPoint = [sender locationInView:sender.view];
    NSLog(@"%f",touchPoint.x);
    if (touchPoint.x < SCREEN_WIDTH/2)
    {
        [self checkInsuranceHomeConfig];
    }
}


- (IBAction)didPageButtonTouch:(UIButton *)sender
{
//    if (_cityServiceArray == nil || _cityServiceArray.count == 0)
//    {
//        [Constants showMessage:@"获取不到城市服务信息，请确认您已打开并允许使用定位功能"];
//        return;
//
//    }
    if (_cityServiceArray == nil || _cityServiceArray.count == 0){
        [Constants showMessage:@"获取信息失败,清检查你的网络刷新页面！"];
        return;
    }
    
    if (!_userInfo.member_id)
    {
        id viewController = [QuickLoginViewController sharedLoginByCheckCodeViewControllerWithProtocolEnable:nil];
        
        [self presentViewController:viewController animated:YES completion:^
         {
             [[[UIApplication sharedApplication] keyWindow] makeToast:@"请先登录"];
         }];
        
        return;
    }
    
    switch (sender.tag)
    {
        case 0:
        {
            NSLog(@"洗车");
            if ([_appDelegate.gpsLocationManager getTheServiceStatus:0])
            {

                CrazyCarWashMapViewController *viewController = [[CrazyCarWashMapViewController alloc] initWithNibName:@"CrazyCarWashMapViewController"
                                                                                                                bundle:nil];
                viewController.service_type = [NSString stringWithFormat:@"%d",(int)sender.tag];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else
            {
                CityNoServiceViewController *viewController = [[CityNoServiceViewController alloc] initWithNibName:@"CityNoServiceViewController"
                                                                                                            bundle:nil];
                viewController.service_type = [NSString stringWithFormat:@"%ld",(long)sender.tag];
                [self.navigationController pushViewController:viewController animated:YES];
            }

        }
            break;
        case 1:
        {
            NSLog(@"保养");
            if ([_appDelegate.gpsLocationManager getTheServiceStatus:1])
            {
//                CrazyCarWashMapViewController *viewController = [[CrazyCarWashMapViewController alloc] initWithNibName:@"CrazyCarWashMapViewController"
//                                                                                                                bundle:nil];
//                viewController.service_type = [NSString stringWithFormat:@"%d",(int)sender.tag];
//                [self.navigationController pushViewController:viewController animated:YES];
                
                BaseAppointVC *vc = [[BaseAppointVC alloc] initWithNibName:nil bundle:nil];
                vc.service_type = [NSString stringWithFormat:@"%d",(int)sender.tag];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            else
            {
                CityNoServiceViewController *viewController = [[CityNoServiceViewController alloc] initWithNibName:@"CityNoServiceViewController"
                                                                                                            bundle:nil];
                viewController.service_type = [NSString stringWithFormat:@"%ld",(long)sender.tag];
                [self.navigationController pushViewController:viewController animated:YES];
            }

        }
            break;
        case 3:
        {
            NSLog(@"美容");
            if ([_appDelegate.gpsLocationManager getTheServiceStatus:3])
            {
//                CrazyCarWashMapViewController *viewController = [[CrazyCarWashMapViewController alloc] initWithNibName:@"CrazyCarWashMapViewController"
//                                                                                                                bundle:nil];
//                viewController.service_type = [NSString stringWithFormat:@"%d",(int)sender.tag];
//                [self.navigationController pushViewController:viewController animated:YES];
                
                BaseAppointVC *vc = [[BaseAppointVC alloc] initWithNibName:nil bundle:nil];
                vc.service_type = [NSString stringWithFormat:@"%d",(int)sender.tag];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                CityNoServiceViewController *viewController = [[CityNoServiceViewController alloc] initWithNibName:@"CityNoServiceViewController"
                                                                                                            bundle:nil];
                viewController.service_type = [NSString stringWithFormat:@"%ld",(long)sender.tag];
                [self.navigationController pushViewController:viewController animated:YES];
            }


        }
            break;
        case 2:
        {
            NSLog(@"划痕");
            if ([_appDelegate.gpsLocationManager getTheServiceStatus:2])
            {
                CrazyCarWashMapViewController *viewController = [[CrazyCarWashMapViewController alloc] initWithNibName:@"CrazyCarWashMapViewController"
                                                                                                                bundle:nil];
                viewController.service_type = [NSString stringWithFormat:@"%d",(int)sender.tag];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else
            {
                CityNoServiceViewController *viewController = [[CityNoServiceViewController alloc] initWithNibName:@"CityNoServiceViewController"
                                                                                                            bundle:nil];
                viewController.service_type = [NSString stringWithFormat:@"%ld",(long)sender.tag];
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
            break;
        case 4:
        {
            NSLog(@"救援");
            
            PopView *popview = [[PopView alloc] initWithImageArray:@[@"img_home_rescue_ring", @"img_home_rescue_Add"] nameArray:@[@"电话救援", @"选择位置"]];
            [self.view.window addSubview:popview];
            popview.delegate = self;
            [popview show];
        }
            break;
        case 6:
        {//车小宝

        }
            break;
        case 11:
        {
            CheXiaoBaoViewController *vc = [[CheXiaoBaoViewController alloc] initWithNibName:@"CheXiaoBaoViewController" bundle:nil];
            NSString *url = [NSString stringWithFormat:ER_SHOU_CHE_GU_JIA, BASE_Uri_FOR_WEB, _userInfo.member_id];
            vc.webUrl = url;
            [self.navigationController pushViewController:vc animated:YES];
            
            [vc setTitle:@"二手车估价"];
        }
            break;
        case 20:
        {
            CheXiaoBaoViewController *vc = [[CheXiaoBaoViewController alloc] initWithNibName:@"CheXiaoBaoViewController" bundle:nil];
            NSString *url = [NSString stringWithFormat:WEI_ZHANG_CHA_XUN, BASE_Uri_FOR_WEB, _userInfo.member_id];
            vc.webUrl = url;
            [self.navigationController pushViewController:vc animated:YES];
            [vc setTitle:@"违章查询"];
        }
            break;
        default:
            break;
    }
}


#pragma PopViewDelegate
- (void) HandleItemSelect:(PopView *) view selectImageName:(NSString *) imageName
{
    if([imageName isEqualToString:@"img_home_rescue_ring"]){//电话
        if ([Constants canMakePhoneCall])
        {
            [Constants showMessage:@"拨打客服电话呼叫救援？"
                          delegate:self
                               tag:531
                      buttonTitles:@"取消",@"确定", nil];
        }
        else
        {
            [Constants showMessage:@"您的设备无法拨打"];
        }
    }
    else{
        RescueAppointVC *mapVc = [[RescueAppointVC alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:mapVc animated:YES];
    }
}

- (void)checkInsuranceHomeConfig
{
    self.rdv_tabBarController.selectedIndex = 1;
}

- (void)checkMineHomeConfig
{
    self.rdv_tabBarController.selectedIndex = 2;
}

- (void)showTargetInsuranceController
{
    if (!_userInfo.member_id)
    {
        InsuranceIntroductionViewController *viewController = [[InsuranceIntroductionViewController alloc] init];
        
        [self.navigationController pushViewController:viewController animated:YES];
        return;
    }
    [InsuranceHelper getDesiredInsuranceControllerResultResponse:^(id targetController)
    {
        [self.navigationController pushViewController:targetController
                                             animated:YES];
    }];

}

#pragma mark - 展示额外内容

- (void)shouldShowAgentView:(BOOL)agentShow
   andShowExtraFunctionView:(BOOL)extraShow
   andShouldShowColorCenter:(BOOL)colorCenter
{
    if (agentShow)
    {
        _agentTitleLabel.text = _agentModel.agent_title;
        _agentNameLabel.text = _agentModel.agent_name;
        [_agentHeaderImageView sd_setImageWithURL:[NSURL URLWithString:_agentModel.agent_logo]
                                 placeholderImage:[UIImage imageNamed:@"img_home_agent_header"]];
        _agentMessageButton.hidden = NO;
        _agentMessageLine.hidden = NO;
    }
    else
    {
        _agentTitleLabel.text = @"客服热线";
        _agentNameLabel.text = @"400-080-3939";
        [_agentHeaderImageView setImage:[UIImage imageNamed:@"img_home_agent_header"]];
        _agentMessageButton.hidden = YES;
        _agentMessageLine.hidden = YES;
    }
//    if (extraShow)
//    {
//        [_jiuyuanButton setBackgroundImage:[UIImage imageNamed:@"img_mainExtraFunction_jiuyuan_free"] forState:UIControlStateNormal];
//        [_nianjianButton setBackgroundImage:[UIImage imageNamed:@"img_mainExtraFunction_nianjian_free"] forState:UIControlStateNormal];
//
//    }
//    else
//    {
//        [_jiuyuanButton setBackgroundImage:[UIImage imageNamed:@"img_mainExtraFunction_jiuyuan"] forState:UIControlStateNormal];
//        [_nianjianButton setBackgroundImage:[UIImage imageNamed:@"img_mainExtraFunction_nianjian"] forState:UIControlStateNormal];
//    }
}


#pragma mark - MainExtraViewDelegate

- (void)didMainExtraFunctionButtonTouched:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 || buttonIndex == 3)
    {
        if(buttonIndex == 0)
        {
            if (![_appDelegate.gpsLocationManager getTheServiceStatus:4])
            {
                CityNoServiceViewController *viewController = [[CityNoServiceViewController alloc] initWithNibName:@"CityNoServiceViewController"
                                                                                                            bundle:nil];
                viewController.service_type = @"4";
                [self.navigationController pushViewController:viewController animated:YES];
                return;
            }
        }
        if(buttonIndex == 3)
        {
            if (![_appDelegate.gpsLocationManager getTheServiceStatus:6])
            {
                CityNoServiceViewController *viewController = [[CityNoServiceViewController alloc] initWithNibName:@"CityNoServiceViewController"
                                                                                                            bundle:nil];
                viewController.service_type = @"6";
                [self.navigationController pushViewController:viewController animated:YES];
                return;
            }
        }
        NSDictionary *submitDic = @{@"longitude":[NSNumber numberWithDouble:_publicUserCoordinate.longitude],
                                    @"latitude": [NSNumber numberWithDouble:_publicUserCoordinate.latitude],
                                    @"target_longitude":@"",
                                    @"target_latitude":@"",
                                    @"round":@"100",
                                    @"service":@"1",
                                    @"page_index":[NSNumber numberWithInteger:1],
                                    @"page_size":[NSNumber numberWithInteger:20],
                                    @"city_id":[[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey],
                                    @"service_type":buttonIndex == 0?@4:@6};
        
        [MBProgressHUD showHUDAddedTo:self.view
                             animated:YES];
        self.view.userInteractionEnabled = NO;
        [WebService requestJsonArrayOperationWithParam:submitDic
                                                action:buttonIndex == 0?@"carWash/service/list":@"carWash/service/getRescue"
                                            modelClass:[CarNurseModel class]
                                        normalResponse:^(NSString *status, id data, NSMutableArray *array)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             self.view.userInteractionEnabled = YES;
             if (buttonIndex == 0)
             {
                 if (array.count > 0)
                 {
                     AccidentRescueViewController *viewController = [[AccidentRescueViewController alloc] initWithNibName:@"AccidentRescueViewController"
                                                                                                                   bundle:nil];
                     viewController.service_type = @"4";
                     viewController.carNurse = array[0];
                     [self.navigationController pushViewController:viewController animated:YES];
                 }
                 else
                 {
                     CityNoServiceViewController *viewController = [[CityNoServiceViewController alloc] initWithNibName:@"CityNoServiceViewController"
                                                                                                                 bundle:nil];
                     viewController.service_type = @"4";
                     [self.navigationController pushViewController:viewController animated:YES];
                     return;
                 }

             }
             else
             {
                 if (array.count == 1 && [array[0] isKindOfClass:[CarNurseModel class]])
                 {
                     CarServiceDetailViewController  *viewController = ALLOC_WITH_CLASSNAME(@"CarServiceDetailViewController");
                     viewController.selectedCarNurse = array[0];
                     viewController.service_type = buttonIndex == 0?@"4":@"6";
                     [self.navigationController pushViewController:viewController animated:YES];
                 }
                 else
                 {
                     CrazyCarWashMapViewController *viewController= [[CrazyCarWashMapViewController alloc] initWithNibName:@"CrazyCarWashMapViewController"
                                                                                                                    bundle:nil];
                     viewController.service_type = buttonIndex == 0?@"4":@"6";
                     [self.navigationController pushViewController:viewController
                                                          animated:YES];
                 }

             }
         }
                                     exceptionResponse:^(NSError *error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             self.view.userInteractionEnabled = YES;
             CrazyCarWashMapViewController *viewController= [[CrazyCarWashMapViewController alloc] initWithNibName:@"CrazyCarWashMapViewController"
                                                                                                            bundle:nil];
             viewController.service_type = buttonIndex == 0?@"4":@"6";
             [self.navigationController pushViewController:viewController
                                                  animated:YES];
         }];

    }
    else
    {
        if (buttonIndex == 1)
        {
            if (![_appDelegate.gpsLocationManager getTheServiceStatus:7])
            {
                CityNoServiceViewController *viewController = [[CityNoServiceViewController alloc] initWithNibName:@"CityNoServiceViewController"
                                                                                                            bundle:nil];
                viewController.service_type = @"7";
                [self.navigationController pushViewController:viewController animated:YES];
                return;
            }
            else
            {
                InsuranceRepaierOrderViewController *viewController = [[InsuranceRepaierOrderViewController alloc] initWithNibName:@"InsuranceRepaierOrderViewController"
                                                                                                                          bundle:nil];
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
        if (buttonIndex == 2)
        {
            if (![_appDelegate.gpsLocationManager getTheServiceStatus:8])
            {
                CityNoServiceViewController *viewController = [[CityNoServiceViewController alloc] initWithNibName:@"CityNoServiceViewController"
                                                                                                            bundle:nil];
                viewController.service_type = @"8";
                [self.navigationController pushViewController:viewController animated:YES];
                return;
            }
            else
            {

                InsuranceAVOrderViewController *viewController = [[InsuranceAVOrderViewController alloc] initWithNibName:@"InsuranceAVOrderViewController" bundle:nil];
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
    }
}

#pragma mark - MainExtraAgentViewDelegate Method

- (IBAction)didMainAgentPhoneButtonTouched
{
    if ([_agentModel.agent_phone isEqualToString:@""] || _agentModel.agent_phone == nil)
    {
        if ([Constants canMakePhoneCall])
        {
            [Constants showMessage:@"拨打客服电话？"
                          delegate:self
                               tag:530
                      buttonTitles:@"取消",@"确定", nil];
        }
        else
        {
            [Constants showMessage:@"您的设备无法拨打"];
        }

    }
    else
    {
        [Constants showMessage:@"拨打专属客户经理电话？"
                      delegate:self
                           tag:611
                  buttonTitles:@"取消",@"确定", nil];
    }

}

- (IBAction)didMainAgentMessageButtonTouched
{
    if ([_agentModel.agent_phone isEqualToString:@""] || _agentModel.agent_phone == nil)
    {
        [Constants showMessage:@"无法发送短信"];
        return;
    }
    NSString *messageString = [NSString stringWithFormat:@"sms://%@",_agentModel.agent_phone];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:messageString]];
}


#pragma mark - 获取活动信息
#pragma mark

- (void)updateActivityConfigWithCityID:(NSString*)cityID
{
    
    NSDictionary *submitDic = @{@"city_id":cityID,
                                @"member_id":_userInfo.member_id};
    NSLog(@"%@", @"获取活动信息");
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"system/service/activity/config"
                               normalResponse:^(NSString *status, id data)
     {
         if (status.intValue > 0)
         {
             _activityModel = [[ActivityModel alloc] initWithDictionary:data];
             if (_activityModel.activity_count.intValue > 0 && [_activityModel.open_activity isEqualToString:@"1"])
             {
                 
             }
             else
             {
             }
         }
     }
                            exceptionResponse:^(NSError *error)
     {
     }];
}

#pragma mark - 查看活动
#pragma mark 

- (void)didTouchOnADV:(NSInteger)pageIndex
{
    ADVModel *headerModel = _headerModelArray[pageIndex];
    [self didTopAdvImageTouched:headerModel];
}

- (void)didMainAdvImageTouched:(adv_list *)model
{
    ADVModel *advModel = [[ADVModel alloc] init];
    advModel.adv_id = model.main_adv_id;
    advModel.photo_addr = model.main_adv_img;
    advModel.title = model.main_adv_title;
    advModel.url = model.main_adv_url;
    advModel.url_type = model.main_adv_type;
    [self didTopAdvImageTouched:advModel];
}

- (void)didTopAdvImageTouched:(ADVModel *)model
{
    if (!_userInfo.member_id && [model.url_type isEqualToString:@"2"])
    {
        if (!_userInfo.member_id)
        {
            id viewController = [QuickLoginViewController sharedLoginByCheckCodeViewControllerWithProtocolEnable:nil];
            
            [self presentViewController:viewController animated:YES completion:^
             {
                 [[[UIApplication sharedApplication] keyWindow] makeToast:@"请先登录"];
             }];
            return;
        }
    }
    if ([model.url_type isEqualToString:@"3"])
    {
        if (!_insuranceHomeModel)
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.view.userInteractionEnabled = NO;
            [InsuranceHelper requestInsuranceHomeModelNormalResponse:^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                self.view.userInteractionEnabled = YES;
                
                InsuranceHomeViewController *viewController = [[InsuranceHomeViewController alloc] initWithNibName:@"InsuranceHomeViewController" bundle:nil];
                [self.navigationController pushViewController:viewController animated:YES];
            }
                                                   exceptionResponse:^{
                                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                       self.view.userInteractionEnabled = YES;
                                                       [Constants showMessage:@"无法使用保险功能"];
                                                   }];
        }
        else
        {
            InsuranceHomeViewController *viewController = [[InsuranceHomeViewController alloc] initWithNibName:@"InsuranceHomeViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
    }
    else if ([model.url isEqualToString:@""] || model.url == nil)
    {
        
    }
    else
    {
        ActivitysController *viewController = [[ActivitysController alloc] initWithNibName:@"ActivitysController"
                                                                                    bundle:nil];
        if ([model.url_type isEqualToString:@"2"] || [model.url_type isEqualToString:@"3"])
        {
            viewController.forbidAddMark = NO;
        }
        else
        {
            viewController.forbidAddMark = YES;
        }
        viewController.advModel = model;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}




- (void)didMainAdvImageHide
{
    _rightButton.hidden = NO;
}

#pragma mark - 换一换猜你喜欢
#pragma mark

- (IBAction)didRefreshButtonTouch:(id)sender
{
    if (_canLoadMore)
    {
        [self startRefreshRecommend];
    }
    else
    {
        _pageIndex = 1;
        _canLoadMore = YES;
        [self startRefreshRecommend];
    }

}

- (void)startRefreshRecommend
{
    if (_publicUserCoordinate.latitude == 0 || _publicUserCoordinate.longitude == 0 || [[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey] == nil)
    {
        [Constants showMessage:@"获取不到您的位置，请确认您已打开并允许使用定位功能"];
        _pageIndex = 1;
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *submitDic = @{@"latitude"  :[NSNumber numberWithDouble:_publicUserCoordinate.latitude],
                                @"longitude" :[NSNumber numberWithDouble:_publicUserCoordinate.longitude],
                                @"page_index":[NSNumber numberWithInteger:_pageIndex],
                                @"page_size":[NSNumber numberWithInt:5],
                                @"city_id"   :[[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey]};
//推荐服务
    NSLog(@"%@", @"推荐服务");
    [WebService requestJsonArrayOperationWithParam:submitDic
                                            action:@"carWash/service/recommend"
                                        modelClass:[CarNurseModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (status.intValue > 0 && array.count > 0)
        {
            if (array.count >= 4)
            {
                _pageIndex++;
                _canLoadMore = YES;
            }
            else
            {
                _pageIndex = 1;
                _canLoadMore = NO;
            }
            _bottomView.hidden = NO;
            _recommendArray = array;
            [_recommendTableView reloadData];
            _recommendTableView.hidden = NO;

            
            for (int x = 0; x<_bottomView.constraints.count; x++)
            {
                NSLayoutConstraint *layoutConstraint = _bottomView.constraints[x];
                if (layoutConstraint.firstAttribute == NSLayoutAttributeHeight)
                {
                    [_bottomView removeConstraint:layoutConstraint];
                    break;
                }

            }
            
            NSDictionary* views = NSDictionaryOfVariableBindings(_bottomView);
            
            NSString *constrainString = nil;
            if (SCREEN_HEIGHT <= 568)
            {
                constrainString = [NSString stringWithFormat:@"V:[_bottomView(%d)]",40+(int)_recommendArray.count*100];
            }
            else
            {
                constrainString = [NSString stringWithFormat:@"V:[_bottomView(%d)]",40+(int)_recommendArray.count*115];
            }
            
            [_bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constrainString
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:views]];
        
        }
        else
        {
            _pageIndex = 1;
            _canLoadMore = YES;
            _recommendTableView.hidden = YES;
            _bottomView.hidden = YES;
            for (int x = 0; x<_bottomView.constraints.count; x++)
            {
                NSLayoutConstraint *layoutConstraint = _bottomView.constraints[x];
                if (layoutConstraint.firstAttribute == NSLayoutAttributeHeight)
                {
                    [_bottomView removeConstraint:layoutConstraint];
                    break;
                }
                
            }
            
            NSDictionary* views = NSDictionaryOfVariableBindings(_bottomView);
            NSString *constrainString = [NSString stringWithFormat:@"V:[_bottomView(%d)]",40];
            
            [_bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constrainString
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:views]];
        }

    }
                                 exceptionResponse:^(NSError *error)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:[error domain] toView:self.view];
        _pageIndex = 1;
        _canLoadMore = YES;
        _recommendTableView.hidden = YES;
        _bottomView.hidden = YES;
        for (int x = 0; x<_bottomView.constraints.count; x++)
        {
            NSLayoutConstraint *layoutConstraint = _bottomView.constraints[x];
            if (layoutConstraint.firstAttribute == NSLayoutAttributeHeight)
            {
                [_bottomView removeConstraint:layoutConstraint];
                break;
            }
            
        }
        
        NSDictionary* views = NSDictionaryOfVariableBindings(_bottomView);
        NSString *constrainString = [NSString stringWithFormat:@"V:[_bottomView(%d)]",40];
        
        [_bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constrainString options:0 metrics:nil views:views]];
    }];
}


#pragma mark - 检查城市服务开通情况
- (void)updateDateCityService
{
    [MBProgressHUD showMessag:@"正在获取城市服务信息" toView:self.view];
    [_appDelegate.gpsLocationManager getCityServiceFromService:[[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey]
                                               SuccessResponse:^{
                                                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                   [self updateWeatherInfoWithCityInfo:_userCityModel];
                                                   [self obtainAdverInfo];
                                                   [self setUpMainScrollViewDisplayItem];

                                               }
                                                  failResponse:^{
                                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                  }];
}

#pragma mark - 获取和展示天气
#pragma mark

- (void)updateWeatherInfoWithCityInfo:(CityModel*)userCity
{
    if (_searchAPI == nil)
    {
        _searchAPI = [[AMapSearchAPI alloc] init];
        _searchAPI.delegate = self;
    }
    
    AMapWeatherSearchRequest *request = [[AMapWeatherSearchRequest alloc] init];
    request.city = userCity.CITY_NAME;
    request.type = AMapWeatherTypeForecast;
    _currentCityLabel.text = userCity.CITY_NAME;
    [_searchAPI AMapWeatherSearch:request];
    
    
//    NSDictionary *submitDic = @{@"city_id":userCity.CITY_ID};
//    [WebService requestJsonArrayOperationWithParam:submitDic
//                                            action:@"weather/service/today"
//                                        modelClass:[WeatherModel class]
//                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
//     {
//         if (status.intValue > 0 && array.count >= 3)
//         {
//             WeatherModel *todayWeatherModel = array[0];
//             WeatherModel *secondWeatherModel = array[1];
//             WeatherModel *thirdWeatherModel = array[2];
//             
//             [self setTitle:[NSString stringWithFormat:@"今天·%@",todayWeatherModel.weather]];
//             _todayDayLabel.text = todayWeatherModel.week;
//             _todayWeatherLabel.text = [NSString stringWithFormat:@"%@ %@",todayWeatherModel.weather,todayWeatherModel.temperature];
//             _todayWeatherLabel.adjustsFontSizeToFitWidth = YES;
//             _currentCityLabel.text = userCity.CITY_NAME;
//             
//             _secondDayLabel.text = secondWeatherModel.week;
//             _secondWeatherLabel.text = [NSString stringWithFormat:@"%@ %@",secondWeatherModel.weather,secondWeatherModel.temperature];
//             _secondWeatherLabel.adjustsFontSizeToFitWidth = YES;
//             
//             
//             _thirdDayLabel.text = thirdWeatherModel.week;
//             _thirdWeatherLabel.text = [NSString stringWithFormat:@"%@ %@",thirdWeatherModel.weather,thirdWeatherModel.temperature];
//             _thirdWeatherLabel.adjustsFontSizeToFitWidth = YES;
//             
//             _showWeatherButton.userInteractionEnabled = YES;
//             
//         }
//         else
//         {
//             [self.view makeToast:@"获取天气信息失败"];
//             [self setTitle:@"优快保"];
//             _currentCityLabel.text = userCity.CITY_NAME;
//             _showWeatherButton.userInteractionEnabled = NO;
//             return ;
//             
//         }
//     }
//                                 exceptionResponse:^(NSError *error) {
//                                     [self.view makeToast:@"获取天气信息失败"];
//                                     [self setTitle:@"优快保"];
//                                     _currentCityLabel.text = userCity.CITY_NAME;
//                                     _showWeatherButton.userInteractionEnabled = NO;
//                                     return ;
//
//                                 }];
}

- (void)onWeatherSearchDone:(AMapWeatherSearchRequest *)request response:(AMapWeatherSearchResponse *)response
{
    if (response.forecasts.count > 0)
    {
        NSLog(@"response.forecasts is %@",response.forecasts);
        AMapLocalWeatherForecast *forecast = [response.forecasts lastObject];
        
        for (int x = 0; x<forecast.casts.count; x++)
        {
            AMapLocalDayWeatherForecast *dayWeatherForecast = forecast.casts[x];
            if (x == 0)
            {
                NSString *currentWeather = nil;
                if ([dayWeatherForecast.dayWeather isEqualToString:@""] || dayWeatherForecast.dayWeather == nil)
                {
                    currentWeather = [NSString stringWithFormat:@"%@",dayWeatherForecast.nightWeather];
                }
                else
                {
                    currentWeather = [NSString stringWithFormat:@"%@",dayWeatherForecast.dayWeather];
                }
                [self setTitle:[NSString stringWithFormat:@"今天·%@",currentWeather]];
                _todayDayLabel.text = [self getWeekChineseWithNumber:dayWeatherForecast.week.intValue];
                _todayWeatherLabel.text = [NSString stringWithFormat:@"%@ %@℃～%@℃",currentWeather,dayWeatherForecast.dayTemp,dayWeatherForecast.nightTemp];
                _todayWeatherLabel.adjustsFontSizeToFitWidth = YES;
                _currentCityLabel.text = forecast.city;
            }
            else if (x== 1)
            {
                _secondDayLabel.text = [self getWeekChineseWithNumber:dayWeatherForecast.week.intValue];
                _secondWeatherLabel.text = [NSString stringWithFormat:@"%@ %@℃～%@℃",dayWeatherForecast.dayWeather,dayWeatherForecast.dayTemp,dayWeatherForecast.nightTemp];
                _secondWeatherLabel.adjustsFontSizeToFitWidth = YES;

            }
            else if (x == 2)
            {
                _thirdDayLabel.text = [self getWeekChineseWithNumber:dayWeatherForecast.week.intValue];
                _thirdWeatherLabel.text = [NSString stringWithFormat:@"%@ %@℃～%@℃",dayWeatherForecast.dayWeather,dayWeatherForecast.dayTemp,dayWeatherForecast.nightTemp];
                _thirdWeatherLabel.adjustsFontSizeToFitWidth = YES;
            }
            else
            {
                break;
            }
        }
        _showWeatherButton.userInteractionEnabled = YES;
    }
    else
    {
        [self.view makeToast:@"获取天气信息失败"];
        [self setTitle:@"优快保"];
        _showWeatherButton.userInteractionEnabled = NO;
        return ;
    }
}

- (NSString*)getWeekChineseWithNumber:(int)weekNumber
{
    NSString *weekString = nil;
    
    switch (weekNumber)
    {
        case 1:
        {
            weekString = @"星期一";
        }
            break;
        case 2:
        {
            weekString = @"星期二";
        }
            break;
        case 3:
        {
            weekString = @"星期三";
        }
            break;
        case 4:
        {
            weekString = @"星期四";
        }
            break;
        case 5:
        {
            weekString = @"星期五";
        }
            break;
        case 6:
        {
            weekString = @"星期六";
        }
            break;
        case 7:
        {
            weekString = @"星期天";
        }
            break;
            
        default:
            break;
    }
    
    return weekString;
}

- (void)didShowWeatherButtonTouched:(UIButton*)sender
{
    if (sender.selected)
    {
        sender.selected = NO;
        if ([UIDevice currentDevice].systemVersion.floatValue < 8.0)
        {
            _weatherView.transform = CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT);
            _hideWeatherButton.hidden = YES;
            
        }
        else
        {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 _weatherView.transform = CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT);
                                 _hideWeatherButton.hidden = YES;
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
        }
    }
    else
    {
        sender.selected = YES;
        if ([UIDevice currentDevice].systemVersion.floatValue < 8.0)
        {
            _weatherView.transform = CGAffineTransformIdentity;
            _hideWeatherButton.hidden = NO;

        }
        else
        {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 _weatherView.transform = CGAffineTransformIdentity;
                                 _hideWeatherButton.hidden = NO;
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
        }
        //        NSString *speakString = [NSString stringWithFormat:@"%@ 今日天气 %@",_currentCityLabel.text,_todayWeatherLabel.text];
        //        [Constants speakingWithWords:speakString];
    }
}

- (IBAction)didHideWeatherButtonTouch:(id)sender
{
    _showWeatherButton.selected = NO;
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0)
    {
        _weatherView.transform = CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT);
        _hideWeatherButton.hidden = YES;
        
    }
    else
    {
        [UIView animateWithDuration:0.3
                         animations:^{
                             _weatherView.transform = CGAffineTransformMakeTranslation(0, -SCREEN_HEIGHT);
                             _hideWeatherButton.hidden = YES;

                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }

}





#pragma mark - 登录成功和登出
#pragma mark

- (void)didReceiveLoginSuccessNotification:(NSNotification*)notification
{

    [self setUpMainScrollViewDisplayItem];
}

#pragma mark - 获得城市和系统参数

- (void)didReceviceCityAndCongifNotification:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTELocationLaunchSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceviceCityAndCongifChangeNotification:)
                                                 name:NOTELocationChange
                                               object:nil];
    _pageIndex = 1;
    [_leftButton setTitle:_userCityModel.CITY_NAME forState:UIControlStateNormal];
    [self startRefreshRecommend];
    [self updateDateCityService];
   }

- (void)didReceviceCityAndCongifChangeNotification:(NSNotification*)notification
{
    [MBProgressHUD showMessag:@"刷新首页数据" toView:self.view];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _pageIndex = 1;
    [_leftButton setTitle:_userCityModel.CITY_NAME forState:UIControlStateNormal];
    [self startRefreshRecommend];
    [self updateDateCityService];
    [MainAdvView resetMainAdvView];
    [self updateMainAdvData:^{
        [self openMainAdvOpreation];
    } failRespone:^{
        _advHaveShow = YES;
        _rightButton.hidden = YES;
    }];
}

- (void)setUpMainScrollViewDisplayItem
{
    BOOL showAgent = YES;
    BOOL showExtra = YES;
    BOOL showColorCenter = YES;
    
    if (!_userInfo.member_id)
    {
        showAgent = NO;
    }
    else if (!_agentModel.agent_id || !_agentModel.agent_phone)
    {
        showAgent = NO;
    }
    if (!_userInfo.member_id)
    {
        showExtra = NO;
    }
    else if (_userInfo.insure_user.intValue > 0)
    {
        showExtra = YES;
    }
    else
    {
        showExtra = NO;
    }
    
    [self shouldShowAgentView:showAgent
     andShowExtraFunctionView:showExtra
     andShouldShowColorCenter:showColorCenter];

}

#pragma mark - 切换城市
#pragma mark

- (void)didReceiveCitySettingNotification:(NSNotification*)notification
{
    NSLog(@"%@",notification);
    NSDictionary *resultDic = [DBManager queryCityByCityID:[[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey]];
    
    if (resultDic)
    {
        CityModel *userCity = [[CityModel alloc] initWithDictionary:resultDic];
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:kLastUserCity])
        {
            [[NSUserDefaults standardUserDefaults] setObject:[userCity convertToDictionary]
                                                      forKey:kLastUserCity];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        _pageIndex = 1;
        [self startRefreshRecommend];
        [self updateWeatherInfoWithCityInfo:userCity];

        
    }
    else
    {
        NSLog(@"找不到城市");
    }
}

- (void)logoutSuccess
{
    _advHaveShow = NO;
    _mainAdvModel = nil;
    [MainAdvView resetMainAdvView];
    [self setUpMainScrollViewDisplayItem];
}

- (void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLogoutSuccessNotifaction
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLoginSuccessNotifaction
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
