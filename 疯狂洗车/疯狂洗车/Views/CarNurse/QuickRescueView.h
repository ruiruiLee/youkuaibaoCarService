//
//  CarNurseView.h
//  优快保
//
//  Created by cts on 15/4/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarNurseModel.h"
#import "MyCarDetailCell.h"
#import "ServiceIntroduceCell.h"
#import "AddCarsCell.h"
#import "ServiceTypeHeaderView.h"
#import "TQStarRatingView.h"
#import "CarNurseServiceModel.h"
#import "CarNurseInfoCell.h"
#import "QuickRescueCell.h"


@protocol QuickRescueViewDelegate <NSObject>

- (void)didSelectOrAddMoreCar;

- (void)didPayOrderButtonTouched;

- (void)didBookOrderButtonTouched;



//新的



- (void)didCarNurseNaviButtonTouched;

- (void)didCarNursePhoneCallTouched;

- (void)didCarNurseCommentButtonTouched;




@end

@interface QuickRescueView : UIView<UITableViewDelegate,UITableViewDataSource,ServiceTypeHeaderDelegate,AddCarsCellDelegate,MyCarDetailCellDelegate,CarNurseInfoDelegate,QuickRescueCellDelegate>
{
    
    IBOutlet UITableView *_contextTableView;
    
    IBOutlet UIView      *_submitView;
    
    IBOutlet UIButton    *_rescueButton;
    
    NSArray              *_carsArray;
    
    NSString             *_openedServiceType;
    
    BOOL                  _showMoreService;
    
    int                   _recommendServiceNumber;
    
    int                   _moreServiceNumber;
    
    IBOutlet UILabel     *_priceLabel;

}

@property (assign, nonatomic) id <QuickRescueViewDelegate> delegate;
@property (assign, nonatomic) NSInteger         pageIndex;

@property (strong, nonatomic) NSString         *servicePrice;

@property (strong, nonatomic) CarNurseModel    *carNurseModel;

@property (strong, nonatomic) CarNurseServiceModel *selectCarServiceModel;

@property (strong, nonatomic) CarInfos         *selectedCar;

@property (strong, nonatomic) NSString         *targetType;

@property (assign, nonatomic) BOOL              isForRescue;



- (void)setDisplayCarNurseInfo:(CarNurseModel*)model withUserCars:(NSArray*)carArray;



@end
