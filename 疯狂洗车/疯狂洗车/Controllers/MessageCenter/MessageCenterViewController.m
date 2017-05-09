//
//  MessageCenterViewController.m
//  优快保
//
//  Created by cts on 15/7/13.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "MessageListCell.h"
#import "DBManager.h"
#import "MessageContentDetailViewController.h"
#import "WebServiceHelper.h"
#import "MBProgressHUD+Add.h"
#import "ADVModel.h"
#import "ActivitysController.h"

@interface MessageCenterViewController ()

@end

@implementation MessageCenterViewController

static NSString *messageListCellWithIdentifier = @"MessageListCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"我的信息"];
    
    [_messageListTableView registerNib:[UINib nibWithNibName:messageListCellWithIdentifier
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:messageListCellWithIdentifier];
    _messageArray = [NSMutableArray array];


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_messageArray.count == 0 && _userInfo.member_id)
    {
        NSArray *resultArray = [DBManager getAllMessageByMemberID:_userInfo.member_id];
        
        if (resultArray.count > 0)
        {
            for (int x = 0; x<resultArray.count; x++)
            {
                MessageModel *model = [[MessageModel alloc] initWithDictionary:resultArray[x]];
                [_messageArray addObject:model];
            }
            [self loadUnreadMessageFromService];
        }
        else
        {
            [self loadUnreadMessageFromService];
        }
    }
}

#pragma mark - UITableViewDataSource
#pragma mark 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 118.0;
}



- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:messageListCellWithIdentifier];
    
    if (cell == nil)
    {
        cell = [[MessageListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:messageListCellWithIdentifier];
    }
    
    MessageModel *model = _messageArray[indexPath.row];
    
    [cell setDisplayMessageInfo:model];
    
    return cell;
}


#pragma mark - UITableViewDelegate
#pragma mark

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageModel *model = _messageArray[indexPath.row];
    
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[model.json dataUsingEncoding:NSUTF8StringEncoding]
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
    if ([model.is_read isEqualToString:@"0"])
    {
        model.is_read = @"1";
        [DBManager updateMessageByMessageModel:model];
        _unReadMessageCount--;
        [_appDelegate showNewLabel:_unReadMessageCount
                   andNannyMessage:[[NSUserDefaults standardUserDefaults] objectForKey:kUnreadMessage]?1:0];
        
        [[NSUserDefaults standardUserDefaults] setInteger:_unReadMessageCount
                                                   forKey:kUnreadSystemMessageCount];
    }
    
    [_messageListTableView reloadData];
    if ([dic objectForKey:@"url"] && ![[dic objectForKey:@"url"] isEqualToString:@""])
    {
        ADVModel *headerModel = [[ADVModel alloc] init];
        
        headerModel.url = [dic objectForKey:@"url"];
        headerModel.title = [dic objectForKey:@"url_title"];

        
        ActivitysController *viewController = [[ActivitysController alloc] initWithNibName:@"ActivitysController" bundle:nil];
        viewController.advModel = headerModel;
        [self.navigationController pushViewController:viewController
                                             animated:YES];
    }
    else
    {
        MessageContentDetailViewController *viewController = [[MessageContentDetailViewController alloc] initWithNibName:@"MessageContentDetailViewController"
                                                                                                                  bundle:nil];
        viewController.model = model;
        [self.navigationController pushViewController:viewController
                                             animated:YES];
    }
}

//读取所有消息（已阅读和未阅读）
- (void)loadAllMessageFromService
{
    NSDictionary *submitDic = @{@"user_id":_userInfo.member_id,
                                @"user_type":@"1"};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebService requestJsonArrayOperationWithParam:submitDic
                                            action:@"msg/service/list"
                                        modelClass:[MessageModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (status.intValue > 0 && array.count > 0)
         {
             _messageArray = array;
             _emptyImageView.hidden = YES;
             _messageListTableView.hidden = NO;
             [_messageListTableView reloadData];
             [DBManager insertDateToDBforTab:20
                                   withArray:array
                                      result:^{

                                      }
                                       error:^{
                                           
                                       }];
         }
         else
         {
             _emptyImageView.hidden = NO;
             _messageListTableView.hidden = YES;
         }


    }
                                 exceptionResponse:^(NSError *error)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [Constants showMessage:[error domain]];
    }];
    
}
//读取未阅读消息

- (void)loadUnreadMessageFromService
{
    NSDictionary *submitDic = @{@"user_id":_userInfo.member_id,
                                @"user_type":@"1",
                                @"is_read":@0};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebService requestJsonArrayOperationWithParam:submitDic
                                            action:@"msg/service/list"
                                        modelClass:[MessageModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (status.intValue > 0 && array.count > 0)
         {
             [DBManager insertDateToDBforTab:20
                                   withArray:array
                                      result:^{
                                          for (int x = 0; x<array.count; x++)
                                          {
                                              [_messageArray insertObject:array[x] atIndex:0];
                                          }
                                          _emptyImageView.hidden = YES;
                                          _messageListTableView.hidden = NO;
                                          [_messageListTableView reloadData];
                                      }
                                       error:^{
                                           _emptyImageView.hidden = NO;
                                           _messageListTableView.hidden = YES;
                                           [_messageListTableView reloadData];
                                       }];
         }
         else
         {
             if (_messageArray.count > 0)
             {
                 _emptyImageView.hidden = YES;
                 _messageListTableView.hidden = NO;
                 [_messageListTableView reloadData];
             }
             else
             {
                 _emptyImageView.hidden = NO;
                 _messageListTableView.hidden = YES;
                 [_messageListTableView reloadData];
             }

         }

     }
                                 exceptionResponse:^(NSError *error)
     {
                                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                     [Constants showMessage:[error domain]];
         if (_messageArray.count > 0)
         {
             _emptyImageView.hidden = YES;
             _messageListTableView.hidden = NO;
             [_messageListTableView reloadData];
         }
         else
         {
             _emptyImageView.hidden = NO;
             _messageListTableView.hidden = YES;
             [_messageListTableView reloadData];
         }
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
