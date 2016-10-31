//
//  AddNewCarController.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/28.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"

@protocol AddNewCarDelegate <NSObject>

@optional
- (void)didFinishAddNewCar;

- (void)didFinishEditCar:(CarInfos*)result;

@end

//添加车辆页面
@interface AddNewCarController : BaseViewController
{

    IBOutlet UITextField        *_chepaiField;
    
    IBOutlet UITextField        *_numberField;
    
    IBOutlet UITextField        *_pinpaiField;
        
    IBOutlet UILabel            *_pinpaiCompleteTag;
    
    IBOutlet UIButton           *_submitBtn;
    
    IBOutlet UISegmentedControl *_carTypeSegment;
    
    NSString                    *_car_brand;
    NSString                    *_brand_id;
    NSString                    *_car_kuanshi;
    NSString                    *_car_xilie;
    NSString                    *_series_id;
    
}

@property (nonatomic, strong) CarInfos *carInfo;

@property (assign, nonatomic) id <AddNewCarDelegate> delegate;

@property (assign, nonatomic) BOOL isFromOrder;

@property (assign, nonatomic) BOOL shouldComplete;

@end
