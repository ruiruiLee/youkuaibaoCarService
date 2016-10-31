//
//  CarServiceSelectHeaderView.h
//  疯狂洗车
//
//  Created by cts on 16/1/27.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarNurseModel.h"


@protocol CarServiceSelectHeaderViewDelegate;

@interface CarServiceSelectHeaderView : UITableViewHeaderFooterView
{
    
    IBOutlet UIButton *_firstButton;
    
    IBOutlet UIButton *_secondButton;
    
    IBOutlet UIButton *_thirdButton;
    
    NSMutableArray    *_itemArray;
    IBOutlet NSLayoutConstraint *_selectedViewLeadingConstraint;
}

- (void)setDisplayInfoWithCarNurseModel:(CarNurseModel*)model
                      withSelectedIndex:(NSInteger)selectIndex;

@property (assign, nonatomic)id <CarServiceSelectHeaderViewDelegate> delegate;

@end

@protocol CarServiceSelectHeaderViewDelegate <NSObject>

- (void)didServiceChange:(NSInteger)serviceIndex;

@end
