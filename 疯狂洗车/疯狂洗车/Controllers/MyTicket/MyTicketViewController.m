//
//  MyTicketViewController.m
//  优快保
//
//  Created by cts on 15/5/21.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "MyTicketViewController.h"
#import "MyTicketCell.h"
#import "TicketModel.h"
#import "ADVModel.h"
#import "ActivitysController.h"
#import "CheXiaoBaoViewController.h"
#import "define.h"



@interface MyTicketViewController ()
{
    int _pageIndex;
    
    BOOL _canLoadMore;
}

@end

@implementation MyTicketViewController

static NSString *myTicketCellIndentifier = @"MyTicketCell";


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"优惠券"];
    
    _ticketArray = [NSMutableArray array];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 68, 36)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];

    
    if ([self.delegate respondsToSelector:@selector(didFinishTicketSelect:)])//当用户由车服务下单页面进入优惠券列表事的显示设置
    {
        [rightBtn setTitle:@"使用说明" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor colorWithRed:96.0/255.0
                                                green:96.0/255.0
                                                 blue:96.0/255.0
                                                alpha:1.0] forState:UIControlStateNormal];
        [rightBtn addTarget:self
                     action:@selector(didRightButtonTouch)
           forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        [self.navigationItem setRightBarButtonItem:rightItem];
        
//        [rightBtn setTitle:@"不使用券" forState:UIControlStateNormal];
//        [rightBtn setTitleColor:self.isClubController?[UIColor whiteColor]:[UIColor colorWithRed:96.0/255.0
//                                                green:96.0/255.0
//                                                 blue:96.0/255.0
//                                                alpha:1.0] forState:UIControlStateNormal];
//        [rightBtn addTarget:self action:@selector(didCleanTicketSelect) forControlEvents:UIControlEventTouchUpInside];
//        
        
        //该情况不需要显示顶部segment
//        _topView.hidden = YES;
//        for (int x = 0; x<_topView.constraints.count; x++)
//        {
//            NSLayoutConstraint *layoutConstraint = _topView.constraints[x];
//            if (layoutConstraint.firstAttribute == NSLayoutAttributeHeight)
//            {
//                [_topView removeConstraint:layoutConstraint];
//                break;
//            }
//            
//        }
//        NSDictionary* views = NSDictionaryOfVariableBindings(_topView);
//        NSString *constrainString = [NSString stringWithFormat:@"V:[_topView(%d)]",0];
//        
//        [_topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constrainString
//                                                                            options:0
//                                                                            metrics:nil
//                                                                              views:views]];

//        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//        [self.navigationItem setRightBarButtonItem:rightItem];
    }
    else//当用户由“我的”页面进入优惠券列表事的显示设置
    {
//        if (_appconfig.service_code_intro == nil || [_appconfig.service_code_intro isEqualToString:@""])
//        {
//            
//        }
//        else
//        {
            [rightBtn setTitle:@"使用说明" forState:UIControlStateNormal];
            [rightBtn setTitleColor:[UIColor colorWithRed:96.0/255.0
                                                    green:96.0/255.0
                                                     blue:96.0/255.0
                                                    alpha:1.0] forState:UIControlStateNormal];
            [rightBtn addTarget:self
                         action:@selector(didRightButtonTouch)
               forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
            [self.navigationItem setRightBarButtonItem:rightItem];
//        }

    }

    
    [_ticketListTableView registerNib:[UINib nibWithNibName:myTicketCellIndentifier
                                                     bundle:[NSBundle mainBundle]]
               forCellReuseIdentifier:myTicketCellIndentifier];
    
    [_ticketListTableView addHeaderActionWithTarget:self
                                             action:@selector(getAllUserTickets)];
    
    [_ticketListTableView addFooterActionWithTarget:self
                                             action:@selector(getMoreUserTickets)];


    
    [self getAllUserTickets];
}

#pragma mark - 选择顶部segmented切换券状态 Method

- (IBAction)didSegmentControlValueChange:(UISegmentedControl *)sender
{
    [_ticketListTableView tableViewHeaderBeginRefreshing];
}

#pragma mark - 获取用户的券 Method

- (void)getAllUserTickets
{
    _pageIndex = 1;
    NSDictionary *submitDic = nil;
    
//    if (_topView.hidden)
//    {
//        submitDic = @{@"service_type":self.serviceType,
//                      @"member_id":_userInfo.member_id,
//                      @"page_index":[NSString stringWithFormat:@"%d",_pageIndex],
//                      @"page_size":@"20",
//                      @"car_wash_id":self.targetCarWashID == nil?@"":self.targetCarWashID,
//                      @"is_used":@"3"};
//
//    }
//    else if (_segmentControl.selectedSegmentIndex == 0)
//    {
      submitDic = @{@"service_type":self.serviceType,
                    @"member_id":_userInfo.member_id,
                    @"page_index":[NSString stringWithFormat:@"%d",_pageIndex],
                    @"page_size":@"20",
                    @"car_wash_id":self.targetCarWashID == nil?@"":self.targetCarWashID,
                    @"is_used":@"0"};
//    }
//    else if (_segmentControl.selectedSegmentIndex == 1)
//    {
//        submitDic = @{@"service_type":self.serviceType,
//                      @"member_id":_userInfo.member_id,
//                      @"page_index":[NSString stringWithFormat:@"%d",_pageIndex],
//                      @"page_size":@"20",
//                      @"car_wash_id":self.targetCarWashID == nil?@"":self.targetCarWashID,
//                      @"is_used":@"1"};
//    }
//    else
//    {
//        submitDic = @{@"service_type":self.serviceType,
//                      @"member_id":_userInfo.member_id,
//                      @"page_index":[NSString stringWithFormat:@"%d",_pageIndex],
//                      @"page_size":@"20",
//                      @"car_wash_id":self.targetCarWashID == nil?@"":self.targetCarWashID,
//                      @"is_used":@"2"};
//    }
    
    self.view.userInteractionEnabled = NO;
    [WebService requestJsonArrayWXOperationWithParam:submitDic
                                            action:@"serviceCode/service/list"
                                        modelClass:[TicketModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
    {
        if (status.intValue > 0 && array.count > 0)
        {
            if (_pageIndex == 1)
            {
                _ticketArray = array;
            }
            else
            {
                [_ticketArray addObjectsFromArray:array];
            }
            [_ticketListTableView tableViewHeaderEndRefreshing];
            if (array.count >= 20)
            {
                _canLoadMore = YES;
                _pageIndex++;
            }
            else
            {
                _canLoadMore = NO;
            }
            _noTickeyImageView.hidden = YES;
            _ticketListTableView.hidden = NO;
            [_ticketListTableView reloadData];
        }
        else
        {
            if (_pageIndex == 1)
            {
                _noTickeyImageView.hidden = NO;
                _ticketListTableView.hidden = YES;
            }
            else
            {
                _noTickeyImageView.hidden = YES;
                _ticketListTableView.hidden = NO;
            }
            _canLoadMore = NO;
        }
        self.view.userInteractionEnabled = YES;
    }
                                 exceptionResponse:^(NSError *error)
    {
        self.view.userInteractionEnabled = YES;
        _noTickeyImageView.hidden = NO;
        _ticketListTableView.hidden = YES;
        _canLoadMore = NO;
        [_ticketListTableView tableViewHeaderEndRefreshing];

    }];
}

- (void)getMoreUserTickets
{
    if (!_canLoadMore)
    {
        [_ticketListTableView tableViewfooterEndRefreshing];
        return;
    }
    NSDictionary *submitDic = nil;
//    if (_topView.hidden)
//    {
//        submitDic = @{@"service_type":self.serviceType,
//                      @"member_id":_userInfo.member_id,
//                      @"page_index":[NSString stringWithFormat:@"%d",_pageIndex],
//                      @"page_size":@"20",
//                      @"car_wash_id":self.targetCarWashID == nil?@"":self.targetCarWashID,
//                      @"is_used":@"3"};
//        
//    }
//    else if (_segmentControl.selectedSegmentIndex == 0)
//    {
        submitDic = @{@"service_type":self.serviceType,
                      @"member_id":_userInfo.member_id,
                      @"page_index":[NSString stringWithFormat:@"%d",_pageIndex],
                      @"page_size":@"20",
                      @"car_wash_id":self.targetCarWashID == nil?@"":self.targetCarWashID,
                      @"is_used":@"0"};
//    }
//    else if (_segmentControl.selectedSegmentIndex == 1)
//    {
//        submitDic = @{@"service_type":self.serviceType,
//                      @"member_id":_userInfo.member_id,
//                      @"page_index":[NSString stringWithFormat:@"%d",_pageIndex],
//                      @"page_size":@"20",
//                      @"car_wash_id":self.targetCarWashID == nil?@"":self.targetCarWashID,
//                      @"is_used":@"1"};
//    }
//    else
//    {
//        submitDic = @{@"service_type":self.serviceType,
//                      @"member_id":_userInfo.member_id,
//                      @"page_index":[NSString stringWithFormat:@"%d",_pageIndex],
//                      @"page_size":@"20",
//                      @"car_wash_id":self.targetCarWashID == nil?@"":self.targetCarWashID,
//                      @"is_used":@"2"};
//    }

    self.view.userInteractionEnabled = NO;
    [WebService requestJsonArrayWXOperationWithParam:submitDic
                                            action:@"serviceCode/service/list"
                                        modelClass:[TicketModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         if (status.intValue > 0 && array.count > 0)
         {
             if (_pageIndex == 1)
             {
                 _ticketArray = array;
             }
             else
             {
                 [_ticketArray addObjectsFromArray:array];
             }
             if (array.count >= 20)
             {
                 _canLoadMore = YES;
                 _pageIndex++;
             }
             else
             {
                 _canLoadMore = NO;
             }
             [_ticketListTableView tableViewfooterEndRefreshing];
             [_ticketListTableView reloadData];
         }
         else
         {
             if (_pageIndex == 1)
             {
                 _noTickeyImageView.hidden = NO;
                 _ticketListTableView.hidden = YES;
             }
             else
             {
                 _noTickeyImageView.hidden = YES;
                 _ticketListTableView.hidden = NO;
             }
             [_ticketListTableView tableViewfooterEndRefreshing];
             _canLoadMore = NO;
         }
         self.view.userInteractionEnabled = YES;
     }
                                 exceptionResponse:^(NSError *error)
     {
         self.view.userInteractionEnabled = YES;
         [_ticketListTableView tableViewfooterEndRefreshing];
         _noTickeyImageView.hidden = NO;
         _ticketListTableView.hidden = YES;
         _canLoadMore = NO;
     }];
}


#pragma mark - UITableViewDataSource Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _ticketArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 146.0*SCREEN_WIDTH/375.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:myTicketCellIndentifier];
    
    if (cell == nil)
    {
        cell = [[MyTicketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTicketCellIndentifier];
    }
    
    TicketModel *model = _ticketArray[indexPath.row];
    
    [cell setDisplayInfo:model];
    
    return cell;
}



#pragma mark - UITableViewDelegate Method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didFinishTicketSelect:)])//当用户由车服务下单页面进入优惠券列表并选择券后执行
    {
        [self.delegate didFinishTicketSelect:_ticketArray[indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 不使用券 Method

- (void)didCleanTicketSelect//当用户由车服务下单页面进入优惠券列表并选择“不使用券”后执行
{
    if ([self.delegate respondsToSelector:@selector(didFinishTicketSelect:)])
    {
        [self.delegate didFinishTicketSelect:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 跳转至使用说明 Method

- (void)didRightButtonTouch
{
//    ADVModel *model = [[ADVModel alloc] init];
//    model.url = _appconfig.service_code_intro;
//    model.url_type = @"1";
//    model.title = @"使用说明";
//    ActivitysController *viewController = [[ActivitysController alloc] initWithNibName:@"ActivitysController" bundle:nil];
//    viewController.advModel = model;
//    viewController.forbidAddMark = NO;
//    [self.navigationController pushViewController:viewController animated:YES];
    
    CheXiaoBaoViewController *vc = [[CheXiaoBaoViewController alloc] initWithNibName:@"CheXiaoBaoViewController" bundle:nil];
    NSString *url = [NSString stringWithFormat:TICKET_SHI_YONG_SHUOMING, BASE_Uri_FOR_WEB, _userInfo.member_id];
    vc.webUrl = url;
    [self.navigationController pushViewController:vc animated:YES];
    
    [vc setTitle:@"使用说明"];
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
