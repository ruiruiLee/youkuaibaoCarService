//
//  MineViewController.m
//  优快保
//
//  Created by cts on 15/4/3.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "MineViewController.h"
#import "UserInfoCell.h"
#import "LeftMenuCell.h"
#import "AppDelegate.h"
#import "UIView+Toast.h"
#import "ShareMenuView.h"
#import "MineTicketCell.h"
#import "MineTicketNumberCell.h"
#import "MyTicketViewController.h"
#import "ShareActivityViewController.h"
#import "ShareMenuView.h"
#import "MessageCenterViewController.h"
#import "MyOrdersController.h"
#import "CarNannyMessageViewController.h"
#import "MineFundationCell.h"
#import "MyAppointVC.h"
#import "CheXianOrderListVC.h"
#import "CheXiaoBaoViewController.h"

#import "define.h"

@interface MineViewController ()<UserInfoCellDelegate,UIAlertViewDelegate>
{
    NSMutableArray  *_mainFrameClassesArray;
    
    NSArray         *_menuListTitleArray;
    
    UILabel         *_versionLabel;
    
    
    int              _totalTickets;
    
    UIButton                    *_rightButton;
    
}

@end

@implementation MineViewController

static NSString *userInfoCellIdentifier = @"UserInfoCell";

static NSString *leftMenuCellIdentifier = @"LeftMenuCell";

static NSString *mineTicketCellIndentifier = @"MineTicketCell";

static NSString *mineTicketNumberCellIndentifier = @"MineTicketNumberCell";

static NSString *mineFundationCellIndentifier = @"MineFundationCell";



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"我的"];
    
    [self.navigationItem setLeftBarButtonItem:nil];

    _mineTableView.delegate = self;
    
    [_mineTableView registerNib:[UINib nibWithNibName:SCREEN_WIDTH > 320? [NSString stringWithFormat:@"%@_4",userInfoCellIdentifier]:userInfoCellIdentifier
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:userInfoCellIdentifier];
    
    
    [_mineTableView registerNib:[UINib nibWithNibName:leftMenuCellIdentifier
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:leftMenuCellIdentifier];
    [_mineTableView registerNib:[UINib nibWithNibName:mineTicketCellIndentifier
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:mineTicketCellIndentifier];
    [_mineTableView registerNib:[UINib nibWithNibName:mineTicketNumberCellIndentifier
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:mineTicketNumberCellIndentifier];
    [_mineTableView registerNib:[UINib nibWithNibName:mineFundationCellIndentifier
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:mineFundationCellIndentifier];

    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    [_rightButton setTitle:@"设置" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_rightButton setTitleColor:[UIColor colorWithRed:235.0/255.0
                                                green:84.0/255.0
                                                 blue:1.0/255.0
                                                alpha:1.0] forState:UIControlStateNormal];
    
    [_rightButton addTarget:self action:@selector(didRightButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];

    
    
    _mainFrameClassesArray = [@[@"ShareFrendController",
                                @"CodeConvertViewController"] mutableCopy];
    
    _menuListTitleArray = @[@"推荐有礼",@"礼包领取",@"联系客服"];


    
    _userInfo = [[UserInfo alloc] initWithCacheKey:kUserInfoKey];
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveUnreadSystemMessageNotification)
                                                 name:kUnreadSystemMessageNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveUnreadSystemMessageNotification)
                                                 name:@"shouldupdatedate"
                                               object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_userInfo.member_id)//用户已登录，刷新数据
    {
        NSDictionary *submitDic = @{@"member_id":_userInfo.member_id};
        [WebService requestJsonModelWithParam:submitDic
                                       action:@"member/service/get"
                                   modelClass:[UserInfo class]
                               normalResponse:^(NSString *status, id data, JsonBaseModel *model)
         {
             if (status.intValue > 0)
             {
                 UserInfo *userInfo = (UserInfo *)model;
                 _userInfo.account_remainder = userInfo.account_remainder;
                 [[NSUserDefaults standardUserDefaults] setObject:[_userInfo convertToDictionary]
                                                           forKey:kUserInfoKey];
             //    [[NSUserDefaults standardUserDefaults] setObject:userInfo.token forKey:kLoginToken];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 [_mineTableView reloadData];
             }
             else
             {
                 
             }
         }
                            exceptionResponse:^(NSError *error) {
                                
                                
                            }];
        [self updateUserTickets];

    }

    [_mineTableView reloadData];
}


- (void)didReceiveUnreadSystemMessageNotification//去除未读消息标志，刷新页面
{
    if (_userInfo.member_id)
    {
        [_mineTableView reloadData];
    }
}


#pragma mark - UITableViewDataSource Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 3;
    }
    else if (section == 2)
    {
        return 3;
    }
    else
    {
     
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 183*SCREEN_WIDTH/320.0;
    }
    else if (indexPath.section == 3)
    {
        return SCREEN_WIDTH/5.0;
    }
    else
    {
        return 45.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4)
    {
        return 40;
    }
    else
    return 10;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] init];
    
    if (section == 3)
    {
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);


        //[view addSubview:_versionLabel];
    }
    else
    {
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
    }
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)//section 0 显示用户基本信息,_userInfo为空时则显示未登录状态
    {
        UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userInfoCellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setDisplayUserInfo:_userInfo
                withUnreadNumber:0];
        cell.delegate = self;
        
        return cell;
    }
    else if (indexPath.section == 1)//section 1 显示用户优惠券信息
    {
//        if (indexPath.row == 0)//row 0 显示用户各类型优惠券信息
//        {
            MineTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:mineTicketCellIndentifier];
            
            if (cell == nil)
            {
                cell = [[MineTicketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mineTicketCellIndentifier];
            }
            
            if (_userInfo.member_id == nil)
            {
                cell.redIconView.hidden = YES;
                cell.arrowImageView.hidden = YES;
                cell.ticketNumberLabel.hidden = YES;
            }
            else if (_userTicketArray.count > 0)
            {
                cell.redIconView.hidden = YES;
                cell.arrowImageView.hidden = NO;
                cell.ticketNumberLabel.hidden = NO;
            }
            else
            {
                cell.redIconView.hidden = YES;
                cell.arrowImageView.hidden = YES;
                cell.ticketNumberLabel.hidden = YES;
            }
        
        if(indexPath.row == 0){
            cell.lbTitle.text = @"优惠券";
            [cell.ticketNumberLabel setText:[NSString stringWithFormat:@"%d 张",_totalTickets]];
            cell.logo.image = [UIImage imageNamed:@"img_mine_list_ticket"];
        }
        else if (indexPath.row == 1){
            cell.lbTitle.text = @"我的爱车";
            cell.logo.image = [UIImage imageNamed:@"img_mine_loveCar"];
            [cell.ticketNumberLabel setText:@""];
        }
        else{
            cell.lbTitle.text = @"我的消息";
            [cell.ticketNumberLabel setText:[NSString stringWithFormat:@"%d",_unReadMessageCount]];
            cell.logo.image = [UIImage imageNamed:@"img_mine_messageCenter"];
        }
//            if (_showTickets)
//            {
//                cell.arrowImageView.highlighted = YES;
//            }
//            else
//            {
//                cell.arrowImageView.highlighted = NO;
//            }
            return cell;
//        }
//        else//row 1 显示用户优惠券总数信息
//        {
//            MineTicketNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:mineTicketNumberCellIndentifier forIndexPath:indexPath];
//            
//            if (cell == nil)
//            {
//                cell = [[MineTicketNumberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mineTicketNumberCellIndentifier];
//            }
//            
//            UserTicketModel *model = _userTicketArray[indexPath.row - 1];
//            
//            [cell setDisplayInfoWithTicketType:model.service_type.intValue
//                               andTicketNumber:model.code_count.intValue];
//            return cell;
//        }
    }
    else if (indexPath.section == 2)//其他数据显示
    {
        LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:leftMenuCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[LeftMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftMenuCellIdentifier];
        }
        
        if (indexPath.row == 0)
        {
            if (_appconfig == nil)
            {
                 cell.menuTitle.text = @"邀请好友";
                cell.rightTitleLabel.text = @"";
            }
            else if ([_appconfig.open_share_code_flag isEqualToString:@"1"])
            {
                cell.menuTitle.text = @"邀请有礼";
                cell.rightTitleLabel.text = @"邀请好友，有好礼!";
            }
            else
            {
                cell.menuTitle.text = @"邀请好友";
                cell.rightTitleLabel.text = @"";
            }
            [cell.menuIcon setImage:[UIImage imageNamed:@"img_mine_list_tuijian"]];
        }
        else if (indexPath.row == 1)
        {
            cell.menuTitle.text = _menuListTitleArray[indexPath.row];
            cell.rightTitleLabel.text = @"";
            [cell.menuIcon setImage:[UIImage imageNamed:@"img_mine_list_codeExchange"]];
        }
        else
        {
            cell.menuTitle.text = _menuListTitleArray[indexPath.row];
            cell.rightTitleLabel.text = @"";
            [cell.menuIcon setImage:[UIImage imageNamed:@"img_mine_list_kefu"]];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        if (indexPath.row == 2)
        {
            cell.topBorderView.hidden = YES;
            cell.bottomSepView.hidden = YES;
            cell.bottomBorderView.hidden = NO;
        }
        else
        {
            cell.topBorderView.hidden = YES;
            cell.bottomSepView.hidden = NO;
            cell.bottomBorderView.hidden = YES;
        }
        [cell showMessageCount:0];
        
        return cell;
    }
    else//底部车大白cell，并显示车大白回复消息树
    {
        MineFundationCell *cell = [tableView dequeueReusableCellWithIdentifier:mineFundationCellIndentifier];
        
        if (cell == nil)
        {
            cell = [[MineFundationCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:mineFundationCellIndentifier];
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kUnreadMessage])
        {
            NSString *unreadMessage = [[NSUserDefaults standardUserDefaults] objectForKey:kUnreadMessage];
            [cell showMessageCount:unreadMessage.intValue];
        }
        else
        {
            [cell showMessageCount:0];
        }
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate Method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0)//当用户未登录时，仅用户弹出登录页面
    {
        
        if (!_userInfo.member_id)
        {
            [self needToLogin];

            return;
        }
    }
    else if (indexPath.section == 1)
    {
        if (!_userInfo.member_id)
        {
            [self needToLogin];

            return;
        }
        if (indexPath.row == 0)//展开或关闭优惠券
        {
            MyTicketViewController *viewController = [[MyTicketViewController alloc] initWithNibName:@"MyTicketViewController"
                                                                                              bundle:nil];
            
            viewController.serviceType = @"";
            viewController.isInMine = YES;
            
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if(indexPath.row == 1)//跳转我的爱车列表
        {
            if (!_userInfo.member_id)
            {
                [self needToLogin];
                
                return;
            }
            
            id controller = ALLOC_WITH_CLASSNAME(@"MyCarsController");
            [self.navigationController pushViewController:controller animated:YES];
        }
        else{//跳消息中心
            if (!_userInfo.member_id)
            {
                [self needToLogin];
                
                return;
            }
            MessageCenterViewController *viewController = [[MessageCenterViewController alloc] initWithNibName:@"MessageCenterViewController"
                                                                                                        bundle:nil];
            
            [self.navigationController pushViewController:viewController
                                                 animated:YES];
        }

    }
    else if (indexPath.section == 2)//跳转对应子页面
    {
        if (indexPath.row == 0)
        {
            if (_appconfig == nil)
            {
                [self shareToFrends];
            }
            else if ([_appconfig.open_share_code_flag isEqualToString:@"1"] )
            {
                ShareActivityViewController *viewController = [[ShareActivityViewController alloc] initWithNibName:@"ShareActivityViewController"
                                                                                                            bundle:nil];
                
                viewController.baseUrlString = _appconfig.share_code_url;
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else
            {
                [self shareToFrends];
            }
        }
        else if (indexPath.row == 1)
        {
            if (!_userInfo.member_id)
            {
                [self needToLogin];
                return;
            }
//            id controller = ALLOC_WITH_CLASSNAME(_mainFrameClassesArray[indexPath.row]);
//            [self.navigationController pushViewController:controller animated:YES];
            CheXiaoBaoViewController *vc = [[CheXiaoBaoViewController alloc] initWithNibName:@"CheXiaoBaoViewController" bundle:nil];
            NSString *url = [NSString stringWithFormat:LI_BAO_LING_QU, BASE_Uri_FOR_WEB, _userInfo.member_id, _userInfo.login_name, _userInfo.member_phone];
            vc.webUrl = url;
            [self.navigationController pushViewController:vc animated:YES];
            
            [vc setTitle:@"礼包领取"];
        }
        else
        {
            [self makePhoneCall];
        }
    }
    else if (indexPath.section == 3)//跳转车大白消息页面
    {
        CarNannyMessageViewController *viewController = [[CarNannyMessageViewController alloc] initWithNibName:@"CarNannyMessageViewController"
                                                                                                        bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)needToLogin
{
    id viewController = [QuickLoginViewController sharedLoginByCheckCodeViewControllerWithProtocolEnable:nil];
    
    [self presentViewController:viewController animated:YES completion:^
     {
         [[[UIApplication sharedApplication] keyWindow] makeToast:@"请先登录"];
     }];
    
}

#pragma mark - UserInfoCellDelegate Method

- (void)didOrderButtonTouched//跳转至“我的预约”
{
    if (!_userInfo.member_id)
    {
        [self needToLogin];
        
        return;
    }
    
    MyAppointVC *vc = [[MyAppointVC alloc] initWithNibName:@"MyAppointVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didMessageButtonTouched//跳转至“车险保单”
{
    if (!_userInfo.member_id)
    {
        [self needToLogin];
        
        return;
    }
    
    CheXianOrderListVC *vc = [[CheXianOrderListVC alloc] initWithNibName:@"CheXianOrderListVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didUserCarButtonTouched//跳转至“我的订单”
{
    if (!_userInfo.member_id)
    {
        [self needToLogin];
        
        return;
    }
    MyOrdersController *viewController = [[MyOrdersController alloc] initWithNibName:@"MyOrdersController"
                                                                              bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - 更新并显示用户优惠券数量 Method

- (void)updateUserTickets
{
    NSDictionary *submitDic = @{@"member_id":_userInfo.member_id};
    [WebService requestJsonArrayOperationWithParam:submitDic
                                            action:@"serviceCode/service/count"
                                        modelClass:[UserTicketModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
    {
        if (status.intValue > 0 && array.count > 0)
        {
            _userTicketArray = array;
            _totalTickets = 0;
            for (int x = 0; x<_userTicketArray.count; x++)
            {
                UserTicketModel *model = _userTicketArray[x];
                _totalTickets += model.code_count.intValue;
            }
        }
        else
        {
            if (_userTicketArray.count > 0)
            {
                [_userTicketArray removeAllObjects];
            }
            _totalTickets = 0;
        }
        [_mineTableView reloadData];

    }
                                 exceptionResponse:^(NSError *error) {
                                     if (_userTicketArray.count > 0)
                                     {
                                         [_userTicketArray removeAllObjects];
                                     }
                                     [_mineTableView reloadData];

    }];
}

#pragma mark - 分享App Method

- (void)shareToFrends
{
    NSString *shareAppUrl = Invite_Url;
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:kShareAppUrl])
//    {
//        shareAppUrl = [[NSUserDefaults standardUserDefaults] objectForKey:kShareAppUrl];
//    }
//    else
//    {
//        shareAppUrl = kDownloadUrl;
//    }
    
    NSString *mainAdvImage = nil;
    
    NSString *imageDirectory = [Constants getCrazyCarWashImageDirestory];
    
    mainAdvImage = [NSString stringWithFormat:@"%@/shareImage",imageDirectory];
    
    UIImage *shareImage = [UIImage imageWithContentsOfFile:mainAdvImage];
    
    if (shareImage == nil)
    {
        shareImage = [UIImage imageNamed:@"img_share_icon"];
    }
    
    NSString *shareContent = @"8小时钣喷快修，4s店品质服务，免费上门接送车，进口环保水性漆，您身边的爱车服务管家。";
    
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:kShareContent])
//    {
//        shareContent = [[NSUserDefaults standardUserDefaults] objectForKey:kShareContent];
//    }
//    else
//    {
//        shareContent = @"不办卡, 也优惠。100多个城市，2000多家优质车场，随时随地，想洗就洗。关注优快保微信，可领优惠券。APP下载：http://t.cn/Rwjwb0D";
//    }
    
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


#pragma mark - 拨打客服电话 Method

- (void)makePhoneCall
{
        if ([Constants canMakePhoneCall])
        {
            NSString *messageString = [NSString stringWithFormat:@"致电客服%@",_kefudianhuaNumber];
            [Constants showMessage:messageString
                          delegate:self
                               tag:530
                      buttonTitles:@"取消",@"确认", nil];
        }
        else
        {
            [Constants showMessage:@"您的设备无法拨打电话"];
        }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 530 && buttonIndex == 1)
    {
        [self callCustomService];
    }
}

- (void)callCustomService
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_kefudianhuaNumber]]];
}


#pragma mark - 右边按钮跳转设置 Method

- (void)didRightButtonTouch
{
    if (!_userInfo.member_id)
    {
        [self needToLogin];
        return;
    }
    id controller = ALLOC_WITH_CLASSNAME(@"MoreController");
    [self.navigationController pushViewController:controller
                                         animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUnreadSystemMessageNotification object:nil];
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
