//
//  CarNurseMapViewController.h
//  优快保
//
//  Created by cts on 15/6/11.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import "CarNurseModel.h"
#import "HeaderFooterTableView.h"


@interface ButlerMapViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,UISearchBarDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
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
        
    IBOutlet UIButton *_butlerButton;
    
    IBOutlet UIButton *_goNowLocationButton;
    
    IBOutlet UIButton *_zoomPlusButton;
    
    IBOutlet UIButton *_zoomLessButton;
    
    BOOL                         _isSearching;
    
    BOOL                         _settingCenter;
    
    float                        _lastZoomLevel;

    CarNurseModel               *_selectCarNurse;
    
    BOOL                         _haveMoved;
    
    BOOL                         _canLoadMore;
    
    BOOL                         _isShowTable;
    
    BOOL                         _isShowBulterHelper;
    
    NSInteger                    _pageIndex;
    
    NSInteger                    _pageSize;
    
    NSInteger                    _mapLocationMode;
    
    CLLocationCoordinate2D       _lastCoordinate;
    
    CLLocationCoordinate2D       _centerCoordinate;
    
    NSInteger                    _selectIndex;
    
#pragma mark - 车保姆相关
    
    NSTimer                     *_nannyUpdateTimer;
    
    int                          _nannyUpdateSeconds;
    
    IBOutlet UIView *_carNannyOrderView;

    IBOutlet UIImageView *_carNannyHeader;
    
    IBOutlet UILabel *_carNannyNameLabel;

    IBOutlet UILabel *_nannyCountLabel;
    
    IBOutlet UIButton *_finishNannyButton;
    
    IBOutlet UIButton *_callNannyButton;
}

@property (strong, nonatomic) NSString *service_type;

@property (assign, nonatomic) BOOL      isNannyServicing;

@end
