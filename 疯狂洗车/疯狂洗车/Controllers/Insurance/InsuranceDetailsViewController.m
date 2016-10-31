//
//  InsuranceDetailsViewController.m
//  
//
//  Created by cts on 15/9/15.
//
//

#import "InsuranceDetailsViewController.h"
#import "InsurancePayInfoModel.h"
#import "WebServiceHelper.h"
#import "InsuranceDetailBasePriceCell.h"
#import "InsuranceDetailOpreationCell.h"
#import "InsuranceDetailOthersCell.h"
#import "InsuranceDetailSecondPriceCell.h"
#import "InsuranceDetailOthersItemModel.h"
#import "InsuranceOrderSubmitViewController.h"
#import "InsuranceDetailItemModel.h"
#import "InsuranceCustomSelectModel.h"
#import "InsuranceCustomValueModel.h"
#import "InsuranceCustomSubmitModel.h"
#import "InsuranceListViewController.h"
#import "InsuranceSelectViewController.h"
#import "InsuranceHelper.h"

@interface InsuranceDetailsViewController ()<InsuranceDetailOpreationCellDelegate,UIAlertViewDelegate>
{
    UIButton *_rightButton;
}

@end

@implementation InsuranceDetailsViewController

static NSString *insuranceDetailBasePriceCellIdentifier = @"InsuranceDetailBasePriceCell";

static NSString *insuranceDetailOpreationCellIdentifier = @"InsuranceDetailOpreationCell";

static NSString *insuranceDetailOthersCellIdentifier = @"InsuranceDetailOthersCell";

static NSString *insuranceDetailSecondPriceCellIdentifier = @"InsuranceDetailSecondPriceCell";



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    [self setTitle:@"报价详情"];
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 16)];

    [_rightButton setImage:[UIImage imageNamed:@"btn_insurance_detail_call"]
                  forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(didRightButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];

    _bottomShadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    _bottomShadowView.layer.shadowRadius = 2;
    _bottomShadowView.layer.shadowOffset = CGSizeMake(0, -1);
    _bottomShadowView.layer.shadowOpacity = 0.1;
    
    _insuranceEditButton.layer.masksToBounds = YES;
    _insuranceEditButton.layer.cornerRadius = 5;
    _insuranceEditButton.layer.borderWidth = 1;
    _insuranceEditButton.layer.borderColor = [UIColor colorWithRed:235/255.0 green:84/255.0 blue:1/255.0 alpha:1.0].CGColor;
    
    _insuranceOrderButton.layer.masksToBounds = YES;
    _insuranceOrderButton.layer.cornerRadius = 5;
    
    [_displayTableView registerNib:[UINib nibWithNibName:insuranceDetailBasePriceCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:insuranceDetailBasePriceCellIdentifier];
    
    [_displayTableView registerNib:[UINib nibWithNibName:insuranceDetailSecondPriceCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:insuranceDetailSecondPriceCellIdentifier];
    
    [_displayTableView registerNib:[UINib nibWithNibName:insuranceDetailOpreationCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:insuranceDetailOpreationCellIdentifier];
    
    [_displayTableView registerNib:[UINib nibWithNibName:insuranceDetailOthersCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:insuranceDetailOthersCellIdentifier];
    
    
    if (self.isForCustomSelect)//自定义报价显示风格
    {
        for (int x = 0; x<_compTopView.constraints.count; x++)
        {
            NSLayoutConstraint *layoutConstraint = _compTopView.constraints[x];
            if (layoutConstraint.firstAttribute == NSLayoutAttributeHeight)
            {
                [_compTopView removeConstraint:layoutConstraint];
                break;
            }
        }
        
        NSDictionary* views = NSDictionaryOfVariableBindings(_compTopView);
        
        NSString *constrainString = nil;
        constrainString = [NSString stringWithFormat:@"V:[_compTopView(0)]"];
        
        
        [_compTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constrainString
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
        [self updateCaculatingViewDisplay:OrderDetailStateCustom];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:self.isClubController?[UIImage imageNamed:@"back_club_btn"]:[UIImage imageNamed:@"back_btn"]
                 forState:UIControlStateNormal];
        [backBtn setFrame:CGRectMake(0, 7, 26, 30)];
        [backBtn addTarget:self
                    action:@selector(leftButtonTouch)
          forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        [self.navigationItem setLeftBarButtonItem:backItem];
    }
    else if (self.insurancesArray.count > 1)
    {
        for (int x = 0; x<self.insurancesArray.count; x++)
        {
            InsuranceDetailModel *model = self.insurancesArray[x];
            
            InsuranceInfoModel *companyModel = model.insuranceInfoModel;
            if (x<_companySegmentControl.numberOfSegments)
            {
                [_companySegmentControl setTitle:companyModel.insurance_name
                               forSegmentAtIndex:x];
            }
            else
            {
                [_companySegmentControl insertSegmentWithTitle:companyModel.insurance_name
                                                       atIndex:_companySegmentControl.numberOfSegments
                                                      animated:NO];
            }
        }
        
        _selectedInsuranceDetailModel = self.insurancesArray[self.defaultCompanyIndex];
        [_companySegmentControl setSelectedSegmentIndex:self.defaultCompanyIndex];
        [self loadInsuranceOrderInfoByInsuranceInfo];
    }
    else
    {
        for (int x = 0; x<_compTopView.constraints.count; x++)
        {
            NSLayoutConstraint *layoutConstraint = _compTopView.constraints[x];
            if (layoutConstraint.firstAttribute == NSLayoutAttributeHeight)
            {
                [_compTopView removeConstraint:layoutConstraint];
                break;
            }
        }
        
        NSDictionary* views = NSDictionaryOfVariableBindings(_compTopView);
        
        NSString *constrainString = nil;
        constrainString = [NSString stringWithFormat:@"V:[_compTopView(0)]"];
        
        
        [_compTopView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constrainString
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
        _compTopView.hidden = YES;
        
        _selectedInsuranceDetailModel = self.insurancesArray[self.defaultCompanyIndex];
        [self loadInsuranceOrderInfoByInsuranceInfo];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_bg_o"]
                                                  forBarMetrics:0];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIButton *backButton = self.navigationItem.leftBarButtonItem.customView;
    [backButton setImage:[UIImage imageNamed:@"back_white_btn"] forState:UIControlStateNormal];
    UILabel *titleLabel = (UILabel *)[self.navigationItem titleView];
    [titleLabel setTextColor:self.isClubController?[UIColor whiteColor]:[UIColor whiteColor]];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (IBAction)didSegmentControlChanged:(UISegmentedControl *)sender
{
    _selectedInsuranceDetailModel = self.insurancesArray[sender.selectedSegmentIndex];
    [self loadInsuranceOrderInfoByInsuranceInfo];
}


- (void)loadInsuranceOrderInfoByInsuranceInfo
{

    if (_selectedInsuranceDetailModel.detailItemModelsArray.count > 0)
    {
        if (_selectedInsuranceDetailModel.insuranceDetailItemModel.define_id == nil ||
            [_selectedInsuranceDetailModel.insuranceDetailItemModel.define_id isEqualToString:@""])
        {
            [self updateCaculatingViewDisplay:OrderDetailStateCustom];
            return;
        }
        else if (_selectedInsuranceDetailModel.insuranceDetailItemModel.suggest_id == nil ||
                 [_selectedInsuranceDetailModel.insuranceDetailItemModel.suggest_id isEqualToString:@""] ||
                 _selectedInsuranceDetailModel.insuranceDetailItemModel.fk_member_price.floatValue == 0)
        {
            [self updateCaculatingViewDisplay:OrderDetailStateWatting];
            return;
        }
        else if (_selectedInsuranceDetailModel.insuranceDetailItemModel.paid_status == nil)
        {
            [self updateCaculatingViewDisplay:OrderDetailStateNone];
            return;
        }
        else
        {
            [self updateCaculatingViewDisplay:OrderDetailStateNormal];
            [_displayTableView reloadData];
        }
        
        return;
    }
    
    if (_selectedInsuranceDetailModel.insuranceInfoModel.suggest_id == nil ||
        [_selectedInsuranceDetailModel.insuranceInfoModel.suggest_id isEqualToString:@"null"] ||
        [_selectedInsuranceDetailModel.insuranceInfoModel.suggest_id isEqualToString:@""])
    {
        [self updateCaculatingViewDisplay:OrderDetailStateWatting];
        return;
    }


    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.view.userInteractionEnabled = NO;
    
    NSDictionary *submitDic = @{@"member_id":_userInfo.member_id,
                                @"suggest_id":_selectedInsuranceDetailModel.insuranceInfoModel.suggest_id == nil?@"":_selectedInsuranceDetailModel.insuranceInfoModel.suggest_id,
                                @"insurance_id":_selectedInsuranceDetailModel.insurance_id,
                                @"comp_id":_selectedInsuranceDetailModel.insuranceInfoModel.comp_id};
    
    [WebService requestJsonModelWithParam:submitDic
                                   action:@"insurance/service/suggestDetail"
                               modelClass:[InsuranceDetailItemModel class]
                           normalResponse:^(NSString *status, id data, JsonBaseModel *model)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.view.userInteractionEnabled = YES;
        if (status.intValue > 0)
        {
            InsuranceDetailItemModel *resultModel = (InsuranceDetailItemModel*)model;
            _selectedInsuranceDetailModel.detailItemModelsArray = [resultModel getInsuranceDetailElementsArray];
            _selectedInsuranceDetailModel.insuranceDetailItemModel = resultModel;
            if ([resultModel.suggest_id isEqualToString:@""] || resultModel.suggest_id == nil)
            {
                [self updateCaculatingViewDisplay:OrderDetailStateCustom];
                if ([resultModel.define_id isEqualToString:@""] || resultModel.define_id == nil)
                {
                    
                }
                else
                {
                    [self updateCaculatingViewDisplay:OrderDetailStateWatting];
                }
            }
            else
            {
                
                if (resultModel.paid_status == nil)
                {
                    [self updateCaculatingViewDisplay:OrderDetailStateNone];
                }
                else if (resultModel.paid_status.intValue >= 0 && resultModel.fk_member_price.floatValue > 0)
                {
                    [self updateCaculatingViewDisplay:OrderDetailStateNormal];
                    [_displayTableView reloadData];
                }
                else
                {
                    [self updateCaculatingViewDisplay:OrderDetailStateWatting];
                    
                }
            }

        }
    }
                        exceptionResponse:^(NSError *error) {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            self.view.userInteractionEnabled = YES;
                            [MBProgressHUD showError:[error domain] toView:self.view];
                            [self updateCaculatingViewDisplay:OrderDetailStateError];
    }];
}

#pragma mark - 展示数据或提示正在报价中

- (void)updateCaculatingViewDisplay:(OrderDetailState)orderDetailState
{
    if (orderDetailState > 0)
    {
        _displayTableView.hidden = YES;
        _bottomView.hidden = _bottomShadowView.hidden = YES;
        if (orderDetailState == OrderDetailStateWatting)
        {
            _caculatingView.hidden = NO;
            _caculatingStateLabel.text = @"保费计算中，请稍等...";
            _caculatingDesLabel.hidden = NO;
        }
        else if (orderDetailState == OrderDetailStateNone)
        {
            _caculatingView.hidden = NO;
            _caculatingStateLabel.text = @"暂不支持该类型的报价";
            _caculatingDesLabel.hidden = YES;
        }
        else if (orderDetailState == OrderDetailStateError)
        {
            _caculatingView.hidden = NO;
            _caculatingStateLabel.text = @"获取报价信息失败";
            _caculatingDesLabel.hidden = YES;
        }
        else if (orderDetailState == OrderDetailStateCustom)
        {
            _caculatingView.hidden = YES;

        }
    }
    else
    {
        _displayTableView.hidden = NO;
        _caculatingView.hidden = YES;
        if ( _selectedInsuranceDetailModel.insuranceDetailItemModel.paid_status.intValue == 2)
        {
            _bottomView.hidden = _bottomShadowView.hidden = YES;
        }
        else
        {
            _bottomView.hidden = _bottomShadowView.hidden = NO;
        }
    }
}


#pragma mark - UITableViewDataSource Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        int countNumber = (int)_selectedInsuranceDetailModel.detailItemModelsArray.count;

        if (countNumber > 0)
        {
            return countNumber - 1;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    else
        return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = [UIColor clearColor];
        
        return view;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 70;
    }
    else if (section == 1)
    {
        int countNumber = (int)_selectedInsuranceDetailModel.detailItemModelsArray.count - 1;
        
        if (countNumber > 0)
        {
            return 10;
        }
        else
        {
            return 0;
        }

    }
    else
    {
        return 10;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        view.backgroundColor = [UIColor clearColor];

        return view;
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = [UIColor clearColor];
        
        return view;
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 40;
    }
    else if (indexPath.section == 1)
    {
        id model = _selectedInsuranceDetailModel.detailItemModelsArray[indexPath.row + 1];

        if ([model isKindOfClass:[InsuranceDetailOthersItemModel class]])
        {
            InsuranceDetailOthersItemModel *targetModel = (InsuranceDetailOthersItemModel*)model;
            CGSize descLabelSize = CGSizeMake(SCREEN_WIDTH-30, MAXFLOAT);
            CGSize othersRealSize = [targetModel.insuranceOtherDesc boundingRectWithSize:descLabelSize
                                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0]}
                                                                                 context:nil].size;
            return 52+othersRealSize.height;
        }
        else
        {
            return 40;
            
        }

    }
    else
    {        
        NSString *giftString = _selectedInsuranceDetailModel.insuranceDetailItemModel.giftsString;
        CGSize descLabelSize = CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT);
        CGSize othersRealSize = [giftString boundingRectWithSize:descLabelSize
                                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}
                                                                             context:nil].size;

        
        return 274+othersRealSize.height;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return [self tableView:tableView insuranceDetailBasePriceCellForRowAtIndexPath:indexPath
                     withModel:_selectedInsuranceDetailModel.detailItemModelsArray[0]];

    }
    else if (indexPath.section == 1)
    {
        id model = _selectedInsuranceDetailModel.detailItemModelsArray[indexPath.row + 1];

        if ([model isKindOfClass:[InsuranceBaseItemModel class]])
        {
            if (indexPath.row == 0)
            {
                return [self tableView:tableView insuranceDetailBasePriceCellForRowAtIndexPath:indexPath
                             withModel:model];
            }
            else
            {
                return [self tableView:tableView insuranceDetailSecondPriceCellForRowAtIndexPath:indexPath
                             withModel:model];
            }
        }
        else
        {
            return [self tableView:tableView insuranceDetailOthersCellForRowAtIndexPath:indexPath
                         withModel:model];
        }
    }
    else
    {
        return  [self tableView:tableView insuranceDetailOpreationCellForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView insuranceDetailBasePriceCellForRowAtIndexPath:(NSIndexPath *)indexPath
                    withModel:(InsuranceBaseItemModel*)model
{
    InsuranceDetailBasePriceCell *cell = [tableView dequeueReusableCellWithIdentifier:insuranceDetailBasePriceCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[InsuranceDetailBasePriceCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:insuranceDetailBasePriceCellIdentifier];
        
    }
    [cell setDisplayInfo:model];
    
    return cell;
}



- (UITableViewCell*)tableView:(UITableView *)tableView insuranceDetailSecondPriceCellForRowAtIndexPath:(NSIndexPath *)indexPath
                    withModel:(InsuranceBaseItemModel*)model
{
    InsuranceDetailSecondPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:insuranceDetailSecondPriceCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[InsuranceDetailSecondPriceCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:insuranceDetailSecondPriceCellIdentifier];
        
    }
    [cell setDisplayInfo:model];
    
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView insuranceDetailOpreationCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InsuranceDetailOpreationCell *cell = [tableView dequeueReusableCellWithIdentifier:insuranceDetailOpreationCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[InsuranceDetailOpreationCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:insuranceDetailOpreationCellIdentifier];
        
    }
    
    [cell setDisplayInsuranceInfo:_selectedInsuranceDetailModel.insuranceDetailItemModel];


    cell.delegate = self;
    
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView insuranceDetailOthersCellForRowAtIndexPath:(NSIndexPath *)indexPath
                    withModel:(InsuranceDetailOthersItemModel*)model
{
    InsuranceDetailOthersCell *cell = [tableView dequeueReusableCellWithIdentifier:insuranceDetailOthersCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[InsuranceDetailOthersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:insuranceDetailOthersCellIdentifier];
    }
    
    [cell setDisplayInsuranceInfo:model];
    
    return cell;
}

- (void)leftButtonTouch
{
    NSArray *viewConteollers = self.navigationController.viewControllers;
    
    id targetController = nil;
    
    for (int x = 0; x<viewConteollers.count; x++)
    {
        id tmpController = viewConteollers[x];
        if ([tmpController isKindOfClass:[InsuranceListViewController class]])
        {
            targetController = tmpController;
            break;
        }
    }
    
    if (targetController == nil)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShouldUpdateInsurance object:nil];
        [self.navigationController popToViewController:targetController animated:YES];
    }
}

- (void)didRightButtonTouch
{
    [self didDetailOpreationPhoneButtonTouched];
}

#pragma mark - InsuranceDetailOpreationCellDelegate Method

- (IBAction)didDetailOpreationPhoneButtonTouched
{
    if ([Constants canMakePhoneCall])
    {
        NSString *alertString = [NSString stringWithFormat:@"致电保险客服"];
        [Constants showMessage:alertString
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
    NSString *phoneString = nil;
    if (!_selectedInsuranceDetailModel.insuranceDetailItemModel.contact_phone
        )
    {
        phoneString = [NSString stringWithFormat:@"tel:%@",_insuranceHomeModel.service_phone];
    }
    else
    {
        phoneString = [NSString stringWithFormat:@"tel:%@",_selectedInsuranceDetailModel.insuranceDetailItemModel.contact_phone];
    }

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
}

#pragma mark - 跳转至车险下单页面 Method

- (IBAction)didDetailOpreationOrderButtonTouched
{
    InsuranceOrderSubmitViewController *viewController = [[InsuranceOrderSubmitViewController alloc] initWithNibName:@"InsuranceOrderSubmitViewController"
                                                                                                              bundle:nil];
    
    viewController.infoModel = _selectedInsuranceDetailModel.insuranceInfoModel;
    viewController.detailModel = _selectedInsuranceDetailModel;
    viewController.suggestType = _selectedInsuranceDetailModel.insuranceDetailItemModel.suggest_type;
    
    [self.navigationController pushViewController:viewController
                                         animated:YES];
}

#pragma mark - 跳转至报价方案选择页面 Method

- (IBAction)didCustomOpreationEditButtonTouched
{
    InsuranceSelectViewController *viewController = [[InsuranceSelectViewController alloc] initWithNibName:@"InsuranceSelectViewController"
                                                                                                    bundle:nil];


    viewController.preValueModelArray = [InsuranceHelper filterValueModelFormDetailItemModel:_selectedInsuranceDetailModel.insuranceDetailItemModel
                                                                             withSuggestType:_selectedInsuranceDetailModel.insuranceDetailItemModel.suggest_type];
    viewController.preAdditionalValueModelArray = [InsuranceHelper filterAdditionalValueModelFormDetailItemModel:_selectedInsuranceDetailModel.insuranceDetailItemModel
                                                                                       withSuggestType:_selectedInsuranceDetailModel.insuranceDetailItemModel.suggest_type];
    viewController.preValueType = _selectedInsuranceDetailModel.insuranceDetailItemModel.suggest_type.intValue-1;
    viewController.selectedInsuranceDetailModel = _selectedInsuranceDetailModel;
    [self.navigationController pushViewController:viewController
                                         animated:YES];
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
