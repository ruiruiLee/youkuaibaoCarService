//
//  AddNewCarController.m
//  优快保
//
//  Created by 朱伟铭 on 15/1/28.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "AddNewCarController.h"
#import "UIView+Toast.h"
#import "MBProgressHUD+Add.h"
#import "WebServiceHelper.h"
#import "LicensePlateSelecter.h"
#import "CarBrandSelectViewController.h"

@interface AddNewCarController () <UIActionSheetDelegate,UITextFieldDelegate,LicensePlateSelecterDeleagte,CarBrandSelectDelegate>
{
    LicensePlateSelecter *_licensePlateSelecter;
}

@end

@implementation AddNewCarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.shouldComplete)
    {
        _pinpaiCompleteTag.hidden = NO;
        _pinpaiField.placeholder = @"请输入车型号";
    }
    
    [self setupInterface];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(closeKeyBoard)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}




#pragma mark - closeKeyBoard

- (void)closeKeyBoard
{
    [[self findFirstResponder:self.view]resignFirstResponder];

}

- (UIView *)findFirstResponder:(UIView*)view
{
    for ( UIView *childView in view.subviews )
    {
        if ([childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder])
        {
            return childView;
        }
        UIView *result = [self findFirstResponder:childView];
        if (result) return result;
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupInterface
{
    if (_carInfo)
    {
        [self setTitle:@"完善信息"];
        switch ([_carInfo.car_type integerValue])
        {
            case 1:
            {
                [_carTypeSegment setSelectedSegmentIndex:0];
            }
                break;
            case 2:
            {
                [_carTypeSegment setSelectedSegmentIndex:1];
            }
            default:
                break;
        }
        [_chepaiField setText:[NSString stringWithFormat:@"%@%@",
                               [_carInfo.car_no substringToIndex:1],
                               [_carInfo.car_no substringWithRange:NSMakeRange(1, 1)]]];

        [_numberField setText:[_carInfo.car_no substringFromIndex:2]];
        
        if ([self.carInfo.car_brand isEqualToString:@""] ||
            self.carInfo.car_brand == nil ||
            self.carInfo.brand_id == nil ||
            [self.carInfo.brand_id isEqualToString:@""] ||
            self.carInfo.series_id == nil ||
            [self.carInfo.series_id isEqualToString:@""])
        {
            _pinpaiField.text = @"";
        }
        else
        {
            NSString *result = [NSString stringWithFormat:@"%@ %@ %@",self.carInfo.car_brand == nil? @"":self.carInfo.car_brand,
                                self.carInfo.car_kuanshi == nil? @"":self.carInfo.car_kuanshi,
                                self.carInfo.car_xilie == nil? @"":self.carInfo.car_xilie];
            
            _pinpaiField.text = result;

        }

    }
    else
    {
        [self setTitle:@"新增车辆"];
    }
    [[_submitBtn layer] setCornerRadius:3.0];
    [[_submitBtn layer] setMasksToBounds:YES];
    
    _chepaiField.layer.borderWidth = 1.0;
    _chepaiField.layer.borderColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0].CGColor;
    
    _numberField.layer.borderWidth = 1.0;
    _numberField.layer.borderColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0].CGColor;
    
    _pinpaiField.layer.borderWidth = 1.0;
    _pinpaiField.layer.borderColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0].CGColor;
}

- (IBAction)chooseProvince:(id)sender
{

}

- (IBAction)chooseType:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择车型"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"轿车", @"SUV", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)chooseChart:(id)sender
{

}

- (IBAction)submitInfo:(id)sender
{
    [self closeKeyBoard];
    
    if ([_numberField.text isEqualToString:@""] || !_numberField.text)
    {
        [self.view makeToast:@"请输入您的车牌号"];
        return;
    }
    if (![self validateCarNo:[NSString stringWithFormat:@"%@%@",[_chepaiField.text substringWithRange:NSMakeRange(1, 1)],_numberField.text]])
    {
        [self.view makeToast:@"您的车牌号码不正确"];
        return;
    }
    if (_carTypeSegment.selectedSegmentIndex == -1)
    {
        [self.view makeToast:@"请选择您的车类型"];
        return;
    }
    if (self.shouldComplete)
    {
        if ([_pinpaiField.text isEqualToString:@""] || _pinpaiField.text == nil)
        {
            [self.view makeToast:@"请选择您的车型号"];
            return;
        }
    }
    NSMutableDictionary *paramDic = [@{} mutableCopy];
    /*
     1.1车辆管理（测试通过）
     地址：http://118.123.249.87/service/car_manage.aspx
     
     新增时不用输入car_id，修改或删除时必须输入car_id
     参数:
     op_type：操作方式(“insert”、“update”、“delete”)
     car_id:车辆id号
     member_id:会员编号
     car_no:牌照
     car_type(1:轿车,2:SUV)
     car_brand:品牌 如用户没输入，请传入””(空)
     */
    if (_carInfo)
    {
        [paramDic setValue:_userInfo.member_id forKey:@"member_id"];
        [paramDic setValue:_carInfo.car_id forKey:@"car_id"];
        [paramDic setValue:[NSString stringWithFormat:@"%@%@", _chepaiField.text, [_numberField.text uppercaseString]]
                    forKey:@"car_no"];
        [paramDic setValue:[NSNumber numberWithInteger:_carTypeSegment.selectedSegmentIndex == 0?1:2]
                    forKey:@"car_type"];
        [paramDic setValue:self.carInfo.car_brand
                    forKey:@"car_brand"];
        [paramDic setValue:self.carInfo.brand_id
                    forKey:@"brand_id"];
        [paramDic setValue:self.carInfo.car_kuanshi
                    forKey:@"car_kuanshi"];
        [paramDic setValue:self.carInfo.car_xilie
                    forKey:@"car_xilie"];
        [paramDic setValue:self.carInfo.series_id
                    forKey:@"series_id"];

        [paramDic setValue:@"update"
                    forKey:@"op_type"];
    }
    else
    {
        [paramDic setValue:_userInfo.member_id forKey:@"member_id"];
        [paramDic setValue:[NSString stringWithFormat:@"%@%@", _chepaiField.text, [_numberField.text uppercaseString]]
                    forKey:@"car_no"];
        [paramDic setValue:[NSNumber numberWithInteger:_carTypeSegment.selectedSegmentIndex == 0?1:2]
                    forKey:@"car_type"];
        [paramDic setValue:_car_brand
                    forKey:@"car_brand"];
        [paramDic setValue:_brand_id
                    forKey:@"brand_id"];
        [paramDic setValue:_car_kuanshi
                    forKey:@"car_kuanshi"];
        [paramDic setValue:_car_xilie
                    forKey:@"car_xilie"];
        [paramDic setValue:_series_id
                    forKey:@"series_id"];
        
        [paramDic setValue:@"insert"
                    forKey:@"op_type"];
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebService requestJsonOperationWithParam:paramDic
                                       action:@"car/service/manage"
                               normalResponse:^(NSString *status, id data)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [Constants showMessage:@"恭喜您，操作成功！"];
         if (_carInfo)
         {
             if ([self.delegate respondsToSelector:@selector(didFinishEditCar:)])
             {
                 [self.delegate didFinishEditCar:_carInfo];
             }
         }
         else
         {
             if ([self.delegate respondsToSelector:@selector(didFinishAddNewCar)])
             {
                 [self.delegate didFinishAddNewCar];
             }
         }

         [self.navigationController popViewControllerAnimated:YES];
     }
                            exceptionResponse:^(NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self.view makeToast:[error.userInfo valueForKey:@"msg"]];
     }];
}

- (BOOL)validateCarNo:(NSString*)carNo
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _chepaiField)
    {
        if (!_licensePlateSelecter)
        {
            _licensePlateSelecter = [[LicensePlateSelecter alloc] initWithFrame:[UIScreen mainScreen].bounds];
            _licensePlateSelecter.delegate = self;
        }
        [_licensePlateSelecter showLincensePlateSelecter];
        return NO;
    }
    if (textField == _pinpaiField)
    {
        CarBrandSelectViewController *viewController = [[CarBrandSelectViewController alloc] initWithNibName:@"CarBrandSelectViewController" bundle:nil];
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController  animated:YES];
        return NO;
    }
    return YES;
}

- (void)didFinishLicensePlateSelect:(NSString *)resultString
{
    _chepaiField.text = resultString;
}

- (void)didFinishCarBrandSelect:(NSString *)resultString andBrandId:(NSString *)brandIdString andKuanshi:(NSString *)kuanshiString andXilie:(NSString *)xilieString andSeriesId:(NSString *)seriesIdString
{
    NSString *result = [NSString stringWithFormat:@"%@ %@\n",resultString,kuanshiString];

    _pinpaiField.text = result;
    
    if (_carInfo)
    {
        self.carInfo.car_brand = resultString;
        self.carInfo.brand_id = brandIdString;
        self.carInfo.car_kuanshi = xilieString;
        self.carInfo.car_xilie = kuanshiString;
        self.carInfo.series_id = seriesIdString;
    }
    else
    {
        _car_brand = resultString;
        _brand_id = brandIdString;
        _car_kuanshi = xilieString;
        _car_xilie = kuanshiString;
        _series_id = seriesIdString;
    }
}

- (IBAction)didNumberFieldChanged:(UITextField *)sender
{
    if (sender.text != nil && ![sender.text isEqualToString:@""])
    {
        sender.text = [sender.text uppercaseString];
    }
}


- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    if ([textField.text length] >= 5 && textField == _numberField)
    {
        if ([string isEqualToString:@""])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



@end
