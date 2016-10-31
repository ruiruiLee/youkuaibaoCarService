//
//  AddWashYardViewController.m
//  优快保
//
//  Created by Darsky on 15/2/12.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "AddWashYardViewController.h"
#import "MBProgressHUD+Add.h"
#import "UIView+Toast.h"
#import "WebServiceHelper.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import "CityModel.h"
#import "CitySelecterViewController.h"
#import "WashYardImageViewController.h"

@interface AddWashYardViewController () <UIGestureRecognizerDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UITextFieldDelegate,AMapSearchDelegate,CitySelecterDelegate,WashYardImageDelegate>
{
    UIScrollView            *_scrollView;
    
    IBOutlet UIView         *_contentView;
    
    IBOutlet UIButton       *_washYardImagebtn;
    
    IBOutlet UITextField    *_yardCityField;
    
    IBOutlet UITextField    *_yardNameField;
    
    IBOutlet UITextField    *_yardShortNameField;
    
    IBOutlet UITextField    *_yardPhoneField;
    
    IBOutlet UITextField    *_yardMessagePhoneField;
    
    IBOutlet UITextField    *_yardAddrField;
    
    IBOutlet UITextField    *_carOrginalPriceField;
    
    IBOutlet UITextField    *_suvOrginalPriceField;
    
    IBOutlet UITextField    *_carVipPriceField;
    
    IBOutlet UITextField    *_suvVipPriceField;
    
    IBOutlet UITextField    *_carOrderPriceField;
    
    IBOutlet UITextField    *_suvOrderPriceField;
    
    IBOutlet UITextField    *_carAgreementPriceField;
    
    IBOutlet UITextField    *_suvAgreementPriceField;
    
    double                   _washYardLongitude;
    
    double                   _washYardLatitude;
    
    NSString                *_logoPath;
    
    NSString                *_logoUrl;
    
    NSString                *_cityID;
    
    AMapSearchAPI               *_search;
    IBOutlet UILabel        *_uploadImageCountLabel;
}

@property (strong, nonatomic) NSMutableArray *uploadImageArray;

@end

@implementation AddWashYardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"提交洗车场"];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(didSubmitItemTouch)];
    [rightItem setTintColor:kNormalTintColor];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(closeKeyBoard)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    _scrollView = [[UIScrollView alloc] init];
    [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_scrollView];
    
    [_scrollView addSubview:_contentView];
    
    [_scrollView makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges.equalTo(self.view);
         make.bottom.equalTo(_contentView.bottom);
     }];
    
    [_contentView makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges.equalTo(_scrollView);
         make.width.equalTo(self.view);
         make.bottom.equalTo(_carWashAgreementView.bottom).offset(280);
     }];
    
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

- (void)closeKeyBoard
{
    _scrollView.transform = CGAffineTransformIdentity;
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

#pragma mark - UITextFieldDelegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _yardCityField)
    {
        CitySelecterViewController *viewController = [[CitySelecterViewController alloc] initWithNibName:@"CitySelecterViewController" bundle:nil];
        viewController.delegate = self;
        viewController.isForCommit = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text length] >= 11 && textField == _yardPhoneField)
    {
        if ([string isEqualToString:@""])
        {
            return YES;
        }
        return NO;
    }
    if ([textField.text length] >= 11 && textField == _yardMessagePhoneField)
    {
        if ([string isEqualToString:@""])
        {
            return YES;
        }
        return NO;
    }
    return YES;
}

- (void)didSubmitItemTouch
{
    [self closeKeyBoard];
    [self judgeSubmitRequst:^
     {
         if (self.uploadImageArray.count > 0)
         {
             [self startSubmitWashYardImages];
         }
         else
         {
             _logoUrl = nil;
             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             [self startSubmitWashYardInfo];
         }
     }
                      error:^(NSString *error)
     {
         [Constants showMessage:error];
     }];
}

//提交车场信息

- (void)startSubmitWashYardImages
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.view.userInteractionEnabled = NO;
    NSString *imageKey = @"testImage.jpg";
    [WebService uploadImageWithParam:@{}
                              action:@"upload/service/photo"
                          imageDatas:self.uploadImageArray
                            imageKey:imageKey
                      normalResponse:^(NSString *status, id data)
     {
         if (status.intValue > 0)
         {
             NSLog(@"%@",data);
             NSString *photoAddrs = [data objectForKey:@"photoAddrs"];
             if ([photoAddrs isEqualToString:@""] || photoAddrs == nil)
             {
                 _logoUrl = nil;
             }
             else
             {
                 _logoUrl = [NSMutableString stringWithString:[photoAddrs stringByReplacingOccurrencesOfString:@"!" withString:@","]];
             }
         }
         else
         {
             _logoUrl = nil;
         }
         
         [self startSubmitWashYardInfo];
     }
                   exceptionResponse:^(NSError *error) {
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                       [MBProgressHUD showError:@"发送失败" toView:self.view];
                       self.view.userInteractionEnabled = YES;
                   }];

}
- (void)startSubmitWashYardInfo
{
    /*
     地址：http://118.123.249.87/service/car_wash_submit.aspx
     
     参数:
     op_type:操作(“insert”、“update”)
     “update”时需要参数car_wash_id：车场编号,”insert”时不需要
     Name:车场名称
     Logo:车场logo图片,如果不传图片的话，该参数请传入””(空)
     Address:车场地址
     Phone:车场电话
     Longitude:经度　如”10.1”
     Latitude:纬度   如”10.1”
     car_original_price: 轿车原始价
     car_member_price: 轿车下单价
     car_agreement_price: 轿车协议价
     suv_original_price: suv原始价
     suv_member_price: suv下单价
     suv_agreement_price: suv协议价
     op_id:操作员id(操作员登录时的admin_id)
     */
    
    
    
    
    NSDictionary *submitDic = @{@"op_type": @"insert",
                                @"phone": _yardPhoneField.text,
                                @"admin_phone":_yardMessagePhoneField.text,
                                @"name": _yardNameField.text,
                                @"short_name":_yardShortNameField.text,
                                @"logo": _logoUrl ? _logoUrl : @"",
                                @"address": _yardAddrField.text,
                                @"longitude": [NSNumber numberWithDouble:_washYardLongitude],
                                @"latitude": [NSNumber numberWithDouble:_washYardLatitude],
                                @"car_original_price": _carOrginalPriceField.text,
                                @"car_vip_price":_carVipPriceField.text,
                                @"car_member_price": _carOrderPriceField.text,
                                @"car_agreement_price": _carAgreementPriceField.text,
                                @"suv_original_price": _suvOrginalPriceField.text,
                                @"suv_vip_price":_suvVipPriceField.text,
                                @"suv_member_price": _suvOrderPriceField.text,
                                @"suv_agreement_price": _suvAgreementPriceField.text,
                                @"op_id": _userInfo.member_id,
                                @"crm_user":_userInfo.crm_user,
                                @"city_id":_cityID};
    
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"carWash/service/manage"
                               normalResponse:^(NSString *status, id data)
     {
         [MBProgressHUD hideHUDForView:self.view animated:NO];
         [MBProgressHUD showSuccess:@"提交成功！" toView:self.navigationController.view];
         [self.navigationController popViewControllerAnimated:YES];
     }
                            exceptionResponse:^(NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [Constants showMessage:@"提交车场失败"];
     }];
}

- (void)judgeSubmitRequst:(void(^)(void))success
                    error:(void(^)(NSString *error))submitError
{
    if ([_yardNameField.text isEqualToString:@""] || _yardNameField.text == nil)
    {
        submitError(@"请输入洗车场名称");
        return;
    }
    if ([_yardShortNameField.text isEqualToString:@""] || _yardShortNameField.text == nil)
    {
        submitError(@"请输入洗车场简称");
        return;
    }
    if (_yardShortNameField.text.length > 8)
    {
        submitError(@"洗车场简称小于等于8个字");
        return;
    }
    if ([_yardPhoneField.text isEqualToString:@""] || _yardPhoneField.text == nil)
    {
        submitError(@"请输入洗车场电话");
        return;
    }
    if ([_yardMessagePhoneField.text isEqualToString:@""] || _yardMessagePhoneField.text == nil)
    {
        submitError(@"请输入洗车场接收短信手机号码");
        return;
    }
    if (_yardMessagePhoneField.text.length < 11)
    {
        [self.view makeToast:@"请输入正确的手机号"];
        return;
    }
    if ([_yardAddrField.text isEqualToString:@""] || _yardAddrField.text == nil)
    {
        submitError(@"请输入洗车场地址");
        return;
    }
    if ([_carOrginalPriceField.text isEqualToString:@""] || _carOrginalPriceField.text == nil)
    {
        submitError(@"请输入洗车场原始价格（轿车）");
        return;
    }
    else if (![self isPureInt:_carOrginalPriceField.text])
    {
        submitError(@"洗车场原始价格（轿车）输入的价格必须为整数");
        return;
    }
    if ([_suvOrginalPriceField.text isEqualToString:@""] || _suvOrginalPriceField.text == nil)
    {
        submitError(@"请输入洗车场原始价格（SUV）");
        return;
    }
    else if (![self isPureInt:_suvOrginalPriceField.text])
    {
        submitError(@"洗车场原始价格（SUV）输入的价格必须为整数");
        return;
    }
    if (_cityID == nil || [_cityID isEqualToString:@""])
    {
        submitError(@"请选择车场所在城市");
        return;
    }
    if ([_carVipPriceField.text isEqualToString:@""] || _carVipPriceField.text == nil)
    {
        submitError(@"请输入洗车场会员价格（轿车）");
        return;
    }
    else if (![self isPureInt:_carVipPriceField.text])
    {
        submitError(@"洗车场会员价格（轿车）输入的价格必须为整数");
        return;
    }
    
    if ([_suvVipPriceField.text isEqualToString:@""] || _suvVipPriceField.text == nil)
    {
        submitError(@"请输入洗车场会员价格（SUV）");
        return;
    }
    else if (![self isPureInt:_suvVipPriceField.text])
    {
        submitError(@"洗车场会员价格（SUV）输入的价格必须为整数");
        return;
    }
    
    if ([_carOrderPriceField.text isEqualToString:@""] || _carOrderPriceField.text == nil)
    {
        submitError(@"请输入洗车场下单价格（轿车）");
        return;
    }
    else if (![self isPureInt:_carOrderPriceField.text])
    {
        submitError(@"洗车场下单价格（轿车）输入的价格必须为整数");
        return;
    }
    
    if ([_suvOrderPriceField.text isEqualToString:@""] || _suvOrderPriceField.text == nil)
    {
        submitError(@"请输入洗车场原始价格（SUV）");
        return;
    }
    else if (![self isPureInt:_suvOrderPriceField.text])
    {
        submitError(@"洗车场原始价格（SUV）输入的价格必须为整数");
        return;
    }
    
    if ([_carAgreementPriceField.text isEqualToString:@""] || _carAgreementPriceField.text == nil)
    {
        submitError(@"请输入洗车场协议价格（轿车）");
        return;
    }
    else if (![self isPureInt:_carAgreementPriceField.text])
    {
        submitError(@"洗车场协议价格（轿车）输入的价格必须为整数");
        return;
    }
    
    if ([_suvAgreementPriceField.text isEqualToString:@""] || _suvAgreementPriceField.text == nil)
    {
        submitError(@"请输入洗车场协议价格（SUV）");
        return;
    }
    else if (![self isPureInt:_suvAgreementPriceField.text])
    {
        submitError(@"洗车场协议价格（SUV）输入的价格必须为整数");
        return;
    }
    else
    {
        NSDictionary *loctionDic = [[NSUserDefaults standardUserDefaults] valueForKey:kLocationKey];
        if (!loctionDic)
        {
            submitError(@"获取不到车场位置");
            return;
        }
        else
        {
            NSString *longitudeString = [loctionDic valueForKey:@"longitude"];
            NSString *latitudeString = [loctionDic valueForKey:@"latitude"];

            _washYardLongitude = longitudeString.doubleValue;
            _washYardLatitude  =  latitudeString.doubleValue;

            success();
            return;
        }

    }
}

#pragma mark - 车场位置查询

- (IBAction)didGetYardButtonTouch:(id)sender
{
    if ([CLLocationManager locationServicesEnabled] == YES)
    {
        [self startGetYardPosttion];
        [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    }
    else
    {
        [Constants showMessage:@"无法使用定位服务，请打开您的定位功能或手动输入地址"];
    }
}

- (void)startGetYardPosttion
{
    NSDictionary *loctionDic = [[NSUserDefaults standardUserDefaults] valueForKey:kLocationKey];
    if (!loctionDic)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [Constants showMessage:@"获取不到车场位置"];
        return;
    }
    else
    {
        NSString *longitudeString = [loctionDic valueForKey:@"longitude"];
        NSString *latitudeString = [loctionDic valueForKey:@"latitude"];

        
        AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
        regeoRequest.location = [AMapGeoPoint locationWithLatitude:latitudeString.doubleValue longitude:longitudeString.doubleValue];
        regeoRequest.radius = 10000;
        regeoRequest.requireExtension = YES;
        
        
        //发起逆地理编码
        [_search AMapReGoecodeSearch: regeoRequest];
        return;
    }
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        _yardAddrField.text = response.regeocode.formattedAddress;
    }
    else
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [Constants showMessage:@"获取不到车场位置"];
    }
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    [manager stopUpdatingLocation];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    CLLocation *location = locations[0];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error)
    {
                       
                       for (CLPlacemark *place in placemarks)
                       {
                           NSLog(@"name,%@",place.name);                       // 位置名
                           NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
                           NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
                           NSLog(@"locality,%@",place.locality);               // 市
                           NSLog(@"subLocality,%@",place.subLocality);         // 区
                           NSLog(@"country,%@",place.country);                 // 国家
                           _yardAddrField.text = [NSString stringWithFormat:@"%@%@%@",
                                                  place.subLocality,
                                                  place.thoroughfare,
                                                  place.subThoroughfare ?place.subThoroughfare : @""];
                       }
                       
                   }];
}

#pragma mark - 车场照片
- (IBAction)didTapOnYardImage:(id)sender
{
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片来源"
//                                                             delegate:self
//                                                    cancelButtonTitle:@"取消"
//                                               destructiveButtonTitle:nil
//                                                    otherButtonTitles:@"相册",@"相机", nil];
//    [actionSheet showInView:self.view];
    
    WashYardImageViewController *viewController = [[WashYardImageViewController alloc] initWithNibName:@"WashYardImageViewController"
                                                                                                bundle:nil];
    viewController.delegate = self;
    if (self.uploadImageArray.count > 0)
    {
        viewController.uploadImageArray = self.uploadImageArray;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didFinishWasyYardImageSelect:(NSArray *)imageArray
{
    self.uploadImageArray = [imageArray mutableCopy];
    if (self.uploadImageArray.count > 0)
    {
        [_washYardImagebtn setImage:[UIImage imageWithData:self.uploadImageArray[0]]
                           forState:UIControlStateNormal];
    }
    else
    {
        [_washYardImagebtn setImage:nil
                           forState:UIControlStateNormal];
    }
    
    [_uploadImageCountLabel setText:[NSString stringWithFormat:@"共 %d 张", (int)self.uploadImageArray.count]];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        if (buttonIndex == 0)
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
        else
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;
            picker.allowsEditing = NO;//设置可编辑
            picker.videoQuality = UIImagePickerControllerQualityType640x480;
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:^
             {
                 
             }];//进入照相界面
        }
    }
}

#pragma mark - CitySelectDelegate Method

- (void)didFinishCitySelectForCommiting:(OpenCityModel *)result
{
    _yardCityField.text = result.city_name;
    _cityID = result.city_id;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@",info);
    [picker dismissViewControllerAnimated:YES
                               completion:^
     {
         if ([[info valueForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"])
         {
             NSString *filename = [self createUpFileName];
             UIImage *tmpImage = [info objectForKey:UIImagePickerControllerOriginalImage];
             
             NSString *documentsDirectory =  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
             
             NSString *imageName = [NSString stringWithFormat:@"%@.jpg",filename];
             NSString *filepath = [documentsDirectory stringByAppendingPathComponent:imageName];
             [_washYardImagebtn setBackgroundImage:tmpImage forState:UIControlStateNormal];
             if([UIImageJPEGRepresentation(tmpImage, 0.3) writeToFile:filepath
                                                           atomically:YES])
             {
                 _logoPath = filepath;
                 [self uploadImage];
             }
         }
         
     }];
}

-  (NSString*)createUpFileName
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags  = NSYearCalendarUnit|
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    kCFCalendarUnitSecond;
    
    NSDateComponents* dayComponents = [calendar components:(unitFlags) fromDate:date];
    NSUInteger year = [dayComponents year];
    NSUInteger month =  [dayComponents month];
    NSUInteger day =  [dayComponents day];
    NSInteger hour =  [dayComponents hour];
    NSInteger minute =  [dayComponents minute];
    double second = [dayComponents second];
    
    NSString *strMonth;
    NSString *strDay;
    NSString *strHour;
    NSString *strMinute;
    NSString *strSecond;
    if (month < 10) {
        strMonth = [NSString stringWithFormat:@"0%lu",(unsigned long)month];
    }
    else {
        strMonth = [NSString stringWithFormat:@"%lu",(unsigned long)month];
    }
    //NSLog(@"%@",strMonth.description);
    if (day < 10) {
        strDay = [NSString stringWithFormat:@"0%lu",(unsigned long)day];
    }
    else {
        strDay = [NSString stringWithFormat:@"%lu",(unsigned long)day];
    }
    
    if (hour < 10) {
        strHour = [NSString stringWithFormat:@"0%ld",(long)hour];
    }
    else {
        strHour = [NSString stringWithFormat:@"%ld",(long)hour];
    }
    
    if (minute < 10) {
        strMinute = [NSString stringWithFormat:@"0%ld",(long)minute];
    }
    else {
        strMinute = [NSString stringWithFormat:@"%ld",(long)minute];
    }
    
    if (second < 10) {
        strSecond = [NSString stringWithFormat:@"0%0.f",second];
    }
    else {
        strSecond = [NSString stringWithFormat:@"%0.f",second];
    }
    
    
    NSString *str = [NSString stringWithFormat:@"%ld%@%@%@%@%@%@",
                     (unsigned long)year,strMonth,strDay,strHour,strMinute,strSecond,[self myUUID]];
    
    NSLog(@"%@",[self myUUID]);
    
    return str;
}

- (NSString*) myUUID
{
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    NSString *guid = (__bridge NSString *)newUniqueIDString;
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    return([guid lowercaseString]);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (UIImage*)resizeImage:(UIImage*)image withSize:(CGSize)size
{
    CGSize newSize = CGSizeMake(size.width, size.height);
    CGFloat widthRatio = newSize.width/image.size.width;
    CGFloat heightRatio = newSize.height/image.size.height;
    
    if(widthRatio > heightRatio)
    {
        newSize=CGSizeMake(image.size.width*heightRatio,image.size.height*heightRatio);
    }
    else
    {
        newSize=CGSizeMake(image.size.width*widthRatio,image.size.height*widthRatio);
    }
    
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 键盘即将退出

- (void)keyBoardWillHide:(NSNotification *)note
{
    [_scrollView setContentSize:CGSizeMake(0, 525)];
}


#pragma mark - 键盘即将打开

- (void)keyBoardWillShow:(NSNotification *)note
{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [_scrollView setContentSize:CGSizeMake(0, 525 + rect.size.height)];
}

#pragma mark - 上传图片

- (void)uploadImage
{
    NSString *imageKey = [_logoPath lastPathComponent];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebService uploadImageWithParam:@{}
                              action:@"upload/service/photo"
                           imagePath:_logoPath
                            imageKey:imageKey
                      normalResponse:^(NSString *status, id data)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         _logoUrl = [data valueForKey:@"photoAddrs"];
         [self.view makeToast:@"上传图片成功"];
     }
                   exceptionResponse:^(NSError *error)
     {
         [self.view makeToast:@"上传图片失败"];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString *regex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(17[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:mobileNum];
    if(isMatch)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

@end
