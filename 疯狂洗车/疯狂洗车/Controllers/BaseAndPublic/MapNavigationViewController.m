//
//  MapNavigationViewController.m
//  优快保
//
//  Created by cts on 15/7/4.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "MapNavigationViewController.h"
#import "MBProgressHUD+Add.h"
#import "CommonUtility.h"
#import "LineDashPolyline.h"
#import "CLLocation+YCLocation.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface MapNavigationViewController ()
{
    CLLocationCoordinate2D _orginCoordinate;
}

@end

@implementation MapNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _baiduNaviButton.layer.masksToBounds = YES;
    _baiduNaviButton.layer.cornerRadius = 5;
    
    _gaodeNaviButton.layer.masksToBounds = YES;
    _gaodeNaviButton.layer.cornerRadius = 5;
    
    [self setTitle:@"导航"];
    
    _searchAPI = [[AMapSearchAPI alloc] init];
    _searchAPI.delegate = self;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_mapView == nil)
    {
        _mapView = [[MAMapView alloc] initWithFrame:_mapDisplayView.bounds];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;
        [_mapDisplayView addSubview:_mapView];
    }
    
    [_mapView setCenterCoordinate:_publicUserCoordinate];
    [self startRouteNavigation];
}


- (void)startRouteNavigation
{
    CLLocationCoordinate2D targetLocationCoordinate = CLLocationCoordinate2DMake(self.carNurseModel.latitude.doubleValue, self.carNurseModel.longitude.doubleValue);

    MAMapPoint point1 = MAMapPointForCoordinate(targetLocationCoordinate);
    MAMapPoint point2 = MAMapPointForCoordinate(_publicUserCoordinate);
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    if (distance <= 100)
    {
        [MBProgressHUD showSuccess:@"该目标地点离您很近" toView:self.view];
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.carNurseModel.latitude.doubleValue, self.carNurseModel.longitude.doubleValue);
        pointAnnotation.title = self.carNurseModel.short_name;
        pointAnnotation.subtitle = self.carNurseModel.address;
        
        
        MAPointAnnotation *pointAnnotation2 = [[MAPointAnnotation alloc] init];
        pointAnnotation2.coordinate = CLLocationCoordinate2DMake(_publicUserCoordinate.latitude, _publicUserCoordinate.longitude);
        pointAnnotation2.title = @"您的位置";
        pointAnnotation2.subtitle = self.carNurseModel.address;
        
        
        
        [_mapView addAnnotations:@[pointAnnotation,pointAnnotation2]];
        CLLocation  *userLocation = [[CLLocation alloc] initWithLatitude:_publicUserCoordinate.latitude
                                                               longitude:_publicUserCoordinate.longitude];
        CLLocation  *targetLocation = [[CLLocation alloc] initWithLatitude:self.carNurseModel.latitude.doubleValue
                                                                 longitude:self.carNurseModel.longitude.doubleValue];
        
        CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake((userLocation.coordinate.latitude+targetLocation.coordinate.latitude)/2.0,
                                                                             (userLocation.coordinate.longitude+targetLocation.coordinate.longitude)/2.0);
        
        MACoordinateRegion targetRegion = MACoordinateRegionMakeWithDistance(centerCoordinate,800, 800);
        [_mapView setRegion:targetRegion animated:YES];

    }
    else
    {
        [MBProgressHUD showHUDWithText:@"正在为您规划路径"
                                    to:self.view
                              animated:YES];
        
        
        AMapDrivingRouteSearchRequest *naviRequest= [[AMapDrivingRouteSearchRequest alloc] init];
        
        naviRequest.requireExtension = YES;
        naviRequest.origin = [AMapGeoPoint locationWithLatitude:_publicUserCoordinate.latitude longitude:_publicUserCoordinate.longitude];
        naviRequest.destination = [AMapGeoPoint locationWithLatitude:self.carNurseModel.latitude.doubleValue longitude:self.carNurseModel.longitude.doubleValue];
        
        //发起路径搜索
        [_searchAPI AMapDrivingRouteSearch:naviRequest];
    }

}

//实现路径搜索的回调函数
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if(response.route == nil)
    {
        [MBProgressHUD showError:@"路径规划失败" toView:self.view];
        return;
    }
    [MBProgressHUD showSuccess:@"路径规划成功" toView:self.view];
    //通过AMapNavigationSearchResponse对象处理搜索结果
    
    [self addLineToMap:response.route];

}


- (void)addLineToMap:(AMapRoute*)mapRoute
{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.carNurseModel.latitude.doubleValue, self.carNurseModel.longitude.doubleValue);
    pointAnnotation.title = self.carNurseModel.short_name;
    pointAnnotation.subtitle = self.carNurseModel.address;
    
    
    MAPointAnnotation *pointAnnotation2 = [[MAPointAnnotation alloc] init];
    pointAnnotation2.coordinate = CLLocationCoordinate2DMake(_publicUserCoordinate.latitude, _publicUserCoordinate.longitude);
    pointAnnotation2.title = @"您的位置";
    pointAnnotation2.subtitle = self.carNurseModel.address;
    
    
    
    [_mapView addAnnotations:@[pointAnnotation,pointAnnotation2]];
    NSArray *polylines = nil;
    
    polylines = [CommonUtility polylinesForPath:mapRoute.paths[0]];
    
    
    [_mapView addOverlays:polylines];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    
    CLLocation  *userLocation = [[CLLocation alloc] initWithLatitude:_publicUserCoordinate.latitude
                                                           longitude:_publicUserCoordinate.longitude];
    CLLocation  *targetLocation = [[CLLocation alloc] initWithLatitude:self.carNurseModel.latitude.doubleValue
                                                             longitude:self.carNurseModel.longitude.doubleValue];
    
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake((userLocation.coordinate.latitude+targetLocation.coordinate.latitude)/2.0,
                                                                         (userLocation.coordinate.longitude+targetLocation.coordinate.longitude)/2.0);
    
    CLLocationDistance distance = [userLocation distanceFromLocation:targetLocation];
    
    
    MACoordinateRegion targetRegion = MACoordinateRegionMakeWithDistance(centerCoordinate, distance*2, distance*2);
    [_mapView setRegion:targetRegion animated:YES];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        MAPointAnnotation *pointAnnotation = (MAPointAnnotation*)annotation;
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
//        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
//        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
        if ([pointAnnotation.title isEqualToString:@"您的位置"])
        {
            [annotationView setImage:[UIImage imageNamed:@"img_mapNavi_orgin"]];
        }
        else
        {
            [annotationView setImage:[UIImage imageNamed:@"img_mapNavi_destnation"]];
        }
        return annotationView;
    }
    return nil;
}


#pragma mark - MAMapViewDelegate


- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        polylineView.lineWidth   = 6;
        polylineView.strokeColor = [UIColor colorWithRed:79.0/255.0 green:107.0/255.0 blue:253/255.0 alpha:1.0];
        
        return polylineView;
    }
    
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        polylineView.lineWidth   = 6;
        polylineView.strokeColor = [UIColor colorWithRed:79.0/255.0 green:107.0/255.0 blue:253/255.0 alpha:1.0];
        
        return polylineView;
    }
    return nil;
    
}

#pragma mark - 地图操作按钮


- (IBAction)didGoNowLocationButtonTouch:(id)sender
{
    [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
}

- (IBAction)didMapZoomButtonTouch:(UIButton *)sender
{
    if (sender.tag > 0)
    {
        [_mapView setZoomLevel:_mapView.zoomLevel+1 animated:YES];
    }
    else
    {
        [_mapView setZoomLevel:_mapView.zoomLevel-1 animated:YES];
    }
}

#pragma mark - 底部导航按钮

- (IBAction)didBaiduNaviButtonTouch:(id)sender
{
    BOOL hasBaiduMap = NO;
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"baidumap://map/"]])
    {
        hasBaiduMap = YES;
    }
    if (hasBaiduMap)
    {
        CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:_publicUserCoordinate.latitude longitude:_publicUserCoordinate.longitude];
        CLLocation *fixUserLocation = [userLocation locationBaiduFromMars];
        
        CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude:self.carNurseModel.latitude.doubleValue longitude:self.carNurseModel.longitude.doubleValue];
        CLLocation *fixTargetLocation = [targetLocation locationBaiduFromMars];
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving",
                                fixUserLocation.coordinate.latitude,
                                fixUserLocation.coordinate.longitude,
                                fixTargetLocation.coordinate.latitude,
                                fixTargetLocation.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }
    else
    {
        [Constants showMessage:@"请先到AppStore安装百度地图后使用此功能！"];
    }
}

- (IBAction)didGaodeNaviButtonTouch:(id)sender
{
    BOOL hasGaodeMap = NO;
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        hasGaodeMap = YES;
    }
    if (hasGaodeMap)
    {
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&lat=%@&lon=%@&dev=0",@"优快保",
                                @"fengkuangxiche",
                                @"终点",
                                self.carNurseModel.latitude,
                                self.carNurseModel.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }
    else
    {
        [Constants showMessage:@"请先到AppStore安装高德地图后使用此功能！"];
    }

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
