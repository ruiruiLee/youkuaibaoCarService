//
//  OwnerCarNurseView.h
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/15.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "CarNurseView.h"
#import "CarNurseModel.h"
#import "MyCarDetailCell.h"
#import "ServiceIntroduceCell.h"
#import "AddCarsCell.h"
#import "ServiceTypeHeaderView.h"
#import "TQStarRatingView.h"
#import "CarNurseServiceModel.h"
#import "CarNurseInfoCell.h"
#import "QuickRescueCell.h"
#import "ServiceGroupModel.h"
#import "CarServiceSelectHeaderView.h"
#import "ServiceTypeTableViewCell.h"
#import "OwnerStoreCarWashModel.h"
#import "ZHPickView.h"
#import "AddressSelectPopView.h"

#import "BaiduMapAPI_Search/BMKSearchComponent.h"//引入检索功能所有的头文件
#import "BaiduMapAPI_Cloud/BMKCloudSearchComponent.h"//引入云检索功能所有的头文件

@protocol OwnerCarNurseViewDelegate <NSObject>

- (void)didSelectOrAddMoreCar;

- (void)didPayOrderButtonTouched;

- (void)didBookOrderButtonTouched;



//新的



- (void)didCarNurseNaviButtonTouched;

- (void)didCarNursePhoneCallTouched;

- (void)didCarNurseCommentButtonTouched;

- (void)didCarNurseDetailButtonTouched;

- (void)didCarNurseTicketsTouched;

- (void)didCarNurseMapTouched;
- (void)appointWithPrama:(NSDictionary *)dic;


@end

@interface OwnerCarNurseView : UIView<UITableViewDelegate,UITableViewDataSource,ServiceTypeHeaderDelegate,AddCarsCellDelegate,MyCarDetailCellDelegate,CarNurseInfoDelegate,QuickRescueCellDelegate,CarServiceSelectHeaderViewDelegate, ServiceTypeTableViewCellDelegate, ZHPickViewDelegate, UIWebViewDelegate, AddressSelectPopViewDelegate>
{
    
    IBOutlet UITableView *_contextTableView;
    
    IBOutlet UIView      *_submitView;
    
    IBOutlet UIButton    *_appointOnline;
    
    IBOutlet UIButton    *_appointPhone;
    
    NSArray              *_carsArray;
    
    NSRange               _openedServiceRange;
    
    ServiceType  _serviceType;//服务方式
    BOOL _priceEstimate;//0： 关闭 ；1:展开
    
    UIWebView *_priceEstimateWeb;
    
    CGFloat _webViewHeight;
    
    OwnerStoreCarWashModel *_ticketsModel;
    
    NSDate *_appointDateStart;
    
    ZHPickView *_pickview;
    
    NSDate *_dateStart;
    
    BMKPoiInfo *_customerLocation;
    
}

@property (assign, nonatomic) id <OwnerCarNurseViewDelegate> delegate;
@property (assign, nonatomic) NSInteger         pageIndex;

@property (strong, nonatomic) NSString         *servicePrice;

@property (strong, nonatomic) CarNurseModel    *carNurseModel;

@property (strong, nonatomic) CarNurseServiceModel *selectCarServiceModel;

@property (strong, nonatomic) CarInfos         *selectedCar;

@property (strong, nonatomic) NSString         *targetType;

@property (assign, nonatomic) BOOL              is4SService;

@property (nonnull, strong) BMKPoiInfo *customerLocation;



- (void)setDisplayCarNurseInfo:(CarNurseModel*)model withUserCars:(NSArray*)carArray;
- (void)setTickets:(OwnerStoreCarWashModel *)model;
- (ServiceType) getServiceType;

@end
