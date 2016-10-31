//
//  ButlerOrderFinishViewController.h
//  优快保
//
//  Created by cts on 15/6/22.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "OldPriceLabel.h"
#import "WebServiceHelper.h"
#import "TQStarRatingView.h"
#import "ButlerOrderModel.h"


@interface ButlerOrderFinishViewController : BaseViewController
{
    
    IBOutlet UIImageView *_nannyHeaderImageView;
    IBOutlet UILabel *_nannyNameLabel;
    IBOutlet UILabel *_nannyCountLabel;
    IBOutlet UIButton *_nannyCallButton;
    IBOutlet UILabel *_nannyOrderTimeLabel;
    IBOutlet UILabel *_priceLabel;
    IBOutlet OldPriceLabel *_oldPriceLabel;
    
    
    
    IBOutlet UIView *_submitBottomView;
    IBOutlet TQStarRatingView *_starRatingView;
    IBOutlet UIButton *_submitButton;
}

@property (assign , nonatomic) BOOL backEnable;

@end
