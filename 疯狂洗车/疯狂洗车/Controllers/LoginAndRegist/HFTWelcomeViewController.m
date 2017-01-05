//
//  CosjiWelcomeViewController.m
//  CosjiApp
//
//  Created by Darsky on 14-1-3.
//  Copyright (c) 2014年 Cosji. All rights reserved.
//

#import "HFTWelcomeViewController.h"
#import "RDVTabBarController.h"
#import "MainViewController.h"
#import "CarNannyMessageViewController.h"
#import <MapKit/MapKit.h>
#import "WebServiceHelper.h"
#import "MBProgressHUD+Add.h"
#import "MyOrdersController.h"
#import "InsuranceViewController.h"
#import "AppDelegate.h"

#define iOS7screen4 [UIScreen mainScreen].bounds.size.height > 480

@interface HFTWelcomeViewController ()
{
    CLLocationManager           *_locationManager;

}

@end

@implementation HFTWelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    [super loadView];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    topListArray = [@[@"splash01",
                      @"splash02",
                      @"splash03"] mutableCopy];
    [self AdImg:topListArray];
    
   // [self.view addSubview:page];
}

- (void)AdImg:(NSMutableArray *)arr
{
    [_welceomSV setContentSize:CGSizeMake(SCREEN_WIDTH*[arr count], SCREEN_HEIGHT)];
    
    for ( int i=0; i<[topListArray count]; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        NSString *name = nil;
        if (SCREEN_HEIGHT < 568)
        {
            name = [NSString stringWithFormat:@"%@_4", [topListArray objectAtIndex:i]];
        }
        else
        {
            name = [NSString stringWithFormat:@"%@", [topListArray objectAtIndex:i]];
        }
        UIImage *image = [UIImage imageNamed:name];
        [imageView setImage:image];
        [_welceomSV addSubview:imageView];
        if (i == topListArray.count - 1)
        {
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            if (SCREEN_HEIGHT < 568)
            {
                cancelButton.frame = CGRectMake(imageView.frame.size.width/2-75, SCREEN_HEIGHT-60, 150, 40);
            }
            else
            {
                cancelButton.frame = CGRectMake(imageView.frame.size.width/2-75, SCREEN_HEIGHT-105*SCREEN_WIDTH/375.0, 150, 40);
            }
            [cancelButton setTitle:@"立即体验" forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

            cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
            [cancelButton setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:84/255.0 blue:1/255.0 alpha:1.0]];
            [imageView addSubview:cancelButton];
            cancelButton.layer.masksToBounds = YES;
            cancelButton.layer.cornerRadius = 20;
            [cancelButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
            imageView.userInteractionEnabled = YES;
            
        }
    }
    
    [self.view addSubview:_welceomSV];
}

- (void)back:(id)sender
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserInfoKey])
    {
        _userInfo = [[UserInfo alloc] initWithCacheKey:kUserInfoKey];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self startAutoLogin:_userInfo
            autoLoginSuccess:^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self setUpAndToMain];
                
            }
              autoLoginError:^{
                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                  [self setUpAndToMain];
              }];
    }
    else
    {
        
        [self setUpAndToMain];
    }


}

- (void)setUpAndToMain
{
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc]init];
    
    MainViewController *homePage = nil;
    homePage = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    
    UINavigationController *homeNavi = [[UINavigationController alloc] initWithRootViewController:homePage];
    
    
////    InsuranceViewController *insuranceController = [[InsuranceViewController alloc] initWithNibName:@"InsuranceViewController" bundle:nil];
//    InsuranceViewController *insuranceController = [[InsuranceViewController alloc] init];
//
//    
//    UINavigationController *insuranceNavi = [[UINavigationController alloc] initWithRootViewController:insuranceController];
    
    UIViewController *mine = ALLOC_WITH_CLASSNAME(@"MineViewController");
    UINavigationController *mineNavi = [[UINavigationController alloc] initWithRootViewController:mine];
    
    [tabBarController setViewControllers:@[homeNavi,
//                                           insuranceNavi,
                                           mineNavi]];
//    NSArray *tabBarItemImages = @[@"img_tabbar_carwash", @"img_tabbar_insurance",@"img_tabbar_mine"];
//    NSArray *tabBarItemTitle = @[@"首页", @"保险",@"我的"];
    
    NSArray *tabBarItemImages = @[@"img_tabbar_carwash", @"img_tabbar_mine"];
    NSArray *tabBarItemTitle = @[@"优快保", @"我的"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items])
    {
        [item setTitle:tabBarItemTitle[index]];
        
        [item setSelectedTitleAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10],
                                           NSForegroundColorAttributeName: [UIColor colorWithRed:205.0/255.0
                                                                                           green:85.0/255.0
                                                                                            blue:20.0/255.0
                                                                                           alpha:1.0]}];
        
        [item setUnselectedTitleAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10],
                                             NSForegroundColorAttributeName: [UIColor colorWithRed:137.0/255.0
                                                                                             green:137.0/255.0
                                                                                              blue:137.0/255.0
                                                                                             alpha:1.0]}];
        [item setBadgeTextColor:[UIColor orangeColor]];
        
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_h",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage
           withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
    
    
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineLabel.backgroundColor  = [UIColor colorWithRed:178.0/255.0
                                                 green:178.0/255.0
                                                  blue:178.0/255.0
                                                 alpha:0.5];
    [[tabBarController tabBar] addSubview:lineLabel];
    [[tabBarController tabBar] setBackgroundColor:[UIColor colorWithRed:250.0/255.0
                                                                  green:250.0/255.0
                                                                   blue:250.0/255.0
                                                                  alpha:1.0]];
    [[UIApplication sharedApplication].keyWindow setRootViewController:tabBarController];
    [[UIApplication sharedApplication].keyWindow reloadInputViews];
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate shouldShowOrHideHot:YES];
    
}

- (void)startAutoLogin:(UserInfo*)userInfo
      autoLoginSuccess:(void(^)(void))normalResponse
        autoLoginError:(void(^)(void))exceptionResponse
{
    NSDictionary *tmpDic=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"]];
    NSDictionary *autoLogin = [[NSUserDefaults standardUserDefaults] objectForKey:kAutoLogin];
    NSDictionary *submitDic = @{@"login_name":[autoLogin objectForKey:@"login_name"],
                                @"app_type":@"2",
                                @"user_type":@"1",
                                @"app_version":[NSString stringWithFormat:@"%.2f",[[tmpDic valueForKey:@"CFBundleShortVersionString"] floatValue]],
                                @"client_id":_notificationDeviceToken==nil?@"":_notificationDeviceToken};
    [WebService requestJsonModelWithParam:submitDic
                                   action:@"member/service/login"
                               modelClass:[UserInfo class]
                           normalResponse:^(NSString *status, id data, JsonBaseModel *model)
     {
         if (status.intValue > 0)
         {
             _userInfo = (UserInfo *)model;
             _agentModel = [[AgentModel alloc] initWithDictionary:data];
             [[NSUserDefaults standardUserDefaults] setObject:[userInfo convertToDictionary]
                                                       forKey:kUserInfoKey];
             [[NSUserDefaults standardUserDefaults] setObject:_userInfo.token forKey:kLoginToken];
             [[NSUserDefaults standardUserDefaults] synchronize];
             normalResponse();
             return ;
         }
         else
         {
             exceptionResponse();
             return ;
         }
     }
                        exceptionResponse:^(NSError *error) {
                            
                            exceptionResponse();
                            return ;
                        }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;   // called on finger up as we are moving
{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
