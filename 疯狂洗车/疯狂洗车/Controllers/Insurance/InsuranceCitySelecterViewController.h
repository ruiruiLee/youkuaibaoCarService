//
//  CitySelecterViewController.h
//  优快保
//
//  Created by cts on 15/3/28.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"

#import "OpenCityModel.h"

@protocol InsuranceCitySelecterDelegate <NSObject>

- (void)didFinishCitySelectForCommiting:(OpenCityModel*)result;

- (void)didFinishCitySetting:(OpenCityModel*)result;

@end
//开通保险服务城市选择页面
@interface InsuranceCitySelecterViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITableView *_cityTableView;
    
    NSMutableArray  *_citysArray;
    
    NSMutableArray  *_hotCitysArray;

}

@property (assign, nonatomic) id <InsuranceCitySelecterDelegate> delegate;

@property (assign, nonatomic) BOOL isForCommit;


@property (assign, nonatomic) BOOL forbidBack;

@end
