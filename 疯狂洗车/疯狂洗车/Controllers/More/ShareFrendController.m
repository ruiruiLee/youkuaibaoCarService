//
//  ShareFrendController.m
//  优快保
//
//  Created by 朱伟铭 on 15/1/28.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "ShareFrendController.h"
#import "QRCodeBuilder.h"
#import "QRCodeGenerator.h"
#import "ShareMenuView.h"

@interface ShareFrendController ()

@end

@implementation ShareFrendController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"告诉好友"];
    
    [_phoneLabel makeConstraints:^(MASConstraintMaker *make)
    {
        make.centerX.equalTo(self.view).offset(15);
    }];
    
    [[_shareBtn layer] setCornerRadius:3.0];
    [[_shareBtn layer] setMasksToBounds:YES];
    
    UIImage *towCode = [QRCodeGenerator qrImageForString:kDownloadUrl
                                               imageSize:600];
    //UIImage *abelImage = [UIImage imageNamed:@"share_icon"];
    //_qrCodeView.image = [QRCodeBuilder twoDimensionCodeImage:towCode withAvatarImage:nil];
//    UIImage *abelImage = [UIImage imageNamed:@"share_icon"];
    _qrCodeView.image = towCode;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareToFrends:(id)sender
{
    NSString *shareAppUrl = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kShareAppUrl])
    {
        shareAppUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kShareAppUrl];
    }
    else
    {
        shareAppUrl = kDownloadUrl;
    }
    
    NSString *mainAdvImage = nil;
    
    NSString *imageDirectory = [Constants getCrazyCarWashImageDirestory];
    
    mainAdvImage = [NSString stringWithFormat:@"%@/shareImage",imageDirectory];
    
    UIImage *shareImage = [UIImage imageWithContentsOfFile:mainAdvImage];
    
    if (shareImage == nil)
    {
        shareImage = [UIImage imageNamed:@"img_share_icon"];
    }
    
    NSString *shareContent = nil;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kShareContent])
    {
        shareContent = [[NSUserDefaults standardUserDefaults] objectForKey:kShareContent];
    }
    else
    {
        shareContent = @"不办卡, 也优惠。100多个城市，2000多家优质车场，随时随地，想洗就洗。关注优快保微信，可领优惠券。APP下载：http://t.cn/Rwjwb0D";
    }
    
    NSString *shareTitle = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kShareAppTitle])
    {
        shareTitle = [[NSUserDefaults standardUserDefaults] objectForKey:kShareAppTitle];
    }
    else
    {
        shareTitle = @"优快保";
    }
    
    [ShareMenuView showShareMenuViewAtTarget:self
                                 withContent:shareContent
                                   withTitle:shareTitle
                                   withImage:shareImage
                                     withUrl:shareAppUrl];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
