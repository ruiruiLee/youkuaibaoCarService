//
//  CarNurseMapViewController.m
//  优快保
//
//  Created by cts on 15/6/11.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "ButlerMapViewController.h"
#import "MBProgressHUD+Add.h"
#import "CarNurseListCell.h"
#import "UIImageView+WebCache.h"
#import "WebServiceHelper.h"
#import "UIView+Toast.h"
#import <MAMapKit/MAMapKit.h>
#import "NewsMapAnnotation.h"
#import "NewsAnnotationView.h"
#import "NewsBasicMapAnnotation.h"
#import "ButlerAnnotationView.h"
#import "BottomButlerView.h"

//#import "ButlerDetailViewController.h"
#import "CarServiceDetailViewController.h"

#import "DBManager.h"
#import "ButlerListCell.h"
#import "OrderDetailModel.h"
#import "OrderCancelViewController.h"
#import "ButlerMapAnnotation.h"
#import "CarNannyAnnotationView.h"
#import "CarNannyCallOutView.h"
#import "ButlerOrderFinishViewController.h"
#import "ButlerHelperView.h"


@interface ButlerMapViewController ()<BottomButlerDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UISearchBar             *_searchBar;

    UISearchDisplayController   *_searchDisplayController;
    
    BOOL  _isLoading;

    BOOL  _shouldGetAll;
    
    BOOL                  _isLaunching;
    
    BOOL                  _isFixing;
    
    ButlerHelperView     *_butlerHelperView;
}

@end

@implementation ButlerMapViewController

static NSString *butlerListCellIdentifier = @"ButlerListCell";

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName = bIsiOS7?[NSString stringWithFormat:@"%@_7",nibNameOrNil]:nibNameOrNil;
    self = [super initWithNibName:nibName
                           bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _pageIndex = 1;
    _pageSize = 20;
    
    _mapLocationMode = 0;
    
    _shouldGetAll = YES;
    
    _listDataArray = [NSMutableArray array];
    _mapDataArray = [NSMutableArray array];
    _recentDataArray = [NSMutableArray array];
    _bottomScrollViewArray = [NSMutableArray array];
    _searchResultArray = [NSMutableArray array];
    
    [_listTableView addHeaderActionWithTarget:self
                                       action:@selector(startLoadAllCarNurseFromRecent)];
    
    [_listTableView addFooterActionWithTarget:self
                                       action:@selector(loadAllCarNurseFromRecent)];
    
    
    [_listTableView registerNib:[UINib nibWithNibName:butlerListCellIdentifier
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:butlerListCellIdentifier];
    
    

    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.0)];
    [_searchBar setPlaceholder:@"请输入车保姆的名称，关键字"];
    [_searchBar setBackgroundImage:[UIImage imageNamed:@"searchbar_bg"]];
    [_searchBar setDelegate:self];
    [_listTableView setTableHeaderView:_searchBar];
    
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar
                                                                 contentsController:self];
    [_searchDisplayController setDelegate:self];
    [_searchDisplayController.searchResultsTableView setDelegate:self];
    [_searchDisplayController.searchResultsTableView setDataSource:self];
    
    [_searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:butlerListCellIdentifier
                                                                                bundle:[NSBundle mainBundle]]
                                          forCellReuseIdentifier:butlerListCellIdentifier];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    if (self.isNannyServicing)
    {
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 64, 32)];
        [rightBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [rightBtn setTitleColor:[UIColor colorWithRed:137.0/255.0
                                                green:137.0/255.0
                                                 blue:137.0/255.0
                                                alpha:1.0]
                       forState:UIControlStateNormal];
        
        [rightBtn addTarget:self action:@selector(didCancelCurrentNannyOrderTouch) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        [self.navigationItem setRightBarButtonItem:rightItem];
    }
    else
    {
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 36, 32)];
        [rightBtn setTitle:@"列表" forState:UIControlStateNormal];
        [rightBtn setTitle:@"地图" forState:UIControlStateSelected];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [rightBtn setTitleColor:[UIColor colorWithRed:235.0/255.0
                                                green:84.0/255.0
                                                 blue:1.0/255.0
                                                alpha:1.0]
                       forState:UIControlStateNormal];
        
        [rightBtn addTarget:self action:@selector(changeDisplayType:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        [self.navigationItem setRightBarButtonItem:rightItem];
    }

    
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

    //初始化地图
    [_mapView setRotateEnabled:NO];
    _mapView.showsUserLocation = YES;
    
    
    NSDictionary *resultDic = [DBManager queryCityByCityID:[[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey]];
    
    if (resultDic)
    {
        CityModel *userCity = [[CityModel alloc] initWithDictionary:resultDic];
        
        if ([userCity.CITY_ID isEqualToString:_userCityModel.CITY_ID])
        {
            _settingCenter = YES;
            _centerCoordinate =_publicUserCoordinate;
            _overallCoordinate = _centerCoordinate;
            _lastCoordinate = _publicUserCoordinate;
            if (self.isNannyServicing && _userButlerOrder)
            {
                if (_userButlerOrder.latitude.doubleValue == 0 || _userButlerOrder.longitude.doubleValue == 0)
                {
                    float scale = 320.0/SCREEN_WIDTH;
                    
                    [_mapView setRegion:MKCoordinateRegionMakeWithDistance(_centerCoordinate, 6000*scale, 6000*scale)
                               animated:YES];
                }
                else
                {
                    CLLocation  *userLocation = [[CLLocation alloc] initWithLatitude:_publicUserCoordinate.latitude
                                                                           longitude:_publicUserCoordinate.longitude];
                    CLLocation  *targetLocation = [[CLLocation alloc] initWithLatitude:_userButlerOrder.latitude.doubleValue
                                                                             longitude:_userButlerOrder.longitude.doubleValue];
                    
                    CLLocationDistance distance = [userLocation distanceFromLocation:targetLocation];
                    
                    MKCoordinateRegion targetRegion = MKCoordinateRegionMakeWithDistance(_publicUserCoordinate, distance*2, distance*2);
                    [_mapView setRegion:targetRegion animated:YES];
                }


            }
            else
            {
                _isLaunching = YES;
                float scale = 320.0/SCREEN_WIDTH;

                [_mapView setRegion:MKCoordinateRegionMakeWithDistance(_centerCoordinate, 6000*scale, 6000*scale)
                           animated:YES];
                [self obtainCarNurseByRegonAndRound:[self getCurrentMapRound]];
            }

        }
        else
        {
            CLLocationCoordinate2D userCityCoordinate = CLLocationCoordinate2DMake(userCity.LATITUDE.doubleValue, userCity.LONGITUDE.doubleValue);
            MKCoordinateSpan theSpan;
            theSpan.latitudeDelta = 0.05;
            theSpan.longitudeDelta = 0.05;
            MKCoordinateRegion theRegion;
            theRegion.center = userCityCoordinate;
            theRegion.span = theSpan;
            
            _settingCenter = YES;
            _isLaunching = YES;
            _centerCoordinate = userCityCoordinate;
            _overallCoordinate = _centerCoordinate;
            [_mapView setRegion:theRegion animated:YES];
            _haveMoved = YES;
            [self obtainCarNurseByRegonAndRound:[self getCurrentMapRound]];

            
            if (_isShowTable)
            {
                _pageIndex = 1;
                [_listTableView tableViewHeaderBeginRefreshing];
            }
        }
    }
    
    if (!self.isNannyServicing)
    {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"ShouldShowButlerHelper"]<=1 && !_isShowTable && !_isShowBulterHelper)
        {
            NSInteger ShouldShowButlerHelper = [[NSUserDefaults standardUserDefaults] integerForKey:@"ShouldShowButlerHelper"];
            ShouldShowButlerHelper++;
            [[NSUserDefaults standardUserDefaults] setInteger:ShouldShowButlerHelper forKey:@"ShouldShowButlerHelper"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            _isShowBulterHelper = YES;
            [self didButlerHelperButtonTouch:nil];
        }
    }

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didShouldUpdateCenter)
                                                 name:kShouldUpdateCenter
                                               object:nil];
    
    _goNowLocationButton.transform = CGAffineTransformMakeTranslation(0, 140);
    _zoomPlusButton.transform = _zoomLessButton.transform = CGAffineTransformMakeTranslation(0, 140);
    _bottomScrollView.hidden= YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isShowTable)
    {
        
    }
    else
    {
        if (_recentDataArray.count > 0)
        {
            _bottomScrollView.hidden = NO;
        }
    }
    if (self.isNannyServicing)
    {
        if (_mapDataArray.count > 0 || _recentDataArray.count > 0)
        {
            [_mapDataArray removeAllObjects];
            [_recentDataArray removeAllObjects];
            for (id tmpAnnotation in _mapView.annotations)
            {
                if ([tmpAnnotation isKindOfClass:[NewsMapAnnotation class]] || [tmpAnnotation isKindOfClass:[NewsBasicMapAnnotation class]])
                {
                    MKAnnotationView *view = [_mapView viewForAnnotation:tmpAnnotation];
                    [view removeFromSuperview];
                }
            }
            [_mapView removeAnnotations:_mapView.annotations];
            
            if (_userButlerOrder.latitude.doubleValue == 0 || _userButlerOrder.longitude.doubleValue == 0)
            {
                [_mapView setRegion:MKCoordinateRegionMakeWithDistance(_mapView.userLocation.coordinate, 6000, 6000)
                           animated:YES];
            }
            else
            {
                CLLocation  *userLocation = [[CLLocation alloc] initWithLatitude:_publicUserCoordinate.latitude
                                                                       longitude:_publicUserCoordinate.longitude];
                CLLocation  *targetLocation = [[CLLocation alloc] initWithLatitude:_userButlerOrder.latitude.doubleValue
                                                                         longitude:_userButlerOrder.longitude.doubleValue];
                
                CLLocationDistance distance = [userLocation distanceFromLocation:targetLocation];
                
                if (distance < 1000)
                {
                    distance = 1200;
                }
                
                MKCoordinateRegion targetRegion = MKCoordinateRegionMakeWithDistance(_publicUserCoordinate, distance*2, distance*2);
                [_mapView setRegion:targetRegion animated:YES];
            }

        }
        [self shouldShowCarNannyOrderView:YES];
        [self startMSGRefrishTimer];
    }
    else
    {

        if (_carNannyOrderView.hidden == NO)
        {
            [self shouldShowCarNannyOrderView:NO];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _bottomScrollView.hidden = YES;
    if (self.isNannyServicing)
    {
        [self stopMSGRefrishTimer];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

#pragma mark - 点击显示帮助
#pragma mark 

- (IBAction)didButlerHelperButtonTouch:(id)sender
{
    if (_butlerHelperView == nil)
    {
        if (bIsiOS7)
        {
            _butlerHelperView = [[NSBundle mainBundle] loadNibNamed:@"ButlerHelperView_7"
                                                              owner:nil
                                                            options:nil][0];
        }
        else
        {
            _butlerHelperView = [[NSBundle mainBundle] loadNibNamed:@"ButlerHelperView"
                                                              owner:nil
                                                            options:nil][0];
        }

        _butlerHelperView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    
    [_butlerHelperView showButlerHelperView];
}


#pragma mark - 列表的代码
#pragma mark - UITableViewDataSource
#pragma mark

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _searchDisplayController.searchResultsTableView)
    {
        return _searchResultArray.count;
    }
    else
    {
        return _listDataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ButlerListCell *cell = [tableView dequeueReusableCellWithIdentifier:butlerListCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[ButlerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:butlerListCellIdentifier];
    }
    
    CarNurseModel *model = tableView == _searchDisplayController.searchResultsTableView? _searchResultArray[indexPath.row]: _listDataArray[indexPath.row];
    
    
    [cell setDisplayButlerInfo:model];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CarNurseModel *model = tableView == _searchDisplayController.searchResultsTableView? _searchResultArray[indexPath.row]: _listDataArray[indexPath.row];

    CarServiceDetailViewController *viewController = ALLOC_WITH_CLASSNAME(@"CarServiceDetailViewController");
    viewController.selectedCarNurse = model;
    viewController.service_type = self.service_type;
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - 列表获取数据
#pragma mark

- (void)startLoadAllCarNurseFromRecent
{
    _pageIndex = 1;
    _canLoadMore = YES;
    [self loadAllCarNurseFromRecent];
}
- (void)loadAllCarNurseFromRecent
{
    if (!_canLoadMore)
    {
        [_listTableView tableViewfooterEndRefreshing];
        return;
    }
    if (_publicUserCoordinate.longitude == 0 ||_overallCoordinate.longitude == 0 || _overallCoordinate.latitude == 0 || _publicUserCoordinate.latitude == 0||![[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey])
    {
        [Constants showMessage:@"获取不到您的位置信息!"];
        return;
    }
    
    NSDictionary *submitDic = @{@"longitude":[NSNumber numberWithDouble:_publicUserCoordinate.longitude],
                                @"latitude": [NSNumber numberWithDouble:_publicUserCoordinate.latitude],
                                @"target_longitude":@"",
                                @"target_latitude":@"",
                                @"round":@"4",
                                @"service":@"1",
                                @"page_index":[NSNumber numberWithInteger:_pageIndex],
                                @"page_size":[NSNumber numberWithInteger:_pageSize],
                                @"city_id":[[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey],
                                @"service_type":self.service_type};
    
    [WebService requestJsonArrayOperationWithParam:submitDic
                                            action:@"carWash/service/list"
                                        modelClass:[CarNurseModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         if (status.intValue > 0 &&array.count)
         {
             if (_pageIndex == 1)
             {
                 if (_listDataArray.count > 0)
                 {
                     [_listDataArray removeAllObjects];
                 }
                 
                 if (array.count >= _pageSize)
                 {
                     _canLoadMore = YES;
                     _pageIndex++;
                 }
                 else
                 {
                     _canLoadMore = NO;
                 }
                 [_listDataArray addObjectsFromArray:array];
                 [_listTableView reloadData];
                 [_listTableView tableViewHeaderEndRefreshing];
             }
             else
             {
                 if (array.count >= _pageSize)
                 {
                     _canLoadMore = YES;
                     _pageIndex++;
                 }
                 else
                 {
                     _canLoadMore = NO;
                 }
                 [_listTableView tableViewfooterEndRefreshing];
                 [_listDataArray addObjectsFromArray:array];
                 [_listTableView reloadData];
             }
             _emptyImageView.hidden = YES;
         }
         else
         {
             if (_pageIndex == 1)
             {
                 [_listTableView tableViewHeaderEndRefreshing];
                 [self.view makeToast:@"您附近没有车场提供该服务"];
                 _listTableView.hidden = YES;
                 _emptyImageView.hidden = NO;
             }
             else
             {
                 [_listTableView tableViewfooterEndRefreshing];
                 [self.view makeToast:@"没有更多"];
             }
             
         }
         
         
         
     }
                                 exceptionResponse:^(NSError *error)
     {
         [self.view makeToast:@"暂无数据"];
         if (_pageIndex == 1)
         {
             [_listTableView tableViewHeaderEndRefreshing];
         }
         else
         {
             [_listTableView tableViewfooterEndRefreshing];
         }
     }];
}


#pragma mark -
#pragma mark UISearchBar and UISearchDisplayController Delegate Methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self loadAllCarNurseFromKeyWord:searchText];
}

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    _isSearching = YES;
}

- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    _isSearching = YES;
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    _isSearching = NO;
    [_listTableView reloadData];
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    _isSearching = NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return YES;
}

- (void)loadAllCarNurseFromKeyWord:(NSString*)carWashName
{
    _pageIndex = 1;
    _canLoadMore = YES;

    if (_publicUserCoordinate.longitude == 0 ||_overallCoordinate.longitude == 0 || _overallCoordinate.latitude == 0 || _publicUserCoordinate.latitude == 0||![[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey])
    {
        [Constants showMessage:@"获取不到您的位置信息!"];
        return;
    }
    
    NSDictionary *submitDic = @{@"longitude":[NSNumber numberWithDouble:_publicUserCoordinate.longitude],
                                @"latitude": [NSNumber numberWithDouble:_publicUserCoordinate.latitude],
                                @"target_longitude": [NSNumber numberWithDouble:_overallCoordinate.longitude],
                                @"target_latitude": [NSNumber numberWithDouble:_overallCoordinate.latitude],
                                @"round":@"100",
                                @"service":@"1",
                                @"page_index":[NSNumber numberWithInteger:1],
                                @"page_size":[NSNumber numberWithInteger:20],
                                @"city_id":[[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey],
                                @"name":carWashName,
                                @"service_type":self.service_type};
    
    
    [WebService requestJsonArrayOperationWithParam:submitDic
                                            action:@"carWash/service/list"
                                        modelClass:[CarNurseModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         if (status.intValue > 0 &&array.count)
         {
             _searchResultArray = array;
         }
         {
             if (_searchResultArray.count > 0)
             {
                 [_searchResultArray removeAllObjects];
             }
         }
         [_searchDisplayController.searchResultsTableView reloadData];

     }
                                 exceptionResponse:^(NSError *error)
     {
         [self.view makeToast:@"暂无数据"];
     }];
    
}

#pragma mark - 地图的代码
#pragma mark - MKMapViewDelegate
#pragma mark 

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (_mapView.userLocation.coordinate.latitude == 0)
    {
        return;
    }
    if (!_settingCenter)
    {
        _mapLocationMode = 1;
        _settingCenter = YES;
        _isLaunching = YES;

        _centerCoordinate = _mapView.userLocation.coordinate;
        _overallCoordinate = _centerCoordinate;
        
        
        [_mapView setRegion:MKCoordinateRegionMakeWithDistance(_centerCoordinate, 6000, 6000)
                   animated:YES];
        _haveMoved = YES;
        if (_recentDataArray.count > 0)
        {
            [_recentDataArray removeAllObjects];
            [self bottomScrollViewReloadData];
        }

        [self obtainCarNurseByRegonAndRound:[self getCurrentMapRound]];

    }
    else
    {
        if (_mapLocationMode <1)
        {
            return;
        }
        _mapLocationMode = 1;
        NSDictionary *dic = @{@"latitude": [NSNumber numberWithDouble:_mapView.userLocation.coordinate.latitude],
                              @"longitude": [NSNumber numberWithDouble:_mapView.userLocation.coordinate.longitude]};
        [[NSUserDefaults standardUserDefaults] setObject:dic
                                                  forKey:kLocationKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        MAMapPoint point1 = MAMapPointForCoordinate(_lastCoordinate);
        MAMapPoint point2 = MAMapPointForCoordinate(_mapView.userLocation.coordinate);
        //2.计算距离
        CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
        NSLog(@"distance is %f",distance);
        
        _lastCoordinate = _mapView.userLocation.coordinate;
        
        NSString *locationCityID = [[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey];
        
        if (![locationCityID isEqualToString:_userCityModel.CITY_ID])
        {
            
        }
        else
        {
            
            if (distance > 100 && _settingCenter)
            {
                NSLog(@"移动过大刷新地图");
                if (_recentDataArray.count > 0)
                {
                    [_recentDataArray removeAllObjects];
                    [self bottomScrollViewReloadData];
                }
                _haveMoved = YES;
                [self obtainCarNurseByRegonAndRound:[self getCurrentMapRound]];
            }
        }
    }
}


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"didSelectAnnotationView");
    NSLog(@"%@",[view description]);
    
    if ([view.annotation isKindOfClass:[NewsMapAnnotation class]])
    {
        [_mapView deselectAnnotation:view.annotation animated:NO];
        
        
        NewsMapAnnotation *annotation = (NewsMapAnnotation *)view.annotation;
        // annotation.locationInfo;

        CarServiceDetailViewController *viewController = ALLOC_WITH_CLASSNAME(@"CarServiceDetailViewController");
        viewController.selectedCarNurse = (CarNurseModel*)annotation.locationInfo;
        viewController.service_type = self.service_type;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if ([view.annotation isKindOfClass:[NewsBasicMapAnnotation class]])
    {
        [_mapView deselectAnnotation:view.annotation animated:NO];
        
        
        NewsBasicMapAnnotation *annotation = (NewsBasicMapAnnotation *)view.annotation;
        
        CarWashModel *info = annotation.calloutInfo;
        MKCoordinateSpan theSpan;
        theSpan.latitudeDelta = 0.01;
        theSpan.longitudeDelta = 0.01;
        MKCoordinateRegion theRegion;
        CLLocationCoordinate2D center;
        center.latitude = [info.latitude doubleValue];
        center.longitude = [info.longitude doubleValue];
        theRegion.center =  center;
        theRegion.span = theSpan;
        [_mapView setRegion:theRegion animated:YES];
    }
    else
    {
        
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    if (_selectCarNurse != nil)
    {
        for (NSObject *object in _mapView.annotations)
        {
            if ([object isKindOfClass:[NewsMapAnnotation class]])
            {
                NewsMapAnnotation *newsAnnotation = (NewsMapAnnotation*)object;
                ButlerAnnotationView *annotationView = (ButlerAnnotationView *)[_mapView viewForAnnotation:newsAnnotation];
                if (annotationView.annotation.coordinate.latitude == [_selectCarNurse.latitude doubleValue] &&
                    annotationView.annotation.coordinate.longitude == [_selectCarNurse.longitude doubleValue]&&[_selectCarNurse.car_wash_id isEqualToString:newsAnnotation.locationInfo.car_wash_id])
                {
                    
                    [annotationView setCustomAnnotationSelect:YES];
                    annotationView.layer.zPosition = 100;
                }
                else
                {
                    [annotationView setCustomAnnotationSelect:NO];
                    annotationView.layer.zPosition = 2;
                }
            }
            if ([object isKindOfClass:[NewsBasicMapAnnotation class]])
            {
                NewsBasicMapAnnotation *basicAnnotation = (NewsBasicMapAnnotation*)object;
                MKAnnotationView *annotationView = [_mapView viewForAnnotation:basicAnnotation];
                
                if (annotationView.annotation.coordinate.latitude == [_selectCarNurse.latitude doubleValue] &&
                    annotationView.annotation.coordinate.longitude == [_selectCarNurse.longitude doubleValue]&&[_selectCarNurse.car_wash_id isEqualToString:basicAnnotation.calloutInfo.car_wash_id])
                {
                    [annotationView setImage:[UIImage imageNamed:@"map_small_s"]];
                    
                }
                else
                {
                    [annotationView setImage:[UIImage imageNamed:@"map_small"]];
                }
            }
        }
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *NewsAnnReuse=@"BUSREUSE";
    static NSString *CustomReuse=@"CustomReuse";
    static NSString *ButlerReuse=@"ButlerReuse";

    
    //判断是否是当前位置得大头针，然后是否做改动
    if (annotation == mapView.userLocation)
    {
        return nil;
    }
    else if([annotation isKindOfClass:[NewsMapAnnotation class]])
    {
        NewsMapAnnotation *newsAnnotation = (NewsMapAnnotation*)annotation;
        ButlerAnnotationView *annotationView = (ButlerAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:NewsAnnReuse];
        if (!annotationView)
        {
            annotationView = [[ButlerAnnotationView alloc] initWithAnnotation:annotation
                                                               reuseIdentifier:NewsAnnReuse];
            
        }
        [annotationView setDisplayInfo:(CarNurseModel*)newsAnnotation.locationInfo];
        return annotationView;
    }
    else if ([annotation isKindOfClass:[ButlerMapAnnotation class]])
    {
        ButlerMapAnnotation *newsAnnotation = (ButlerMapAnnotation*)annotation;
        
        CarNannyAnnotationView *annotationView = (CarNannyAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:ButlerReuse];
        if (!annotationView)
        {
            annotationView = [[CarNannyAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:ButlerReuse];
            
        }
        [annotationView setDisplayInfo:(ButlerOrderModel*)newsAnnotation.locationInfo];
        [annotationView setImage:[UIImage imageNamed:@"img_carNanny_pin"]];
        return annotationView;
    }
    else
    {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:CustomReuse];
        [annotationView setImage:[UIImage imageNamed:@"map_small"]];
        return annotationView;
    }
    return nil;
}


#pragma mark - 监控位置变化并更新按钮状态

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"%f,%f", _mapView.region.span.latitudeDelta, _mapView.region.span.longitudeDelta);
    NSLog(@"zoom level %ld", (long)[self getZoomLevel:_mapView]);
    
    CLLocationCoordinate2D centerPoint = [mapView convertPoint:CGPointMake(mapView.frame.size.width / 2, mapView.frame.size.height / 2) toCoordinateFromView:mapView];
    
    MAMapPoint point1 = MAMapPointForCoordinate(centerPoint);
    MAMapPoint point2 = MAMapPointForCoordinate(_centerCoordinate);
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    
    
    int currentLevel = (int)[self getZoomLevel:_mapView];
    if (currentLevel >= 17)
    {
        [_zoomPlusButton setEnabled:NO];
        [_zoomLessButton setEnabled:YES];
    }
    else if (currentLevel <= 9)
    {
        [_zoomPlusButton setEnabled:YES];
        [_zoomLessButton setEnabled:NO];
    }
    else
    {
        [_zoomPlusButton setEnabled:YES];
        [_zoomLessButton setEnabled:YES];
    }
    float targetDistance = [self getCurrentMapRound]*1000;
    //float targetDistance = 200*(20-[self getZoomLevel:_mapView]);
    
    if (_lastZoomLevel == 0 )
    {
        _lastZoomLevel = currentLevel;
    }
    else if (currentLevel == _lastZoomLevel && [self lookforCarWashInMapCenter:centerPoint])
    {
        if ([self lookforCarWashInMapCenter:centerPoint])
        {
            
        }
        else
        {
            _lastZoomLevel = currentLevel;
            NSLog(@"该刷新车场了");
            _centerCoordinate = centerPoint;
            _overallCoordinate = _centerCoordinate;
            [self obtainCarNurseByRegonAndRound:[self getCurrentMapRound]];
        }
    }
    else if ( currentLevel - _lastZoomLevel <= -2 || distance >= targetDistance || (currentLevel - _lastZoomLevel < 0 && currentLevel < 14))
    {
        _lastZoomLevel = currentLevel;
        NSLog(@"该刷新车场了");
        _centerCoordinate = centerPoint;
        _overallCoordinate = _centerCoordinate;
        [self obtainCarNurseByRegonAndRound:[self getCurrentMapRound]];
    }
    else if (currentLevel - _lastZoomLevel >= 2  )
    {
        _lastZoomLevel = currentLevel;
        [self setAnnotionsWithList:_mapDataArray];
    }
}

- (BOOL)lookforCarWashInMapCenter:(CLLocationCoordinate2D)targetCenterCoordinate
{
    BOOL result = NO;
    if (_lastZoomLevel < 14)
    {
        return NO;
    }
    else if (_mapDataArray.count > 0)
    {
        int foundOutCarWashNumber = 0;
        float targetDistance = [self getCurrentMapRound]*600;
        for (int x = 0; x<_mapDataArray.count; x++)
        {
            if (foundOutCarWashNumber >= 5)
            {
                result = YES;
                break;
            }
            CarNurseModel *mapCarWash = _mapDataArray[x];
            
            CLLocationCoordinate2D carWashCoordinate = CLLocationCoordinate2DMake(mapCarWash.latitude.doubleValue, mapCarWash.longitude.doubleValue);
            MAMapPoint point1 = MAMapPointForCoordinate(targetCenterCoordinate);
            MAMapPoint point2 = MAMapPointForCoordinate(carWashCoordinate);
            //2.计算距离
            CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
            if ([self checkThisCarWashInViewCenter:carWashCoordinate])
            {
                foundOutCarWashNumber++;
                continue;
            }
            else if (distance <= targetDistance)
            {
                foundOutCarWashNumber ++;
                continue;
                
            }
            else
            {
                continue;
            }
        }
        NSLog(@"foundOutCarWashNumber is %d",foundOutCarWashNumber);
    }
    
    return result;
}

- (BOOL)checkThisCarWashInViewCenter:(CLLocationCoordinate2D)carWashCoordinate
{
    CGPoint annotationPointInView = [_mapView convertCoordinate:carWashCoordinate toPointToView:_mapView];
    if (annotationPointInView.x >= 0 && annotationPointInView.x <SCREEN_WIDTH
        && annotationPointInView.y > SCREEN_HEIGHT/3 && annotationPointInView.y <= SCREEN_HEIGHT*2/3)
    {
        NSLog(@"有这种点");
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - 地图数据读取

- (void)obtainCarNurseByRegonAndRound:(float)roundValue
{
    if (!_settingCenter || _isLoading ||self.isNannyServicing)
    {
        NSLog(@"地图未启动完毕，暂不请求数据");
        return;
    }
    
    if (_publicUserCoordinate.longitude == 0 ||_overallCoordinate.longitude == 0 || _overallCoordinate.latitude == 0 || _publicUserCoordinate.latitude == 0||![[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey])
    {
        [Constants showMessage:@"获取不到您的位置信息!"];
        return;
    }
    
    NSDictionary *submitDic = nil;
    if (roundValue == 0)
    {
        submitDic = @{@"longitude":[NSNumber numberWithDouble:_publicUserCoordinate.longitude],
                      @"latitude": [NSNumber numberWithDouble:_publicUserCoordinate.latitude],
                      @"target_longitude": [NSNumber numberWithDouble:_overallCoordinate.longitude],
                      @"target_latitude": [NSNumber numberWithDouble:_overallCoordinate.latitude],
                      @"round":@"50",
                      @"service":@"1",
                      @"city_id":[[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey],
                      @"service_type":self.service_type};
    }
    else
    {
        submitDic = @{@"longitude":[NSNumber numberWithDouble:_publicUserCoordinate.longitude],
                      @"latitude": [NSNumber numberWithDouble:_publicUserCoordinate.latitude],
                      @"target_longitude": [NSNumber numberWithDouble:_overallCoordinate.longitude],
                      @"target_latitude": [NSNumber numberWithDouble:_overallCoordinate.latitude],
                      @"round":[NSString stringWithFormat:@"%f",roundValue],
                      @"service":@"1",
                      @"city_id":[[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey],
                      @"service_type":self.service_type};
    }
    _isLoading = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebService requestJsonArrayOperationWithParam:submitDic
                                            action:@"carWash/service/list"
                                        modelClass:[CarNurseModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         if (status.intValue > 0 && array.count > 0)
         {
             NSMutableArray *tmpRecentDataArray = [NSMutableArray array];
             BOOL shouldAdd = NO;
             if (_recentDataArray.count == 0)
             {
                 shouldAdd = YES;
             }

             double mixDistance = 0;
             for (int x = 0; x<5; x++)
             {
                 CarNurseModel *addTargrt = nil;
                 for (int y = 0; y<array.count; y++)
                 {
                     if (y == 0)
                     {
                         CarNurseModel *tmpModel = array[y];
                         addTargrt = tmpModel;
                     }
                     else
                     {
                         CarNurseModel *tmpModel = array[y];
                         if (tmpModel.distance.doubleValue < addTargrt.distance.doubleValue && tmpModel.distance.doubleValue > mixDistance)
                         {
                             addTargrt = tmpModel;
                         }
                     }
                 }
                 if (addTargrt && tmpRecentDataArray.count < 5 && addTargrt.distance.doubleValue <= 2.0 && shouldAdd)
                 {
                     mixDistance = addTargrt.distance.doubleValue;
                     [tmpRecentDataArray addObject:addTargrt];
                     [array removeObject:addTargrt];
                 }
                 else
                 {
                     break;
                 }
             }
             if (tmpRecentDataArray.count >= 3)
             {
                 [_recentDataArray addObjectsFromArray:tmpRecentDataArray];
             }
             else
             {
                 int targetCycle = 3-(int)tmpRecentDataArray.count;
                 for (int x = 0; x<targetCycle; x++)
                 {
                     CarNurseModel *addTargrt = nil;
                     for (int y = 0; y<array.count; y++)
                     {
                         if (y == 0)
                         {
                             CarNurseModel *tmpModel = array[y];
                             addTargrt = tmpModel;
                         }
                         else
                         {
                             CarNurseModel *tmpModel = array[y];
                             if (tmpModel.distance.doubleValue < addTargrt.distance.doubleValue)
                             {
                                 addTargrt = tmpModel;
                             }
                         }
                     }
                     if (addTargrt && tmpRecentDataArray.count < 3 && addTargrt.distance.doubleValue <= 5.0&& shouldAdd)
                     {
                         [tmpRecentDataArray addObject:addTargrt];
                         [array removeObject:addTargrt];
                     }
                     else
                     {
                         break;
                     }
                 }
                 if (tmpRecentDataArray.count == 0&& shouldAdd)
                 {
                     [tmpRecentDataArray addObject:array[0]];
                     [array removeObjectAtIndex:0];
                 }
                 if (tmpRecentDataArray.count > 0)
                 {
                     _recentDataArray = tmpRecentDataArray;
                 }
             }
             _mapDataArray = array;
             if (_recentDataArray.count > 0)
             {
                 _goNowLocationButton.transform = CGAffineTransformIdentity;
                 _zoomPlusButton.transform = _zoomLessButton.transform = CGAffineTransformIdentity;
                 if (!_isShowTable)
                 {
                     _bottomScrollView.hidden= NO;
                 }
                 else
                 {
                     _bottomScrollView.hidden= YES;
                 }
                 
             }
             else
             {
                 _goNowLocationButton.transform = CGAffineTransformMakeTranslation(0, 140);
                 _zoomPlusButton.transform = _zoomLessButton.transform = CGAffineTransformMakeTranslation(0, 140);
                 _bottomScrollView.hidden= YES;
             }
             _isLoading = NO;
             [self synMapDataWithRecentData];

         }
         else if (status.intValue > 0 && _recentDataArray.count == 0 &&_shouldGetAll)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             _isLoading = NO;
             _shouldGetAll = NO;
             [self obtainCarNurseByRegonAndRound:0];
         }
         else
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             _isLoading = NO;
         }

         
        }
                                 exceptionResponse:^(NSError *error)
     {
         _isLoading = NO;
         _goNowLocationButton.transform = CGAffineTransformMakeTranslation(0, 140);
         _zoomLessButton.transform = _zoomPlusButton.transform = CGAffineTransformMakeTranslation(0, 140);
         _bottomScrollView.hidden= YES;
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [_listTableView tableViewHeaderEndRefreshing];
         [self.view makeToast:@"暂无数据"];
     }];
}

- (void)synMapDataWithRecentData
{
    for (int x = 0; x< _recentDataArray.count; x++)
    {
        CarNurseModel *recentModel = _recentDataArray[x];
        
        int deleteIndex = -99;
        for (int y = 0; y<_mapDataArray.count; y++)
        {
            CarNurseModel *mapCarWash = _mapDataArray[y];
            if ([mapCarWash.car_wash_id isEqualToString:recentModel.car_wash_id])
            {
                deleteIndex = y;
            }
        }
        if (deleteIndex != -99)
        {
            [_mapDataArray removeObjectAtIndex:deleteIndex];
        }
        else
        {
            continue;
        }
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    
    if (_recentDataArray.count > 0)
    {
        if (_selectCarNurse == nil)
        {
            _selectCarNurse = _recentDataArray[0];
            _selectIndex = 0;
        }
        else
        {
            int dupliceteIndex = -99;
            for (int x = 0; x<_recentDataArray.count; x++)
            {
                CarNurseModel *recentModel = _recentDataArray[x];
                if ([_selectCarNurse.car_wash_id isEqualToString:recentModel.car_wash_id])
                {
                    dupliceteIndex = x;
                    break;
                }
            }
            if (dupliceteIndex < 0)
            {
                _selectCarNurse = _recentDataArray[0];
                _selectIndex = 0;
            }
            else
            {
                _selectIndex = dupliceteIndex;
            }
        }
    }
    
    
    [self setAnnotionsWithList:_mapDataArray];
    [self bottomScrollViewReloadData];

}
-(void)setAnnotionsWithList:(NSArray *)list
{
    if (self.isNannyServicing)
    {
        return;
    }
    if ([self getZoomLevel:_mapView] <= 12)
    {
        NSMutableArray *mutableArr=[[NSMutableArray alloc]init];
        for (NSInteger i = [_mapDataArray count] - 1; i > -1; i --)
        {
            CarNurseModel *data = [_mapDataArray objectAtIndex:i];
            CLLocationDegrees latitude = [data.latitude doubleValue];
            CLLocationDegrees longitude = [data.longitude doubleValue];
            NewsBasicMapAnnotation *basicMapAnnotation=[[NewsBasicMapAnnotation alloc] initWithLatitude:latitude
                                                                                           andLongitude:longitude];
            basicMapAnnotation.calloutInfo = data;
            [mutableArr addObject:basicMapAnnotation];
        }
        if (_recentDataArray.count > 0)
        {
            for (NSInteger i = [_recentDataArray count] - 1; i > -1; i --)
            {
                CarNurseModel *data = [_recentDataArray objectAtIndex:i];
                CLLocationDegrees latitude = [data.latitude doubleValue];
                CLLocationDegrees longitude = [data.longitude doubleValue];
                NewsBasicMapAnnotation *basicMapAnnotation=[[NewsBasicMapAnnotation alloc] initWithLatitude:latitude
                                                                                               andLongitude:longitude];
                basicMapAnnotation.calloutInfo = data;
                [mutableArr addObject:basicMapAnnotation];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           for (id tmpAnnotation in _mapView.annotations)
                           {
                               if ([tmpAnnotation isKindOfClass:[NewsMapAnnotation class]] || [tmpAnnotation isKindOfClass:[NewsBasicMapAnnotation class]])
                               {
                                   MKAnnotationView *view = [_mapView viewForAnnotation:tmpAnnotation];
                                   [view removeFromSuperview];
                               }
                           }
                           [_mapView removeAnnotations:_mapView.annotations];
                           [_mapView addAnnotations:mutableArr];
                           if (_isLaunching)
                           {
                               _isLaunching = NO;
                               if (_recentDataArray.count > 0)
                               {
                                   CarNurseModel *model = _recentDataArray[0];
                                   if (model.distance.floatValue > 2)
                                   {
                                       [self fixedMapCarnurseDisplay:model];
                                   }
                               }
                               else if (_mapDataArray.count > 0)
                               {
                                   CarNurseModel *model = _mapDataArray[0];
                                   if (model.distance.floatValue > 2)
                                   {
                                       [self fixedMapCarnurseDisplay:model];
                                   }
                               }
                           }
                       });
    }
    else
    {
        NSMutableArray *mutableArr=[[NSMutableArray alloc]init];
        for (NSInteger i = [_mapDataArray count] - 1; i > -1; i --)
        {
            CarNurseModel *data = [_mapDataArray objectAtIndex:i];
            CLLocationDegrees latitude = [data.latitude doubleValue];
            CLLocationDegrees longitude = [data.longitude doubleValue];
            NewsMapAnnotation *basicMapAnnotation=[[NewsMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
            basicMapAnnotation.locationInfo = data;
            [mutableArr addObject:basicMapAnnotation];
        }
        if (_recentDataArray.count > 0)
        {
            for (NSInteger i = [_recentDataArray count] - 1; i > -1; i --)
            {
                CarNurseModel *data = [_recentDataArray objectAtIndex:i];
                CLLocationDegrees latitude = [data.latitude doubleValue];
                CLLocationDegrees longitude = [data.longitude doubleValue];
                NewsMapAnnotation *basicMapAnnotation=[[NewsMapAnnotation alloc] initWithLatitude:latitude andLongitude:longitude];
                basicMapAnnotation.locationInfo = data;
                [mutableArr addObject:basicMapAnnotation];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           for (id tmpAnnotation in _mapView.annotations)
                           {
                               if ([tmpAnnotation isKindOfClass:[NewsMapAnnotation class]] || [tmpAnnotation isKindOfClass:[NewsBasicMapAnnotation class]])
                               {
                                   MKAnnotationView *view = [_mapView viewForAnnotation:tmpAnnotation];
                                   [view removeFromSuperview];
                               }
                           }
                           [_mapView removeAnnotations:_mapView.annotations];
                           [_mapView addAnnotations:mutableArr];
                           if (_isLaunching)
                           {
                               _isLaunching = NO;
                               if (_recentDataArray.count > 0)
                               {
                                   CarNurseModel *model = _recentDataArray[0];
                                   if (model.distance.floatValue > 2)
                                   {
                                       [self fixedMapCarnurseDisplay:model];
                                   }
                               }
                               else if (_mapDataArray.count > 0)
                               {
                                   CarNurseModel *model = _mapDataArray[0];
                                   if (model.distance.floatValue > 2)
                                   {
                                       [self fixedMapCarnurseDisplay:model];
                                   }
                               }
                           }
                           
                       });
    }
}

- (void)fixedMapCarnurseDisplay:(CarNurseModel*)carNurseModel
{
    if (carNurseModel.latitude.doubleValue == 0 || carNurseModel.longitude.doubleValue == 0)
    {
        return;
    }
    _isFixing = YES;
    if ([_userCityModel.CITY_ID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kLocationCityIDKey]])
    {
        CLLocation  *userLocation = [[CLLocation alloc] initWithLatitude:_publicUserCoordinate.latitude
                                                                longitude:_publicUserCoordinate.longitude];
        CLLocation  *targetLocation = [[CLLocation alloc] initWithLatitude:carNurseModel.latitude.doubleValue
                                                                 longitude:carNurseModel.longitude.doubleValue];
        
        CLLocationDistance distance = [userLocation distanceFromLocation:targetLocation];
        
        
        MKCoordinateRegion targetRegion = MKCoordinateRegionMakeWithDistance(_publicUserCoordinate, distance*2+1000, distance*2+1000);
        [_mapView setRegion:targetRegion animated:YES];
    }
    else
    {
        _centerCoordinate = CLLocationCoordinate2DMake([carNurseModel.latitude doubleValue],
                                                       [carNurseModel.longitude doubleValue]);
        
        [_mapView setRegion:MKCoordinateRegionMakeWithDistance(_centerCoordinate, 6000, 6000)
                   animated:YES];
    }

    
}

#define MERCATOR_RADIUS 85445659.44705395


- (NSInteger)getZoomLevel:(MKMapView*)mapView
{
    
    return 21-round(log2(_mapView.region.span.longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * _mapView.bounds.size.width)));
    
}

- (void)setZoomLevel:(NSInteger)level
{
    
}

#pragma mark - 得到地图登记

- (double)getCurrentMapRound
{
    CLLocationCoordinate2D centerPoint = [_mapView convertPoint:CGPointMake(_mapView.frame.size.width / 2, _mapView.frame.size.height / 2) toCoordinateFromView:_mapView];
    CLLocationCoordinate2D orginPoint = [_mapView convertPoint:CGPointMake(0,0) toCoordinateFromView:_mapView];
    
    
    MAMapPoint point1 = MAMapPointForCoordinate(centerPoint);
    MAMapPoint point2 = MAMapPointForCoordinate(orginPoint);
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    NSLog(@"getCurrentMapRound %f",distance);
    return distance/1000.0;
}

#pragma mark - 定位到当前位置

- (IBAction)goToNowLocation:(id)sender
{
    if (_mapView.userLocation.coordinate.latitude <= 0 ||_mapView.userLocation.coordinate.longitude <= 0)
    {
        return;
    }

    [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];

}

#pragma mark － 从后台切换至前台使用

- (void)didShouldUpdateCenter
{

    
}

#pragma mark - 缩放加

- (IBAction)zoomPlus:(id)sender
{
    CLLocationCoordinate2D theSpan = _mapView.region.center;
    [self setCenterCoordinate:theSpan
                    zoomLevel:[self getZoomLevel:_mapView] + 1
                     animated:YES];
}

#pragma mark - 缩放减

- (IBAction)zoomLess:(id)sender
{
    CLLocationCoordinate2D theSpan = _mapView.region.center;
    [self setCenterCoordinate:theSpan
                    zoomLevel:[self getZoomLevel:_mapView] - 2
                     animated:YES];
}

#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395

- (double)longitudeToPixelSpaceX:(double)longitude
{
    return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0);
}

- (double)latitudeToPixelSpaceY:(double)latitude
{
    return round(MERCATOR_OFFSET - MERCATOR_RADIUS * logf((1 + sinf(latitude * M_PI / 180.0)) / (1 - sinf(latitude * M_PI / 180.0))) / 2.0);
}

- (double)pixelSpaceXToLongitude:(double)pixelX
{
    return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI;
}

- (double)pixelSpaceYToLatitude:(double)pixelY
{
    return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI;
}

#pragma mark -
#pragma mark Helper methods

- (MKCoordinateSpan)coordinateSpanWithMapView:(MKMapView *)mapView
                             centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                 andZoomLevel:(NSUInteger)zoomLevel
{
    // convert center coordiate to pixel space
    double centerPixelX = [self longitudeToPixelSpaceX:centerCoordinate.longitude];
    double centerPixelY = [self latitudeToPixelSpaceY:centerCoordinate.latitude];
    
    // determine the scale value from the zoom level
    NSInteger zoomExponent = 20 - zoomLevel;
    double zoomScale = pow(2, zoomExponent);
    
    // scale the map’s size in pixel space
    CGSize mapSizeInPixels = mapView.bounds.size;
    double scaledMapWidth = mapSizeInPixels.width * zoomScale;
    double scaledMapHeight = mapSizeInPixels.height * zoomScale;
    
    // figure out the position of the top-left pixel
    double topLeftPixelX = centerPixelX - (scaledMapWidth / 2);
    double topLeftPixelY = centerPixelY - (scaledMapHeight / 2);
    
    // find delta between left and right longitudes
    CLLocationDegrees minLng = [self pixelSpaceXToLongitude:topLeftPixelX];
    CLLocationDegrees maxLng = [self pixelSpaceXToLongitude:topLeftPixelX + scaledMapWidth];
    CLLocationDegrees longitudeDelta = maxLng - minLng;
    
    // find delta between top and bottom latitudes
    CLLocationDegrees minLat = [self pixelSpaceYToLatitude:topLeftPixelY];
    CLLocationDegrees maxLat = [self pixelSpaceYToLatitude:topLeftPixelY + scaledMapHeight];
    CLLocationDegrees latitudeDelta = -1 * (maxLat - minLat);
    
    // create and return the lat/lng span
    MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
    return span;
}

#pragma mark -
#pragma mark Public methods

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated
{
    // clamp large numbers to 28
    zoomLevel = MIN(zoomLevel, 28);
    
    // use the zoom level to compute the region
    MKCoordinateSpan span = [self coordinateSpanWithMapView:_mapView
                                           centerCoordinate:centerCoordinate
                                               andZoomLevel:zoomLevel];
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    
    // set the region like normal
    [_mapView setRegion:region animated:animated];
}

#pragma mark - 地图和列表显示切换

- (void)changeDisplayType:(UIButton *)sender
{
    if (_isShowTable)
    {
        _isShowTable = NO;
        sender.selected = NO;
        [_mapView setHidden:NO];
        [_goNowLocationButton setHidden:NO];
        _zoomLessButton.hidden = NO;
        _zoomPlusButton.hidden = NO;
        
        _emptyImageView.hidden = YES;
        [_listTableView setHidden:YES];
        _bottomScrollView.hidden = NO;
        _butlerButton.hidden = NO;
        
        
        //[self obtainAllCarWashByRegon];
    }
    else
    {
        _pageIndex = 1;
        _isShowTable = YES;
        sender.selected = YES;
        [_mapView setHidden:YES];
        [_goNowLocationButton setHidden:YES];
        
        [_listTableView setHidden:NO];
        _bottomScrollView.hidden = YES;
        _zoomLessButton.hidden = YES;
        _zoomPlusButton.hidden = YES;
        _butlerButton.hidden = YES;
    
        
        [_listTableView tableViewHeaderBeginRefreshing];
    }
}

#pragma mark - 底部推荐列表
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_recentDataArray.count == 0)
    {
        return;
    }
    if (scrollView == _bottomScrollView)
    {
        NSInteger index = scrollView.contentOffset.x / _bottomScrollView.frame.size.width;
        _selectIndex = index;
        CarNurseModel *info = _recentDataArray[index];
        
        _selectCarNurse = info;
        for (NSObject *object in _mapView.annotations)
        {
            if ([object isKindOfClass:[NewsMapAnnotation class]])
            {
                NewsMapAnnotation *newsAnnotation = (NewsMapAnnotation*)object;
                ButlerAnnotationView *annotationView = (ButlerAnnotationView *)[_mapView viewForAnnotation:newsAnnotation];
                if (annotationView.annotation.coordinate.latitude == [info.latitude doubleValue] &&
                    annotationView.annotation.coordinate.longitude == [info.longitude doubleValue]
                    &&[_selectCarNurse.car_wash_id isEqualToString:newsAnnotation.locationInfo.car_wash_id])
                {
                    
                    [annotationView setCustomAnnotationSelect:YES];
                    annotationView.layer.zPosition = 100;
                }
                else
                {
                    [annotationView setCustomAnnotationSelect:NO];
                    annotationView.layer.zPosition = 2;
                }
            }
            if ([object isKindOfClass:[NewsBasicMapAnnotation class]])
            {
                NewsBasicMapAnnotation *basicAnnotation = (NewsBasicMapAnnotation*)object;
                MKAnnotationView *annotationView = [_mapView viewForAnnotation:basicAnnotation];
                
                if (annotationView.annotation.coordinate.latitude == [_selectCarNurse.latitude doubleValue] &&
                    annotationView.annotation.coordinate.longitude == [_selectCarNurse.longitude doubleValue]&&[_selectCarNurse.car_wash_id isEqualToString:basicAnnotation.calloutInfo.car_wash_id])
                {
                    [annotationView setImage:[UIImage imageNamed:@"map_small_s"]];
                    
                }
                else
                {
                    [annotationView setImage:[UIImage imageNamed:@"map_small"]];
                }
            }
        }
        
        _centerCoordinate = CLLocationCoordinate2DMake([info.latitude doubleValue],
                                                       [info.longitude doubleValue]);
        
        [_mapView setRegion:MKCoordinateRegionMakeWithDistance(_centerCoordinate, 6000, 6000)
                   animated:YES];
    }
}

- (void)bottomScrollViewReloadData
{
    if (_recentDataArray.count > 0)
    {
        
        for (int x = 0; x<_recentDataArray.count; x++)
        {
            if (_bottomScrollViewArray.count == 0)
            {
                BottomButlerView *bottomCarWashView = nil;
                if (SCREEN_WIDTH < 375)
                {
                    bottomCarWashView = [[NSBundle mainBundle] loadNibNamed:@"BottomButlerView_4" owner:self options:nil][0];
                }
                else
                {
                    bottomCarWashView = [[NSBundle mainBundle] loadNibNamed:@"BottomButlerView" owner:self options:nil][0];
                }
                
                bottomCarWashView.frame = CGRectMake(10, 0, SCREEN_WIDTH-34, 170);
                CarNurseModel *model = _recentDataArray[x];
                
                [bottomCarWashView setDisplayCarNurseInfo:model];

                bottomCarWashView.delegate = self;
                bottomCarWashView.itemIndex = x;

                [_bottomScrollView addSubview:bottomCarWashView];
                [_bottomScrollViewArray addObject:bottomCarWashView];
                continue;
            }
            if (x > _bottomScrollViewArray.count - 1)
            {
                BottomButlerView *bottomCarWashView = nil;
                if (SCREEN_WIDTH < 375)
                {
                    bottomCarWashView = [[NSBundle mainBundle] loadNibNamed:@"BottomButlerView_4" owner:self options:nil][0];
                }
                else
                {
                    bottomCarWashView = [[NSBundle mainBundle] loadNibNamed:@"BottomButlerView" owner:self options:nil][0];
                }
                
                bottomCarWashView.frame = CGRectMake(x*_bottomScrollView.frame.size.width+10, 0, SCREEN_WIDTH-34, 170);
                CarNurseModel *model = _recentDataArray[x];
                
                [bottomCarWashView setDisplayCarNurseInfo:model];


                bottomCarWashView.delegate = self;
                bottomCarWashView.itemIndex = x;
                [_bottomScrollView addSubview:bottomCarWashView];
                [_bottomScrollViewArray addObject:bottomCarWashView];
            }
            else
            {
                BottomButlerView *bottomCarWashView = _bottomScrollViewArray[x];
                CarNurseModel *model = _recentDataArray[x];
                [bottomCarWashView setDisplayCarNurseInfo:model];
                
                bottomCarWashView.delegate = self;
                bottomCarWashView.itemIndex = x;
                if (x == _recentDataArray.count -1 )
                {
                    NSMutableArray *removeArray = [NSMutableArray array];
                    for (int y = x + 1 ; y < _bottomScrollViewArray.count; y++)
                    {
                        BottomButlerView *bottomCarWashView = _bottomScrollViewArray[y];
                        [removeArray addObject:bottomCarWashView];
                    }
                    
                    if (removeArray.count > 0)
                    {
                        for (int z = 0; z<removeArray.count; z++)
                        {
                            BottomButlerView *bottomCarWashView = removeArray[z];
                            [bottomCarWashView removeFromSuperview];
                            
                        }
                        [_bottomScrollViewArray removeObjectsInRange:NSMakeRange(x+1, removeArray.count)];
                    }
                    
                    
                }
            }
        }
        [_bottomScrollView setContentSize:CGSizeMake(_bottomScrollView.frame.size.width*_bottomScrollViewArray.count, _bottomScrollView.frame.size.height)];
        [_bottomScrollView setContentOffset:CGPointMake(_selectIndex*_bottomScrollView.frame.size.width, 0)];
        if (_isShowTable)
        {
            _goNowLocationButton.transform = CGAffineTransformIdentity;
            _zoomPlusButton.transform = _zoomLessButton.transform = CGAffineTransformIdentity;
            _bottomScrollView.hidden= YES;
        }
        else
        {
            _goNowLocationButton.transform = CGAffineTransformIdentity;
            _zoomPlusButton.transform = _zoomLessButton.transform = CGAffineTransformIdentity;
            _bottomScrollView.hidden= NO;
        }
        
    }
    else
    {
        if (_bottomScrollViewArray.count > 0)
        {
            for (BottomButlerView *view in _bottomScrollViewArray)
            {
                [view removeFromSuperview];
            }
            
            [_bottomScrollViewArray removeAllObjects];
        }
        _goNowLocationButton.transform = CGAffineTransformMakeTranslation(0, 140);
        _zoomPlusButton.transform = _zoomLessButton.transform = CGAffineTransformMakeTranslation(0, 140);
        _bottomScrollView.hidden= YES;
        
    }
}

#pragma mark - BottomCarNurseDelegate Method

- (void)didOrderButtonTouched:(NSInteger)index shouldOrderTime:(BOOL)isOrderTime
{
    if (_recentDataArray.count > 0)
    {
        CarServiceDetailViewController *controller = ALLOC_WITH_CLASSNAME(@"CarServiceDetailViewController");
        controller.selectedCarNurse = _recentDataArray[index];
        controller.service_type = self.service_type;
        //controller.isEditTime = isOrderTime;
        [self.navigationController pushViewController:controller
                                             animated:YES];
    }
    else
    {
        [self.view makeToast:@"没有车场数据"];
        return;
    }
}

#pragma mark - 下面是关于车保姆已下单的代码
#pragma mark 

#pragma mark - 完成订单

- (IBAction)didNannyFinishButtonTouch:(id)sender
{
    if (![_userButlerOrder.nanny_state isEqualToString:@"2"] && _userButlerOrder)
    {
        ButlerOrderFinishViewController *viewController = nil;
        
        if (SCREEN_HEIGHT <= 480)
        {
            viewController = [[ButlerOrderFinishViewController alloc] initWithNibName:@"ButlerOrderFinishViewController_4s"
                                                                               bundle:nil];

        }
        else
        {
            viewController = [[ButlerOrderFinishViewController alloc] initWithNibName:@"ButlerOrderFinishViewController"
                                                                               bundle:nil];

        }
        viewController.backEnable = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


#pragma mark - 取消订单

- (void)didCancelCurrentNannyOrderTouch
{
    OrderDetailModel *info = [[OrderDetailModel alloc] init];
    info.order_id = _userButlerOrder.order_id;
    info.out_trade_no = @"";
    info.car_wash_id = _userButlerOrder.car_wash_id;
    info.member_id = _userInfo.member_id;
    info.car_id = @"";
    info.pay_type = @"";
    info.pay_money = @"";
    
    OrderCancelViewController *viewController = [[OrderCancelViewController alloc] initWithNibName:@"OrderCancelViewController" bundle:nil];
    viewController.orderModel = info;
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 457 && buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", _userButlerOrder.admin_phone]]];
    }
}


#pragma mark - 拨打车保姆电话

- (IBAction)didCallCurrentNannyOrderTouch
{
    if ([Constants canMakePhoneCall])
    {
        [Constants showMessage:@"确认联系该车保姆"
                      delegate:self
                           tag:457
                  buttonTitles:@"取消",@"确定", nil];
    }
    else
    {
        [Constants showMessage:@"您的设备无法拨打电话"];
    }

}


#pragma mark - 切换状态

- (void)shouldShowCarNannyOrderView:(BOOL)should
{
    if (should)
    {
        self.isNannyServicing = YES;
        _goNowLocationButton.transform = CGAffineTransformMakeTranslation(0, 80);
        _zoomPlusButton.transform = _zoomLessButton.transform = CGAffineTransformMakeTranslation(0, 80);
        _bottomScrollView.hidden= YES;
        _carNannyOrderView.hidden = NO;
        _carNannyNameLabel.text = _userButlerOrder.name;
        _zoomPlusButton.hidden = NO;
        _zoomLessButton.hidden = NO;
        _goNowLocationButton.hidden = NO;
        
        if (SCREEN_WIDTH < 375)
        {
            _nannyCountLabel.font = [UIFont systemFontOfSize:10];
            _carNannyNameLabel.font = [UIFont systemFontOfSize:12];
        }
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 64, 32)];
        [rightBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [rightBtn setTitleColor:[UIColor colorWithRed:137.0/255.0
                                                green:137.0/255.0
                                                 blue:137.0/255.0
                                                alpha:1.0]
                       forState:UIControlStateNormal];
        
        [rightBtn addTarget:self action:@selector(didCancelCurrentNannyOrderTouch) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        [self.navigationItem setRightBarButtonItem:rightItem];

        if (_isShowTable)
        {
            _emptyImageView.hidden = YES;
            [_listTableView setHidden:YES];
        }
        if (_recentDataArray.count > 0)
        {
            [_recentDataArray removeAllObjects];
            [self bottomScrollViewReloadData];
        }
        
        _mapView.hidden = NO;
        _butlerButton.hidden = YES;
        _nannyCountLabel.text = [NSString stringWithFormat:@"服务次数：%d次",_userButlerOrder.service_count.intValue];
        _carNannyHeader.layer.masksToBounds = YES;
        _carNannyHeader.layer.cornerRadius = 65.0/2.0;
        
        _callNannyButton.layer.masksToBounds = YES;
        _callNannyButton.layer.cornerRadius = 55/2.0;
        
        _finishNannyButton.layer.masksToBounds = YES;
        _finishNannyButton.layer.cornerRadius = 55/2.0;

        [_carNannyHeader sd_setImageWithURL:[NSURL URLWithString:_userButlerOrder.logo]
                     placeholderImage:[UIImage imageNamed:@"img_carNanny_defauly_serving"]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             if (error == nil)
             {
                 [_carNannyHeader setImage:[Constants imageByScalingAndCroppingForSize:CGSizeMake(85, 85) withTarget:image]];
             }
         }];

    }
    else
    {
        if (_carNannyOrderView.hidden == NO)
        {
            [_mapView removeAnnotations:_mapView.annotations];
            [_mapView reloadInputViews];
        }
        [self stopMSGRefrishTimer];
        self.isNannyServicing = NO;
        _carNannyOrderView.hidden = YES;
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 36, 32)];
        [rightBtn setTitle:@"列表" forState:UIControlStateNormal];
        [rightBtn setTitle:@"地图" forState:UIControlStateSelected];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [rightBtn setTitleColor:[UIColor colorWithRed:205.0/255.0
                                                green:85.0/255.0
                                                 blue:20.0/255.0
                                                alpha:1.0] forState:UIControlStateNormal];
        
        [rightBtn addTarget:self action:@selector(changeDisplayType:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        [self.navigationItem setRightBarButtonItem:rightItem];
        [self obtainCarNurseByRegonAndRound:[self getCurrentMapRound]];
    }
}

#pragma mark - 更新信息

- (void)startMSGRefrishTimer
{
    if ([_nannyUpdateTimer isValid])
    {
        [_nannyUpdateTimer invalidate];
    }

    _nannyUpdateSeconds = 0;
    _nannyUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                        target:self
                                                      selector:@selector(beginTimingRecord)
                                                      userInfo:nil
                                                       repeats:YES];
}



- (void)beginTimingRecord
{
    if (_nannyUpdateSeconds>0)
    {
        _nannyUpdateSeconds--;
    }
    else
    {
        NSLog(@"刷新车保姆信息");
        if (!_userInfo.member_id)
        {
            [self stopMSGRefrishTimer];
        }
        else
        {
            NSDictionary *submitDic = @{@"member_id":_userInfo.member_id,
                                        @"longitude":[NSNumber numberWithDouble:_publicUserCoordinate.longitude],
                                        @"latitude":[NSNumber numberWithDouble:_publicUserCoordinate.latitude]};
            [WebService requestJsonModelWithParam:submitDic
                                           action:@"order/service/getNannyOrder"
                                       modelClass:[ButlerOrderModel class]
                                   normalResponse:^(NSString *status, id data, JsonBaseModel *model)
             {
                 if (status.intValue > 0 && ![data isEqual:@{}])
                 {
                     _userButlerOrder = (ButlerOrderModel*)model;
                     [self updateCarNannyAnnotationInfo];
                     if ([_userButlerOrder.nanny_state isEqualToString:@"2"])
                     {
                         ButlerOrderFinishViewController *viewController = nil;
                         
                         if (SCREEN_HEIGHT <= 480)
                         {
                             viewController = [[ButlerOrderFinishViewController alloc] initWithNibName:@"ButlerOrderFinishViewController_4s"
                                                                                                bundle:nil];
                             
                         }
                         else
                         {
                             viewController = [[ButlerOrderFinishViewController alloc] initWithNibName:@"ButlerOrderFinishViewController"
                                                                                                bundle:nil];
                             
                         }
                         [self.navigationController pushViewController:viewController animated:YES];
                     }

                 }
                 else if (status.intValue > 0)
                 {
                     _userButlerOrder = nil;
                     [self shouldShowCarNannyOrderView:NO];
                 }
                 else
                 {
                     [MBProgressHUD showError:@"更新车保姆信息失败" toView:self.view];
                 }
             }
                                exceptionResponse:^(NSError *error)
            {
                                    
                                    [MBProgressHUD showError:@"更新车保姆信息失败" toView:self.view];
            }];

            _nannyUpdateSeconds = 30;
            
        }
        
    }
}

- (void)stopMSGRefrishTimer
{
    if ([_nannyUpdateTimer isValid])
    {
        [_nannyUpdateTimer invalidate];
    }
}

- (void)updateCarNannyAnnotationInfo
{
//    double distanceValue = _userButlerOrder.distance.doubleValue;
//    if (distanceValue >= 1000)
//    {
//        _carNannyDistanceLabel.adjustsFontSizeToFitWidth = YES;
//        [_carNannyDistanceLabel  setText:@"大于1000km"];
//    }
//    else if (distanceValue >= 1)
//    {
//        [_carNannyDistanceLabel setText:[NSString stringWithFormat:@"距离：%dkm", (int)distanceValue]];
//    }
//    else
//    {
//        [_carNannyDistanceLabel  setText:[NSString stringWithFormat:@"距离：%.2fm", distanceValue*1000]];
//    }

    NSMutableArray *targetArray = [NSMutableArray array];
    for (int x = 0; x<_mapView.annotations.count; x++)
    {
        id target = _mapView.annotations[x];
        
        if ([target isKindOfClass:[ButlerMapAnnotation class]])
        {
            [targetArray addObject:target];
        }
    }
    
    [_mapView removeAnnotations:targetArray];

    ButlerMapAnnotation *basicMapAnnotation=[[ButlerMapAnnotation alloc] initWithLatitude:_userButlerOrder.latitude.doubleValue
                                                
                                                                                   andLongitude:_userButlerOrder.longitude.doubleValue];
    
    basicMapAnnotation.locationInfo = _userButlerOrder;
    
    [_mapView addAnnotation:basicMapAnnotation];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kShouldUpdateCenter object:nil];
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
