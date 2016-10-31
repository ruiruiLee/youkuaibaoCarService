//
//  InsuranceSelectViewController.m
//  疯狂洗车
//
//  Created by cts on 15/11/19.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "InsuranceSelectViewController.h"
#import "InsuranceDetailBasePriceCell.h"
#import "InsuranceCustomValueSelectView.h"
#import "InsuranceCustomSelectModel.h"
#import "InsuranceCustomValueModel.h"
#import "InsuranceCustomItemCell.h"
#import "InsuranceListViewController.h"
#import "InsuranceCustomSubmitModel.h"
#import "InsuranceSelectHeaderView.h"
#import "InsuranceSubmitViewController.h"
#import "InsuranceViewController.h"



@interface InsuranceSelectViewController ()<UITableViewDataSource,UITableViewDelegate,InsuranceCustomValueSelectViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *_economicalValueModelArray;//经济型险种基本险数据数组
    
    NSMutableArray *_economicalAdditionalValueModelArray;//经济型险种附加险数据数组
    
    NSMutableArray *_popularValueModelArray;//大众型险种基本险数据数组
    
    NSMutableArray *_popularAdditionalValueModelArray;//大众型险种附加险数据数组

    
    NSMutableArray *_overallValueModelArray;//全面型性险种基本险数据数组
    
    NSMutableArray *_overallAdditionalValueModelArray;//经济型险种附加险数据数组

    
    NSMutableArray *_customValueModelArray;//自定义型险种基本险数据数组
    
    NSMutableArray *_customAdditionalValueModelArray;//自定义型险种附加险数据数组
    
    InsuranceCustomValueSelectView *_customValueSelectView;//险种具体参数设置页面
    
    NSInteger       _selectedTypeIndex;
    
    NSIndexPath    *_selectedModelIndex;
    
    int             _secondSectionRowNumber;
    
    int             _thirdSectionRowNumber;
    
    int             _baseInsuranceNumber;
    
    int             _additionalInsuranceNumber;
}

@end

@implementation InsuranceSelectViewController

static NSString *insuranceCustomItemCellIdentifier = @"InsuranceCustomItemCell";

static NSString *insuranceSelectHeaderViewIdentifier = @"InsuranceSelectHeaderView";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"投保方案"];
    
    _submitButton.layer.cornerRadius = 5;
    _submitButton.layer.masksToBounds = YES;
    
    _backListButton.layer.cornerRadius = 5;
    _backListButton.layer.masksToBounds = YES;
    
    
    _topShadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    _topShadowView.layer.shadowRadius = 5;
    _topShadowView.layer.shadowOffset = CGSizeMake(0, 3);
    _topShadowView.layer.shadowOpacity = 0.2;
    
    _bottomShadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    _bottomShadowView.layer.shadowRadius = 2;
    _bottomShadowView.layer.shadowOffset = CGSizeMake(0, -1);
    _bottomShadowView.layer.shadowOpacity = 0.1;

    
    
    [_contextTableView registerNib:[UINib nibWithNibName:insuranceCustomItemCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:insuranceCustomItemCellIdentifier];
    
    _economicalValueModelArray = [NSMutableArray array];
    _economicalAdditionalValueModelArray = [NSMutableArray array];
    
    _popularValueModelArray = [NSMutableArray array];
    _popularAdditionalValueModelArray = [NSMutableArray array];

    _overallValueModelArray = [NSMutableArray array];
    _overallAdditionalValueModelArray = [NSMutableArray array];
    
    _customValueModelArray = [NSMutableArray array];
    _customAdditionalValueModelArray = [NSMutableArray array];
    
    if (_preValueModelArray.count > 0)//当存在用户上次选择的险种数据时，按照上次选中的数据初始化基本险和附加险数据，并默认显示用户上次报价数据
    {
        [_economicalValueModelArray  addObjectsFromArray:self.preValueType == 0?_preValueModelArray:[InsuranceHelper createAndSettingDefaultEconomicalValueModelArray]];
        [_economicalAdditionalValueModelArray  addObjectsFromArray:self.preValueType == 0?_preAdditionalValueModelArray:[InsuranceHelper createAndSettingDefaultEconomicalAdditionalValueModelArray]];

        [_popularValueModelArray  addObjectsFromArray:self.preValueType == 1?_preValueModelArray:[InsuranceHelper createAndSettingDefaultPopularValueModelArray]];
        [_popularAdditionalValueModelArray  addObjectsFromArray:self.preValueType == 1?_preAdditionalValueModelArray:[InsuranceHelper createAndSettingDefaultPopularAdditionalValueModelArray]];

        [_overallValueModelArray  addObjectsFromArray:self.preValueType == 2?_preValueModelArray:[InsuranceHelper createAndSettingDefaultOverallValueModelArray]];
        [_overallAdditionalValueModelArray  addObjectsFromArray:self.preValueType == 2?_preAdditionalValueModelArray:[InsuranceHelper createAndSettingDefaultOverallAdditionalValueValueModelArray]];

        [_customValueModelArray  addObjectsFromArray:self.preValueType == 3?_preValueModelArray:[InsuranceHelper createAndSettingDefaultCustomValueModelArray]];
        [_customAdditionalValueModelArray  addObjectsFromArray:self.preValueType == 3?_preAdditionalValueModelArray:[InsuranceHelper createAndSettingDefaultCustomAdditionalValueModelArray]];
        _selectedTypeIndex = self.preValueType;
        
        switch ((int)_selectedTypeIndex)
        {
            case 0:
            {
                _secondSectionRowNumber = (int)_economicalValueModelArray.count-1;
                _thirdSectionRowNumber = (int)_economicalAdditionalValueModelArray.count;
            }
                break;
            case 1:
            {
                _secondSectionRowNumber = (int)_popularValueModelArray.count-1;
                _thirdSectionRowNumber = (int)_popularAdditionalValueModelArray.count;
            }
                break;
            case 2:
            {
                _secondSectionRowNumber = (int)_overallValueModelArray.count-1;
                _thirdSectionRowNumber = (int)_overallAdditionalValueModelArray.count;
            }
                break;
            case 3:
            {
                _secondSectionRowNumber = (int)_customValueModelArray.count-1;
                _thirdSectionRowNumber = (int)_customAdditionalValueModelArray.count;
            }
                break;
                
            default:
                break;
        }
        
        _segmentControl.selectedSegmentIndex = _selectedTypeIndex;
    }
    else//当不存在用户上次选择的险种数据时，按照使用默认数据初始化基本险和附加险数据，并默认显示大众型报价数据
    {
        [_economicalValueModelArray  addObjectsFromArray:[InsuranceHelper createAndSettingDefaultEconomicalValueModelArray]];
        [_economicalAdditionalValueModelArray addObjectsFromArray:[InsuranceHelper createAndSettingDefaultEconomicalAdditionalValueModelArray]];
        [_popularValueModelArray  addObjectsFromArray:[InsuranceHelper createAndSettingDefaultPopularValueModelArray]];
        [_popularAdditionalValueModelArray addObjectsFromArray:[InsuranceHelper createAndSettingDefaultPopularAdditionalValueModelArray]];
        [_overallValueModelArray  addObjectsFromArray:[InsuranceHelper createAndSettingDefaultOverallValueModelArray]];
        [_overallAdditionalValueModelArray addObjectsFromArray:[InsuranceHelper createAndSettingDefaultOverallAdditionalValueValueModelArray]];
        [_customValueModelArray  addObjectsFromArray:[InsuranceHelper createAndSettingDefaultCustomValueModelArray]];
        [_customAdditionalValueModelArray addObjectsFromArray:[InsuranceHelper createAndSettingDefaultCustomAdditionalValueModelArray]];
        
        
        _selectedTypeIndex = 1;
        _secondSectionRowNumber = (int)_popularValueModelArray.count-1;
        _thirdSectionRowNumber = (int)_popularAdditionalValueModelArray.count;
        
        _segmentControl.selectedSegmentIndex = 1;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_bg_o"]
                                                  forBarMetrics:0];
    //该页面使用白色系的控件
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIButton *backButton = self.navigationItem.leftBarButtonItem.customView;
    [backButton setImage:[UIImage imageNamed:@"back_white_btn"] forState:UIControlStateNormal];
    UILabel *titleLabel = (UILabel *)[self.navigationItem titleView];
    [titleLabel setTextColor:self.isClubController?[UIColor whiteColor]:[UIColor whiteColor]];

}


#pragma mark - 用户切换报价类型，更新界面 Method
- (IBAction)didSegmentValueChanged:(UISegmentedControl *)sender
{
    _selectedTypeIndex = sender.selectedSegmentIndex;
    switch ((int)_selectedTypeIndex) {
        case 0:
        {
            _secondSectionRowNumber = (int)_economicalValueModelArray.count-1;
            _thirdSectionRowNumber = (int)_economicalAdditionalValueModelArray.count;
        }
            break;
        case 1:
        {
            _secondSectionRowNumber = (int)_popularValueModelArray.count-1;
            _thirdSectionRowNumber = (int)_popularAdditionalValueModelArray.count;
        }
            break;
        case 2:
        {
            _secondSectionRowNumber = (int)_overallValueModelArray.count-1;
            _thirdSectionRowNumber = (int)_overallAdditionalValueModelArray.count;
        }
            break;
        case 3:
        {
            _secondSectionRowNumber = (int)_customValueModelArray.count-1;
            _thirdSectionRowNumber = (int)_customAdditionalValueModelArray.count;
        }
            break;
            
        default:
            break;
    }

    [_contextTableView reloadData];

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
        return _secondSectionRowNumber >0?_secondSectionRowNumber:0;
    }
    else
    {
        return _thirdSectionRowNumber >0?_thirdSectionRowNumber:0;

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    else if (section == 1)
    {
        if (_secondSectionRowNumber > 0)
        {
            return 30;
        }
        else
        {
            return 0;
        }

    }
    else
    {
        if (_thirdSectionRowNumber > 0)
        {
            return 30;
        }
        else
        {
            return 0;
        }
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = [UIColor clearColor];
        
        return view;
    }
    else if (section == 1)
    {
        if (_secondSectionRowNumber > 0)
        {
            InsuranceSelectHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"InsuranceSelectHeaderView"];
            if (view == nil)
            {
                view = [[NSBundle mainBundle] loadNibNamed:@"InsuranceSelectHeaderView"
                                                     owner:nil
                                                   options:nil][0];
                
            }
            view.headerTitleLabel.text = @"基础险";
            view.contentView.backgroundColor = [UIColor whiteColor];
            return view;
        }
        else
        {
            return nil;

        }
    }
    else
    {
        if (_thirdSectionRowNumber > 0)
        {
            InsuranceSelectHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"InsuranceSelectHeaderView"];
            if (view == nil)
            {
                view = [[NSBundle mainBundle] loadNibNamed:@"InsuranceSelectHeaderView"
                                                     owner:nil
                                                   options:nil][0];
                
            }
            view.headerTitleLabel.text = @"附加险";
            view.contentView.backgroundColor = [UIColor whiteColor];
            return view;
        }
        else
        {
            return nil;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0||section == 1)
    {
        return 10;
    }
    else
    {
        return 40;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = [UIColor clearColor];
        
        return view;
    }
    else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        view.backgroundColor = [UIColor clearColor];
        
        return view;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    InsuranceCustomItemCell *cell = [tableView dequeueReusableCellWithIdentifier:insuranceCustomItemCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[InsuranceCustomItemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:insuranceCustomItemCellIdentifier];
    }
    
    InsuranceCustomSelectModel *model = nil;
    
    if (indexPath.section == 0)
    {
        if (_selectedTypeIndex == 0)
        {
            model = _economicalValueModelArray[0];
        }
        else if (_selectedTypeIndex == 1)
        {
            model = _popularValueModelArray[0];
        }
        else if (_selectedTypeIndex == 2)
        {
            model = _overallValueModelArray[0];
        }
        else
        {
            model = _customValueModelArray[0];
        }
        
    }
    else if (indexPath.section == 1)
    {
        if (_selectedTypeIndex == 0)
        {
            model = _economicalValueModelArray[indexPath.row+1];
        }
        else if (_selectedTypeIndex == 1)
        {
            model = _popularValueModelArray[indexPath.row+1];
        }
        else if (_selectedTypeIndex == 2)
        {
            model = _overallValueModelArray[indexPath.row+1];
        }
        else
        {
            model = _customValueModelArray[indexPath.row+1];
        }
    }
    else
    {
        if (_selectedTypeIndex == 0)
        {
            model = _economicalAdditionalValueModelArray[indexPath.row];
        }
        else if (_selectedTypeIndex == 1)
        {
            model = _popularAdditionalValueModelArray[indexPath.row];
        }
        else if (_selectedTypeIndex == 2)
        {
            model = _overallAdditionalValueModelArray[indexPath.row];
        }
        else
        {
            model = _customAdditionalValueModelArray[indexPath.row];
        }
    }

        
    [cell setDisplayCustomItemInfo:model];
    
    return cell;
}

#pragma mark - UITableViewDelegate Method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section > 0)
    {

        _selectedModelIndex = indexPath;
        InsuranceCustomSelectModel *model = nil;
        
        if (indexPath.section == 1)
        {
            if (_selectedTypeIndex == 0)
            {
                model = _economicalValueModelArray[indexPath.row+1];
            }
            else if (_selectedTypeIndex == 1)
            {
                model = _popularValueModelArray[indexPath.row+1];
            }
            else if (_selectedTypeIndex == 2)
            {
                model = _overallValueModelArray[indexPath.row+1];
            }
            else
            {
                model = _customValueModelArray[indexPath.row+1];
            }

        }
        else
        {
            if (_selectedTypeIndex == 0)
            {
                model = _economicalAdditionalValueModelArray[indexPath.row];
            }
            else if (_selectedTypeIndex == 1)
            {
                model = _popularAdditionalValueModelArray[indexPath.row];
            }
            else if (_selectedTypeIndex == 2)
            {
                model = _overallAdditionalValueModelArray[indexPath.row];
            }
            else
            {
                model = _customAdditionalValueModelArray[indexPath.row];
            }
        }
       
        if (_customValueSelectView == nil)
        {
            _customValueSelectView = [[NSBundle mainBundle] loadNibNamed:@"InsuranceCustomValueSelectView"
                                                                   owner:nil
                                                                 options:nil][0];
            
            _customValueSelectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            _customValueSelectView.delegate = self;
        }
        [_customValueSelectView showAndSetUpWithPropertyModel:model];
    }
}


#pragma mark - InsuranceCustomValueSelectViewDelegate Method

- (void)didFinishInsuranceCustomValueSelect:(InsuranceCustomSelectModel *)model//当用户设置完险种具体数据时刷新页面
{
    if (model.valueType == CustomSelectValueTypeCS)
    {
        if (_selectedTypeIndex == 3)
        {
            if (!model.bjmpSelected || model.selectedIndex == 0)
            {
                for (int x= 0; x<_customAdditionalValueModelArray.count; x++)
                {
                    InsuranceCustomSelectModel *model = _customAdditionalValueModelArray[x];
                    if (model.valueType == CustomSelectValueTypeZR)
                    {
                        model.bjmpEnable = NO;
                        model.bjmpSelected = NO;
                    }
                }
            }
            else
            {
                for (int x= 0; x<_customAdditionalValueModelArray.count; x++)
                {
                    InsuranceCustomSelectModel *model = _customAdditionalValueModelArray[x];
                    if (model.valueType == CustomSelectValueTypeZR)
                    {
                        if (!model.bjmpEnable)
                        {
                            model.bjmpEnable = YES;
                        }
                    }
                }
            }
        }
    }
    
    
    [_contextTableView reloadData];
}


#pragma mark - 提交保险选项 Method

- (IBAction)didSubmitButtonTouch:(id)sender
{
    [Constants showMessage:@"确定提交"
                  delegate:self
                       tag:511
              buttonTitles:@"取消",@"确定", nil];
}

#pragma mark - UIAlertViewDelegate Method

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 511 && buttonIndex == 1)
    {
        [self submitCustomInsuracenWay];
    }
}

#pragma mark - 提交报价方案至服务器 Method

- (void)submitCustomInsuracenWay
{
    InsuranceCustomSubmitModel *targetModel = [[InsuranceCustomSubmitModel alloc] init];
    
    targetModel.member_id = _userInfo.member_id;
    targetModel.suggest_type = [NSString stringWithFormat:@"%d",(int)_selectedTypeIndex+1];
    if (self.isForSubmit)
    {
        targetModel.insurance_id = self.insuranceIDForCustom;
        targetModel.define_id = @"";
        targetModel.comp_id = @"";
        targetModel.op_type = @"new";
    }
    else
    {
        targetModel.insurance_id = _selectedInsuranceDetailModel.insurance_id;
        targetModel.comp_id = _selectedInsuranceDetailModel.insuranceInfoModel.comp_id;
        if (_selectedInsuranceDetailModel.insuranceDetailItemModel.define_id == nil)
        {
            targetModel.define_id = @"";
            targetModel.op_type = @"new";
            
        }
        else
        {
            targetModel.define_id = _selectedInsuranceDetailModel.insuranceDetailItemModel.define_id;
            targetModel.op_type = @"edit";
        }
    }
    
    NSMutableArray *targetArray = nil;
    if (_selectedTypeIndex == 0)
    {
        targetArray = [NSMutableArray arrayWithArray:_economicalValueModelArray];
        [targetArray addObjectsFromArray:_economicalAdditionalValueModelArray];
    }
    else if (_selectedTypeIndex == 1)
    {
        targetArray = [NSMutableArray arrayWithArray:_popularValueModelArray];
        [targetArray addObjectsFromArray:_popularAdditionalValueModelArray];
    }
    else if (_selectedTypeIndex == 2)
    {
        targetArray = [NSMutableArray arrayWithArray:_overallValueModelArray];
        [targetArray addObjectsFromArray:_overallAdditionalValueModelArray];
    }
    else
    {
        targetArray = [NSMutableArray arrayWithArray:_customValueModelArray];
        [targetArray addObjectsFromArray:_customAdditionalValueModelArray];
    }

    
    for (int x = 0; x<targetArray.count; x++)
    {
        InsuranceCustomSelectModel *model = targetArray[x];
        InsuranceCustomValueModel *valueModel = model.itemsArray[model.selectedIndex];
        
        if (model.valueType == CustomSelectValueTypeJQCC)
        {
            targetModel.cc_status = @"1";
            targetModel.jq_status = @"1";
        }
        else if (model.valueType == CustomSelectValueTypeCS)
        {
            targetModel.cs_status = valueModel.valueString;
            targetModel.cs_bjmp_status = model.bjmpSelected ?@"1":@"0";
        }
        else if (model.valueType == CustomSelectValueTypeSZ)
        {
            targetModel.sz_price = valueModel.valueString;
            targetModel.sz_bjmp_status = model.bjmpSelected ?@"1":@"0";
        }
        else if (model.valueType == CustomSelectValueTypeDQ)
        {
            targetModel.dq_status = valueModel.valueString;
            targetModel.dq_bjmp_status = model.bjmpSelected ?@"1":@"0";
        }
        else if (model.valueType == CustomSelectValueTypeSJ)
        {
            
            targetModel.sj_price = valueModel.valueString;
            targetModel.sj_bjmp_status = model.bjmpSelected ?@"1":@"0";
        }
        else if (model.valueType == CustomSelectValueTypeCK)
        {
            
            targetModel.ck_price = valueModel.valueString;
            targetModel.ck_bjmp_status = model.bjmpSelected ?@"1":@"0";
        }
        else if (model.valueType == CustomSelectValueTypeBL)
        {
            targetModel.bl_status = valueModel.valueString;
        }
        else if (model.valueType == CustomSelectValueTypeSS)
        {
            targetModel.ss_status = valueModel.valueString;
            targetModel.ss_bjmp_status = model.bjmpSelected ?@"1":@"0";
        }
        else if (model.valueType == CustomSelectValueTypeHH)
        {
            targetModel.hh_price = valueModel.valueString;
            targetModel.hh_bjmp_status = model.bjmpSelected ?@"1":@"0";
        }
        else if (model.valueType == CustomSelectValueTypeZR)
        {
            targetModel.zr_status = valueModel.valueString;
            targetModel.zr_bjmp_status = model.bjmpSelected ?@"1":@"0";
        }
        else
        {
            
        }
    }
    
    NSDictionary *submitDic = [targetModel convertToDictionary];
    self.view.userInteractionEnabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"insurance/service/manageUserDefine"
                               normalResponse:^(NSString *status, id data)
     {
         self.view.userInteractionEnabled = YES;
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [MBProgressHUD showSuccess:@"提交成功" toView:self.view];
         [[NSNotificationCenter defaultCenter] postNotificationName:kShouldUpdateInsurance
                                                             object:nil];
         UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         [backBtn setImage:[UIImage imageNamed:@"back_white_btn"]
                  forState:UIControlStateNormal];
         [backBtn setFrame:CGRectMake(0, 7, 26, 30)];
         [backBtn addTarget:self
                     action:@selector(didBackListButtonTouch:)
           forControlEvents:UIControlEventTouchUpInside];
         
         UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
         [self.navigationItem setLeftBarButtonItem:backItem];

         _submitSuccessView.hidden = NO;
     }
                            exceptionResponse:^(NSError *error) {
                                self.view.userInteractionEnabled = YES;
                                [MBProgressHUD hideAllHUDsForView:self.view
                                                         animated:YES];
                                [MBProgressHUD showError:[error domain]
                                                  toView:self.view];
                            }];

}


#pragma mark - 用户点击导航栏返回按钮时根据实际应用场景返回 Method

- (IBAction)didBackListButtonTouch:(id)sender
{
    NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
    
    id tmpListInsuranceController = nil;
    
    for (int x = 0; x<viewControllers.count; x++)
    {
        id tmpController = viewControllers[x];
        if ([tmpController isKindOfClass:[InsuranceListViewController class]])
        {
            tmpListInsuranceController = tmpController;
        }
    }
    
    if (tmpListInsuranceController == nil)//
    {
        NSInteger targetIndex = 0;
        for (int x = 0; x<viewControllers.count; x++)
        {
            id tmpController = viewControllers[x];
            if ([tmpController isKindOfClass:[InsuranceSubmitViewController class]])
            {
                targetIndex = x;
                break;
            }
        }
        if (targetIndex == 0)//返回首页
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else//从navi栈中去除提交报价页面并返回
        {
            InsuranceListViewController *targetController = [[InsuranceListViewController alloc] initWithNibName:@"InsuranceListViewController" bundle:nil];
            [viewControllers removeObjectsInRange:NSMakeRange(targetIndex, viewControllers.count - targetIndex)];
            [viewControllers addObject:targetController];
            [self.navigationController setViewControllers:viewControllers
                                                 animated:YES];
        }
    }
    else//直接返回报价列表
    {
        [self.navigationController popToViewController:tmpListInsuranceController animated:YES];
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
