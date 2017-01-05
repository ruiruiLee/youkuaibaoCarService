//
//  PaySuccessedVC.h
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/13.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "BaseViewController.h"

@interface PaySuccessedVC : BaseViewController

@property (nonatomic, strong) IBOutlet UIImageView *logo;
@property (nonatomic, strong) IBOutlet UIButton *btnList;
@property (nonatomic, strong) IBOutlet UIButton *btnShare;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *logoLength;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *statusLength;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *btnLength;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *btnShareLength;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *sepShareLength;

@property (nonatomic, strong) NSString *outTradeNo;
@property (nonatomic, strong) NSString *giftType;


@end
