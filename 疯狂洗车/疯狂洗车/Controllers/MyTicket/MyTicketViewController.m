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
#import "UIView+Toast.h"

#import "PresentedTicketsViewController.h"



@interface MyTicketViewController ()
{
    int _pageIndex;
    
    BOOL _canLoadMore;
}

@end

@implementation MyTicketViewController

static NSString *myTicketCellIndentifier = @"MyTicketCell";

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPresentSuccessAndRefreshTicketsListNotification object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"优惠券"];
    
    _ticketArray = [NSMutableArray array];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 68, 36)];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];

    
    if (!self.isInMine)//当用户由车服务下单页面进入优惠券列表事的显示设置
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
    }
    else//当用户由“我的”页面进入优惠券列表事的显示设置
    {
//        [rightBtn setTitle:@"转赠" forState:UIControlStateNormal];
//        [rightBtn setTitleColor:[UIColor colorWithRed:0xff/255.0
//                                                green:0x66/255.0
//                                                 blue:0x19/255.0
//                                                alpha:1.0] forState:UIControlStateNormal];
//        [rightBtn addTarget:self
//                     action:@selector(doBtnPresentedViewController)
//           forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//        [self.navigationItem setRightBarButtonItem:rightItem];
//        rightBtn.frame = CGRectMake(0, 0, 50, 36);
//        
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
//        headerView.backgroundColor = _COLOR(0xe3, 0xe3, 0xe3);
//        
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 84, 2, 78, 36)];
//        btn.titleLabel.font = [UIFont systemFontOfSize:16];
//        [btn setTitle:@"使用说明" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor colorWithRed:96.0/255.0
//                                           green:96.0/255.0
//                                            blue:96.0/255.0
//                                           alpha:1.0] forState:UIControlStateNormal];
//        [btn addTarget:self
//                action:@selector(didRightButtonTouch)
//      forControlEvents:UIControlEventTouchUpInside];
//        [headerView addSubview:btn];
//        
//        _ticketListTableView.tableHeaderView = headerView;
    }
    
    [_ticketListTableView registerNib:[UINib nibWithNibName:myTicketCellIndentifier
                                                     bundle:[NSBundle mainBundle]]
               forCellReuseIdentifier:myTicketCellIndentifier];
    
    [_ticketListTableView addHeaderActionWithTarget:self
                                             action:@selector(getAllUserTickets)];
    
    [_ticketListTableView addFooterActionWithTarget:self
                                             action:@selector(getMoreUserTickets)];


    _pageIndex = 1;
    [_ticketListTableView tableViewHeaderBeginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyRefreshTicketsList:) name:kPresentSuccessAndRefreshTicketsListNotification object:nil];
}

- (void) notifyRefreshTicketsList:(NSNotification *) notify
{
    _pageIndex = 1;
    [_ticketListTableView tableViewHeaderBeginRefreshing];
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
    
      submitDic = @{@"service_type":self.serviceType,
                    @"member_id":_userInfo.member_id,
                    @"page_index":[NSString stringWithFormat:@"%d",_pageIndex],
                    @"page_size":@"20",
                    @"car_wash_id":self.targetCarWashID == nil?@"":self.targetCarWashID,
                    @"is_used":@"0"};
    
    self.view.userInteractionEnabled = NO;
    [WebService requestJsonArrayWXOperationWithParam:submitDic
                                            action:@"serviceCode/service/list"
                                        modelClass:[TicketModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
    {
        if(self.isInMine){
            if(array.count == 0){
                UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];
                [self.navigationItem setRightBarButtonItem:rightItem];
            }else
            {
                UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 68, 36)];
                rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                [rightBtn setTitle:@"转赠" forState:UIControlStateNormal];
                [rightBtn setTitleColor:[UIColor colorWithRed:0xff/255.0
                                                        green:0x66/255.0
                                                         blue:0x19/255.0
                                                        alpha:1.0] forState:UIControlStateNormal];
                [rightBtn addTarget:self
                             action:@selector(doBtnPresentedViewController)
                   forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
                [self.navigationItem setRightBarButtonItem:rightItem];
                rightBtn.frame = CGRectMake(0, 0, 50, 36);
                
                UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
                headerView.backgroundColor = _COLOR(0xe3, 0xe3, 0xe3);
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 90, 2, 88, 36)];
                btn.titleLabel.font = [UIFont systemFontOfSize:16];
                [btn setTitle:@"?使用说明" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithRed:96.0/255.0
                                                   green:96.0/255.0
                                                    blue:96.0/255.0
                                                   alpha:1.0] forState:UIControlStateNormal];
                [btn addTarget:self
                        action:@selector(didRightButtonTouch)
              forControlEvents:UIControlEventTouchUpInside];
                [headerView addSubview:btn];
                
                _ticketListTableView.tableHeaderView = headerView;
            }
        }
        
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
        [_ticketListTableView tableViewHeaderEndRefreshing];
    }
                                 exceptionResponse:^(NSError *error)
    {
        self.view.userInteractionEnabled = YES;
        _noTickeyImageView.hidden = NO;
        _ticketListTableView.hidden = YES;
        _canLoadMore = NO;
        [_ticketListTableView tableViewHeaderEndRefreshing];
        [self.view makeToast:[error domain]];

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

        submitDic = @{@"service_type":self.serviceType,
                      @"member_id":_userInfo.member_id,
                      @"page_index":[NSString stringWithFormat:@"%d",_pageIndex],
                      @"page_size":@"20",
                      @"car_wash_id":self.targetCarWashID == nil?@"":self.targetCarWashID,
                      @"is_used":@"0"};


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
         [self.view makeToast:[error domain]];
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

- (void) doBtnPresentedViewController
{
    PresentedTicketsViewController *vc = [[PresentedTicketsViewController alloc] initWithNibName:@"PresentedTicketsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

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



@end
