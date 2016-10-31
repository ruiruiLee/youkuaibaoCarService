//
//  OrderDetailViewController.m
//  优快保
//
//  Created by cts on 15/5/15.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderCarWashCell.h"
#import "OrderServiceCell.h"
#import "OrderDetailCell.h"
#import "CommentsListController.h"
#import "WebServiceHelper.h"
#import "MBProgressHUD+Add.h"
#import "OrderServiceIntroduceCell.h"
#import "OrderCancelViewController.h"
#import "AddCommentController.h"

@interface OrderDetailViewController ()
{
    UIButton        *_rightButton;
}

@end

@implementation OrderDetailViewController

static NSString *orderCarWashCellIdentifier = @"OrderCarWashCell";
static NSString *orderServiceCellIdentifier = @"OrderServiceCell";
static NSString *orderServiceIntroduceCellIdentifier = @"OrderServiceIntroduceCell";
static NSString *orderDetailCellIdentifier = @"OrderDetailCell";



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"订单详情"];


    // Do any additional setup after loading the view from its nib.
    
    [_contextTableView registerNib:[UINib nibWithNibName:orderServiceCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:orderServiceCellIdentifier];
    [_contextTableView registerNib:[UINib nibWithNibName:orderCarWashCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:orderCarWashCellIdentifier];
    [_contextTableView registerNib:[UINib nibWithNibName:orderServiceIntroduceCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:orderServiceIntroduceCellIdentifier];
    [_contextTableView registerNib:[UINib nibWithNibName:orderDetailCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:orderDetailCellIdentifier];
    
    if (self.orderListModel)
    {
        if ([self.orderListModel.service_type isEqualToString:@"0"] || self.orderListModel.service_type == nil)
        {
            self.isCarWashOrder = YES;
        }
        else
        {
            self.isCarWashOrder = NO;
        }
        [self loadOrderDetailInfoFromeService];
    }
    else
    {
        [Constants showMessage:@"订单数据错误"];
        return ;
    }
    

    [self addAllNotification];
}

- (void)loadOrderDetailInfoFromeService
{
    NSDictionary *submitDic = @{@"order_id": self.orderListModel.order_id};
    self.view.userInteractionEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebService requestJsonModelWithParam:submitDic
                                   action:@"order/service/detail"
                               modelClass:[OrderDetailModel class]
                           normalResponse:^(NSString *status, id data, JsonBaseModel *model)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         self.view.userInteractionEnabled = YES;
         if (status.intValue > 0)
         {
             if ([data isKindOfClass:[NSNull class]])
             {
                 [Constants showMessage:@"获取订单数据失败"];
                 return ;
             }
             self.orderModel = (OrderDetailModel*)model;
             [self setUpDisplayInfo];
         }
         else
         {
             [Constants showMessage:@"获取订单数据失败"];
             return ;
         }
         
     }
                        exceptionResponse:^(NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         self.view.userInteractionEnabled = YES;
         [Constants showMessage:[error domain]];
         return ;
     }];

}

- (void)addAllNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishAddCommented)
                                                 name:kAddCommentsSuccess
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadOrderDetailInfoFromeService)
                                                 name:kOrderDetailShouldUpdateNotification
                                               object:nil];
}

- (void)setUpDisplayInfo
{
    
    if (self.orderModel.order_state.intValue >= 0)
    {
        if (_rightButton == nil)
        {
            _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 72, 32)];
            [_rightButton setTitle:@"取消订单" forState:UIControlStateNormal];
            [_rightButton setTitleColor:[UIColor colorWithRed:235.0/255.0
                                                        green:84.0/255.0
                                                         blue:1.0/255.0
                                                        alpha:1.0] forState:UIControlStateNormal];
            
            [_rightButton addTarget:self
                             action:@selector(rightButtonTouch)
                   forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
            [self.navigationItem setRightBarButtonItem:rightItem];
        }
    }
    else
    {
        if (_rightButton)
        {
            _rightButton.hidden = YES;
        }
    }
    
    
    [_starRatingView setScore:self.orderModel.average_score == nil? 0:self.orderModel.average_score.floatValue/5.0
                withAnimation:NO];
    
    _scoreLabel.text = [NSString stringWithFormat:@"%.1f分",self.orderModel.average_score.floatValue];
    
    _commentLabel.text = [NSString stringWithFormat:@"评价(%d)",self.orderModel.evaluation_counts.intValue];
    
    [_contextTableView reloadData];
}




#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isCarWashOrder)
    {
        return 2;
    }
    else
    {
        return 4;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isCarWashOrder)
    {
        if (indexPath.row == 0)
        {
            return 135;
        }
        else
        {
            return 185;
        }

    }
    else
    {
        if (indexPath.row == 0)
        {
            return 135;
        }
        else if (indexPath.row == 1)
        {
            return 185;
        }
        else if (indexPath.row == 2)
        {
            CGSize messageSize = CGSizeMake(SCREEN_WIDTH-115, MAXFLOAT);
            
            
            CGSize contentSize =[self.orderModel.more_requiry boundingRectWithSize:messageSize
                                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                                                              context:nil].size;
            
            CGSize addressSize =[self.orderModel.service_addr boundingRectWithSize:messageSize
                                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                                                           context:nil].size;
            return (int)contentSize.height+(int)addressSize.height+90;

        }
        else
        {
            CGSize messageSize = CGSizeMake(SCREEN_WIDTH-85, MAXFLOAT);
            
            
            CGSize contentSize =[self.orderModel.service_content boundingRectWithSize:messageSize
                                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                                                              context:nil].size;
            CGSize accessoriesSize =[self.orderModel.accessories boundingRectWithSize:messageSize
                                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                                                              context:nil].size;
            
            float targetHeight = 51;
            if (contentSize.height > 18)
            {
                targetHeight += (int)contentSize.height;
            }
            else
            {
                targetHeight += 18;
            }
            
            if (accessoriesSize.height > 18)
            {
                targetHeight += (int)accessoriesSize.height;
            }
            else
            {
                targetHeight += 18;
            }
            
            
            return targetHeight;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        OrderCarWashCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCarWashCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[OrderCarWashCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderCarWashCellIdentifier];
        }
        
        [cell setDisplayInfo:self.orderModel];
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        OrderServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:orderServiceCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[OrderServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderServiceCellIdentifier];
        }
        
        [cell setDisplayInfo:self.orderModel];
        
        return cell;
    }
    else if (indexPath.row == 2)
    {
        OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:orderDetailCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderDetailCellIdentifier];
        }
        
        [cell setDisplayInfo:self.orderModel];
        
        return cell;
    }
    else
    {
        OrderServiceIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:orderServiceIntroduceCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[OrderServiceIntroduceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderServiceIntroduceCellIdentifier];
        }
        
        if ([self.orderModel.service_content isEqualToString:@""] || self.orderModel.service_content == nil)
        {
            cell.contentLabel.text = @"暂无内容";
        }
        else
        {
            cell.contentLabel.text = self.orderModel.service_content;
        }
        if ([self.orderModel.accessories isEqualToString:@""] || self.orderModel.accessories == nil)
        {
            cell.accessoryLabel.text = @"暂无材料";
        }
        else
        {
            cell.accessoryLabel.text = self.orderModel.accessories;
        }
        
        return cell;
    }
}

- (IBAction)didGoCommentListButtonTouch:(id)sender
{
    NSDictionary *submitDic = @{@"car_wash_id":self.orderModel.car_wash_id,
                                @"service":self.isCarWashOrder?@"1":@"2"};
    [WebService requestJsonModelWithParam:submitDic
                                   action:@"carWash/service/detail"
                               modelClass:[CarWashModel class]
                           normalResponse:^(NSString *status, id data, JsonBaseModel *model)
     {
         if (status.intValue > 0)
         {
             CommentsListController *controller = ALLOC_WITH_CLASSNAME(@"CommentsListController");
             if ([self.orderModel.order_type isEqualToString:@"2"])
             {
                 controller.commentType = 1;
             }
             else
             {
                 controller.commentType = 0;
             }
             [controller setCarWashInfo:(CarWashModel*)model];
             [self.navigationController pushViewController:controller animated:YES];
         }
         else
         {
             [Constants showMessage:@"获取车场评论数据失败"];
         }
     }
                        exceptionResponse:^(NSError *error)
     {
         [Constants showMessage:@"获取车场评论数据失败"];
     }];
}

- (IBAction)didGoCommentButtonTouch:(id)sender
{
    
    NSDictionary *submitDic = @{@"car_wash_id":self.orderModel.car_wash_id,
                                @"service":self.isCarWashOrder?@"1":@"2"};
    [WebService requestJsonModelWithParam:submitDic
                                   action:@"carWash/service/detail"
                               modelClass:[CarWashModel class]
                           normalResponse:^(NSString *status, id data, JsonBaseModel *model)
     {
         if (status.intValue > 0)
         {
             
             AddCommentController *controller = ALLOC_WITH_CLASSNAME(@"AddCommentController");
             [controller setCarWashModel:(CarWashModel*)model];
             if ([self.orderModel.order_type isEqualToString:@"2"])
             {
                 controller.service_id = [NSString stringWithFormat:@"1"];
                 controller.isCarWash = NO;
             }
             else
             {
                 controller.service_id = [NSString stringWithFormat:@"0"];
                 controller.isCarWash = YES;
             }
             
             
             
             [self.navigationController pushViewController:controller animated:YES];
         }
         else
         {
             [Constants showMessage:@"获取车场评论数据失败"];
         }
    }
                        exceptionResponse:^(NSError *error)
     {
         [Constants showMessage:@"获取车场评论数据失败"];
    }];
}


- (void)rightButtonTouch
{
    OrderDetailModel *info = self.orderModel;
    OrderCancelViewController *viewController = [[OrderCancelViewController alloc] initWithNibName:@"OrderCancelViewController" bundle:nil];
    viewController.orderModel = info;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didFinishAddCommented
{
    
    NSDictionary *submitDic = @{@"order_id": self.orderModel.order_id};
    
    [WebService requestJsonModelWithParam:submitDic
                                   action:@"order/service/detail"
                               modelClass:[OrderDetailModel class]
                           normalResponse:^(NSString *status, id data, JsonBaseModel *model)
     {
         if (status.intValue > 0)
         {
             if ([data isKindOfClass:[NSNull class]])
             {
                 [Constants showMessage:@"更新订单数据失败"];
                 return ;
             }
             
             self.orderModel = (OrderDetailModel*)model;
             [self setUpDisplayInfo];
             
         }
         else
         {
             [Constants showMessage:@"更新订单数据失败"];
             return ;
         }
         
     }
                        exceptionResponse:^(NSError *error)
     {
         [Constants showMessage:[error domain]];
         return ;
     }];

}


#pragma mark - UITableViewDelegate
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kAddCommentsSuccess
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kOrderDetailShouldUpdateNotification
                                                  object:nil];

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
