//
//  CarNannyMessageViewController.m
//  优快保
//
//  Created by cts on 15/4/11.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "CarNannyMessageViewController.h"
#import "CarNannyMessaceCell.h"
#import "NannyModel.h"
#import "NannyTypeModel.h"
#import "WebServiceHelper.h"
#import "MBProgressHUD+Add.h"
#import "UIView+Toast.h"
#import "CarNannyRichMessageViewController.h"
#import "PhotoBroswerVC.h"


@interface CarNannyMessageViewController ()<CarNannyRichMessageDelegate,CarNannyMessaceCellDelegate>
{
    
    BOOL  _canLoadMore;
    
    NSInteger  _currantPage;
    NSInteger   _nanny_type;
    
    NSMutableArray  *_nanyTypeArray;
    
    NannyTypeModel  *_selectNannyType;
    
    NSInteger   _preSelect;
    
    float       _keyBoardHeight;
}

@end

@implementation CarNannyMessageViewController
static NSString *CarNannyMessaceCellIdentifier = @"CarNannyMessaceCell";


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 36, 32)];
    [rightBtn setTitle:@"留言" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn setTitleColor:[UIColor colorWithRed:205.0/255.0
                                            green:85.0/255.0
                                             blue:20.0/255.0
                                            alpha:1.0] forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(didRichMessageButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
    


    
    UITapGestureRecognizer *conditionViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(didTapOnConditionView)];
    [_conditionView addGestureRecognizer:conditionViewTapGesture];
    
    
    _conditionButton.layer.masksToBounds = YES;
    _conditionButton.layer.cornerRadius = 4;
    _conditionButton.layer.borderWidth = 1;
    _conditionButton.layer.borderColor = _conditionButton.titleLabel.textColor.CGColor;
    
    
//    [rightBtn addTarget:self action:@selector(changeDisplayType:) forControlEvents:UIControlEventTouchUpInside];
    



    [self setTitle:@"车大白"];
    
    [_messageTableView addHeaderActionWithTarget:self
                                          action:@selector(loadAlllNannyMessage)];
    
    [_messageTableView addFooterActionWithTarget:self
                                          action:@selector(loadMoreNannyMessage)];



    
    [_messageTableView registerNib:[UINib nibWithNibName:CarNannyMessaceCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:CarNannyMessaceCellIdentifier];
    _messageArray = [NSMutableArray array];
    
    if (_userInfo.member_id == nil)
    {
        [_typeSegment setSelectedSegmentIndex:1];
    }
    [self configConditionItems];
    [self showOrHideContitionView:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (_userInfo.member_id != nil)
    {
        if (_messageArray.count > 0)
        {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:kUnreadMessage])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUnreadMessage];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //[_appDelegate refreshMessageNumLabel:@""];
                if (!_userInfo.member_id)
                {
                    
                }
                else
                {
                    [_typeSegment setSelectedSegmentIndex:0];
                    [_messageTableView tableViewHeaderBeginRefreshing];
                }
            }
        }


        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadAllCannyMessageForReply)
                                                     name:@"shouldupdatedate"
                                                   object:nil];
    }
    else if (_typeSegment.selectedSegmentIndex == 0)
    {
        [_typeSegment setSelectedSegmentIndex:1];
        [_messageTableView tableViewHeaderBeginRefreshing];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];


    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"shouldupdatedate"
                                                  object:nil];
}


#pragma mark - UITableViewDataSource Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _messageArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NannyModel *model = _messageArray[indexPath.section];
    
    CGSize messageSize = CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT);
    CGSize contentSize =[model.question_content boundingRectWithSize:messageSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                                  context:nil].size;
    
    CGSize responeSize = CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT);
    CGSize responeContent = [model.reply_content boundingRectWithSize:responeSize
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                                                 context:nil].size;
    
    CGSize imageContentSize = CGSizeMake(0, 0);
    
    if (model.imageAddrsArray.count > 0)
    {
        if (model.photo_status.intValue > 0)
        {
            float itemWidth = (SCREEN_WIDTH - 35)/4.0;
            float itemHeight = itemWidth;
            float cloumFloat = (int)model.imageAddrsArray.count /4.0;
            int cloum = (int)cloumFloat;
            if (cloumFloat > cloum)
            {
                cloum++;
            }
            imageContentSize = CGSizeMake(0, cloum*itemHeight + 30);
        }
        else if ([model.member_id isEqualToString:_userInfo.member_id])
        {
            float itemWidth = (SCREEN_WIDTH - 35)/4.0;
            float itemHeight = itemWidth;
            float cloumFloat = (int)model.imageAddrsArray.count /4.0;
            int cloum = (int)cloumFloat;
            if (cloumFloat > cloum)
            {
                cloum++;
            }
            imageContentSize = CGSizeMake(0, cloum*itemHeight + 30);
        }
        else
        {
            
        }
    }
    
    
    

    if (contentSize.height <= 18 && responeContent.height <= 18 && imageContentSize.height <= 0)
    {
        return 155;
    }
    else
    {
        return 119+contentSize.height+responeContent.height + imageContentSize.height;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, SCREEN_WIDTH-10, 13)];
    label.font = [UIFont systemFontOfSize:13];
    NannyModel *model = _messageArray[section];
    label.text = model.question_time;
    label.textColor = [UIColor colorWithRed:37/255.0 green:37/255.0 blue:37/255.0 alpha:1.0];
    [view addSubview:label];
    
    if (_userInfo.member_id != nil)
    {
        if ([model.member_id isEqualToString:_userInfo.member_id])
        {
            UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteButton.frame = CGRectMake(view.frame.size.width-34, 6, 30, 24);
            [deleteButton setImage:[UIImage imageNamed:@"btn_carNurseMessage_delete"] forState:UIControlStateNormal];
            [deleteButton setBackgroundColor:[UIColor clearColor]];
            deleteButton.tag = section;
            [deleteButton addTarget:self
                             action:@selector(didDeleteButtonTouch:)
                   forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:deleteButton];
        }
    }

    
    return view;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarNannyMessaceCell *cell = [tableView dequeueReusableCellWithIdentifier:CarNannyMessaceCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[CarNannyMessaceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CarNannyMessaceCellIdentifier];
    }
    
    cell.delegate = self;
    cell.indexPath = indexPath;
    NannyModel *model = _messageArray[indexPath.section];
    [cell setDisplayInfo:model];
    
    
    return cell;
}

#pragma mark - CarNannyMessaceCellDelegate Method

- (void)didSelectAndShowBigImage:(NSIndexPath *)indexPath andImageIndex:(NSInteger)imageIndex
{    
    NannyModel *model = _messageArray[indexPath.section];

    __weak typeof(self) weakSelf=self;
    
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypePush index:imageIndex photoModelBlock:^NSArray *{
        
        
        NSArray *networkImages=model.imageAddrsArray;
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:networkImages.count];
        for (NSUInteger i = 0; i< networkImages.count; i++) {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.image_HD_U = networkImages[i];
            
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];

}

#pragma mark - UIScrollViewDelegate Method

- (IBAction)didChangeNannyMessageType:(UIButton *)sender
{
    if (_conditionButton.selected)
    {
        [self showOrHideContitionView:NO];
        
        _conditionButton.selected = NO;
    }
    else
    {
        [self showOrHideContitionView:YES];
        
        _conditionButton.selected = YES;
    }

}

#pragma mark - 用户选择消息归属 Method

- (IBAction)didTypeSegmentChangeed:(UISegmentedControl*)sender
{
    [self showOrHideContitionView:NO];
    if (!_userInfo.member_id && sender.selectedSegmentIndex == 0)
    {
        [sender setSelectedSegmentIndex:1];
        id viewController = [QuickLoginViewController sharedLoginByCheckCodeViewControllerWithProtocolEnable:nil];
        
        [self presentViewController:viewController animated:YES completion:^
         {
             [[[UIApplication sharedApplication] keyWindow] makeToast:@"请先登录"];
         }];
        
        return;
    }
    
    [_messageTableView tableViewHeaderBeginRefreshing];
    
    //[self loadAlllNannyMessage];
}

#pragma mark - 加载消息类型 Method

- (void)configConditionItems
{
    _nanyTypeArray = [NSMutableArray array];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebService requestJsonArrayOperationWithParam:nil
                                            action:@"nanny/service/getType"
                                        modelClass:[NannyTypeModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
    {
        if (status.intValue > 0 && array.count > 0)
        {
            [_nanyTypeArray addObjectsFromArray:array];
            [self setUpConditionScrollViewWithItems:_nanyTypeArray];
            [_messageTableView tableViewHeaderBeginRefreshing];
        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:@"启动车保姆失败" toView:self.view];
        }
    }
                                 exceptionResponse:^(NSError *error) {
                                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                     [MBProgressHUD showError:@"启动车保姆失败" toView:self.view];
    }];
}

#pragma mark - 初始化消息类型选择控件 Method

- (void)setUpConditionScrollViewWithItems:(NSArray*)array
{
    float itemWidth = SCREEN_WIDTH/3.0;
    float itemHeight = _conditionItemScrollView.frame.size.height/3.0;
    for (int x = 0; x<array.count; x++)
    {
        NannyTypeModel *model = array[x];
        int cloum = x/3;
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.frame = CGRectMake((x%3)*itemWidth, cloum*itemHeight, itemWidth, itemHeight);
        
        if ([model.type_name isEqualToString:@"所有"])
        {
            itemButton.selected = YES;
        }
        [itemButton setTitle:model.type_name forState:UIControlStateNormal];
        [itemButton setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateSelected];
        
        
        [itemButton setTitleColor:[UIColor colorWithRed:34/355.0 green:34/355.0 blue:34/355.0 alpha:1.0]
                         forState:UIControlStateNormal];
        [itemButton setBackgroundImage:[UIImage imageNamed:@"img_button_higlithed"]
                              forState:UIControlStateSelected];
        itemButton.layer.borderWidth = 0.5;
        itemButton.tag = x;
        [itemButton setTintColor:[UIColor lightGrayColor]];
        
        itemButton.layer.borderColor = [UIColor colorWithRed:204/255.0
                                                       green:204/255.0
                                                        blue:204/255.0
                                                       alpha:1.0].CGColor;
        [itemButton addTarget:self action:@selector(didSelectConditionItem:) forControlEvents:UIControlEventTouchUpInside];
        [_conditionItemScrollView addSubview:itemButton];
    }
}

- (void)didTapOnConditionView
{
    [self showOrHideContitionView:NO];
}

- (void)didSelectConditionItem:(UIButton*)sender
{
    if (sender.selected)
    {
        return;
    }
    for (UIView *view in _conditionItemScrollView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton*)view;
            if (button == sender)
            {
                button.selected = YES;
            }
            else
            {
                button.selected = NO;
            }
        }
    }
    _selectNannyType = _nanyTypeArray[sender.tag];
    if ([_selectNannyType.type_name isEqualToString:@"所有"])
    {
        [_conditionButton setTitle:@"所有分类"
                          forState:UIControlStateNormal];
    }
    else
    {
        [_conditionButton setTitle:_selectNannyType.type_name
                          forState:UIControlStateNormal];
    }
    [self showOrHideContitionView:NO];
    [_messageArray removeAllObjects];
    [_messageTableView reloadData];
    [_messageTableView tableViewHeaderBeginRefreshing];
}

- (void)showOrHideContitionView:(BOOL)shouldShow
{
    if (shouldShow)
    {
        _conditionView.hidden = NO;
        [UIView animateWithDuration:0.3
                         animations:^{
                             _conditionArrowIcon.highlighted = YES;
                             _conditionArrowIcon.transform = CGAffineTransformMakeRotation(M_PI);
                             _conditionItemScrollView.transform = CGAffineTransformIdentity;
                             _conditionButton.selected = YES;
                             [_conditionButton setBackgroundColor:[UIColor colorWithRed:235/255.0 green:84/255.0 blue:1/255.0 alpha:1.0]];
                             
                         }
                         completion:^(BOOL finished)
         {
             
         }];
    }
    else
    {
        _conditionView.hidden = YES;
        _conditionButton.selected = NO;
        [_conditionButton setBackgroundColor:[UIColor clearColor]];
        _conditionArrowIcon.highlighted = NO;
        _conditionArrowIcon.transform = CGAffineTransformIdentity;
        _conditionItemScrollView.transform = CGAffineTransformMakeTranslation(0, -_conditionItemScrollView.frame.size.height);
    }
}

#pragma mark - 消息数据加载 Method

- (void)loadAlllNannyMessage
{
    _nanny_type = 0;
    _currantPage = 1;
    _canLoadMore = YES;

    NSMutableDictionary *submitDic = [NSMutableDictionary dictionary];
    if (_selectNannyType == nil)
    {
        [submitDic setObject:@"0" forKey:@"nanny_type"];
    }
    else
    {
        [submitDic setObject:_selectNannyType.type_id forKey:@"nanny_type"];
    }
    if (_typeSegment.selectedSegmentIndex == 0)
    {
        [submitDic setObject:_userInfo.member_id forKey:@"member_id"];
    }
    else
    {
        if (!_userInfo.member_id)
        {
            
        }
        else
        {
            [submitDic setObject:_userInfo.member_id forKey:@"member_id2"];
        }
    }
    
    
    
    [submitDic setObject:[NSNumber numberWithInteger:_currantPage] forKey:@"page_index"];
    [submitDic setObject:@"10" forKey:@"page_size"];
    [WebService requestJsonArrayOperationWithParam:submitDic
                                            action:@"nanny/service/list"
                                        modelClass:[NannyModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (status.intValue > 0 && array.count > 0)
        {
            if (_messageArray.count > 0)
            {
                [_messageArray removeAllObjects];
            }
            [_messageArray addObjectsFromArray:array];
            if (array.count >= 10)
            {
                _canLoadMore = YES;
                _currantPage++;
            }
            else
            {
                _canLoadMore = NO;
            }
            if ([[NSUserDefaults standardUserDefaults] objectForKey:kUnreadMessage])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUnreadMessage];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [_appDelegate showNewLabel:_unReadMessageCount andNannyMessage:0];

            }

            
            _messageTableView.hidden = NO;
            _emptyImageView.hidden = YES;
            [_messageTableView reloadData];
        }
        else
        {
            _messageTableView.hidden = YES;
            _emptyImageView.hidden = NO;
            _emptyImageView.highlighted = _selectNannyType == nil?NO:YES;

        }
        [_messageTableView tableViewHeaderEndRefreshing];
    }
                                 exceptionResponse:^(NSError *error)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"获取信息失败" toView:self.view];
        [_messageTableView tableViewHeaderEndRefreshing];

    }];
}

- (void)loadMoreNannyMessage
{
    if (!_canLoadMore)
    {
        [_messageTableView tableViewfooterEndRefreshing];
        return;
    }
    NSMutableDictionary *submitDic = [NSMutableDictionary dictionary];
    if (_selectNannyType == nil)
    {
        [submitDic setObject:@"0" forKey:@"nanny_type"];
    }
    else
    {
        [submitDic setObject:_selectNannyType.type_id forKey:@"nanny_type"];
    }
    if (_typeSegment.selectedSegmentIndex == 0)
    {
        [submitDic setObject:_userInfo.member_id forKey:@"member_id"];
    }
    else
    {
        if (!_userInfo.member_id)
        {
            
        }
        else
        {
            [submitDic setObject:_userInfo.member_id forKey:@"member_id2"];
        }
    }
    
    [submitDic setObject:[NSNumber numberWithInteger:_currantPage] forKey:@"page_index"];
    [submitDic setObject:@"10" forKey:@"page_size"];
    [WebService requestJsonArrayOperationWithParam:submitDic
                                            action:@"nanny/service/list"
                                        modelClass:[NannyModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (status.intValue > 0 && array.count > 0)
         {
             [_messageArray addObjectsFromArray:array];
             if (array.count >= 10)
             {
                 _canLoadMore = YES;
                 _currantPage ++;
             }
             else
             {
                 _canLoadMore = NO;
             }
             _messageTableView.hidden = NO;
             _emptyImageView.hidden = YES;
             [_messageTableView reloadData];
         }
         else
         {
             if (_messageArray.count == 0)
             {
                 _messageTableView.hidden = YES;
                 _emptyImageView.hidden = NO;
                 _emptyImageView.highlighted = _selectNannyType == nil?NO:YES;
             }

         }
         [_messageTableView tableViewfooterEndRefreshing];
     }
                                 exceptionResponse:^(NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [MBProgressHUD showError:@"获取信息失败" toView:self.view];
         [_messageTableView tableViewfooterEndRefreshing];
     }];
}

#pragma mark - 跳转富文本发送编辑页面 Method

- (void)didRichMessageButtonTouch
{
    if (!_userInfo.member_id)
    {
        id viewController = [QuickLoginViewController sharedLoginByCheckCodeViewControllerWithProtocolEnable:nil];
        
        [self presentViewController:viewController animated:YES completion:^
         {
             [[[UIApplication sharedApplication] keyWindow] makeToast:@"请先登录"];
         }];
        return;
    }
    CarNannyRichMessageViewController *viewController = nil;
    if (bIsiOS7)
    {
        viewController = [[CarNannyRichMessageViewController alloc] initWithNibName:@"CarNannyRichMessageViewController_7"
                                                                                                                bundle:nil];
    }
    else
    {
        viewController = [[CarNannyRichMessageViewController alloc] initWithNibName:@"CarNannyRichMessageViewController"
                                                                                                                bundle:nil];
    }
    viewController.delegate = self;
    viewController.selectNannyType = _selectNannyType;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - 消息发送完成 Method

- (void)didFinishMessageSend
{
    [self showOrHideContitionView:NO];
    [_messageArray removeAllObjects];
    [_messageTableView reloadData];
    [_typeSegment setSelectedSegmentIndex:0];
    _selectNannyType = nil;
    
    _conditionButton.selected = NO;
    [_messageTableView tableViewHeaderBeginRefreshing];
}

#pragma mark - 删除消息 Method

- (void)didDeleteButtonTouch:(UIButton*)sender
{
    int target = 600+(int)sender.tag;
    [Constants showMessage:@"确定删除该条留言？"
                  delegate:self
                       tag:target
              buttonTitles:@"取消",@"确定", nil];
}

#pragma mark - 接收通知加载刷新列表 Method

- (void)loadAllCannyMessageForReply
{
    [self showOrHideContitionView:NO];
    [_messageArray removeAllObjects];
    [_messageTableView reloadData];
    [_typeSegment setSelectedSegmentIndex:0];
    _selectNannyType = nil;

    _conditionButton.selected = NO;
    [_messageTableView tableViewHeaderBeginRefreshing];
}

#pragma mark - 打电话 Method

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

- (void)callCustomService
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_kefudianhuaNumber]]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 530 && buttonIndex ==1)
    {
        [self callCustomService];
    }
    if (alertView.tag >= 600 && buttonIndex == 1)
    {
        NSInteger target = alertView.tag - 600;
        NannyModel *model = _messageArray[target];
        if (![model.member_id isEqualToString:_userInfo.member_id])
        {
            [Constants showMessage:@"您没有权限删除此条留言"];
        }
        else
        {
            NSDictionary *submitDic = @{@"nanny_id":model.nanny_id};
            [WebService requestJsonOperationWithParam:submitDic
                                               action:@"nanny/service/del"
                                       normalResponse:^(NSString *status, id data)
             {
                 if (status.intValue > 0)
                 {
                     [Constants showMessage:@"留言删除成功"];
                     [self loadAlllNannyMessage];
                 }
                 else
                 {
                     [Constants showMessage:@"删除留言失败"];
                 }
            }
                                    exceptionResponse:^(NSError *error)
             {
                                        [Constants showMessage:[error domain]];

            }];
        }
        

        
    }
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
