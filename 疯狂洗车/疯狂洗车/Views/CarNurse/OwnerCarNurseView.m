//
//  OwnerCarNurseView.m
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/15.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "OwnerCarNurseView.h"
#import "UIImageView+WebCache.h"
#import "CarNurseServiceModel.h"
#import "AppointInfoItemTableViewCell.h"
#import "PriceBudgetTableViewCell.h"
#import "define.h"
#import "MyTicketViewController.h"
#import "CLLocation+YCLocation.h"

@implementation OwnerCarNurseView
@synthesize customerLocation = _customerLocation;

static NSString *myCarDetailCellIdentifier = @"MyCarDetailCell";
static NSString *carNurseCellIdentifier = @"CarNurseInfoCell";
static NSString *AppointInfoItemTableViewCellIdentifier = @"AppointInfoItemTableViewCell";
static NSString *PriceBudgetTableViewCellIdentifier = @"PriceBudgetTableViewCell";
static NSString *ServiceTypeTableViewCellIdentifier = @"ServiceTypeTableViewCell";



- (void)awakeFromNib {
    // Initialization code
    _appointPhone.layer.masksToBounds = YES;
    _appointPhone.layer.cornerRadius  = 3;
    _appointPhone.layer.borderWidth = 1;
    _appointPhone.layer.borderColor = _COLOR(0xff, 0x66, 0x19).CGColor;
    
    _appointOnline.layer.masksToBounds = YES;
    _appointOnline.layer.cornerRadius  = 3;
    
    _serviceType = enumZjiadaodian;
    _priceEstimate = 0;
    _webViewHeight = 30;
    [self initAppointDate];
    
    [_contextTableView registerNib:[UINib nibWithNibName:myCarDetailCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:myCarDetailCellIdentifier];
    [_contextTableView registerNib:[UINib nibWithNibName:AppointInfoItemTableViewCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:AppointInfoItemTableViewCellIdentifier];
    
    [_contextTableView registerNib:[UINib nibWithNibName:PriceBudgetTableViewCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:PriceBudgetTableViewCellIdentifier];
    [_contextTableView registerNib:[UINib nibWithNibName:ServiceTypeTableViewCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:ServiceTypeTableViewCellIdentifier];
    
    if (self.tag<0)
    {
        [_contextTableView registerNib:[UINib nibWithNibName:[NSString stringWithFormat:@"%@_Club",carNurseCellIdentifier]
                                                      bundle:[NSBundle mainBundle]]
                forCellReuseIdentifier:carNurseCellIdentifier];
        
//        [_contextTableView registerNib:[UINib nibWithNibName:serviceIntroduceCellIdentifier
//                                                      bundle:[NSBundle mainBundle]]
//                forCellReuseIdentifier:serviceIntroduceCellIdentifier];
        
    }
    else
    {
        [_contextTableView registerNib:[UINib nibWithNibName:carNurseCellIdentifier
                                                      bundle:[NSBundle mainBundle]]
                forCellReuseIdentifier:carNurseCellIdentifier];
        
//        [_contextTableView registerNib:[UINib nibWithNibName:serviceIntroduceCellIdentifier
//                                                      bundle:[NSBundle mainBundle]]
//                forCellReuseIdentifier:serviceIntroduceCellIdentifier];
        
    }
    
    _contextTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (SCREEN_WIDTH < 375)
    {
//        for (int x = 0; x<_submitView.constraints.count; x++)
//        {
//            NSLayoutConstraint *layoutConstraint = _submitView.constraints[x];
//            if (layoutConstraint.firstAttribute == NSLayoutAttributeHeight)
//            {
//                [_submitView removeConstraint:layoutConstraint];
//                break;
//            }
//            
//        }
//        
//        NSDictionary* views = NSDictionaryOfVariableBindings(_submitView);
//        
//        [_submitView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_submitView(50)]"
//                                                                            options:0
//                                                                            metrics:nil
//                                                                              views:views]];
    }
}

- (void) initAppointDate
{
    NSDate *date = [[NSDate alloc] initWithTimeInterval:3600*2 sinceDate:[NSDate date]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
    
    NSInteger hour = [comps hour];
    
    if(hour < 9){
        [comps setHour:9];
        [comps setMinute:0];
        [comps setSecond:0];
        date = [calendar dateFromComponents:comps];
    }
    else if(hour > 17){
        [comps setHour:9];
        [comps setMinute:0];
        [comps setSecond:0];
        date = [calendar dateFromComponents:comps];
        date = [date dateByAddingTimeInterval:24 * 3600];
    }
    
    _appointDateStart = date;
    _dateStart = date;
}

- (void)setTickets:(OwnerStoreCarWashModel *)model
{
    _ticketsModel = model;
    [_contextTableView reloadData];
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
        
        [_contextTableView reloadData];
        
    }
}

#pragma mark - UITableViewDataSource

//
/*
 section:
 0 : header+评分
 1 : 服务方式
 2 : 服务车辆信息
 3 : 更多车辆
 4 : 预约时间
 5 : 优惠券抵扣
 6 : 价格估算
 */


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_serviceType == enumSmenquche)
        return 8;
    else
        return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.01;
    }
    else if (section == 1)
    {
        return 30;
    }
    else if (section == 2)
    {
        return 0.01;
    }
    else if (section == 3)
    {
        return 11;
    }
    else
        return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(_serviceType == enumSmenquche)
    {
        if(section == 3)
            return 50.f;
        else if (section == 7 && _priceEstimate)
            return _webViewHeight;
        else
            return 0.01;
    }
    else{
   
        if (section == 6 && _priceEstimate)
            return _webViewHeight;
        else
            return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_serviceType == enumSmenquche){
        if(indexPath.section == 6){
            if(_ticketsModel.code_id == nil)
                return 0;
            else
                return 40;
        }
        
    }
    else{
        if(indexPath.section == 5){
            if(_ticketsModel.code_id == nil)
                return 0;
            else
                return 40;
        }
    }
    if (indexPath.section == 0)
    {
        return 213;
    }
    else if (indexPath.section == 1)
    {
        return 40;
    }
    else
    {
        return 40.f;
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
    else
    {
        return 1;
    }
}

- (UIView *) initSectionHeaderView:(NSString *) titile
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10, 30)];
    titleLabel.textColor = [UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0];
    titleLabel.font = [UIFont systemFontOfSize:13];
    
    titleLabel.text = titile;
    
    
    [view addSubview:titleLabel];
    
    return view;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return [self initSectionHeaderView:@"服务车辆"];
    }
    else if (section == 3)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
        return  view;
    }
    else
    {
        return nil;
    }
}

- (void) initWebView
{
    _priceEstimateWeb = [[UIWebView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, _webViewHeight - 20)];
    [_priceEstimateWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:GU_JIA_URL, BASE_Uri_FOR_WEB, _userInfo.member_id, self.targetType, _carNurseModel.car_wash_id]]]];
    [_priceEstimateWeb.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    _priceEstimateWeb.scrollView.scrollEnabled = NO;
    _priceEstimateWeb.delegate = self;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(_serviceType == enumSmenquche){
        if(section == 3){
       
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
            view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10, 30)];
            titleLabel.textColor = [UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0];
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.numberOfLines = 2;
            titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            
            [view addSubview:titleLabel];
            
            [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[titleLabel]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)]];
            [view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            
            titleLabel.text = @"成都市绕城内提供免费上门取车及送还服务，安全由中国人民财产保险有限公司承保！";
            
            
            
            return view;
        }else if (section == 7){
            if(_priceEstimate){
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _webViewHeight)];
                view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
                
                if(!_priceEstimateWeb){
                    [self initWebView];
                    [MBProgressHUD showHUDAddedTo:self animated:YES];
                    
                    
                }
                else{
                    [_priceEstimateWeb removeFromSuperview];
                    _priceEstimateWeb.frame = CGRectMake(0, 10, SCREEN_WIDTH, _webViewHeight - 20);
                }
                
                
                [view addSubview:_priceEstimateWeb];
                
                
                return view;
            }else{
                [_priceEstimateWeb removeFromSuperview];
                return nil;
            }
        }
        else
            return nil;
    }else{
        if (section == 6){
            if(_priceEstimate){
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _webViewHeight)];
                view.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
                
                if(!_priceEstimateWeb){
                    [self initWebView];
                    [MBProgressHUD showHUDAddedTo:self animated:YES];
                }
                else{
                    [_priceEstimateWeb removeFromSuperview];
                    _priceEstimateWeb.frame = CGRectMake(0, 10, SCREEN_WIDTH, _webViewHeight - 20);
                }
                
                [view addSubview:_priceEstimateWeb];
                
                return view;
            }else{
                [_priceEstimateWeb removeFromSuperview];
                return nil;
            }
        }
    }
    return nil;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return [self carNurseInfoTableView:tableView
                     cellForRowAtIndexPath:indexPath];
        
    }
    else if (indexPath.section >2 )
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
    if(_serviceType == enumSmenquche){
        if(indexPath.section == 7){
            PriceBudgetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PriceBudgetTableViewCellIdentifier forIndexPath:indexPath];
            if (cell == nil)
            {
                cell = [[PriceBudgetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PriceBudgetTableViewCellIdentifier];
            }
            
            cell.sepLine.hidden = YES;
            cell.lbTitle.text = @"价格估算:";
            if(_priceEstimate){
                cell.shutImgV.image = [UIImage imageNamed:@"img_weather_arrow_up_gray"];
                cell.lbContent.text= @"收起";
            }else{
           
            cell.shutImgV.image = [UIImage imageNamed:@"img_weather_arrow_down_gray"];
                cell.lbContent.text= @"马上估价";
            }
            
            return cell;
            
        }
        else if (indexPath.section == 3){
            ServiceTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ServiceTypeTableViewCellIdentifier forIndexPath:indexPath];
            if (cell == nil)
            {
                cell = [[ServiceTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ServiceTypeTableViewCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lbTitle.text = @"服务方式:";
            cell.delegate = self;
            [cell setCurrentServiceType:_serviceType];
            
            return cell;
        }
        else{
            AppointInfoItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AppointInfoItemTableViewCellIdentifier forIndexPath:indexPath];
            
            if (cell == nil)
            {
                cell = [[AppointInfoItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AppointInfoItemTableViewCellIdentifier];
            }
            
            cell.sepLine.hidden = YES;
            cell.lbContent.textColor = _COLOR(0x21, 0x21, 0x21);
            switch (indexPath.section) {
                case 4:
                {
                    cell.lbTitle.text = @"取车地址:";
                    NSString *address = _customerLocation.address;
                    if(address == nil)
                        address = @"";
                    NSString *name = _customerLocation.name;
                    if(name == nil)
                        name = @"";
                    cell.lbContent.text = [NSString stringWithFormat:@"%@%@", address, name];
                }
                    break;
                case 5:
                {
                    cell.lbTitle.text = @"上门时间:";
                    cell.lbContent.text = [self appointTimeFromDate:_appointDateStart];
                }
                    break;
                case 6:
                {
                    cell.lbTitle.text = @"优惠券:";
                    cell.lbContent.text = _ticketsModel.code_name;
                    cell.lbContent.textColor = [UIColor redColor];
                }
                    break;
                    
                default:
                    break;
            }
            
            
            return cell;
            
        }
    }
    else{
        if(indexPath.section == 6){
            PriceBudgetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PriceBudgetTableViewCellIdentifier forIndexPath:indexPath];
            if (cell == nil)
            {
                cell = [[PriceBudgetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PriceBudgetTableViewCellIdentifier];
            }
            
            cell.sepLine.hidden = YES;
            cell.lbTitle.text = @"价格估算:";
            if(_priceEstimate){
                cell.shutImgV.image = [UIImage imageNamed:@"img_weather_arrow_up_gray"];
                cell.lbContent.text= @"收起";
            }else{
                
                cell.shutImgV.image = [UIImage imageNamed:@"img_weather_arrow_down_gray"];
                cell.lbContent.text= @"马上估价";
            }
            
            return cell;
            
        }
        else if (indexPath.section == 3){
            ServiceTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ServiceTypeTableViewCellIdentifier forIndexPath:indexPath];
            if (cell == nil)
            {
                cell = [[ServiceTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ServiceTypeTableViewCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lbTitle.text = @"服务方式:";
            cell.delegate = self;
            [cell setCurrentServiceType:_serviceType];
            
            return cell;
        }
        else{
            AppointInfoItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AppointInfoItemTableViewCellIdentifier forIndexPath:indexPath];
            
            if (cell == nil)
            {
                cell = [[AppointInfoItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AppointInfoItemTableViewCellIdentifier];
            }
            
            cell.sepLine.hidden = YES;
            switch (indexPath.section) {
                case 4:
                {
                    cell.lbTitle.text = @"上门时间:";
                    cell.lbContent.text = [self appointTimeFromDate:_appointDateStart];
                    cell.lbContent.textColor = _COLOR(0x21, 0x21, 0x21);
                }
                    break;
                case 5:
                {
                    cell.lbTitle.text = @"优惠券:";
//                    cell.lbContent.attributedText = [self attributeStringWithPrice:[NSNumber numberWithDouble:_ticketsModel.price].stringValue];
                    cell.lbContent.text = _ticketsModel.code_name;
                    cell.lbContent.textColor = [UIColor redColor];
                }
                    break;
                    
                default:
                    break;
            }
            
            
            return cell;
            
        }
    }
}

- (NSString *) appointTimeFromDate:(NSDate *) date{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
    
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSInteger hour = [comps hour];
    
    return [NSString stringWithFormat:@"%4d-%02d-%02d %02d点-%02d点", year, month, day, hour, hour+1];
}

- (NSAttributedString *) attributeStringWithPrice:(NSString *) price
{
    NSString *string = [NSString stringWithFormat:@"%@ %@", price, @"元"];
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    [attribute addAttribute:NSForegroundColorAttributeName
                             value:[UIColor redColor]
                             range:NSMakeRange(0, [price length])];
    [attribute addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:15]
                             range:NSMakeRange(0, [price length])];
    
    return attribute;
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

- (void)scrollToBottom
{
    if(_priceEstimateWeb)
        return;
    CGFloat yOffset = 0; //设置要滚动的位置 0最顶部 CGFLOAT_MAX最底部
    if (_contextTableView.contentSize.height > _contextTableView.bounds.size.height) {
        yOffset = _contextTableView.contentSize.height - _contextTableView.bounds.size.height;
    }
    [_contextTableView setContentOffset:CGPointMake(0, yOffset) animated:NO];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(_serviceType == enumSmenquche){
        if(indexPath.section == 7){
            _priceEstimate = !_priceEstimate;
            [_contextTableView reloadData];
            [self scrollToBottom];
        }
        else if (indexPath.section == 6){
            [self showRelativeTickets];
        }
        else if (indexPath.section == 5){
            [self SelectBeginDate];
        }else if (indexPath.section == 4){
            if(self.delegate && [self.delegate respondsToSelector:@selector(didCarNurseMapTouched)]){
                [self.delegate didCarNurseMapTouched];
            }
        }
    }
    else{
        if(indexPath.section == 6){
            _priceEstimate = !_priceEstimate;
            [_contextTableView reloadData];
            [self scrollToBottom];
        }else if (indexPath.section == 5){
            [self showRelativeTickets];
        }else if (indexPath.section == 4){
            [self SelectBeginDate];
        }
    }
}

- (void) AddressViewPoped
{
    
}

- (void) showRelativeTickets{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didCarNurseTicketsTouched)]){
        [self.delegate didCarNurseTicketsTouched];
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
/*    if (leftEnable)
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
    }*/
}

- (void)updatePayAndBookOrderButtonWithLeftEnable:(BOOL)leftEnable andRightEnable:(BOOL)rightEnable
{
/*    if (leftEnable)
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
    }*/
}



#pragma mark - UITableViewDelegate

#pragma ServiceTypeTableViewCellDelegate
- (void) NotifyServiceTypeChanged:(ServiceTypeTableViewCell *) object type:(ServiceType) type
{
    _serviceType = type;
    
    [_contextTableView reloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        _webViewHeight = [[_priceEstimateWeb stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
        _webViewHeight += 50;
        [_contextTableView reloadData];
    }  
}

#pragma UIWebViewDelegate

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self animated:YES];
}


- (void) dealloc
{
    [_priceEstimateWeb.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

#pragma ZHPickViewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultDate:(NSDate *)resultDate
{
    _appointDateStart = resultDate;
    [_contextTableView reloadData];
}

- (void) SelectBeginDate
{
    if(!_pickview){
        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        [mArray addObject:[self getDateArray]];
        [mArray addObject:[self getTimeArray]];
        _pickview = [[ZHPickView alloc] initPickviewWithArray:mArray isHaveNavControler:NO];
        [_pickview show];
        _pickview.delegate = self;
    }else{
        [_pickview show];
    }
}

- (NSArray*) getTimeArray
{
        NSArray *array = @[@"09", @"10",@"11", @"12", @"13",@"14", @"15", @"16",@"17"];
        return array;
}

- (NSArray*) getDateArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDate *curdate = _dateStart;
    NSInteger current = [curdate timeIntervalSince1970];
    for (int i = 0; i < 5; i++) {
        NSInteger timeInterval = current + i * 24 * 60 * 60 ;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        [array addObject:date];
    }
    
    return array;
}

- (void) setCustomerLocation:(BMKPoiInfo *)location
{
    _customerLocation = location;
    
    [_contextTableView reloadData];
}

- (IBAction)btnAppointByPhone:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", SERVICE_PHONE]]];
}

- (IBAction)btnAppointOnline:(id)sender
{
    BOOL flag = [self checkValueFull];
    if(!flag){
        return;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(appointWithPrama:)]){
        NSMutableDictionary *pramas = [[NSMutableDictionary alloc] init];
        
        [pramas setObject:self.targetType forKey:@"service_type"];
        [pramas setObject:_ticketsModel.service_id forKey:@"service_id"];
        
        NSInteger reserve_type = (_serviceType == enumZjiadaodian) ? 2 : 1;
        [pramas setObject:[NSNumber numberWithInteger:reserve_type] forKey:@"reserve_type"];
        
        NSString *member_id = _userInfo.member_id;
        [pramas setObject:member_id forKey:@"member_id"];
        NSString *province_id = _userInfo.province_id;
        [pramas setObject:province_id forKey:@"province_id"];
        NSString *city_id = _userInfo.city_id;
        [pramas setObject:city_id forKey:@"city_id"];
        NSString *car_id = _selectedCar.car_id;
        [pramas setObject:car_id forKey:@"car_id"];
        NSString *car_wash_id = _carNurseModel.car_wash_id;
        [pramas setObject:car_wash_id forKey:@"car_wash_id"];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        
        NSDateComponents *comps  = [calendar components:unitFlags fromDate:_dateStart];
        
        NSInteger year = [comps year];
        NSInteger month = [comps month];
        NSInteger day = [comps day];
        NSInteger hour = [comps hour];
        NSString *reserve_day = [NSString stringWithFormat:@"%04d-%02d-%02d", year, month, day];
        [pramas setObject:reserve_day forKey:@"reserve_day"];
        NSString *b_time = [NSString stringWithFormat:@"%02d:00", hour];
        [pramas setObject:b_time forKey:@"b_time"];
        NSString *e_time = [NSString stringWithFormat:@"%02d:00", hour + 1];
        [pramas setObject:e_time forKey:@"e_time"];
        
        if(_serviceType == enumSmenquche){
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:_customerLocation.pt.latitude longitude:_customerLocation.pt.longitude];
            CLLocation *locationHuoxing = [location locationMarsFromBaidu];
            NSString *longitude = [[NSNumber numberWithFloat:locationHuoxing.coordinate.longitude] stringValue];
            [pramas setObject:longitude forKey:@"longitude"];
            NSString *latitude = [[NSNumber numberWithFloat:locationHuoxing.coordinate.latitude] stringValue];
            [pramas setObject:latitude forKey:@"latitude"];
            NSString *addr = [NSString stringWithFormat:@"%@%@", _customerLocation.address, _customerLocation.name];
            [pramas setObject:addr forKey:@"addr"];
        }
        
        [self.delegate appointWithPrama:pramas];
    }
}

- (ServiceType) getServiceType;
{
    return _serviceType;
}

- (BOOL) checkValueFull
{
    BOOL result = YES;
    
    if(!_customerLocation && _serviceType == enumSmenquche){
        result = NO;
        [Constants showMessage:@"上门取车您还没有输入取车地址！"
                      delegate:self.delegate
                           tag:532
                  buttonTitles:@"取消",@"马上添加", nil];
        
        return result;
        
    }
    
    if(!_selectedCar){
        result = NO;
        [Constants showMessage:@"您还没有添加您的车辆，请先补充您的车辆信息"
                      delegate:self.delegate
                           tag:531
                  buttonTitles:@"取消",@"马上补充", nil];
        
        return result;
    }
    
    return result;
}

@end
