//
//  CarNurseMapViewController.h
//  优快保
//
//  Created by cts on 15/6/11.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import "CarWashModel.h"
#import "HeaderFooterTableView.h"

//旧洗车场地图（已废）
@interface CarWashMapViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,UISearchBarDelegate,UIScrollViewDelegate>
{
    NSMutableArray              *_listDataArray;//列表数组
    
    NSMutableArray              *_mapDataArray;//地图数组
    
    NSMutableArray              *_recentDataArray;//推荐车场数组
    
    NSMutableArray              *_searchResultArray;//搜索车场数组
    
    IBOutlet HeaderFooterTableView *_listTableView;
    
    IBOutlet UIImageView *_emptyImageView;
    
    IBOutlet MKMapView *_mapView;
    
    IBOutlet UIScrollView *_bottomScrollView;
    
    NSMutableArray        *_bottomScrollViewArray;
        
    IBOutlet UIButton *_goNowLocationButton;
    
    IBOutlet UIButton *_zoomPlusButton;
    
    IBOutlet UIButton *_zoomLessButton;
    
    BOOL                         _isSearching;
    
    BOOL                         _settingCenter;
    
    float                        _lastZoomLevel;

    CarWashModel               *_selectCarWash;
    
    BOOL                         _haveMoved;
    
    BOOL                         _canLoadMore;
    
    BOOL                         _isShowTable;
    
    NSInteger                    _pageIndex;
    
    NSInteger                    _pageSize;
    
    NSInteger                    _mapLocationMode;
    
    CLLocationCoordinate2D       _lastCoordinate;
    
    CLLocationCoordinate2D       _centerCoordinate;
    
    NSInteger                    _selectIndex;

}

@property (strong, nonatomic) NSString *service_type;

@end
