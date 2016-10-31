//
//  CarSelectView.h
//  优快保
//
//  Created by Darsky on 15/2/7.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarInfos.h"


@protocol CarSelectViewDelegate <NSObject>

- (void)didAddButtonTouched;

- (void)didSelectACar:(CarInfos*)carInfo;

@end


@interface CarSelectView : UIView <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    UITableView  *_carListView;
    
    UIView    *_carView;
    
    UIButton  *_addButton;
    
    NSMutableArray  *_carsArray;
    
}

@property (assign, nonatomic) id <CarSelectViewDelegate> delegate;

+ (void)showCarSelectViewWithCars:(NSArray*)cars
                        ForTarget:(id)target;


@end
