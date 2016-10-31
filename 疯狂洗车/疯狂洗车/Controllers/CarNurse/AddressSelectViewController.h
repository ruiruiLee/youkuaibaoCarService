//
//  AddressSelectViewController.h
//  优快保
//
//  Created by cts on 15/4/10.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "LocationModel.h"

@protocol AddressSelectDelegate <NSObject>

- (void)didFinishAddressSelect:(LocationModel*)locationModel;

@end

//服务地址选择页面
@interface AddressSelectViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,AMapSearchDelegate,UITextFieldDelegate>
{
    
    IBOutlet UIView      *_searchView;
    IBOutlet UITextField *_searchField;
    
    IBOutlet UITableView *_addressTabelView;
    
    NSMutableArray       *_resultArray;
        
    NSString             *_userAddress;
    
    CLLocationCoordinate2D _userCoordinate;
    
    AMapSearchAPI        *_search;
    
    IBOutlet UIView      *_searchDarkView;
}

@property (assign, nonatomic) id <AddressSelectDelegate> delegate;

@end
