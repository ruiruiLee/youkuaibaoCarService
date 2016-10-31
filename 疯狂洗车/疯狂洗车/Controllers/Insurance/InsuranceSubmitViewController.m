//
//  InsuranceSubmitViewController.m
//  优快保
//
//  Created by cts on 15/7/7.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "InsuranceSubmitViewController.h"
#import "MBProgressHUD+Add.h"
#import "WebServiceHelper.h"
#import "InsuranceListViewController.h"
#import "UIImageView+WebCache.h"
#import "InsuranceCitySelecterViewController.h"
#import "InsuranceDetailsViewController.h"
#import "CustomActionSheet.h"
#import "InsuranceSelectViewController.h"
#import "UIView+Toast.h"
#import "DBManager.h"
#import "ADVModel.h"
#import "ActivitysController.h"


@interface InsuranceSubmitViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,InsuranceCitySelecterDelegate,CustomActionSheetDelegate>
{
    NSInteger   _targetCertificate;
    
    NSString   *_uploadImageAddrs;
    
    NSString   *_uploadImageOldAddrs;
    
    BOOL        _carCardChanged;
    
    UIImage    *_uploadFrontImage;
    
    IBOutlet UIView *_contentInfoView;
    
    IBOutlet UIView *_driveCardView;
    
    UIButton *_rightButton;
}

@end

@implementation InsuranceSubmitViewController

#pragma mark - 根据设备显示加载不同的xib Method

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName = nil;

    if (SCREEN_WIDTH < 414)
    {
        if (SCREEN_WIDTH < 375)
        {
            nibName= [NSString stringWithFormat:@"%@_4",nibNameOrNil];

        }
        else
        {
            nibName = nibNameOrNil;
        }
    }
    else
    {
        nibName= [NSString stringWithFormat:@"%@_6p",nibNameOrNil];
    }
    self = [super initWithNibName:nibName
                           bundle:nibBundleOrNil];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"车险试算"];
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 16)];
    
    [_rightButton setImage:[UIImage imageNamed:@"btn_insurance_intro_call"]
                  forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(didRightButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0)
    {
        _scrollView.bounces = NO;
    }
    
    CGRect topRect = CGRectMake(0, 0, SCREEN_WIDTH - 20, 80);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:topRect
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = topRect;
    maskLayer.path = maskPath.CGPath;
    _contentInfoView.layer.mask = maskLayer;
//
//    
    CGRect bottomRect = CGRectMake(0, 0, SCREEN_WIDTH - 20, (SCREEN_WIDTH-20)*7/15);
    UIBezierPath *bottomMaskPath = [UIBezierPath bezierPathWithRoundedRect:bottomRect
                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *bottomMaskLayer = [[CAShapeLayer alloc] init];
    bottomMaskLayer.frame = bottomRect;
    bottomMaskLayer.path = bottomMaskPath.CGPath;
    _driveCardView.layer.mask = bottomMaskLayer;

    
    if (_insuranceHomeModel)//当存在新的保险活动数据时显示最新车险活动图片
    {
        [_insuranceImageNewView sd_setImageWithURL:[NSURL URLWithString:_insuranceHomeModel.insurance_new_img]
                                  placeholderImage:[UIImage imageNamed:@"img_insurance_submit_default"]];
    }
    
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 3;
    
    _frontImageView.layer.masksToBounds = YES;
    _frontImageView.layer.cornerRadius = 5;
    _frontImageView.layer.borderWidth = 1;
    _frontImageView.layer.borderColor = [UIColor colorWithRed:235/255.0
                                                        green:235/255.0
                                                         blue:235/255.0
                                                        alpha:1].CGColor;
    
    if (self.isEdit && self.insuranceGroupModel)
    {
        _idNumberField.text = self.insuranceGroupModel.cid == nil?@"":self.insuranceGroupModel.cid;
        _cityID = self.insuranceGroupModel.city_id;
        _cityField.text = self.insuranceGroupModel.city_name;
        
        [_frontImageView sd_setImageWithURL:[NSURL URLWithString:self.insuranceGroupModel.photo_addr]
                           placeholderImage:[UIImage imageNamed:@"img_imageDowloading"]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             if (error == nil)
             {
                 
             }
             else
             {
                 [_frontImageView setImage:[UIImage imageNamed:@"img_imageDowloading_error"]];
             }
         }];
        _frontButton.selected = YES;
    }
    else
    {
        NSDictionary *resultDic = nil;
        resultDic  = [DBManager queryCityByCityName:@"成都"];
        if (resultDic)
        {
            CityModel *userCity = [[CityModel alloc] initWithDictionary:resultDic];
            _cityID = userCity.CITY_ID;
            _cityField.text = userCity.CITY_NAME;
        }             
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(closeKeyBoard)];
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess:)
                                                 name:kLoginSuccessNotifaction
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self closeKeyBoard];
}


#pragma mark - 选择行驶证
#pragma mark

- (IBAction)didCarCertificateButtonTouch:(UIButton *)sender
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
    _targetCertificate = sender.tag;
    
    [self closeKeyBoard];
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                             delegate:self
//                                                    cancelButtonTitle:@"取消"
//                                               destructiveButtonTitle:nil
//                                                    otherButtonTitles:@"拍照",@"选取照片", nil];
//    [actionSheet showFromRect:CGRectMake(0, SCREEN_HEIGHT-600, SCREEN_WIDTH, 600) inView:self.view animated:YES];
    
    UIImage *simpleImage = [UIImage imageNamed:@"img_carCard_sample"];
    
    CustomActionSheetItem *customSheetItem1 = [[CustomActionSheetItem alloc] initWithType:CustomActionSheetItemTypeImage
                                                                             andSubobject:simpleImage];
    
    CustomActionSheetItem *customSheetItem2 = [[CustomActionSheetItem alloc] initWithType:CustomActionSheetItemTypeTitle
                                                                             andSubobject:@"请选择输入方式"];
    CustomActionSheetItem *customSheetItem3 = [[CustomActionSheetItem alloc] initWithType:CustomActionSheetItemTypeButton
                                                                             andSubobject:@"拍摄“行驶证”照片"];
    CustomActionSheetItem *customSheetItem4 = [[CustomActionSheetItem alloc] initWithType:CustomActionSheetItemTypeButton
                                                                             andSubobject:@"选取“行驶证”照片"];
    
    [CustomActionSheet showCustomActionSheetWithDelegate:self
                                               withItems:@[customSheetItem1,customSheetItem2,customSheetItem3,customSheetItem4]
                                    andCancelButtonTitle:@"取消"];
}


- (void)customActionWillDismissWithButtonIndex:(NSInteger)buttonIndex andActionSheetTag:(NSInteger)tagValue
{
    if (buttonIndex == 2)
    {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = NO;//设置可编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^
         {
             
         }];//进入照相界面
    }
    else if (buttonIndex == 3)
    {
        
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = NO;
        [self presentViewController:pickerImage
                           animated:YES
                         completion:^
         {
         }];
    }

}


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *uploadImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (_targetCertificate == 0)
    {
        if (self.isEdit)
        {
            _carCardChanged = YES;
        }
        
        _uploadFrontImage = uploadImage;
        [_frontImageView setImage:_uploadFrontImage];
        
    }
    else
    {
              
    }
    
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   
                               }];
}

#pragma mark - UITextFieldDelegate
#pragma mark

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!_userInfo.member_id)
    {
        
        id viewController = [QuickLoginViewController sharedLoginByCheckCodeViewControllerWithProtocolEnable:nil];
        
        [self presentViewController:viewController animated:YES completion:^
         {
             [[[UIApplication sharedApplication] keyWindow] makeToast:@"请先登录"];
         }];
        return NO;
    }
    if (textField == _cityField)
    {
        InsuranceCitySelecterViewController *viewController = [[InsuranceCitySelecterViewController alloc] initWithNibName:@"InsuranceCitySelecterViewController" bundle:nil];
        viewController.delegate = self;
        viewController.isForCommit = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        return NO;
    }
    else if (textField == _idNumberField && SCREEN_HEIGHT < 736)
    {
        [_scrollView setContentOffset:CGPointMake(0, _textInfoView.frame.origin.y) animated:YES];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _idNumberField && SCREEN_HEIGHT < 736)
    {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}


- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    if ([textField.text length] >= 18 && textField == _idNumberField)
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
#pragma mark - InsuranceCitySelectDelegate Method

- (void)didFinishCitySelectForCommiting:(OpenCityModel *)result
{
    _cityField.text = result.city_name;
    _cityID = result.city_id;
}

#pragma mark - 提交资料
#pragma mark

- (IBAction)didSubmitButtonTouch:(id)sender
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
    [self checkSubmitInfo:^
     {
         [self startSubmitAllInfo];
         
     }
                withError:^(NSString *errorString)
     {
         [Constants showMessage:errorString];
     }];
}

#pragma mark - UIAlertViewDelegateMethod
#pragma mark

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 530 && buttonIndex == 1)
    {
        [self callCustomService];
    }
    if (alertView.tag == 511)
    {
        if (buttonIndex == 1)
        {
            [self startSubmitAllInfo];
        }
        else
        {
            [_idNumberField becomeFirstResponder];
        }
    }
}
- (IBAction)didIntroductionButtonTouch:(id)sender
{
    if (!_insuranceHomeModel.intro_url)
    {
        [Constants showMessage:@"数据错误，无法加载"];
    }
    else
    {
        ADVModel *headerModel = [[ADVModel alloc] init];
        headerModel.url = _insuranceHomeModel.intro_url;
        ActivitysController *viewController = [[ActivitysController alloc] initWithNibName:@"ActivitysController" bundle:nil];
        viewController.advModel = headerModel;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    

}

- (void)callCustomService
{
    NSString *phoneString = [NSString stringWithFormat:@"tel:%@",_insuranceHomeModel.service_phone];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
}

- (void)startSubmitAllInfo
{
    if (self.isEdit)
    {
        if (_carCardChanged)
        {
            [self startSubmitCarCarFrontImageSuccessRespone:^{
                [self startInsuranceInfoSubmit];

            }
                                               errorRespone:^{
                                                   
                                               }];
        }
        else
        {
            _uploadImageAddrs = nil;
            [self startInsuranceInfoSubmit];
        }
    }
    else
    {
        [self startSubmitCarCarFrontImageSuccessRespone:^{
            [self startInsuranceInfoSubmit];
        }
                                           errorRespone:^{
                                               
                                           }];
    }
}

- (void)checkSubmitInfo:(void(^)(void))noError
              withError:(void(^)(NSString *errorString))haveError;
{
    if ([_cityField.text isEqualToString:@""] || _cityField.text == nil)
    {
        haveError(@"请选择投保城市");
        return;
    }
    
    if ([_idNumberField.text isEqualToString:@""] || _idNumberField.text == nil)
    {
        haveError(@"为获得更准确的报价，请您完善身份证号码，谢谢！");
        return;
    }
    else if (![self validateIdentityCard:_idNumberField.text])
    {
        haveError(@"请输入正确的身份证号");
        return;
    }
    if (_uploadFrontImage == nil && !self.isEdit)
    {
        haveError(@"请选择要上传的行驶证正本照片");
        return;
    }
    else
    {
        noError();
        return;
    }
}

- (void)startSubmitCarCarFrontImageSuccessRespone:(void(^)(void))successRespone
                                     errorRespone:(void(^)(void))errorRespone
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.view.userInteractionEnabled = NO;
    NSString *imageKey = @"testImage.jpg";
    [WebService uploadImageWithParam:@{}
                              action:@"upload/service/insurphoto"
                           imageData:UIImageJPEGRepresentation(_uploadFrontImage, 0.5)
                            imageKey:imageKey
                      normalResponse:^(NSString *status, id data)
     {
         if (status.intValue > 0)
         {
             if (self.isEdit)
             {
                 _uploadImageOldAddrs = [NSString stringWithFormat:@"%@",self.insuranceGroupModel.photo_addr];
             }
             _uploadImageAddrs = [data objectForKey:@"photoAddrs"];
             successRespone();
             return ;
         }
         
     }
                   exceptionResponse:^(NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [Constants showMessage:[error domain]];
         self.view.userInteractionEnabled = YES;
         errorRespone();
         return ;
     }];
}

- (void)startInsuranceInfoSubmit
{
    
    NSDictionary *submitDic = nil;
    if (self.isEdit)
    {
        NSMutableString *del_addr = [NSMutableString string];
        
        if ([_uploadImageOldAddrs isEqualToString:@""] || _uploadImageOldAddrs == nil)
        {
            
        }
        else
        {
            [del_addr appendFormat:@"%@,",_uploadImageOldAddrs];
        }

        
        submitDic = @{@"member_id":_userInfo.member_id,
                      @"phone":_userInfo.member_phone,
                      @"cid":_idNumberField.text == nil?@"":_idNumberField.text,
                      @"photo_addr":_uploadImageAddrs == nil?@"":_uploadImageAddrs,
                      @"photo_addr2":@"",
                      @"app_type":@2,
                      @"city_id":_cityID,
                      @"del_addr":del_addr,
                      @"insurance_id":self.insuranceGroupModel.insurance_id};
        
    }
    else
    {
        submitDic = @{@"member_id":_userInfo.member_id,
                      @"phone":_userInfo.member_phone,
                      @"cid":_idNumberField.text == nil?@"":_idNumberField.text,
                      @"photo_addr":_uploadImageAddrs,
                      @"photo_addr2":@"",
                      @"city_id":_cityID,
                      @"app_type":@2};
        
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.view.userInteractionEnabled = NO;
    
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"insurance/service/manage"
                               normalResponse:^(NSString *status, id data)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         self.view.userInteractionEnabled = YES;
         
         if (self.isEdit)
         {
             if (self.isCustomdSubmited)
             {
                 [Constants showMessage:@"\n资料提交成功，正在计算保费，请稍等...\n\n稍后我们将会以短信通知您计算结果"];
                 [self returnToInsuranceList];
             }
             else
             {
                 [Constants showMessage:@"\n请选择投保方案"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:kShouldUpdateInsurance object:nil];
                 InsuranceSelectViewController *viewController = [[InsuranceSelectViewController alloc] initWithNibName:@"InsuranceSelectViewController"
                                                                                                                 bundle:nil];
                 viewController.insuranceIDForCustom = self.insuranceGroupModel.insurance_id;
                 viewController.isForSubmit = YES;
                 [self.navigationController pushViewController:viewController
                                                      animated:YES];
             }
         }
         else
         {
             if (_insuranceHomeModel.is_used.intValue < 1)
             {
                 [InsuranceHelper requestInsuranceHomeModelNormalResponse:^{
                     
                 } exceptionResponse:^{
                     
                 }];
             }
//             [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotifaction
//                                                                 object:nil];
             if ([data objectForKey:@"insurance_id"])
             {
                 [Constants showMessage:@"\n请选择投保方案"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:kShouldUpdateInsurance object:nil];
                 InsuranceSelectViewController *viewController = [[InsuranceSelectViewController alloc] initWithNibName:@"InsuranceSelectViewController"
                                                                                                                 bundle:nil];
                 viewController.insuranceIDForCustom = [data objectForKey:@"insurance_id"];
                 viewController.isForSubmit = YES;
                 [self.navigationController pushViewController:viewController
                                                      animated:YES];
             }
             else
             {
                 [Constants showMessage:@"\n资料提交成功，正在计算保费，请稍等...\n\n稍后我们将会以短信通知您计算结果"];
                 [self returnToInsuranceList];
             }
         }
         
         
         
         
     }
                            exceptionResponse:^(NSError *error) {
                                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                [Constants showMessage:[error domain]];
                                self.view.userInteractionEnabled = YES;
                            }];
}

- (void)returnToInsuranceList
{
    id targetController = nil;
    NSMutableArray  *controllers = [self.navigationController.viewControllers mutableCopy];
    
    for (int x = 0; x<controllers.count; x++)
    {
        id controller = controllers[x];
        if ([controller isKindOfClass:[InsuranceListViewController class]])
        {
            targetController = controller;
        }
    }
    
    if (targetController == nil)
    {
        [controllers removeLastObject];
        InsuranceListViewController *viewController = [[InsuranceListViewController alloc] initWithNibName:@"InsuranceListViewController"
                                                                                                    bundle:nil];        
        [controllers addObject:viewController];
        
        [self.navigationController setViewControllers:controllers animated:YES];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShouldUpdateInsurance object:nil];
        [self.navigationController popToViewController:targetController animated:YES];
    }
}


#pragma mark UIGestureRecognizer Method

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]] ||
        [touch.view isKindOfClass:[UITextField class]])
    {
        return NO;
    }
    return YES;
}


#pragma mark - closeKeyBoard
#pragma mark


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

- (BOOL)validateIdentityCard:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
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

- (void)loginSuccess:(NSNotification *)notification
{
    [InsuranceHelper getDesiredInsuranceControllerResultResponse:^(id targetController)
    {
        if ([targetController isKindOfClass:[InsuranceSubmitViewController class]])
        {
            
        }
        else
        {
            NSMutableArray *controllers = [self.navigationController.viewControllers mutableCopy];
            [controllers removeLastObject];
            [controllers addObject:targetController];
            [self.navigationController setViewControllers:controllers animated:YES];
        }
    }
                                           orUnFinishedInsurance:^(InsuranceGroupModel *insuranceGroupModel) {
                                               self.insuranceGroupModel = insuranceGroupModel;
                                               self.isEdit = YES;
                                               _idNumberField.text = self.insuranceGroupModel.cid == nil?@"":self.insuranceGroupModel.cid;
                                               _cityID = self.insuranceGroupModel.city_id;
                                               _cityField.text = self.insuranceGroupModel.city_name;
                                               
                                               [_frontImageView sd_setImageWithURL:[NSURL URLWithString:self.insuranceGroupModel.photo_addr]
                                                                  placeholderImage:[UIImage imageNamed:@"img_imageDowloading"]
                                                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                                                {
                                                    if (error == nil)
                                                    {
                                                    }
                                                    else
                                                    {
                                                        [_frontImageView setImage:[UIImage imageNamed:@"img_imageDowloading_error"]];
                                                    }
                                                }];
                                               _frontButton.selected = YES;


    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kLoginSuccessNotifaction
                                                  object:nil];
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
