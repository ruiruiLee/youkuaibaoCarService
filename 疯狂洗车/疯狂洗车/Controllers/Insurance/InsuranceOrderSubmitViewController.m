//
//  InsuranceOrderSubmitViewController.m
//  
//
//  Created by cts on 15/9/16.
//
//

#import "InsuranceOrderSubmitViewController.h"
#import "MoreRequestViewController.h"
#import "AddressSelectViewController.h"
#import "LocationImageUploadView.h"
#import "QBImagePickerController.h"
#import "InsurancePresentItemModel.h"
#import "UIImageView+WebCache.h"
#import "UploadImageModel.h"
#import "InsuranceListViewController.h"
#import "InsuranceOrderConfirmView.h"
#import "MyTicketViewController.h"


@interface InsuranceOrderSubmitViewController ()
<MoreRequestDelegate,
AddressSelectDelegate,
LocationImageUploadViewDelegate,
QBImagePickerControllerDelegate,
InsuranceOrderConfirmViewDelegate,
MyTicketDelegate,
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIAlertViewDelegate>
{
    NSString        *_addressString;
    
    NSString        *_moreRequestString;
    
    LocationModel       *_serviceLocation;
    
    BOOL _driveCardUploadEnable;
    
    LocationImageUploadView *_driveCardUploadVew;
    
    BOOL _idCardUploadEnable;
    
    BOOL _ticketEnable;
    
    BOOL _ticketSelected;
    
    LocationImageUploadView *_idCardUploadVew;
    
    NSInteger       _selectedImageUploadIndex;
    
    NSString        *_uploadDriveCardImageSring;
    
    NSString        *_uploadIdCardImageSring;
    
    InsuranceOrderConfirmView *_insuranceOrderConfirmView;


    IBOutlet UIView *_ticketSelectView;
    
    IBOutlet UIImageView *_ticketSelectIcon;
    
    IBOutlet UILabel *_ticketPayTitle;
    
    IBOutlet UILabel *_ticketNameLabel;
    
    IBOutlet UILabel *_ticketNumberTitle;
    
    IBOutlet UILabel *_ticketNumberLabel;
    
    IBOutlet UILabel *_ticketPriceLabel;
    
    IBOutlet UILabel *_ticketTypeLabel;
}

@property (strong, nonatomic) TicketModel *defaultTicketModel;

@property (strong, nonatomic) TicketModel *selectTicketModel;



@end

@implementation InsuranceOrderSubmitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _carCardFrontImageView.layer.masksToBounds = YES;
    _carCardFrontImageView.layer.cornerRadius = 5;
    _carCardFrontImageView.layer.borderWidth = 1;
    _carCardFrontImageView.layer.borderColor = [UIColor colorWithRed:235/255.0
                                                               green:235/255.0
                                                                blue:235/255.0
                                                               alpha:1].CGColor;
    _carCardBackImageView.layer.masksToBounds = YES;
    _carCardBackImageView.layer.cornerRadius = 5;
    _carCardBackImageView.layer.borderWidth = 1;
    _carCardBackImageView.layer.borderColor = [UIColor colorWithRed:235/255.0
                                                              green:235/255.0
                                                               blue:235/255.0
                                                              alpha:1].CGColor;
    
    [self setTitle:@"确认下单"];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(closeKeyBoard)];
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 5;
    
    if (self.payInfoModel == nil)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.view.userInteractionEnabled = NO;
        NSDictionary *submitDic = @{@"member_id":_userInfo.member_id,
                                    @"suggest_id":self.infoModel.suggest_id,
                                    @"insurance_id":self.detailModel.insurance_id,
                                    @"suggest_type":self.suggestType};
        [WebService requestJsonModelWithParam:submitDic
                                       action:@"insurance/service/payinfo"
                                   modelClass:[InsurancePayInfoModel class]
                               normalResponse:^(NSString *status, id data, JsonBaseModel *model)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             self.view.userInteractionEnabled = YES;
             if (status.intValue > 0)
             {
                 self.payInfoModel = (InsurancePayInfoModel*)model;
                 
                 self.defaultTicketModel = [self loadDefaultTicketFromService];
                 if (self.defaultTicketModel)
                 {
                     _ticketEnable = YES;
                     [self didFinishTicketSelect:self.defaultTicketModel];
                     _ticketSelected = YES;
                 }
                 else if (self.payInfoModel.code_count.intValue > 0)
                 {
                     _ticketEnable = YES;
                     _ticketSelected = NO;
                 }
                 [self updateDisplayPayPrice];
             }
             else
             {
                 [Constants showMessage:@"信息获取失败，请稍后再试"];
             }
         }
                            exceptionResponse:^(NSError *error) {
                                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                self.view.userInteractionEnabled = YES;
                                [MBProgressHUD showError:[error domain] toView:self.view];
                            }];
    }
    _phoneField.text = _userInfo.member_phone;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self closeKeyBoard];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self closeKeyBoard];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

#pragma mark - 显示保险价格信息

- (void)updateDisplayPayPrice
{
    _insuranceCompNameLabel.text = self.payInfoModel.insuranceCompName;
    
    
    _jqccPriceLabel.text = self.payInfoModel.jqccPrice;
    
    
    if (self.payInfoModel.giftsArray.count > 0)
    {
        NSMutableString *giftString = [NSMutableString string];
        for (int x = 0; x<self.payInfoModel.giftsArray.count; x++)
        {
            InsurancePresentItemModel *model = self.payInfoModel.giftsArray[x];
            if (x == self.payInfoModel.giftsArray.count-1)
            {
                [giftString appendFormat:@"%@",model.presentContent];
            }
            else
            {
                [giftString appendFormat:@"%@,",model.presentContent];
            }
        }
        
        _giftsLabel.text = giftString;
    }
    else
    {
        _giftsLabel.text = @"暂无内容";
    }
    
    for (int x = 0; x<_giftsView.constraints.count; x++)
    {
        NSLayoutConstraint *layoutConstraint = _giftsView.constraints[x];
        if (layoutConstraint.firstAttribute == NSLayoutAttributeHeight)
        {
            [_giftsView removeConstraint:layoutConstraint];
            break;
        }
    }
    
    [_carCardFrontImageView sd_setImageWithURL:[NSURL URLWithString:self.payInfoModel.carCardFrontUrl]
                              placeholderImage:[UIImage imageNamed:@"img_carCard_downloading"]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        if (error == nil)
        {
            [_carCardFrontImageView setImage:image];
        }
        else
        {
            [_carCardFrontImageView setImage:[UIImage imageNamed:@"img_carCard_failed"]];
        }
    }];
    
    if ([self.payInfoModel.carCardBackUrl isEqualToString:@""] || self.payInfoModel.carCardBackUrl == nil)
    {
        
    }
    else
    {
        [_carCardBackImageView sd_setImageWithURL:[NSURL URLWithString:self.payInfoModel.carCardBackUrl]
                                 placeholderImage:[UIImage imageNamed:@"img_carCard_downloading"]
                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             if (error == nil)
             {
                 [_carCardBackImageView setImage:image];
                 _deleteCarCardBackButton.hidden = NO;
             }
             else
             {
                 [_carCardBackImageView setImage:[UIImage imageNamed:@"img_carCard_failed"]];
                 _deleteCarCardBackButton.hidden = YES;
             }
         }];
    }

    
    CGSize messageSize = CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT);
    CGSize contentSize =[_giftsLabel.text boundingRectWithSize:messageSize
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName:_giftsLabel.font}
                                                             context:nil].size;


    NSDictionary* views = NSDictionaryOfVariableBindings(_giftsView);
    
    NSString *constrainString = nil;
    constrainString = [NSString stringWithFormat:@"V:[_giftsView(%.2f)]",20+contentSize.height];
    
    
    [_giftsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constrainString
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
    
    
    _syPriceLabel.text = self.payInfoModel.scxPrice;
    _jqccsyPriceLabel.text = [NSString stringWithFormat:@"%@ %@",self.payInfoModel.total_price_title,self.payInfoModel.total_price_content];
    _reducePriceLabel.text = [NSString stringWithFormat:@"支付立减： -￥%@",self.payInfoModel.zk_price];
    _payPriceLabel.text = [NSString stringWithFormat:@"实付合计：￥%@",self.payInfoModel.member_price];
    
    _driveCardImgRequestNumber = NSMakeRange(self.payInfoModel.min_jsz_num.intValue, self.payInfoModel.max_jsz_num.intValue);
    _idCardImgRequestNumber = NSMakeRange(self.payInfoModel.min_cid_num.intValue, self.payInfoModel.max_cid_num.intValue);

    float uploadViewHeight = (SCREEN_WIDTH - 60)/3.0;
    if (_driveCardImgRequestNumber.length > 0)
    {
        _driveCardUploadEnable = YES;
        _driveCardUploadVew = [[LocationImageUploadView alloc] initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, uploadViewHeight)
                                                         andUploadImageRange:_driveCardImgRequestNumber];
        _driveCardUploadVew.delegate = self;
        _driveCardUploadVew.tag = 1;
        [_driveCardView addSubview:_driveCardUploadVew];
    }
    
    if (_idCardImgRequestNumber.length > 0)
    {
        _idCardUploadEnable = YES;
        _idCardUploadVew = [[LocationImageUploadView alloc] initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, uploadViewHeight)
                                                      andUploadImageRange:_idCardImgRequestNumber];
        _idCardUploadVew.delegate = self;
        _idCardUploadVew.tag = 2;
        [_idCardView addSubview:_idCardUploadVew];
    }
    [self updateUploadImageViewConstraints];
}

- (TicketModel*)loadDefaultTicketFromService
{
    if ([self.payInfoModel.code_id isEqualToString:@""] ||
        self.payInfoModel.code_id == nil)
    {
        return nil;
    }
    else
    {
        TicketModel *ticket = [[TicketModel alloc] init];
        ticket.code_id = self.payInfoModel.code_id;
        ticket.code_content = self.payInfoModel.code_content;
        ticket.price = self.payInfoModel.price;
        ticket.consume_type = self.payInfoModel.consume_type;
        ticket.create_time = self.payInfoModel.create_time;
        ticket.service_type = self.payInfoModel.service_type;
        ticket.code_name = self.payInfoModel.code_name;
        ticket.begin_time = self.payInfoModel.begin_time;
        ticket.end_time = self.payInfoModel.end_time;
        ticket.remain_times = self.payInfoModel.remain_times;
        ticket.code_desc = self.payInfoModel.code_desc;
        ticket.comp_id = self.payInfoModel.comp_id;
        ticket.comp_name = self.payInfoModel.comp_name;
        ticket.pay_flag = self.payInfoModel.pay_flag;
        ticket.times_limit = self.payInfoModel.times_limit;
        return ticket;
    }
}


#pragma mark - UITextFieldDelegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _addressField || textField == _moreRequestField)
    {
        if (textField == _addressField)
        {
            AddressSelectViewController *viewController = [[AddressSelectViewController alloc] initWithNibName:@"AddressSelectViewController"
                                                                                                        bundle:nil];
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if (textField == _moreRequestField)
        {
            MoreRequestViewController *viewController = [[MoreRequestViewController alloc] initWithNibName:@"MoreRequestViewController"
                                                                                                    bundle:nil];
            viewController.delegate = self;
            if (_moreRequestString != nil && ![_moreRequestString isEqualToString:@""])
            {
                viewController.requestString = _moreRequestString;
            }
            [self.navigationController pushViewController:viewController animated:YES];
        }
        return NO;
    }
    else if (textField == _phoneField)
    {
        [_contextScrollView scrollRectToVisible:CGRectMake(0,
                                                           _moreInfoView.frame.origin.y+_moreInfoView.frame.size.height*2/3,
                                                           _contextScrollView.frame.size.width,
                                                           _contextScrollView.frame.size.height)
                                       animated:YES];
        return YES;
    }
    else
        return YES;
}

#pragma mark - 更多信息的操作

- (void)didFinishAddressSelect:(LocationModel *)locationModel
{
    _serviceLocation = locationModel;
    _addressString = _serviceLocation.addressString;
    _addressField.text = _addressString;
}

#pragma mark - MoreRequestDelegate Method

- (void)didFinishMoreRequestEditing:(NSString *)contextString
{
    _moreRequestString = contextString;
    
    _moreRequestField.text = _moreRequestString;
    
}


- (void)updateUploadImageViewConstraints
{
    float uploadImageViewHeight = 0;
    
    float carCardViewHeight = 150*SCREEN_WIDTH/320;
    
    float driveCarViewHeight = 0;
    float idCarViewHeight = 0;
    
    float uploadViewHeight = (SCREEN_WIDTH - 60)/3.0;
    
    if (_driveCardUploadEnable)
    {
        int itemCount = (int)_driveCardUploadVew.itemsArray.count;
        float cloumFloat = itemCount/3.0;
        int cloum = (int)cloumFloat;
        
        if (cloumFloat > cloum)
        {
            cloum += 1;
        }
        if (cloum > 1)
        {
            driveCarViewHeight = cloum * uploadViewHeight + (cloum - 1 )*10 + 50;

        }
        else
        {
            driveCarViewHeight = uploadViewHeight + 50;

        }
        _driveCardView.hidden = NO;
    }
    else
    {
        driveCarViewHeight = 0;
        _driveCardView.hidden = YES;
    }
    
    [self updateDriveCardViewConstraintsWithValue:driveCarViewHeight];
    
    if (_idCardUploadEnable)
    {
        int itemCount = (int)_idCardUploadVew.itemsArray.count;
        float cloumFloat = itemCount/3.0;
        int cloum = (int)cloumFloat;
        
        if (cloumFloat > cloum)
        {
            cloum += 1;
        }
        if (cloum > 1)
        {
            idCarViewHeight = cloum * uploadViewHeight + (cloum - 1 )*10 + 50;
        }
        else
        {
            idCarViewHeight = uploadViewHeight + 50;

        }
        _idCardView.hidden = NO;
    }
    else
    {
        idCarViewHeight = 0;
        _idCardView.hidden = YES;
    }
    
    [self updateIDCardViewConstraintsWithValue:idCarViewHeight];
    
    uploadImageViewHeight = carCardViewHeight + driveCarViewHeight + idCarViewHeight;
    
    BOOL shouldUpdate = NO;
    for (int x = 0; x<_uploadImageView.constraints.count; x++)
    {
        NSLayoutConstraint *layoutConstraint = _uploadImageView.constraints[x];
        if (layoutConstraint.firstAttribute == NSLayoutAttributeHeight && layoutConstraint.multiplier != uploadImageViewHeight)
        {
            shouldUpdate = YES;
            [_uploadImageView removeConstraint:layoutConstraint];
            break;
        }
        
    }
    
    if (!shouldUpdate)
    {
        return;
    }
    
    NSDictionary* views = NSDictionaryOfVariableBindings(_uploadImageView);
    
    NSString *constrainString = nil;
    constrainString = [NSString stringWithFormat:@"V:[_uploadImageView(%.2f)]",uploadImageViewHeight];
    
    
    [_uploadImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constrainString
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];

}

- (void)updateDriveCardViewConstraintsWithValue:(float)targetValue
{
    BOOL shouldUpdate = NO;
    for (int x = 0; x<_driveCardView.constraints.count; x++)
    {
        NSLayoutConstraint *layoutConstraint = _driveCardView.constraints[x];
        if (layoutConstraint.firstAttribute == NSLayoutAttributeHeight && layoutConstraint.multiplier != targetValue)
        {
            shouldUpdate = YES;
            [_driveCardView removeConstraint:layoutConstraint];
            break;
        }
        
    }
    
    if (!shouldUpdate)
    {
        return;
    }
    
    NSDictionary* views = NSDictionaryOfVariableBindings(_driveCardView);
    
    NSString *constrainString = nil;
    constrainString = [NSString stringWithFormat:@"V:[_driveCardView(%.2f)]",targetValue];

    
    [_driveCardView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constrainString
                                                                        options:0
                                                                        metrics:nil
                                                                          views:views]];
}

- (void)updateIDCardViewConstraintsWithValue:(float)targetValue
{
    BOOL shouldUpdate = NO;
    for (int x = 0; x<_idCardView.constraints.count; x++)
    {
        NSLayoutConstraint *layoutConstraint = _idCardView.constraints[x];
        if (layoutConstraint.firstAttribute == NSLayoutAttributeHeight && layoutConstraint.multiplier != targetValue)
        {
            shouldUpdate = YES;
            [_idCardView removeConstraint:layoutConstraint];
            break;
        }
        
    }
    
    if (!shouldUpdate)
    {
        return;
    }
    
    NSDictionary* views = NSDictionaryOfVariableBindings(_idCardView);
    
    NSString *constrainString = nil;
    constrainString = [NSString stringWithFormat:@"V:[_idCardView(%.2f)]",targetValue];
    
    
    [_idCardView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constrainString
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
}

#pragma mark - LocationImageUploadViewDelegate Method


- (void)didNeedAddShowImagePicker:(UIView *)locationImageUploadView
{
    _selectedImageUploadIndex = locationImageUploadView.tag;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照",@"选取照片", nil];
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
}

- (void)didNeedEditShowImagePicker:(UIView *)locationImageUploadView
{
    _selectedImageUploadIndex = locationImageUploadView.tag;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照",@"选取照片", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

- (IBAction)didBackCarCardButtonTouch:(id)sender
{
    _selectedImageUploadIndex = 0;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照",@"选取照片", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}


- (void)didLocationImageUploadViewFrameChanged:(UIView*)locationImageUploadView
{
    [self updateUploadImageViewConstraints];
}

#pragma mark - UIActionSheetDelegate Method


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate = self;
            picker.allowsEditing = NO;//设置可编辑
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:nil];//进入照相界面
        }
            break;
        case 1:
        {
            
            if (actionSheet.tag == 1)
            {
                UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    pickerImage.allowsEditing = NO;
                    pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
                }
                pickerImage.delegate = self;
                pickerImage.allowsEditing = NO;
                [self presentViewController:pickerImage animated:YES completion:nil];
            }
            else
            {
                NSInteger maxNumber = 0;
                
                if (_selectedImageUploadIndex == 1)
                {
                    maxNumber = _driveCardImgRequestNumber.length + 1 - _driveCardUploadVew.itemsArray.count;
                }
                else if (_selectedImageUploadIndex == 2)
                {
                    maxNumber = _idCardImgRequestNumber.length + 1 - _idCardUploadVew.itemsArray.count;
                }
                
                if (maxNumber <= 0)
                {
                    return;
                }
                
                QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsMultipleSelection = YES;
                imagePickerController.maximumNumberOfSelection = maxNumber;
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
                [self presentViewController:navigationController
                                   animated:YES
                                 completion:NULL];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerController Method

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *uploadImage = nil;
    
    
    UIImage *tmpImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(tmpImage, 1.0);
    if (imageData.length > 200000)
    {
        float targetScle = 200000.0/(unsigned long)imageData.length;
        uploadImage = [UIImage imageWithData:imageData scale:targetScle];
    }
    else
    {
        uploadImage = tmpImage;
    }

    if (_selectedImageUploadIndex == 1)
    {
        [_driveCardUploadVew addImagesToItem:@[uploadImage]];
    }
    else  if (_selectedImageUploadIndex == 2)
    {
        [_idCardUploadVew addImagesToItem:@[uploadImage]];
    }
    else
    {
        _uploadCarCardBackImage = uploadImage;
        [_carCardBackImageView setImage:_uploadCarCardBackImage];
        _deleteCarCardBackButton.hidden = NO;
    }
    self.view.userInteractionEnabled = YES;
    
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   
                               }];
}


- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    
    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    
    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       NSMutableArray *resultArray = [NSMutableArray array];
                       for (int x = 0 ; x <assets.count  ; x++)
                       {
                           ALAsset *asset = assets[x];
                           UIImage *tmpImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                           [resultArray addObject:tmpImage];
                       }
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          if (_selectedImageUploadIndex == 1)
                                          {
                                              [_driveCardUploadVew addImagesToItem:resultArray];
                                          }
                                          else  if (_selectedImageUploadIndex == 2)
                                          {
                                              [_idCardUploadVew addImagesToItem:resultArray];
                                          }
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          self.view.userInteractionEnabled = YES;
                                          
                                      });
                   });
}

#pragma mark - 选择券

- (IBAction)didTicketSelectButtonTouched:(id)sender
{
    if (_ticketSelected)
    {
        [self didFinishTicketSelect:nil];
    }
    else
    {
        if (!_ticketEnable)
        {
            [Constants showMessage:@"您没有该服务的优惠券"];
            return;
        }
        else if (self.defaultTicketModel)
        {
            [self didFinishTicketSelect:self.defaultTicketModel];
            
        }
        else
        {
            [self selectTicketToPay];
        }
    }
}

- (IBAction)checkPayType:(UIButton *)sender
{
    if (!_ticketEnable)
    {
        [Constants showMessage:@"您没有该服务的优惠券"];
        return;
    }
    else if (_ticketSelected || self.defaultTicketModel == nil)
    {
        [self selectTicketToPay];
    }
    else
    {
        [self didFinishTicketSelect:self.defaultTicketModel];
        
    }
}

- (void)selectTicketToPay
{
    MyTicketViewController *viewController = [[MyTicketViewController alloc] initWithNibName:@"MyTicketViewController" bundle:nil];
    
    viewController.serviceType = @"100";
    viewController.delegate = self;
    //viewController.targetCarWashID = self.carNurse.car_wash_id;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didFinishTicketSelect:(TicketModel *)model
{
    if (model == nil)
    {
        _ticketSelected = NO;
        self.selectTicketModel = nil;
        [_ticketPayTitle setTextColor:self.isClubController?kClubBlackColor:[UIColor blackColor]];
        _ticketSelectIcon.highlighted = NO;
        _ticketNameLabel.text = @"";
        _ticketNumberLabel.text = [NSString stringWithFormat:@"%d张可用",self.payInfoModel.code_count.intValue];
        _ticketNumberTitle.hidden = NO;
        
        _ticketPriceLabel.text = @"";
        _ticketTypeLabel.text = @"";
        
    }
    else
    {
        _ticketSelected = YES;
        self.selectTicketModel = model;
        [_ticketPayTitle setTextColor:self.isClubController?kClubBlackGoldColor:kNormalTintColor];
        _ticketSelectIcon.highlighted = YES;
        
        _ticketNameLabel.text =[self.selectTicketModel.comp_name isEqualToString:@""]?@"":self.selectTicketModel.comp_name;
        _ticketNumberLabel.text = @"";
        _ticketNumberTitle.hidden = YES;
        _ticketPriceLabel.text = [NSString stringWithFormat:@"%d元",self.selectTicketModel.price.intValue];
        _ticketTypeLabel.text = [self.selectTicketModel.code_name isEqualToString:@""]?@"":self.selectTicketModel.code_name;
        
    }
    [self updateDisplayPayPrice];
}



#pragma mark - 支付相关

- (IBAction)didSubmitButtonTouch:(id)sender
{
    [self closeKeyBoard];
    [self checkSubmitOrderInfoSuccess:^{
        //[self showAlertViewBeforePay];
        if (_insuranceOrderConfirmView == nil)
        {
            _insuranceOrderConfirmView = [[NSBundle mainBundle] loadNibNamed:@"InsuranceOrderConfirmView"
                                                                   owner:nil
                                                                 options:nil][0];
            
            _insuranceOrderConfirmView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            _insuranceOrderConfirmView.delegate = self;
        }
        [_insuranceOrderConfirmView showAndSetUpWithPayInfoModel:self.payInfoModel
                                                  withTicketInfo:self.selectTicketModel];

    }
                         errorSuccess:^(NSString *alertString)
    {
        [Constants showMessage:alertString];
    }];
}

- (void)checkSubmitOrderInfoSuccess:(void(^)(void))successResponse
                       errorSuccess:(void(^)(NSString *alertString))errorRespone
{
    if (_uploadCarCardBackImage == nil)
    {
        errorRespone(@"请上传行驶证副本");
        return;
    }
    if (_idCardUploadEnable)
    {
        if (![_idCardUploadVew didUpdateImageSatisfyMixCount])
        {
            NSString *alertString = [NSString stringWithFormat:@"请至少上传%d张身份证照片",(int)_idCardImgRequestNumber.location];
            errorRespone(alertString);
            return;
        }
    }
    if (_driveCardUploadEnable)
    {
        if (![_driveCardUploadVew didUpdateImageSatisfyMixCount])
        {
            NSString *alertString = [NSString stringWithFormat:@"请至少上传%d张驾驶证照片",(int)_driveCardImgRequestNumber.location];
            errorRespone(alertString);
            return;
        }
    }
    if ([_addressString isEqualToString:@""] || _addressString == nil)
    {
        errorRespone(@"您还未选择保单配送地址");
        return;
    }
    if ([_phoneField.text isEqualToString:@""] || _phoneField.text == nil)
    {
        errorRespone(@"您还未输入联系电话");
        return;
    }
    if (_phoneField.text.length != 11)
    {
        errorRespone(@"您输入的联系电话有误");
        return;
    }
    else
    {
        successResponse();
        return;
    }
}

- (IBAction)didDeleteCarCardBackButtonTouch:(id)sender
{
    [Constants showMessage:@"确定删除这张图片？"
                  delegate:self
                       tag:599
              buttonTitles:@"取消", @"确定", nil];
}


- (void)startSubmitInsuranceImagesWithImageArray:(NSArray*)imageArray
                                  successRespone:(void(^)(NSString *uploadImagesUrls))successRespone
                                     errorRespone:(void(^)(void))errorRespone
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.view.userInteractionEnabled = NO;
    NSString *imageKey = @"testImage.jpg";
    [WebService uploadImageWithParam:@{}
                              action:@"upload/service/insurphoto"
                          imageDatas:imageArray
                            imageKey:imageKey
                      normalResponse:^(NSString *status, id data)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         self.view.userInteractionEnabled = YES;
         if (status.intValue > 0)
         {
             NSLog(@"%@",data);
             NSString *resultString = nil;
             NSString *photoAddrs = [data objectForKey:@"photoAddrs"];
             if ([photoAddrs isEqualToString:@""] || photoAddrs == nil)
             {
                 errorRespone();
                 return ;
             }
             else
             {
                 resultString = [NSMutableString stringWithString:[photoAddrs stringByReplacingOccurrencesOfString:@"!" withString:@","]];
                 successRespone(resultString);
                 return ;
             }

         }
     }
                   exceptionResponse:^(NSError *error) {
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                       [MBProgressHUD showError:@"图片发送失败" toView:self.view];
                       self.view.userInteractionEnabled = YES;
                       errorRespone();
                       return ;
                   }];

}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 599 && buttonIndex == 1)
    {
        _uploadCarCardBackImage = nil;
        [_carCardBackImageView setImage:[UIImage imageNamed:@"img_carCardBack_default"]];
        _deleteCarCardBackButton.hidden = YES;
    }
}

#pragma mark - InsuranceOrderConfirmViewDelegate
- (void)didInsuranceOrderConfirmViewDismissAfterConfirm
{
    [self startUploadAndPayOrder];
}

- (void)startUploadAndPayOrder
{
    [self startUploadBackCarCardSuccessRespone:^{
        
        [self startUploadIDCardSuccessRespone:^{
            
            [self startUploadDriveCardSuccessRespone:^{
               
                [self startSubmitOrderInfo];
            }
                                        errorRespone:^{
                                            
                                        }];
        }
                                 errorRespone:^{
                                     
                                 }];

    }
                                  errorRespone:^{
        
    }];
}

- (void)startUploadBackCarCardSuccessRespone:(void(^)(void))successRespone
                           errorRespone:(void(^)(void))errorRespone
{
    NSArray *submitArray = nil;
    NSData *uploadImageData = UIImageJPEGRepresentation(_uploadCarCardBackImage, 0.1);
    if (uploadImageData.length > 20000)
    {
        submitArray = @[UIImageJPEGRepresentation(_uploadCarCardBackImage, 0.1)];
    }
    else
    {
        submitArray = @[ uploadImageData];
    }
    
    
    [self startSubmitInsuranceImagesWithImageArray:submitArray
                                    successRespone:^(NSString *uploadImagesUrls)
     {
         _uploadCarCardBackImageUrl = uploadImagesUrls;
         successRespone();
         return ;
     }
                                      errorRespone:^{
                                          errorRespone();
                                          return ;
                                      }];

}

- (void)startUploadDriveCardSuccessRespone:(void(^)(void))successRespone
                              errorRespone:(void(^)(void))errorRespone
{
    if (_driveCardUploadEnable)
    {
        NSArray *driveImageArray = [_driveCardUploadVew getAllImageData];
        if (driveImageArray.count > 0)
        {
            [self startSubmitInsuranceImagesWithImageArray:driveImageArray
                                            successRespone:^(NSString *uploadImagesUrls)
             {
                 _uploadDriveCardImageSring = uploadImagesUrls;
                 successRespone();
                 return ;
             }
                                              errorRespone:^{
                                                  errorRespone();
                                                  return ;
                                              }];
        }
        else
        {
            _uploadDriveCardImageSring = nil;
            successRespone();
            return;
        }

    }
    else
    {
        successRespone();
        return;
    }
}

- (void)startUploadIDCardSuccessRespone:(void(^)(void))successRespone
                              errorRespone:(void(^)(void))errorRespone
{
    if (_idCardUploadEnable)
    {
        NSArray *driveImageArray = [_idCardUploadVew getAllImageData];
        if (driveImageArray.count > 0)
        {
            [self startSubmitInsuranceImagesWithImageArray:driveImageArray
                                            successRespone:^(NSString *uploadImagesUrls)
             {
                 _uploadIdCardImageSring = uploadImagesUrls;
                 successRespone();
                 return ;
             }
                                              errorRespone:^{
                                                  errorRespone();
                                                  return ;
                                              }];
        }
        else
        {
            _uploadIdCardImageSring = nil;
            successRespone();
            return;
        }
        
    }
    else
    {
        successRespone();
        return;
    }
}

- (void)startSubmitOrderInfo
{
    NSString *codeIdString = nil;
    
    if (_ticketSelected && self.selectTicketModel)
    {
        codeIdString = self.selectTicketModel.code_id;
    }
    else
    {
        codeIdString = @"";
    }
    
    NSDictionary *submitDic = @{@"member_id":_userInfo.member_id,
                                @"suggest_id":self.infoModel.suggest_id,
                                @"pay_money":@"0",
                                @"code_id":codeIdString,
                                @"address":_addressString,
                                @"pay_type":@"1",
                                @"requiry":_moreRequestString == nil?@"": _moreRequestString,
                                @"suggest_type":self.suggestType,
                                @"photo_addr":@"",
                                @"photo_addr2":_uploadCarCardBackImageUrl,
                                @"jsz_addr":_uploadDriveCardImageSring == nil? @"":_uploadDriveCardImageSring,
                                @"cid_addr":_uploadIdCardImageSring == nil? @"":_uploadIdCardImageSring};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.view.userInteractionEnabled = NO;
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"insurance/service/payOrder"
                               normalResponse:^(NSString *status, id data)
     {
         [Constants showMessage:@"保险下单成功"];
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
             [[NSNotificationCenter defaultCenter] postNotificationName:kShouldUpdateInsurance
                                                                 object:nil];
             [self.navigationController popToViewController:targetController animated:YES];
         }
         
         
     }
                            exceptionResponse:^(NSError *error) {
                                [MBProgressHUD hideHUDForView:self.view
                                                     animated:NO];
                                [Constants showMessage:[error domain]];
                                self.view.userInteractionEnabled = YES;
                            }];
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
