//
//  InsuranceListViewController.m
//  优快保
//
//  Created by cts on 15/7/8.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "InsuranceListViewController.h"
#import "WebServiceHelper.h"
#import "InsuranceInfoModel.h"
#import "InsuranceGroupModel.h"
#import "InsuranceListInfoCell.h"

#import "UIView+Toast.h"
#import "MBProgressHUD+Add.h"
#import "InsuranceSubmitViewController.h"
#import "InsuranceDetailsViewController.h"
#import "InsuranceItemCell.h"
#import "InsuranceItemWaittingCell.h"
#import "InsuranceDetailModel.h"
#import "InsuranceSuggestModel.h"
#import "PhotoBroswerVC.h"
#import "InsuranceOrderSubmitViewController.h"
#import "UploadImageModel.H"
#import "InsuranceListSuggestEmptyCell.h"
#import "InsuranceSelectViewController.h"

@interface InsuranceListViewController ()<InsuranceItemCellDelegate,InsuranceListInfoCellDelegate,InsuranceListSuggestEmptyCellDelegate>
{
    NSMutableArray *_listGroupArray;
    
    BOOL _launched;
    BOOL _canLoadMore;
    
    BOOL _isLoading;
    
    NSInteger     _pageIndex;
    
    NSInteger     _pageSize;
    
    UIButton     *_rightButton;
    
    InsuranceInfoModel  *_selectedInsuranceInfoModel;
    
}

@end

@implementation InsuranceListViewController

static NSString *InsuranceListInfoCellIdentifier = @"InsuranceListInfoCell";

static NSString *InsuranceItemCellIdentifier = @"InsuranceItemCell";

static NSString *InsuranceListSuggestEmptyCellIdentifier = @"InsuranceListSuggestEmptyCell";


//static NSString *InsuranceItemWaittingCellIdentifier = @"InsuranceItemWaittingCell";



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"报价"];
    
    [_listTableView addHeaderActionWithTarget:self action:@selector(loadInsuranceListItem)];
    
//    [_listTableView registerNib:[UINib nibWithNibName:InsuranceItemWaittingCellIdentifier
//                                               bundle:[NSBundle mainBundle]]
//         forCellReuseIdentifier:InsuranceItemWaittingCellIdentifier];
    
    [_listTableView registerNib:[UINib nibWithNibName:InsuranceListInfoCellIdentifier
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:InsuranceListInfoCellIdentifier];
    
    [_listTableView registerNib:[UINib nibWithNibName:InsuranceItemCellIdentifier
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:InsuranceItemCellIdentifier];
    
    [_listTableView registerNib:[UINib nibWithNibName:InsuranceListSuggestEmptyCellIdentifier
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:InsuranceListSuggestEmptyCellIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveShouldUpdateInsuranceNotification)
                                                 name:kShouldUpdateInsurance object:nil];
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 64, 32)];
    [_rightButton setTitle:@"新增算价" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_rightButton setTitleColor:[UIColor colorWithRed:235/255.0
                                                green:84.0/255.0
                                                 blue:1.0/255.0
                                                alpha:1.0] forState:UIControlStateNormal];
    
    [_rightButton addTarget:self action:@selector(didAddInsuranceButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    
    _pageIndex = 1;
    _pageSize = 100;
    
    _canLoadMore = YES;
    
    _listGroupArray = [NSMutableArray array];
    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_launched)
    {
        _launched = YES;
        [_listTableView tableViewHeaderBeginRefreshing];
    }
}


- (void)didReceiveShouldUpdateInsuranceNotification
{
    _launched = NO;
}

#pragma mark - 读取保险列表
#pragma mark

- (void)loadInsuranceListItem
{
    _pageIndex = 1;
    _pageSize = 100;
    
    _canLoadMore = YES;
    NSDictionary *submitDic = @{@"member_id":_userInfo.member_id,
                                @"page_index":[NSNumber numberWithInteger:_pageIndex],
                                @"page_size":[NSNumber numberWithInteger:_pageSize],
                                @"ver_no":@"3"};
    
    self.view.userInteractionEnabled = NO;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebService requestJsonArrayOperationWithParam:submitDic
                                            action:@"insurance/service/list"
                                        modelClass:[InsuranceGroupModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         self.view.userInteractionEnabled = YES;
         if (status.intValue > 0 && array.count >0)
         {
             _canLoadMore = NO;
             _listGroupArray = array;
             
             [_listTableView reloadData];
         }
         else
         {
             _canLoadMore = NO;
             [Constants showMessage:@"暂无保险信息"];
         }
         [_listTableView tableViewHeaderEndRefreshing];
     }
                                 exceptionResponse:^(NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         self.view.userInteractionEnabled = YES;
         [_listTableView tableViewHeaderEndRefreshing];
         _canLoadMore = NO;
         [Constants showMessage:[error domain]];
     }];

    
    
}

- (void)loadMoreInsuranceListItem
{
    if (!_canLoadMore)
    {
        [[[UIApplication sharedApplication] keyWindow] makeToast:@"没有更多"];
        [_listTableView tableViewfooterEndRefreshing];
        return;
    }
    else
    {
        NSDictionary *submitDic = @{@"member_id":_userInfo.member_id,
                                    @"page_index":[NSNumber numberWithInteger:_pageIndex],
                                    @"page_size":[NSNumber numberWithInteger:_pageSize],
                                    @"ver_no":@"3"};
        
        [WebService requestJsonArrayOperationWithParam:submitDic
                                                action:@"insurance/service/list"
                                            modelClass:[InsuranceGroupModel class]
                                        normalResponse:^(NSString *status, id data, NSMutableArray *array)
        {
            if (array.count >= _pageSize)
            {
                
            }
        }
                                     exceptionResponse:^(NSError *error)
        {
            
        }];
    }
}

#pragma mark - 保险列表展示代码
#pragma mark 


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listGroupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    InsuranceGroupModel *model = _listGroupArray[section];
    if (model.insur_status.intValue == 4)
    {
        return 2;
    }
    else
    {
        return model.suggest_list.count+1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_listGroupArray.count-1 == section)
    {
        return 20;
    }
    else
    {
        return 0;
    }
}


- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    if (_listGroupArray.count-1 == section)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    else
    {
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InsuranceGroupModel *groupModel = _listGroupArray[indexPath.section];
    if (indexPath.row == 0)
    {
        if (groupModel.img_list.count > 0)
        {
            float itemWidth = (SCREEN_WIDTH - 44)/3.0;
            float itemHeight = itemWidth;
            float cloumFloat = (int)groupModel.img_list.count /3.0;
            int cloum = (int)cloumFloat;
            if (cloumFloat > cloum)
            {
                cloum++;
            }
            CGSize imageContentSize = CGSizeMake(0, cloum*itemHeight+(cloum-1)*2);
            return 226 + imageContentSize.height;
        }
        else
        {
            return 226;
        }
    }
    else
    {
        if (groupModel.insur_status.intValue == 4)
        {
            return 80;
        }
        else
        {
            InsuranceInfoModel *model = groupModel.suggest_list[indexPath.row-1];
            
            if ([model.suggest_id isEqualToString:@""] || model.suggest_id == nil || [model.gifts isEqualToString:@""] || model.gifts == nil)
            {
                return 147;
            }
            else
            {
                CGSize messageSize = CGSizeMake(SCREEN_WIDTH-105, MAXFLOAT);
                NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphstyle setLineSpacing:10];
                CGSize contentSize =[model.giftsString boundingRectWithSize:messageSize
                                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0],NSParagraphStyleAttributeName:paragraphstyle}
                                                                    context:nil].size;
                return 163+contentSize.height;
            }

        }
    }
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return [self tableView:tableView insuranceInfoCellForRowAtIndexPath:indexPath];
    }
    else
    {
        return [self tableView:tableView insuranceItemCellForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView insuranceInfoCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InsuranceListInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:InsuranceListInfoCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[InsuranceListInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:InsuranceListInfoCellIdentifier];
    }
    
    InsuranceGroupModel *model = _listGroupArray[indexPath.section];
    
    [cell setDisplayInsuranceGroupInfo:model];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView insuranceItemCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InsuranceGroupModel *model = _listGroupArray[indexPath.section];
    if (model.insur_status.intValue == 4)
    {
        return [self tableView:tableView insuranceListSuggestEmptyCellForRowAtIndexPath:indexPath];
    }
    else
    {
        InsuranceInfoModel *itemModel = model.suggest_list[indexPath.row-1];
        
        InsuranceItemCell *cell = [tableView dequeueReusableCellWithIdentifier:InsuranceItemCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[InsuranceItemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:InsuranceItemCellIdentifier];
        }
        
        
        
        [cell setDisplayInsuranceInfo:itemModel];
        cell.delegate = self;
        cell.indexPath = indexPath;
        if (indexPath.row == model.suggest_list.count)
        {
            cell.bottomCornerView.hidden = NO;
            cell.bottomCubeView.hidden = YES;
        }
        else
        {
            cell.bottomCornerView.hidden = YES;
            cell.bottomCubeView.hidden = NO;
        }
        
        return cell;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView insuranceListSuggestEmptyCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InsuranceListSuggestEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:InsuranceListSuggestEmptyCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[InsuranceListSuggestEmptyCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:InsuranceListSuggestEmptyCellIdentifier];
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    return cell;
}


//- (UITableViewCell*)tableView:(UITableView *)tableView insuranceItemWaittingCellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    InsuranceGroupModel *model = _listGroupArray[indexPath.section];
//    InsuranceInfoModel *itemModel = model.suggest_list[indexPath.row-1];
//    
//    InsuranceItemWaittingCell *cell = [tableView dequeueReusableCellWithIdentifier:InsuranceItemWaittingCellIdentifier];
//    
//    if (cell == nil)
//    {
//        cell = [[InsuranceItemWaittingCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                        reuseIdentifier:InsuranceItemWaittingCellIdentifier];
//    }
//    
//    
//    
//    [cell setDisplayInsuranceInfo:itemModel];
//    cell.indexPath = indexPath;
//    if (indexPath.row == model.suggest_list.count)
//    {
//        cell.bottomCornerView.hidden = NO;
//        cell.bottomCubeView.hidden = YES;
//    }
//    else
//    {
//        cell.bottomCornerView.hidden = YES;
//        cell.bottomCubeView.hidden = NO;
//    }
//    
//    return cell;
//}



#pragma mark - UITableViewDelegate

- (void)didOpreationButtonTouched:(NSIndexPath *)indexPath
{
    InsuranceGroupModel *model = _listGroupArray[indexPath.section];
    
  //  BOOL isCustomOrder = NO;
    NSMutableArray *insurancesArray = [NSMutableArray array];
    for (int x = 0; x<model.suggest_list.count; x++)
    {
        InsuranceDetailModel *tmpModel = [[InsuranceDetailModel alloc] init];
        tmpModel.insuranceInfoModel = model.suggest_list[x];
        tmpModel.insurance_id = model.insurance_id;
        [insurancesArray addObject:tmpModel];
    }
    
    InsuranceDetailsViewController *viewController = [[InsuranceDetailsViewController alloc] initWithNibName:@"InsuranceDetailsViewController"
                                                                                                      bundle:nil];
    
    
    viewController.defaultCompanyIndex = indexPath.row - 1;
    viewController.insurancesArray = insurancesArray;
    
    [self.navigationController pushViewController:viewController
                                         animated:YES];
}

- (void)didImageItemTouched:(NSIndexPath *)indexPath andImageIndex:(NSInteger)imageIndex
{
    InsuranceGroupModel *model = _listGroupArray[indexPath.section];
    
    __weak typeof(self) weakSelf=self;
    
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypePush index:imageIndex photoModelBlock:^NSArray *{
        
        
        NSArray *networkImages=model.img_list;
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:networkImages.count];
        for (NSUInteger i = 0; i< networkImages.count; i++) {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            UploadImageModel *tmpModel = networkImages[i];
            pbModel.mid = i + 1;
            pbModel.image_HD_U = tmpModel.img_url;
            
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];


}

- (void)didPhoneCallButtonTouched:(NSIndexPath *)indexPath
{
    if ([Constants canMakePhoneCall])
    {
        InsuranceGroupModel *model = _listGroupArray[indexPath.section];
        InsuranceInfoModel *itemModel = model.suggest_list[indexPath.row-1];
        
        _selectedInsuranceInfoModel = itemModel;
        NSString *alertString = [NSString stringWithFormat:@"致电保险客服%@",itemModel.contact_phone];
        [Constants showMessage:alertString
                      delegate:self
                           tag:531
                  buttonTitles:@"取消",@"确认", nil];
    }
    else
    {
        [Constants showMessage:@"您的设备无法拨打电话"];
    }

}

- (void)didEditButtonTouched:(NSIndexPath *)indexPath
{
    InsuranceGroupModel *groupModel = _listGroupArray[indexPath.section];
    
    InsuranceSubmitViewController *viewController = [[InsuranceSubmitViewController alloc] initWithNibName:@"InsuranceSubmitViewController"
                                                                                                    bundle:nil];
    viewController.isEdit = YES;
    viewController.insuranceGroupModel = groupModel;
    viewController.isCustomdSubmited = groupModel.custom_submitted.intValue > 0?YES:NO;
    [self.navigationController pushViewController:viewController
                                         animated:YES];
}


#pragma mark - InsuranceListSuggestEmptyCellDelegate method

- (void)didInsuranceSelectButtonTouched:(NSIndexPath *)indexPath
{
    InsuranceGroupModel *groupModel = _listGroupArray[indexPath.section];
    InsuranceSelectViewController *viewController = [[InsuranceSelectViewController alloc] initWithNibName:@"InsuranceSelectViewController"
                                                                                                    bundle:nil];
    viewController.insuranceIDForCustom = groupModel.insurance_id;
    viewController.isForSubmit = YES;
    [self.navigationController pushViewController:viewController
                                         animated:YES];

}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 531 && buttonIndex == 1)
    {
        NSString *phoneString = [NSString stringWithFormat:@"tel:%@",_selectedInsuranceInfoModel.contact_phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
    }
}


- (void)didAddInsuranceButtonTouch:(id)sender
{
    InsuranceSubmitViewController *viewController = [[InsuranceSubmitViewController alloc] initWithNibName:@"InsuranceSubmitViewController"
                                                                                                    bundle:nil];
    [self.navigationController pushViewController:viewController
                                         animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kShouldUpdateInsurance object:nil];
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
