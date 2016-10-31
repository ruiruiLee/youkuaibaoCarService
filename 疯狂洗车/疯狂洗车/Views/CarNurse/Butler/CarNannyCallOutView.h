//
//  CarNannyCallOutView.h
//  优快保
//
//  Created by cts on 15/6/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButlerOrderModel.h"

@interface CarNannyCallOutView : UIView
{
    UILabel *_nannyDistanceTitleLabel;
    
    UILabel *_nannyDistanceValueLabel;

    UILabel *_nannyDistanceUnitLabel;

}

- (void)setDisplayCarWashInfo:(ButlerOrderModel*)model;
@end
