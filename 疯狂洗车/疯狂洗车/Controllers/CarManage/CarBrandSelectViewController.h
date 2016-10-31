//
//  CarBrandSelectViewController.h
//  优快保
//
//  Created by cts on 15/3/21.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "BaseViewController.h"

@protocol CarBrandSelectDelegate <NSObject>

- (void)didFinishCarBrandSelect:(NSString*)resultString
                     andBrandId:(NSString*)brandIdString
                     andKuanshi:(NSString*)kuanshiString
                       andXilie:(NSString*)xilieString
                    andSeriesId:(NSString*)seriesIdString;


@end

//车辆品牌选择页面
@interface CarBrandSelectViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITableView *_carBrandTableView;
    
    NSMutableArray *_carBrandArray;
    
    
    
    IBOutlet UITableView *_carModelTableView;
    
    IBOutlet UILabel     *_carBrandLabel;
    IBOutlet UIView      *_carModelView;
    
    NSMutableArray *_carModelArray;
    
    IBOutlet UIView      *_carSubModelView;
    IBOutlet UITableView *_carSubModelTableView;
    IBOutlet UILabel     *_carModelLabel;
    
    NSMutableArray *_carSubModelArray;

}

@property (assign, nonatomic) id <CarBrandSelectDelegate> delegate;

@end
