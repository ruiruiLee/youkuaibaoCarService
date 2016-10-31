//
//  CarNurseView.m
//  优快保
//
//  Created by cts on 15/4/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "ButlerView.h"
#import "UIImageView+WebCache.h"
#import "CarNurseServiceModel.h"
#import "ServiceIntroduceCell.h"

@implementation ButlerView

static NSString *headerViewIdentifier = @"ServiceTypeHeaderView";
static NSString *serviceIntroduceCellIdentifier = @"ServiceIntroduceCell";
static NSString *myCarDetailCellIdentifier = @"MyCarDetailCell";
static NSString *butlerInfoCellIdentifier = @"ButlerInfoCell";



- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    [_contextTableView registerNib:[UINib nibWithNibName:butlerInfoCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:butlerInfoCellIdentifier];
    
    [_contextTableView registerNib:[UINib nibWithNibName:serviceIntroduceCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:serviceIntroduceCellIdentifier];
    [_contextTableView registerNib:[UINib nibWithNibName:myCarDetailCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:myCarDetailCellIdentifier];
    
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
    
    
    if (!_showMoreService)
    {
        _recommendServiceNumber = 0;
        _moreServiceNumber = 0;
        
        if (_carNurseModel.serviceArray.count > 0 && self.targetType != nil)
        {
            for (int x = 0; x<_carNurseModel.serviceArray.count; x++)
            {
                CarNurseServiceModel *model = _carNurseModel.serviceArray[x];
                
                if ([model.service_type isEqualToString:self.targetType])
                {
                    _recommendServiceNumber++;
                }
                else
                {
                    _moreServiceNumber++;
                }
            }
        }
        if (_moreServiceNumber > 0)
        {
            _recommendServiceNumber ++;
        }
        NSLog(@"推荐%d 更多 %d",_recommendServiceNumber,_moreServiceNumber);
    }
    
    if (_carNurseModel.serviceArray.count > 0 && self.targetType != nil)
    {
        for (int x = 0; x<_carNurseModel.serviceArray.count; x++)
        {
            CarNurseServiceModel *model = _carNurseModel.serviceArray[x];
            
            if ([model.service_type isEqualToString:self.targetType])
            {
                _selectCarServiceModel = model;
                _openedServiceType = [NSString stringWithFormat:@"%d",x+2];
                break;
            }
        }
    }
    
    if (_selectCarServiceModel != nil)
    {
        CarNurseServiceModel *target = nil;
        for (int x = 0; x < _carNurseModel.serviceArray.count; x++)
        {
            CarNurseServiceModel *model = _carNurseModel.serviceArray[x];
            if ([_selectCarServiceModel.service_id isEqualToString:model.service_id])
            {
                target = model;
            }
        }
        if (target == nil)
        {
            _selectCarServiceModel = nil;
        }
        else
        {
            _selectCarServiceModel = target;
        }
    }
    
    _priceLabel.text = [NSString stringWithFormat:@"¥%@", _selectCarServiceModel.member_price];
    [_contextTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_showMoreService)
    {
        return _carNurseModel.serviceArray.count+4;
    }
    else
    {
        return _recommendServiceNumber+4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_showMoreService)
    {
        if (section == 0)
        {
            return 0;
        }
        else if (section == 1)
        {
            return 30;
        }
        else if (section > 1 && section < 2 + _carNurseModel.serviceArray.count)
        {
            return 40;
        }
        else if (section ==  _carNurseModel.serviceArray.count + 2)
        {
            return 30;
        }
        else
            return 0;

    }
    else
    {
        if (section == 0)
        {
            return 0;
        }
        else if (section == 1)
        {
            return 30;
        }
        else if (section > 1 && section < 2 + _recommendServiceNumber)
        {
            return 40;
        }
        else if (section == _recommendServiceNumber + 2)
        {
            return 30;
        }
        else
            return 0;
    }
//    if (section == 0 || section == _carNurseModel.serviceArray.count + 3)
//    {
//        return 0;
//    }
//    else if (section == 1 || section ==  _carNurseModel.serviceArray.count + 2)
//    {
//        return 30;
//    }
//    else
//    {
//        return 40;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_showMoreService)
    {
        if (section == _carNurseModel.serviceArray.count+3)
        {
            return 90;
        }
        else
            return 0;
    }
    else
    {
        if (section == _recommendServiceNumber+3)
        {
            return 90;
        }
        else
            return 0;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_showMoreService)
    {
        if (indexPath.section == 0)
        {
            if ([_carNurseModel.introduction isEqualToString:@""] || _carNurseModel.introduction == nil)
            {
                return 354;
            }
            else
            {
                CGSize messageSize = CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT);
                
                
                CGSize contentSize =[_carNurseModel.introduction boundingRectWithSize:messageSize
                                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}
                                                                              context:nil].size;
                return 354+contentSize.height;
            }
        }
        else if (indexPath.section == 1)
        {
            return 0;
        }
        else if (indexPath.section > 1 && indexPath.section < 2 + _carNurseModel.serviceArray.count)
        {
            CarNurseServiceModel *model = _carNurseModel.serviceArray[indexPath.section-2];
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
        else
        {
            return 40;
        }
    }
    else
    {
        if (indexPath.section == 0)
        {
            if ([_carNurseModel.introduction isEqualToString:@""] || _carNurseModel.introduction == nil)
            {
                return 354;
            }
            else
            {
                CGSize messageSize = CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT);
                
                
                CGSize contentSize =[_carNurseModel.introduction boundingRectWithSize:messageSize
                                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}
                                                                              context:nil].size;
                return 354+contentSize.height;
            }
        }
        else if (indexPath.section == 1)
        {
            return 0;
        }
        else if (indexPath.section > 1 && indexPath.section < 2 + _recommendServiceNumber)
        {
            CarNurseServiceModel *model = _carNurseModel.serviceArray[indexPath.section-2];
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
        else
        {
            return 40;
        }
    }
//    if (indexPath.section == 0)
//    {
//        if ([_carNurseModel.introduction isEqualToString:@""] || _carNurseModel.introduction == nil)
//        {
//            return 337;
//        }
//        else
//        {
//            CGSize messageSize = CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT);
//            
//            
//            CGSize contentSize =[_carNurseModel.introduction boundingRectWithSize:messageSize
//                                                                          options:NSStringDrawingUsesLineFragmentOrigin
//                                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}
//                                                                          context:nil].size;
//            return 337+contentSize.height;
//        }
//        
//    }
//    else
//    {
//        return 40;
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_showMoreService)
    {
        if (section == 0)
        {
            return 1;
        }
        else if (section == 1)
        {
            return 0;
        }
        else if (section == _carNurseModel.serviceArray.count+2)
        {
            if (_carsArray.count > 2)
            {
                return 2;
            }
            else
                return _carsArray.count;
        }
        else if (section == _carNurseModel.serviceArray.count+3)
        {
            return 1;
        }
        else
        {
            if (_openedServiceType == nil)
            {
                return 0;
            }
            else
            {
                if (_openedServiceType.intValue == section)
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
    else
    {
        if (section == 0)
        {
            return 1;
        }
        else if (section == 1)
        {
            return 0;
        }
        else if (section == _recommendServiceNumber+2)
        {
            if (_carsArray.count > 2)
            {
                return 2;
            }
            else
                return _carsArray.count;
        }
        else if (section == _recommendServiceNumber+3)
        {
            return 1;
        }
        else
        {
            if (_openedServiceType == nil)
            {
                return 0;
            }
            else
            {
                if (_openedServiceType.intValue == section)
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
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_showMoreService)
    {
        if (section > 1 && section < _carNurseModel.serviceArray.count+2)
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
            CarNurseServiceModel *model = _carNurseModel.serviceArray[section-2];
            view.serviceTypeNameLabel.text =  model.service_name;
            view.servicePriceLabel.text = [NSString stringWithFormat:@"¥%@",model.member_price];
            view.serviceOldPriceLabel.text = [NSString stringWithFormat:@"¥%@",model.original_price];
            
            
            //控制选中按钮状态
            
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
            view.serviceSelectButton.selected = NO;
            view.serviceSelectButton.backgroundColor = [UIColor clearColor];
            return view;
        }
        else if (section == 1 || section ==  _carNurseModel.serviceArray.count + 2)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
            view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10, 30)];
            titleLabel.textColor = [UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0];
            titleLabel.font = [UIFont systemFontOfSize:13];
            
            if (section == 1)
            {
                titleLabel.text = @"服务类型";
            }
            else
            {
                titleLabel.text = @"服务车辆";
            }
            
            [view addSubview:titleLabel];
            
            return view;
        }
        else
        {
            return nil;
        }
    }
    else
    {
        if (section > 1 && section < _carNurseModel.serviceArray.count+2)
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
            CarNurseServiceModel *model = _carNurseModel.serviceArray[section-2];
            view.serviceTypeNameLabel.text =  model.service_name;
            

            if (section - 2 == _recommendServiceNumber - 1)
            {
                if (_moreServiceNumber > 0)
                {
                    view.delegate = self;
                    view.serviceSelectButton.selected = YES;
                    view.serviceSelectButton.backgroundColor = [UIColor whiteColor];
                }
                else
                {
                    view.sectionIndex = section;
                    view.delegate = self;
                    view.serviceSelectButton.selected = NO;
                    view.serviceSelectButton.backgroundColor = [UIColor clearColor];
                    CarNurseServiceModel *model = _carNurseModel.serviceArray[section-2];
                    view.serviceTypeNameLabel.text = model.service_name;
                    view.servicePriceLabel.text = [NSString stringWithFormat:@"¥%@",model.member_price];
                    view.serviceOldPriceLabel.text = [NSString stringWithFormat:@"¥%@",model.original_price];
                }

            }
            else
            {
                view.sectionIndex = section;
                view.delegate = self;
                view.serviceSelectButton.selected = NO;
                view.serviceSelectButton.backgroundColor = [UIColor clearColor];
                CarNurseServiceModel *model = _carNurseModel.serviceArray[section-2];
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

            }
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
        else if (section == 1 || section ==  _carNurseModel.serviceArray.count + 2)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
            view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10, 30)];
            titleLabel.textColor = [UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0];
            titleLabel.font = [UIFont systemFontOfSize:13];
            
            if (section == 1)
            {
                titleLabel.text = @"服务类型";
            }
            else
            {
                titleLabel.text = @"服务车辆";
            }
            
            [view addSubview:titleLabel];
            
            return view;
        }
        else
        {
            return nil;
        }
    }

}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_showMoreService)
    {
        if (section == _carNurseModel.serviceArray.count+3)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
            view.backgroundColor = [UIColor clearColor];
            return view;
        }
        else
            return nil;
    }
    else
    {
        if (section == _recommendServiceNumber+3)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
            view.backgroundColor = [UIColor clearColor];
            return view;
        }
        else
            return nil;
    }

}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_showMoreService)
    {
        if (indexPath.section == 0)
        {
            return [self carNurseInfoTableView:tableView
                         cellForRowAtIndexPath:indexPath];
            
        }
        else if (indexPath.section > 1 && indexPath.section < _carNurseModel.serviceArray.count + 2)
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
    else
    {
        if (indexPath.section == 0)
        {
            return [self carNurseInfoTableView:tableView
                         cellForRowAtIndexPath:indexPath];
            
        }
        else if (indexPath.section > 1 && indexPath.section < _recommendServiceNumber + 2)
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


}


- (UITableViewCell*)carNurseInfoTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ButlerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:butlerInfoCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[ButlerInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:butlerInfoCellIdentifier];
    }
    
    [cell setDisplayCarNurseInfo:_carNurseModel];
    cell.delegate = self;

    return cell;
}


- (UITableViewCell*)contextTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:serviceIntroduceCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[ServiceIntroduceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:serviceIntroduceCellIdentifier];
    }
    
    CarNurseServiceModel *model = _carNurseModel.serviceArray[indexPath.section-2];
    
    
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
    if (indexPath.section == _carNurseModel.serviceArray.count + 3)
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
}

#pragma mark - ServiceTypeHeaderViewDelegate

- (void)didArrowButtonTouched:(NSInteger)section
{

}



- (void)didServiceTypeSelect:(NSInteger)section
{
    
    if (_carNurseModel.serviceArray.count > 0)
    {
        _selectCarServiceModel = _carNurseModel.serviceArray[section-2];
        
        if ([_selectCarServiceModel.service_content isEqualToString:@""] && [_selectCarServiceModel.accessories isEqualToString:@""])
        {
            _openedServiceType = nil;
        }
        else if (_openedServiceType == nil)
        {
            _openedServiceType = [NSString stringWithFormat:@"%ld",(long)section];
            
        }
        else if ([_openedServiceType isEqualToString:[NSString stringWithFormat:@"%ld",(long)section]])
        {
            _openedServiceType = nil;
        }
        else
        {
            
            _openedServiceType = [NSString stringWithFormat:@"%ld",(long)section];
            
        }
        _priceLabel.text = [NSString stringWithFormat:@"¥%@", _selectCarServiceModel.member_price];
        [_contextTableView reloadData];
        
        return;
    }

}

#pragma mark - MoreServiceCellDelegate

- (void)didMoreServiceButtonTouched
{
    if (_moreServiceNumber > 0)
    {
        _showMoreService = YES;
        [_contextTableView reloadData];
    }
    else
    {
        [Constants showMessage:@"没有更多服务了"];
        return;
    }
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
    if (_selectCarServiceModel == nil)
    {
        [Constants showMessage:@"您还没有选择服务"];
        return;
    }
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






#pragma mark - UITableViewDelegate


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
