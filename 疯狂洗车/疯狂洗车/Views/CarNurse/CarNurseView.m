//
//  CarNurseView.m
//  优快保
//
//  Created by cts on 15/4/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CarNurseView.h"
#import "UIImageView+WebCache.h"
#import "CarNurseServiceModel.h"

@implementation CarNurseView

static NSString *headerViewIdentifier = @"ServiceTypeHeaderView";
static NSString *serviceIntroduceCellIdentifier = @"ServiceIntroduceCell";
static NSString *myCarDetailCellIdentifier = @"MyCarDetailCell";
static NSString *carNurseCellIdentifier = @"CarNurseInfoCell";



- (void)awakeFromNib {
    // Initialization code
    _payOrderButton.layer.masksToBounds = YES;
    _payOrderButton.layer.cornerRadius  = 3;
    
    _bookOrderButton.layer.masksToBounds = YES;
    _bookOrderButton.layer.cornerRadius  = 3;
    
    _rescueButton.layer.masksToBounds = YES;
    _rescueButton.layer.cornerRadius  = 3;
    
    [_contextTableView registerNib:[UINib nibWithNibName:myCarDetailCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:myCarDetailCellIdentifier];
    if (self.tag<0)
    {
        [_contextTableView registerNib:[UINib nibWithNibName:[NSString stringWithFormat:@"%@_Club",carNurseCellIdentifier]
                                                      bundle:[NSBundle mainBundle]]
                forCellReuseIdentifier:carNurseCellIdentifier];
        
        [_contextTableView registerNib:[UINib nibWithNibName:serviceIntroduceCellIdentifier
                                                      bundle:[NSBundle mainBundle]]
                forCellReuseIdentifier:serviceIntroduceCellIdentifier];

    }
    else
    {
        [_contextTableView registerNib:[UINib nibWithNibName:carNurseCellIdentifier
                                                      bundle:[NSBundle mainBundle]]
                forCellReuseIdentifier:carNurseCellIdentifier];
        
        [_contextTableView registerNib:[UINib nibWithNibName:serviceIntroduceCellIdentifier
                                                      bundle:[NSBundle mainBundle]]
                forCellReuseIdentifier:serviceIntroduceCellIdentifier];

    }
    

    
    if (SCREEN_WIDTH < 375)
    {
        for (int x = 0; x<_submitView.constraints.count; x++)
        {
            NSLayoutConstraint *layoutConstraint = _submitView.constraints[x];
            if (layoutConstraint.firstAttribute == NSLayoutAttributeHeight)
            {
                [_submitView removeConstraint:layoutConstraint];
                break;
            }
            
        }
        
        NSDictionary* views = NSDictionaryOfVariableBindings(_submitView);
        
        [_submitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_submitView(50)]"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:views]];
    }
}



- (void)setDisplayCarNurseInfo:(CarNurseModel*)model
                  withUserCars:(NSArray*)carArray
{
    _carNurseModel = model;
    
    _carsArray = [NSArray arrayWithArray:carArray];
    
    if (_carsArray.count > 0)
    {
        _selectedCar = _carsArray[0];
    }

    
    
    if (_carNurseModel.serviceArray.count > 0 && self.targetType != nil)
    {
        ServiceGroupModel *groupModel = _carNurseModel.serviceArray[0];
        BOOL shouldSetDefault = NO;
        for (int x = 0; x<groupModel.subServiceArray.count; x++)
        {
            CarNurseServiceModel *model = groupModel.subServiceArray[x];
            if (self.targetType.intValue == 20 && x == 0)
            {
                shouldSetDefault = YES;
            }
            else if ([model.service_type isEqualToString:self.targetType])
            {
                shouldSetDefault = YES;
            }
            
            if (shouldSetDefault)
            {
                if ([model.service_mode isEqualToString:@""] || model.service_mode == nil)
                {
                    continue;
                }
                if ([model.service_mode rangeOfString:@","].location != NSNotFound)
                {
                    [self updatePayAndBookOrderButtonWithLeftEnable:YES
                                                     andRightEnable:YES];
                }
                else
                {
                    if ([model.service_mode isEqualToString:@"1"])
                    {
                        [self updatePayAndBookOrderButtonWithLeftEnable:YES
                                                         andRightEnable:NO];
                    }
                    else  if ([model.service_mode isEqualToString:@"2"])
                    {
                        [self updatePayAndBookOrderButtonWithLeftEnable:NO
                                                         andRightEnable:YES];
                    }
                    else
                    {
                        [self updatePayAndBookOrderButtonWithLeftEnable:NO
                                                         andRightEnable:NO];
                    }
                }
                break;
            }
            if (!shouldSetDefault)
            {
                [self updatePayAndBookOrderButtonWithLeftEnable:NO
                                                 andRightEnable:NO];
            }
        }
//        if (_selectCarServiceModel != nil)
//        {
//            CarNurseServiceModel *target = nil;
//            for (int x = 0; x < groupModel.subServiceArray.count; x++)
//            {
//                CarNurseServiceModel *model = _carNurseModel.serviceArray[x];
//                if ([_selectCarServiceModel.service_id isEqualToString:model.service_id])
//                {
//                    target = model;
//                }
//            }
//            if (target == nil)
//            {
//                _selectCarServiceModel = nil;
//            }
//            else
//            {
//                _selectCarServiceModel = target;
//            }
//        }

        [_contextTableView reloadData];

    }
 }

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    ServiceGroupModel *groupModel = _carNurseModel.serviceArray[_pageIndex];
    
    return groupModel.subServiceArray.count+4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else if (section == 1)
    {
        return 30;
    }
    else if (section == 2)
    {
        return 0;
    }
    else if (section == 3)
    {
        return 50;
    }
    else
        return 40;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    ServiceGroupModel *groupModel = _carNurseModel.serviceArray[_pageIndex];
    if (section == groupModel.subServiceArray.count+3)
    {
        return 90;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceGroupModel *groupModel = _carNurseModel.serviceArray[_pageIndex];
    if (indexPath.section == 0)
    {
        return 213;
    }
    else if (indexPath.section == 1)
    {
        return 40;
    }
    else if (indexPath.section == 2)
    {
        return 40;
    }
    else if (indexPath.section == 3)
    {
        return 0;
    }
    else
    {
        CarNurseServiceModel *model = groupModel.subServiceArray[indexPath.section-4];
        CGSize messageSize = CGSizeMake(SCREEN_WIDTH-85, MAXFLOAT);
        
        
        CGSize contentSize =[model.service_content boundingRectWithSize:messageSize
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                                                context:nil].size;
        CGSize accessoriesSize =[model.accessories boundingRectWithSize:messageSize
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                                                context:nil].size;
        if ((contentSize.height+accessoriesSize.height+56-95)<0)
        {
            return 95;
        }
        else
        {
            return contentSize.height+accessoriesSize.height+56;
        }
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        if (_carsArray.count > 2)
        {
            return 2;
        }
        else
            return _carsArray.count;
    }
    else if (section == 2)
    {
        return 1;
    }
    else if (section == 3)
    {
        return 0;
    }
    else
    {
        
        if (_openedServiceRange.length == 0 && _openedServiceRange.location == 0)
        {
            return 0;
        }
        else
        {
            if (_openedServiceRange.location == _pageIndex && _openedServiceRange.length == section)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ServiceGroupModel *groupModel = _carNurseModel.serviceArray[_pageIndex];
    if (section == 1)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10, 30)];
        titleLabel.textColor = [UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0];
        titleLabel.font = [UIFont systemFontOfSize:13];
        
        titleLabel.text = @"服务车辆";
        
        
        [view addSubview:titleLabel];
        
        return view;
    }
    else if (section == 3)
    {
        
        CarServiceSelectHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CarServiceSelectHeaderView"];
        if (view == nil)
        {
            view = [[NSBundle mainBundle] loadNibNamed:@"CarServiceSelectHeaderView"
                                                 owner:nil
                                               options:nil][0];
            
        }
        view.delegate = self;
        [view setDisplayInfoWithCarNurseModel:_carNurseModel
                            withSelectedIndex:_pageIndex];
        return  view;
    }
    else if (section >3)
    {
        ServiceTypeHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ServiceTypeHeaderView"];
        if (view == nil)
        {
            view = [[NSBundle mainBundle] loadNibNamed:@"ServiceTypeHeaderView"
                                                 owner:nil
                                               options:nil][0];
            
        }
        view.sectionIndex = section;
        view.delegate = self;
        view.serviceSelectButton.selected = NO;
        view.serviceSelectButton.backgroundColor = [UIColor clearColor];
        CarNurseServiceModel *model = groupModel.subServiceArray[section-4];
        view.serviceTypeNameLabel.text = model.service_name;
        view.servicePriceLabel.text = [NSString stringWithFormat:@"¥%@",model.member_price];
        view.serviceOldPriceLabel.text = [NSString stringWithFormat:@"¥%@",model.original_price];
        
        if (_selectCarServiceModel != nil)
        {
            if (model == _selectCarServiceModel)
            {
                view.selectIconImageView.highlighted = YES;
            }
            else
            {
                view.selectIconImageView.highlighted = NO;
            }
        }
        else
        {
            view.selectIconImageView.highlighted = NO;
        }
        return view;
    }
    else
    {
        return nil;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ServiceGroupModel *groupModel = _carNurseModel.serviceArray[_pageIndex];
    if (section == groupModel.subServiceArray.count+3)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    else
        return nil;

}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return [self carNurseInfoTableView:tableView
                     cellForRowAtIndexPath:indexPath];
        
    }
    else if (indexPath.section >3 )
    {
        return  [self contextTableView:tableView
                 cellForRowAtIndexPath:indexPath];
    }
    else
    {
        return  [self carTableView:tableView
             cellForRowAtIndexPath:indexPath];
    }
}


- (UITableViewCell*)carNurseInfoTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarNurseInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:carNurseCellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[CarNurseInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:carNurseCellIdentifier];
    }
    
    cell.tag = _is4SService?1:0;
    [cell setDisplayCarNurseInfo:_carNurseModel];
    cell.delegate = self;

    return cell;
}


- (UITableViewCell*)contextTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:serviceIntroduceCellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[ServiceIntroduceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:serviceIntroduceCellIdentifier];
    }
    
    ServiceGroupModel *groupModel = _carNurseModel.serviceArray[_pageIndex];
    CarNurseServiceModel *model = groupModel.subServiceArray[indexPath.section-4];
    
    
    if ([model.service_content isEqualToString:@""] || model.service_content == nil)
    {
        cell.contentLabel.text = @"暂无内容";
    }
    else
    {
        cell.contentLabel.text = model.service_content;
    }
    if ([model.accessories isEqualToString:@""] || model.accessories == nil)
    {
        cell.accessoryLabel.text = @"暂无材料";
    }
    else
    {
        cell.accessoryLabel.text = model.accessories;
    }

    
    return cell;
}

- (UITableViewCell*)carTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        AddCarsCell *cell = [[NSBundle mainBundle] loadNibNamed:@"AddCarsCell"
                                                          owner:nil
                                                        options:nil][0];
        cell.delegate = self;
        if (!_userInfo.member_id)
        {
            cell.opreationTitle.text = @"未登录";
        }
        else if (_carsArray.count > 2)
        {
            cell.opreationTitle.text = @"更多车辆";
        }
        else
        {
            cell.opreationTitle.text = @"添加车辆";
        }
        return cell;
    }
    else
    {
        MyCarDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:myCarDetailCellIdentifier];
        if (nil == cell)
        {
            cell = [[MyCarDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:myCarDetailCellIdentifier];
        }
        CarInfos *info = _carsArray[indexPath.row];
        [cell setDisplayInfo:info];
        if (_selectedCar != nil)
        {
            if (info == _selectedCar)
            {
                cell.selectIcon.highlighted = YES;
            }
            else
            {
                cell.selectIcon.highlighted = NO;
            }
        }
        else
        {
            cell.selectIcon.highlighted = NO;
        }
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)didAddCarButtonTouched
{
    if ([self.delegate respondsToSelector:@selector(didSelectOrAddMoreCar)])
    {
        [self.delegate didSelectOrAddMoreCar];
    }
}

- (void)didMyCarButtonSelectButtonTouched:(NSIndexPath *)indexPath
{
    _selectedCar = _carsArray[indexPath.row];
    [_contextTableView reloadData];
   // [_contextTableView reloadRowsAtIndexPaths: withRowAnimation:UITableView];
}

#pragma mark - ServiceTypeHeaderViewDelegate

- (void)didArrowButtonTouched:(NSInteger)section
{

}

- (void)didServiceChange:(NSInteger)serviceIndex
{
    _pageIndex = serviceIndex;
//    ServiceGroupModel *groupModel = _carNurseModel.serviceArray[_pageIndex];
//    if (groupModel.subServiceArray.count > 0)
//    {
//        _selectCarServiceModel = groupModel.subServiceArray[0];
//        if ([_selectCarServiceModel.service_mode rangeOfString:@","].location != NSNotFound)
//        {
//            
//            [self updatePayAndBookOrderButtonWithLeftEnable:YES andRightEnable:YES];
//            
//            
//        }
//        else
//        {
//            if ([_selectCarServiceModel.service_mode isEqualToString:@"1"])
//            {
//                [self updatePayAndBookOrderButtonWithLeftEnable:YES andRightEnable:NO];
//                
//            }
//            else  if ([_selectCarServiceModel.service_mode isEqualToString:@"2"])
//            {
//                
//                [self updatePayAndBookOrderButtonWithLeftEnable:NO andRightEnable:YES];
//                
//            }
//            else
//            {
//                [self updatePayAndBookOrderButtonWithLeftEnable:NO andRightEnable:NO];
//                
//            }
//        }
//        _openedServiceRange = NSMakeRange(0, 0);
//    }
//    else
//    {
//        _selectCarServiceModel = nil;
//        _openedServiceRange = NSMakeRange(0, 0);
//        [self updatePayAndBookOrderButtonWithLeftEnable:NO andRightEnable:NO];
//    }
    [_contextTableView reloadData];
}

- (void)didServiceTypeSelect:(NSInteger)section
{
    if (_carNurseModel.serviceArray.count > 0)
    {
        ServiceGroupModel *groupModel = _carNurseModel.serviceArray[_pageIndex];
        _selectCarServiceModel = groupModel.subServiceArray[section-4];
        if ([_selectCarServiceModel.service_mode rangeOfString:@","].location != NSNotFound)
        {
            
            [self updatePayAndBookOrderButtonWithLeftEnable:YES andRightEnable:YES];


        }
        else
        {
            if ([_selectCarServiceModel.service_mode isEqualToString:@"1"])
            {
                [self updatePayAndBookOrderButtonWithLeftEnable:YES andRightEnable:NO];

            }
            else  if ([_selectCarServiceModel.service_mode isEqualToString:@"2"])
            {
                
                [self updatePayAndBookOrderButtonWithLeftEnable:NO andRightEnable:YES];

            }
            else
            {
                [self updatePayAndBookOrderButtonWithLeftEnable:NO andRightEnable:NO];

            }
        }

        if ([_selectCarServiceModel.service_content isEqualToString:@""] && [_selectCarServiceModel.accessories isEqualToString:@""])
        {
            _openedServiceRange = NSMakeRange(0, 0);
        }
        else if (_openedServiceRange.length == 0 && _openedServiceRange.location == 0)//当前无展开展开
        {
            _openedServiceRange = NSMakeRange(_pageIndex, section);

        }
        else if (_openedServiceRange.length == section && _openedServiceRange.location == _pageIndex)//当前无展开展开
        {
            _openedServiceRange = NSMakeRange(0, 0);
        }
        else
        {

            _openedServiceRange = NSMakeRange(_pageIndex, section);
        }
        [_contextTableView reloadData];

        if (_openedServiceRange.length > 0)
        {
            [_contextTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                         inSection:_openedServiceRange.length]
                                     atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }

        return;
    }
}




- (void)didInsertOrDeleteAnimationFinish
{
    self.userInteractionEnabled = YES;
    [_contextTableView reloadData];

}

- (IBAction)didPayOrderButtonTouch:(id)sender
{

    if ([self.delegate respondsToSelector:@selector(didPayOrderButtonTouched)])
    {
        [self.delegate didPayOrderButtonTouched];
    }
}

- (IBAction)didBookOrderButtonTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didBookOrderButtonTouched)])
    {
        [self.delegate didBookOrderButtonTouched];
    }
}

- (void)didNaviButtonTouched
{
    if ([self.delegate respondsToSelector:@selector(didCarNurseNaviButtonTouched)])
    {
        [self.delegate didCarNurseNaviButtonTouched];
    }
}

- (void)didPhoneCallButtonTouched
{
    if ([self.delegate respondsToSelector:@selector(didCarNursePhoneCallTouched)])
    {
        [self.delegate didCarNursePhoneCallTouched];
    }
}

- (void)didCommentsButtonTouched
{
    if ([self.delegate respondsToSelector:@selector(didCarNurseCommentButtonTouched)])
    {
        [self.delegate didCarNurseCommentButtonTouched];
    }
}

- (void)didCarWashDetailButtonTouched
{
    if ([self.delegate respondsToSelector:@selector(didCarNurseDetailButtonTouched)])
    {
        [self.delegate didCarNurseDetailButtonTouched];
    }
}

- (void)didQuickRescuePhoneButtonTouched
{
    if ([self.delegate respondsToSelector:@selector(didCarNursePhoneCallTouched)])
    {
        [self.delegate didCarNursePhoneCallTouched];
    }
}

- (void)didQuickRescueCommentButtonTouched
{
    if ([self.delegate respondsToSelector:@selector(didCarNurseCommentButtonTouched)])
    {
        [self.delegate didCarNurseCommentButtonTouched];
    }
}

- (void)updateClubPayAndBookOrderButtonWithLeftEnable:(BOOL)leftEnable
                                       andRightEnable:(BOOL)rightEnable
{
    if (leftEnable)
    {
        [_payOrderButton setTitleColor:kClubBlackGoldColor
                              forState:UIControlStateNormal];
        [_payOrderButton setBackgroundColor:kClubBlackColor];
        _payOrderButton.userInteractionEnabled = YES;
    }
    else
    {
        [_payOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payOrderButton setBackgroundColor:kClubLightGrayColor];
        _payOrderButton.userInteractionEnabled = NO;
    }
    
    if (rightEnable)
    {
        [_bookOrderButton setTitleColor:kClubBlackColor forState:UIControlStateNormal];
        [_bookOrderButton setBackgroundColor:[UIColor clearColor]];
        _bookOrderButton.layer.borderColor = kClubBlackColor.CGColor;
        _bookOrderButton.layer.borderWidth = 0.7;
        _bookOrderButton.userInteractionEnabled = YES;
    }
    else
    {
        [_bookOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bookOrderButton setBackgroundColor:kClubLightGrayColor];
        _bookOrderButton.layer.borderColor = [UIColor clearColor].CGColor;
        _bookOrderButton.layer.borderWidth = 0.7;
        _bookOrderButton.userInteractionEnabled = NO;
    }
}

- (void)updatePayAndBookOrderButtonWithLeftEnable:(BOOL)leftEnable andRightEnable:(BOOL)rightEnable
{
    if (leftEnable)
    {
        [_payOrderButton setBackgroundColor:[UIColor colorWithRed:235.0/255.0
                                                            green:84.0/255.0
                                                             blue:1.0/255.0
                                                            alpha:1.0]];
        _payOrderButton.userInteractionEnabled = YES;
    }
    else
    {
        [_payOrderButton setBackgroundColor:[UIColor colorWithRed:190.0/255.0
                                                            green:190.0/255.0
                                                             blue:190.0/255.0
                                                            alpha:1.0]];
        _payOrderButton.userInteractionEnabled = NO;
    }
    
    if (rightEnable)
    {
        [_bookOrderButton setBackgroundColor:[UIColor colorWithRed:39.0/255.0
                                                             green:185.0/255.0
                                                              blue:84.0/255.0
                                                             alpha:1.0]];
        _bookOrderButton.userInteractionEnabled = YES;
    }
    else
    {
        [_bookOrderButton setBackgroundColor:[UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0]];
        _bookOrderButton.userInteractionEnabled = NO;
    }
}



#pragma mark - UITableViewDelegate


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
