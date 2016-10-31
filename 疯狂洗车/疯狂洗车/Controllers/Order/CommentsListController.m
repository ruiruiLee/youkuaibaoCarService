//
//  CommentsListController.m
//  优快保
//
//  Created by 朱伟铭 on 15/1/30.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CommentsListController.h"
#import "WebServiceHelper.h"
#import "UIView+Toast.h"
#import "CommentsListCell.h"
#import "TQStarRatingView.h"
#import "UIImageView+WebCache.h"
#import "AddCommentController.h"


@interface CommentsListController ()
{
    NSMutableArray  *_dataArray;
    NSInteger       _pageIndex;
    NSInteger       _pageSize;
}

@end

static NSString *ReuseIndentifier = @"CommentsListCell";

@implementation CommentsListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%d",_carWashInfo.service_type.intValue);
    if (self.isButler)
    {
        [self setTitle:@"车保姆评价"];
    }
    else
    {
        [self setTitle:@"车场评价"];
    }
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 72, 32)];
    [rightBtn setTitle:@"我要评价" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn setTitleColor:[UIColor colorWithRed:205.0/255.0
                                            green:85.0/255.0
                                             blue:20.0/255.0
                                            alpha:1.0] forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(didRightButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];

    
    _pageIndex = 1;
    _pageSize = 20;
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [_titleLabel setText:_carWashInfo.name];
    [_addressLabel setText:_carWashInfo.address];
    
    if (self.commentType == 0)
    {
        [_nowPriceLabel setText:@"洗车服务评分："];
    }
    else
    {
        [_nowPriceLabel setText:@"车服务评分："];

    }


    [_startRatingView setScore:_carWashInfo.average_score.floatValue/5.0 withAnimation:NO];
    [_commentCountLabel setText:[NSString stringWithFormat:@"共%@个车友评价 ", _carWashInfo.evaluation_counts]];
    
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius = 5;
    
    
    if (self.isButler)
    {
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.cornerRadius = _iconView.frame.size.width/2.0;
    }
    else
    {
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.cornerRadius = 5;
    }
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_carWashInfo.logo]
                     placeholderImage:[UIImage imageNamed:@"img_default_logo"]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if (error == nil)
         {
             [_iconView setImage:[Constants imageByScalingAndCroppingForSize:CGSizeMake(85, 85) withTarget:image]];
         }
     }];

    
    
    _iconView.layer.borderWidth = 0.5;
    _iconView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // Do any additional setup after loading the view from its nib.
    
    [_listTable addHeaderActionWithTarget:self action:@selector(obtainCommentsList)];
    
    [_listTable addFooterActionWithTarget:self action:@selector(loadMoreComments)];
    

    [_listTable registerNib:[UINib nibWithNibName:@"CommentsListCell"
                                           bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:ReuseIndentifier];
    
    [self addCommentNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_listTable tableViewHeaderBeginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求数据

- (void)obtainCommentsList
{
    /*
     4.2　分页查询某车场的评价 (测试通过)
     地址：http://118.123.249.87/service/ get_car_wash_evaluation.aspx
     参数:
     car_wash_id:车场编号
     page_index:第几页
     page_size：每页大小
     返回纪录自动按时间倒序排序，返回的格式如下:
     */
    _pageIndex = 1;
    _pageSize = 20;
    
    NSDictionary *submitDic = @{@"car_wash_id": _carWashInfo.car_wash_id,
                                @"page_index": [NSNumber numberWithInteger:_pageIndex],
                                @"page_size": [NSNumber numberWithInteger:_pageSize],
                                @"service":[NSString stringWithFormat:@"%ld",self.commentType+1]};

    
    [WebService requestJsonArrayOperationWithParam:submitDic
                                            action:@"evaluation/service/list"
                                        modelClass:[EvaluationListModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         [_listTable tableViewHeaderEndRefreshing];
         _dataArray = array;
         if([_dataArray count] < _pageSize * _pageIndex)
         {
             [_listTable letTableViewFooterHidden:YES];;
         }
         else
         {
             _pageIndex += 1;
         }
         [_listTable reloadData];
     }
                                 exceptionResponse:^(NSError *error)
     {
         [_listTable tableViewHeaderEndRefreshing];
         [self.view makeToast:[[error userInfo] valueForKey:@"msg"]];
     }];
    
}

#pragma mark - 加载更多

- (void)loadMoreComments
{
    [WebService requestJsonArrayOperationWithParam:@{@"car_wash_id": _carWashInfo.car_wash_id,
                                                     @"page_index": [NSNumber numberWithInteger:_pageIndex],
                                                     @"page_size": [NSNumber numberWithInteger:_pageSize],
                                                     @"service":[NSString stringWithFormat:@"%ld",self.commentType+1]}
                                            action:@"evaluation/service/list"
                                        modelClass:[EvaluationListModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         [_dataArray  addObjectsFromArray:array];
         if([_dataArray count] < _pageSize * _pageIndex)
         {
         }
         else
         {
             _pageIndex += 1;
         }
         [_listTable tableViewfooterEndRefreshing];
         [_listTable reloadData];
     }
                                 exceptionResponse:^(NSError *error)
     {
         [_listTable tableViewfooterEndRefreshing];
         [self.view makeToast:[[error userInfo] valueForKey:@"msg"]];
     }];
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluationListModel *info = _dataArray[indexPath.row];
    CGSize messageSize = CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT);
    CGSize contentSize =[info.content boundingRectWithSize:messageSize
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]}
                                                             context:nil].size;
    if (contentSize.height > 16)
    {
        return 90+contentSize.height;
    }
    else
    {
        return 90.0;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentsListCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIndentifier];
    if (nil == cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CommentsListCell"
                                             owner:nil
                                           options:nil][0];
    }
    EvaluationListModel *info = _dataArray[indexPath.row];
    if ([info.phone isEqualToString:@""] || info.phone == nil)
    {
        [cell.titleLabel setText:@"匿名用户"];
    }
    else
    {
        [cell.titleLabel setText:[NSString stringWithFormat:@"%@" , info.phone]];
    }


    [cell.scoreView setScore:[info.score doubleValue] /5.0 withAnimation:NO];
    [cell.timeLabel setText:info.evaluation_time];
    [cell.commentsLabel setText:info.content];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didRightButtonTouch
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
    AddCommentController *controller = ALLOC_WITH_CLASSNAME(@"AddCommentController");
    [controller setCarWashModel:self.carWashInfo];
    if (self.commentType == 0)
    {
        controller.isCarWash = YES;
    }
    controller.service_id = [NSString stringWithFormat:@"%ld",(long)self.commentType];
    controller.isButler = self.isButler;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)addCommentNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishAddCommented)
                                                 name:kAddCommentsSuccess
                                               object:nil];
}

- (void)didFinishAddCommented
{
    
    NSString *service = nil;
    
    if (self.commentType == 0)
    {
        service = @"1";//洗车
    }
    else
    {
        service = @"2";//其他
    }
    
    NSDictionary *submitDic = @{@"car_wash_id":self.carWashInfo.car_wash_id,
                                @"service":service};
    
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"carWash/service/detail"
                               normalResponse:^(NSString *status, id data)
     {
         if (status.intValue > 0)
         {
             if ([data isKindOfClass:[NSNull class]])
             {
                 [Constants showMessage:@"订单数据错误"];
                 return ;
             }
             CarWashModel *model = [[CarWashModel alloc] initWithDictionary:data];
             self.carWashInfo.evaluation_counts = model.evaluation_counts;
             self.carWashInfo.average_score = model.average_score;
             [_startRatingView setScore:_carWashInfo.average_score.floatValue/5.0 withAnimation:NO];
             [_commentCountLabel setText:[NSString stringWithFormat:@"共%@个车友评价 ", _carWashInfo.evaluation_counts]];
        }
         else
         {
             [self.view makeToast:@"刷新车场信息失败"];
         }
     }
                            exceptionResponse:^(NSError *error)
     {
         [self.view makeToast:@"刷新车场信息失败"];
     }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAddCommentsSuccess object:nil];
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
