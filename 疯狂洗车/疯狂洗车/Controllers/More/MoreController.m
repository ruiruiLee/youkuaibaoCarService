//
//  MoreController.m
//  优快保
//
//  Created by 朱伟铭 on 15/1/28.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "MoreController.h"
#import "SettingCell.h"
#import "DBManager.h"
#import "CityModel.h"
#import "MBProgressHUD+Add.h"
#import "WebServiceHelper.h"
#import "AppVersionCell.h"
#import "CheXiaoBaoViewController.h"
#import "define.h"


@interface MoreController () <UIActionSheetDelegate>
{
    NSMutableArray *_titleArray;
    NSArray *_imagesArray;
    NSArray *_controllersArray;
    
    NSString        *_appVersion;

}

@end

static NSString *SettingCellReuse = @"SettingCell";

static NSString *appVersionCellIndentifier = @"AppVersionCell";


@implementation MoreController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"更多"];
    
    
    NSDictionary *tmpDic=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"]];
    
    _appVersion = [NSString stringWithFormat:@"当前版本：%.2f",[[tmpDic valueForKey:@"CFBundleShortVersionString"] floatValue]];

    
    [_menuTable registerNib:[UINib nibWithNibName:@"SettingCell"
                                           bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:SettingCellReuse];
    
    [_menuTable registerNib:[UINib nibWithNibName:appVersionCellIndentifier
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:appVersionCellIndentifier];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _titleArray = [@[@"关于优快保",@"意见反馈",@"退出登录"] mutableCopy];
    _imagesArray = @[@"more_share_icon", @"more_feedback",@"more_exit_icon"];
    _controllersArray = @[@"CheXiaoBaoViewController", @"FeedBackController"];
    if ([_userInfo.if_salesman boolValue])
    {
        _titleArray = [@[@"关于优快保",@"意见反馈",@"退出登录", @"提交车场信息"] mutableCopy];
        _imagesArray = @[@"more_share_icon", @"more_feedback",@"more_exit_icon", @"more_addcarwashyard"];
        _controllersArray = @[@"CheXiaoBaoViewController", @"FeedBackController",@"",@"AddWashYardViewController"];
    }
    
    [_menuTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return _titleArray.count;
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:SettingCellReuse];
        if (nil == cell)
        {
            cell = [[NSBundle mainBundle] loadNibNamed:@"SettingCell"
                                                 owner:nil
                                               options:nil][0];
        }
        [cell.iconView setImage:[UIImage imageNamed:_imagesArray[indexPath.row]]];
        [cell.titleLabel setText:_titleArray[indexPath.row]];
        return cell;
    }
    else
    {
        AppVersionCell *cell = [tableView dequeueReusableCellWithIdentifier:appVersionCellIndentifier];
        
        if (cell == nil)
        {
            cell = [[AppVersionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:appVersionCellIndentifier];
        }
        
        cell.versionLabel.text = _appVersion;
        
        return cell;

    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
        return;
    }
    if (indexPath.row != 2)
    {
        id controller = ALLOC_WITH_CLASSNAME(_controllersArray[indexPath.row]);
        [self.navigationController pushViewController:controller animated:YES];
        if(indexPath.row == 0){
            CheXiaoBaoViewController *chexiaobao = (CheXiaoBaoViewController*) controller;
            [chexiaobao setTitle:_titleArray[0]];
            chexiaobao.webUrl = [NSString stringWithFormat:ABOUT_UKB, BASE_Uri_FOR_WEB, _userInfo.member_id];
        }
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"退出后不会删除任何历史数据，下次登录仍然可以使用本账号。"
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"退出登录", nil];
        [actionSheet showInView:self.view];
    }
}

#pragma mark - actionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {

            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
            NSDictionary *submitDic = @{@"member_id":_userInfo.member_id};
            [WebService requestJsonOperationWithParam:submitDic action:@"member/service/logout"
                                       normalResponse:^(NSString *status, id data)
            {
                _userInfo = nil;
                _agentModel = nil;
                _insuranceHomeModel = nil;
                [self startLogoutAction];

            }
                                    exceptionResponse:^(NSError *error) {
                                        _userInfo = nil;
                                        _agentModel = nil;
                                        [self startLogoutAction];

            }];
            
            
        }
            break;
        default:
            break;
    }
}

- (void)startLogoutAction
{
    [self startLogoutFunctionNormalResponse:^{
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserInfoKey];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLoginToken];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter]  postNotificationName:kLogoutSuccessNotifaction
                                                             object:nil];
        
        [Constants showMessage:@"退出成功！"];
        [_appDelegate cleanAllUserRelationInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }
                          exceptionResponse:^{
                              _appconfig = nil;
                              [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
                              [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserInfoKey];
                              [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLoginToken];
                              
                              [[NSUserDefaults standardUserDefaults] synchronize];
                              [[NSNotificationCenter defaultCenter]  postNotificationName:kLogoutSuccessNotifaction
                                                                                   object:nil];
                              [Constants showMessage:@"退出成功！"];
                              [_appDelegate cleanAllUserRelationInfo];
                              [self.navigationController popViewControllerAnimated:YES];
                          }];

}

- (void)startLogoutFunctionNormalResponse:(void(^)(void))normalResponse
                        exceptionResponse:(void(^)(void))exceptionResponse
{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    [_appDelegate.gpsLocationManager changeAppConfigSuccessResponse:^{
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        normalResponse();
        return ;
    } failResponse:^{
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        exceptionResponse();
        return ;
    }];
}

@end
