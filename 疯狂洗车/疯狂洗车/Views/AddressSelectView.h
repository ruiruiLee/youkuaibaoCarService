//
//  AddressSelectView.h
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/23.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityInfoModel.h"

typedef void (^ReturnCarInfoBlock)(CarInfos* info);

@class AddressSelectView;

@protocol AddressSelectViewDelegate <NSObject>

- (void)addressSelectView:(AddressSelectView *) view WithCarInfo:(CarInfos *) car Address:(CityInfoModel *) address;//下预约单
- (void)addressSelectViewCancelAction;
- (void)addressSelectView:(AddressSelectView *) view withBlock:(ReturnCarInfoBlock) block;
- (void)addressSelectView:(AddressSelectView *) view addCarWithBlock:(ReturnCarInfoBlock) block;

@end

@interface AddressSelectView : UIView


@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, strong) IBOutlet UIButton *btnSubmit;
@property (nonatomic, strong) IBOutlet UILabel *lbAddress;
@property (nonatomic, strong) IBOutlet UILabel *lbGPS;
@property (nonatomic, strong) IBOutlet UILabel *lbCarNo;

@property (nonatomic, strong) IBOutlet UILabel *lbAddCar;

@property (nonatomic, weak) id<AddressSelectViewDelegate> delegate;

@property (nonatomic, strong) CityInfoModel *addressInfo;
@property (nonatomic, strong) CarInfos *carInfo;



- (void) show;

- (void) hidden;



@end
