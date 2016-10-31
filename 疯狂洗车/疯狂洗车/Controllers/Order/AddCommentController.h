//
//  AddCommentController.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/30.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"


@class TQStarRatingView;
@class GCPlaceholderTextView;

//添加评价页面
@interface AddCommentController : BaseViewController
{
    IBOutlet UIImageView    *_iconView;
    IBOutlet UILabel        *_titleLabel;
    IBOutlet UILabel        *_addressLabel;
    IBOutlet UILabel        *_nowPriceLabel;
    
    IBOutlet TQStarRatingView *_carWashStarView;

    
    IBOutlet TQStarRatingView *_starView;
    IBOutlet UIView *_comentsBg;
    IBOutlet UIButton *_submitBtn;
    IBOutlet GCPlaceholderTextView *_commentsTextView;
}

@property (nonatomic, strong) OrderListModel *orderInfo;

@property (nonatomic, strong) CarWashModel   *carWashModel;

@property (nonatomic, strong) NSString       *service_id;

@property (assign, nonatomic) BOOL           isCarWash;

@property (assign, nonatomic) BOOL           isButler;

@end
