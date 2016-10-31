//
//  BaseViewController.m
//  康吾康
//
//  Created by 朱伟铭 on 14/12/29.
//  Copyright (c) 2014年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "RDVTabBarController.h"

#include <objc/runtime.h>
#import "MTA.h"


@interface BaseViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSArray *viewControllerNameArray;

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.navigationController.navigationBar setBackgroundImage:self.isClubController?[UIImage imageNamed:@"navi_club_bg"]:[UIImage imageNamed:@"navi_bg"]
                                                  forBarMetrics:0];
    
    self.viewControllerNameArray = [self getAllViewControllersName];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:self.isClubController?[UIImage imageNamed:@"back_club_btn"]:[UIImage imageNamed:@"back_btn"]
                       forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 7, 26, 30)];
    [backBtn addTarget:self
                action:@selector(backBtnPre:)
      forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [titleLabel setTextColor:self.isClubController?[UIColor whiteColor]:[UIColor blackColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    self.navigationItem.titleView = titleLabel;
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [[UIApplication sharedApplication] setStatusBarStyle:self.isClubController? UIStatusBarStyleLightContent:UIStatusBarStyleDefault];

    if ([UINavigationBar instancesRespondToSelector:@selector(setShadowImage:)])
    {
        [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"nav_shaw_clear.png"]];
    }
    
    _appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    // Do any additional setup after loading the view.
}

- (void)backBtnPre:(id)sender
{
    if ([[[self navigationController] viewControllers] count] > 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setTitle:(NSString *)title
{
    UILabel *titleLabel = (UILabel *)[self.navigationItem titleView];
    [titleLabel setText:title];
    [titleLabel setTextColor:self.isClubController?[UIColor whiteColor]:[UIColor blackColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel sizeToFit];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.navigationController.viewControllers count] == 1)
    {
        [self.rdv_tabBarController.tabBar removeFromSuperview];
        [self.rdv_tabBarController.tabBar setFrame:CGRectMake(0, self.view.bounds.size.height - 49, SCREEN_WIDTH, 49)];
        [self.view addSubview:self.rdv_tabBarController.tabBar];
    }
    [self.navigationController.navigationBar setBackgroundImage:self.isClubController?[UIImage imageNamed:@"navi_club_bg"]:[UIImage imageNamed:@"navi_bg"]
                                                  forBarMetrics:0];
    [[UIApplication sharedApplication] setStatusBarStyle:self.isClubController? UIStatusBarStyleLightContent:UIStatusBarStyleDefault];


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 6.0)
        
    {
        NSArray *arrayChildClass = [self findAllOf: [self  class]];
        [self startThisClass:[NSString stringWithCString:object_getClassName([arrayChildClass lastObject])
                                                encoding:NSUTF8StringEncoding]];
    }
    
    if ([self.navigationController.viewControllers count] > 1)//非root不具备左滑返回手势
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    else
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 6.0)
    {
        NSArray *arrayChildClass = [self findAllOf: [self  class]];
        [self endThisClass:[NSString stringWithCString:object_getClassName([arrayChildClass lastObject])
                                              encoding:NSUTF8StringEncoding]];
    }
    

}

#pragma mark - MTA

- (void)startThisClass:(NSString*)className
{
    for (NSDictionary *childClass in self.viewControllerNameArray)
    {
        if ([[childClass objectForKey:@"Class"] isEqualToString:className])
        {
            NSLog(@"开始%@",[childClass objectForKey:@"describe"]);
            [MTA trackPageViewBegin:[childClass objectForKey:@"describe"]];
        }
    }
}

- (void)endThisClass:(NSString*)className
{
    for (NSDictionary *childClass in self.viewControllerNameArray)
    {
        if ([[childClass objectForKey:@"Class"] isEqualToString:className])
        {
            NSLog(@"结束%@",[childClass objectForKey:@"describe"]);
            [MTA trackPageViewEnd:[childClass objectForKey:@"describe"]];
        }
    }
}



- (NSArray *)findAllOf:(Class)defaultClass

{
    int count = objc_getClassList(NULL, 0);
    if (count <= 0)
    {
        return [NSArray arrayWithObject:defaultClass];
    }
    
    NSMutableArray *output = [NSMutableArray arrayWithObject:defaultClass];
    Class *classes = (Class *) malloc(sizeof(Class) * count);
    objc_getClassList(classes, count);
    for (int i = 0; i < count; ++i)
    {
        if (defaultClass == class_getSuperclass(classes[i]))//子类
        {
            [output addObject:classes[i]];
        }
    }
    
    free(classes);
    
    return [NSArray arrayWithArray:output];
}


- (NSArray*)getAllViewControllersName
{
    NSArray *names = @[@{@"describe":@"登录页",@"Class":@"LoginByCheckCodeViewController"},
                       @{@"describe":@"首页",@"Class":@"MainViewController"},
                       @{@"describe":@"车辆品牌选择",@"Class":@"CarBrandSelectViewController"},
                       @{@"describe":@"添加或编辑车辆",@"Class":@"AddNewCarController"},
                       @{@"describe":@"我的汽车页面",@"Class":@"MyCarsController"},
                       @{@"describe":@"我的订单",@"Class":@"MyOrdersController"},
                       @{@"describe":@"洗车支付页面订单",@"Class":@"CarWashOrderViewController"},
                       @{@"describe":@"添加评论",@"Class":@"AddCommentController"},
                       @{@"describe":@"车场评论",@"Class":@"CommentsListController"},
                       @{@"describe":@"更多",@"Class":@"MoreController"},
                       @{@"describe":@"意见反馈",@"Class":@"FeedBackController"},
                       @{@"describe":@"告诉好友",@"Class":@"ShareFrendController"},
                       @{@"describe":@"提交车场",@"Class":@"AddWashYardViewController"},
                       @{@"describe":@"车服务地图",@"Class":@"CarNurseMapViewController"},
                       @{@"describe":@"车服务支付页面",@"Class":@"CarNurseOrderViewController"},
                       @{@"describe":@"车服务车场详情页面",@"Class":@"CarServiceDetailViewController"},
                       @{@"describe":@"选择服务地址",@"Class":@"AddressSelectViewController"},
                       @{@"describe":@"车保姆地图",@"Class":@"ButlerMapViewController"},
                       @{@"describe":@"车保姆支付页面",@"Class":@"ButlerOrderViewController"},
                       @{@"describe":@"车保姆详细信息页面",@"Class":@"ButlerDetailViewController"},
                       @{@"describe":@"车保姆订单完成页面",@"Class":@"ButlerOrderFinishViewController"},
                       @{@"describe":@"车保姆提交投诉页面",@"Class":@"ButlerComplainViewController"},
                       @{@"describe":@"订单详情页面",@"Class":@"OrderDetailViewController"},
                       @{@"describe":@"取消订单页面",@"Class":@"OrderCancelViewController"},
                       @{@"describe":@"取消订单页面(其他原因)",@"Class":@"OrderCancelMoreViewController"},
                       @{@"describe":@"下单有礼页面",@"Class":@"OrderSuccessViewController"},
                       @{@"describe":@"车大白留言列表",@"Class":@"CarNannyMessageViewController"},
                       @{@"describe":@"车大白发送留言页面",@"Class":@"CarNannyRichMessageViewController"},
                       @{@"describe":@"速援/救援地图",@"Class":@"CarNurseRescueMapViewController"},
                       @{@"describe":@"速援/救援支付页面",@"Class":@"CarNurseRescueOrderViewController"},
                       @{@"describe":@"洗车地图",@"Class":@"CarWashMapViewController"},
                       @{@"describe":@"消息中心",@"Class":@"MessageCenterViewController"},
                       @{@"describe":@"消息详情",@"Class":@"MessageContentDetailViewController"},
                       @{@"describe":@"保险首页",@"Class":@"InsuranceViewController"},
                       @{@"describe":@"提交行驶证",@"Class":@"InsuranceSubmitViewController"},
                       @{@"describe":@"报价列表",@"Class":@"InsuranceListViewController"},
                       @{@"describe":@"保险报价详情",@"Class":@"InsuranceDetailsViewController"},
                       @{@"describe":@"保险报价支付页面",@"Class":@"InsuranceOrderSubmitViewController"},
                       @{@"describe":@"我的优惠券列表",@"Class":@"MyTicketViewController"},
                       @{@"describe":@"优惠码兑换页面",@"Class":@"CodeConvertViewController"},
                       @{@"describe":@"分享有礼页面",@"Class":@"ShareActivityViewController"},
                       @{@"describe":@"VIP送修年审页面",@"Class":@"InsuranceRepaierOrAVViewController"},
                       @{@"describe":@"年审下单页面",@"Class":@"InsuranceAVOrderViewController"},
                       @{@"describe":@"我的页面",@"Class":@"MineViewController"},
                       @{@"describe":@"活动",@"Class":@"ActivitysController"}];
    return names;
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
