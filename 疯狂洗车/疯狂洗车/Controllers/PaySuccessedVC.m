//
//  PaySuccessedVC.m
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/13.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "PaySuccessedVC.h"
#import "MyOrdersController.h"
#import "ShareMenuView.h"

@interface PaySuccessedVC ()
{
    NSString *_sharelogo;
    NSString *_sharename;
    NSString *_shareremark;
    NSString *_shareshorturl;
}

@end

@implementation PaySuccessedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"支付成功"];
    
    self.logo.layer.cornerRadius = 40;
    self.btnList.layer.cornerRadius = 4;
    self.btnList.layer.borderWidth = 1;
    self.btnList.layer.borderColor = [UIColor colorWithRed:0xff/255.0 green:0x66/255.0 blue:0x19/255.0 alpha:1].CGColor;
    self.btnShare.layer.cornerRadius = 4;
    
    
    CGFloat h = [[UIScreen mainScreen] bounds].size.height;
    self.statusLength.constant = (h-150)/7;
    self.btnLength.constant = (h-150)/7;
    
    [self loadShareInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadShareInfo
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [WebService requestJsonWXOperationWithParam:@{@"source": @"app"} action:@"wechat/initWechatUrl.xhtml" normalResponse:^(NSString *status, id data) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.view.userInteractionEnabled = YES;
        if(status.intValue > 0){
            if(data != nil && [data isKindOfClass:[NSNull class]]){
                self.btnShareLength.constant = 80;
                self.sepShareLength.constant = 10;
                _sharelogo = [data objectForKey:@"logo"];
                _sharename = [data objectForKey:@"name"];
                _shareremark = [data objectForKey:@"remark"];
                _shareshorturl = [data objectForKey:@"shorturl"];
            }else{
                self.btnShareLength.constant = 0;
                self.sepShareLength.constant = 0;
            }
        }else{
            self.btnShareLength.constant = 0;
            self.sepShareLength.constant = 0;
        }
        
    } exceptionResponse:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        self.view.userInteractionEnabled = YES;
        [MBProgressHUD showError:[error domain]
                          toView:self.view];
        
        self.btnShareLength.constant = 0;
        self.sepShareLength.constant = 0;
    }];
}

- (IBAction)doBtnList:(id)sender
{
    MyOrdersController *viewController = [[MyOrdersController alloc] initWithNibName:@"MyOrdersController"
                                                                              bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)doBtnShare:(id)sender
{
    NSString *shareUrl = [NSString stringWithFormat:@"%@&outTradeNo=%@&giftType=%@&phone=%@&memberId=%@", _shareshorturl, self.outTradeNo, self.giftType, _userInfo.member_phone, _userInfo.member_id];//[targetUrlString stringByReplacingOccurrencesOfString:@"sourceParams" withString:@"11"];
    
    
    [ShareMenuView showShareMenuViewAtTarget:self
                                 withContent:_shareremark
                                   withTitle:_sharename
                                withImageUrl:_sharelogo
                                     withUrl:shareUrl];
}

@end
