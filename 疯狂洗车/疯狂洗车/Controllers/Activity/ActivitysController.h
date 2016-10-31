//
//  ActivitysContrller.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/28.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "ADVModel.h"
#import "CrazyCarWashWebView.h"

//首页活动详情展示页面
@interface ActivitysController : BaseViewController <UIWebViewDelegate>
{
    IBOutlet CrazyCarWashWebView *_webView;
    
    IBOutlet UIImageView         *_noActivityImageView;
    
    IBOutlet UILabel             *_noActivityLabel;
}

@property (nonatomic, strong) NSString  *titleString;

@property (nonatomic, strong) NSString  *urlString;

@property (strong, nonatomic) ADVModel  *advModel;

@property (assign, nonatomic) BOOL       forbidAddMark;


@end
