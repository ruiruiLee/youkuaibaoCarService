//
//  FourSServiceSmallCallOutView.h
//  疯狂洗车
//
//  Created by cts on 16/1/29.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarNurseModel.h"


@interface FourSServiceSmallCallOutView : UIView
{
    UIImageView *_bgImageView;
    
    UIImageView *_logoImageView;
}

- (void)setDisplayCarWashInfo:(CarNurseModel*)model;

@property (assign , nonatomic) BOOL isSelected;


@end
