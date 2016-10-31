//
//  CarNannyRichMessageViewController.m
//  优快保
//
//  Created by cts on 15/5/27.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CarNannyRichMessageViewController.h"
#import "WebServiceHelper.h"
#import "MBProgressHUD+Add.h"
#import "QBImagePickerController.h"

@interface CarNannyRichMessageViewController ()<UIGestureRecognizerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,QBImagePickerControllerDelegate>
{
    NSMutableString *_uploadImageAddrs;
    
    UIButton *_rightButton;
    
    BOOL      _isEditImage;
}

@end

@implementation CarNannyRichMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _imageSelectView.delegate = self;
    [_contextTextView setPlaceholder:@"有问题给大白说"];
    
    [self setTitle:@"留言"];
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 36, 32)];
    [_rightButton setTitle:@"发送" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_rightButton setTitleColor:[UIColor colorWithRed:235.0/255.0
                                            green:84.0/255.0
                                             blue:1.0/255.0
                                            alpha:1.0] forState:UIControlStateNormal];
    
    [_rightButton addTarget:self action:@selector(didSubmitButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];

    
    _contextTextView.layer.masksToBounds = YES;
    _contextTextView.layer.cornerRadius = 5;
    _contextTextView.layer.borderWidth = 1.0;
    _contextTextView.layer.borderColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0].CGColor;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(closeKeyBoard)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_imageSelectView.imagesArray.count >= 5                                                                       )
    {
        _contentView.transform = CGAffineTransformIdentity;
    }
    else
    {
        CGFloat change = (SCREEN_WIDTH - 40 - 30)/4.0;
        
        _contentView.transform = CGAffineTransformMakeTranslation(0, -change);

    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![self.preInputString isEqualToString:@""] &&self.preInputString != nil)
    {
        if ([_contextTextView.text isEqualToString:@""] || _contextTextView.text == nil)
        {
            [_contextTextView setText:self.preInputString];
        }
    }
}





#pragma mark - 图片选择 Method
- (void)didNeedAddShowImagePicker
{
    [self closeKeyBoard];
    _isEditImage = NO;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照",@"选取照片", nil];
    [actionSheet showInView:self.view];
}

- (void)didNeedEditShowImagePicker
{
    [self closeKeyBoard];
    _isEditImage = YES;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照",@"选取照片", nil];
    [actionSheet showInView:self.view];
}

- (void)didImageUploadViewDelegateImage
{
    if (_imageSelectView.imagesArray.count >= 5                                                                       )
    {
        _contentView.transform = CGAffineTransformIdentity;
    }
    else
    {
        CGFloat change = (SCREEN_WIDTH - 40 - 30)/4.0;
        
        _contentView.transform = CGAffineTransformMakeTranslation(0, -change);

    }

}


- (void)didSubmitButtonTouch
{
    if ([_contextTextView.text isEqualToString:@""] || _contextTextView.text == nil)
    {
        [Constants showMessage:@"请输入您要发送的留言内容"];
        return;
    }
    [self closeKeyBoard];
    NSArray *imageArray = [_imageSelectView getAllImageData];
    if (imageArray.count > 0)
    {
        [self submitImagesContentWithArray:imageArray];
    }
    else
    {
        [self submitTextContent];
    }
}

- (void)submitTextContent
{
    _rightButton.userInteractionEnabled = NO;
    NSMutableDictionary *submitDic = [NSMutableDictionary dictionary];
    if (_selectNannyType == nil)
    {
        [submitDic setObject:@"0" forKey:@"nanny_type"];
    }
    else
    {
        [submitDic setObject:_selectNannyType.type_id forKey:@"nanny_type"];
    }
    [submitDic setObject:_userInfo.member_id forKey:@"member_id"];
    if ([_uploadImageAddrs isEqualToString:@""] || _uploadImageAddrs == nil)
    {
        [submitDic setObject:@"0" forKey:@"photo_status"];
    }
    else
    {
        [submitDic setObject:_uploadImageAddrs forKey:@"photo_addrs"];
        [submitDic setObject:_shouldShowImageButton.selected?@"1":@"0"
                      forKey:@"photo_status"];

    }

    NSDictionary *loctionDic = [[NSUserDefaults standardUserDefaults] valueForKey:kLocationKey];
    if (loctionDic)
    {
        [submitDic setObject:[loctionDic valueForKey:@"longitude"] forKey:@"longitude"];
        [submitDic setObject:[loctionDic valueForKey:@"latitude"] forKey:@"latitude"];
    }
    [submitDic setObject:_contextTextView.text forKey:@"content"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.view.userInteractionEnabled = NO;
    [WebService requestJsonOperationWithParam:submitDic
                                       action:@"nanny/service/ask"
                               normalResponse:^(NSString *status, id data)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         if (status.intValue > 0)
         {
             [Constants showMessage:@"发送成功"];
             self.view.userInteractionEnabled = YES;

             if ([self.delegate respondsToSelector:@selector(didFinishMessageSend)])
             {
                 [self.delegate didFinishMessageSend];
             }
             [self.navigationController popViewControllerAnimated:YES];
         }
         else
         {
             self.view.userInteractionEnabled = YES;
             [MBProgressHUD showError:@"发送失败" toView:self.view];
         }
         _rightButton.userInteractionEnabled = YES;
     }
                            exceptionResponse:^(NSError *error) {
                                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                [MBProgressHUD showError:@"发送失败" toView:self.view];
                                self.view.userInteractionEnabled = YES;
                                _rightButton.userInteractionEnabled = YES;
                            }];

}

- (void)submitImagesContentWithArray:(NSArray*)imageArray
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _rightButton.userInteractionEnabled = NO;
    NSString *imageKey = @"testImage.jpg";
    [WebService uploadImageWithParam:@{}
                              action:@"upload/service/photo"
                          imageDatas:imageArray
                            imageKey:imageKey
                      normalResponse:^(NSString *status, id data)
     {
         if (status.intValue > 0)
         {
             NSLog(@"%@",data);
             NSString *photoAddrs = [data objectForKey:@"photoAddrs"];
             if ([photoAddrs isEqualToString:@""] || photoAddrs == nil)
             {
                 _uploadImageAddrs = nil;
             }
             else
             {
                 _uploadImageAddrs = [NSMutableString stringWithString:[photoAddrs stringByReplacingOccurrencesOfString:@"!" withString:@","]];
             }
         }
         else
         {
             _uploadImageAddrs = nil;
         }
         [self submitTextContent];
     }
                   exceptionResponse:^(NSError *error) {
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                       [MBProgressHUD showError:@"发送失败" toView:self.view];
                       _rightButton.userInteractionEnabled = YES;
                   }];
}
- (IBAction)didShouldShowImageButtonTouch:(HFTRadionButton *)sender
{
    if (sender == _shouldShowImageButton)
    {
        _shouldShowImageButton.selected = YES;
        _shouldNotShowImageButton.selected = NO;
    }
    else
    {
        _shouldShowImageButton.selected = NO;
        _shouldNotShowImageButton.selected = YES;
    }
}

#pragma mark - UIImagePickerDelegate Method

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
            if (_isEditImage)
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
                QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsMultipleSelection = YES;
                imagePickerController.maximumNumberOfSelection = 9 - _imageSelectView.imagesArray.count;
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
    
    
//    if (picker.allowsEditing)
//    {
//        uploadImage = [self imageByScalingAndCroppingForSize:CGSizeMake(640, 640)
//                                                  withTarget:[info objectForKey:UIImagePickerControllerEditedImage]];
//    }
//    else
//    {
//        uploadImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//    }
    [_imageSelectView setUploadImageItem:uploadImage];
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   self.view.userInteractionEnabled = NO;
                                   [UIView animateWithDuration:0.3
                                                    animations:^{
                                                        if (_imageSelectView.imagesArray.count > 4)
                                                        {
                                                            _contentView.transform = CGAffineTransformMakeTranslation(0, 0);
                                                        }
                                                        else
                                                        {
                                                            CGFloat change = (SCREEN_WIDTH - 40 - 30)/4.0;
                                                            
                                                            _contentView.transform = CGAffineTransformMakeTranslation(0, -change);

                                                        }
                                                    }
                                                    completion:^(BOOL finished)
                                   {
                                    
                                       if (finished)
                                       {
                                           self.view.userInteractionEnabled = YES;
                                       }
                                   }];

                               }];
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withTarget:(UIImage*)target

{
    UIImage *sourceImage = target;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
        
    {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
                                          [_imageSelectView setUploadImageItems:resultArray];
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          self.view.userInteractionEnabled = NO;
                                          [UIView animateWithDuration:0.3
                                                           animations:^{
                                                               if (_imageSelectView.imagesArray.count > 4)
                                                               {
                                                                   _contentView.transform = CGAffineTransformMakeTranslation(0, 0);
                                                               }
                                                               else
                                                               {
                                                                   CGFloat change = (SCREEN_WIDTH - 40 - 30)/4.0;
                                                                   
                                                                   _contentView.transform = CGAffineTransformMakeTranslation(0, -change);
                                                                   
                                                               }
                                                           }
                                                           completion:^(BOOL finished)
                                           {
                                               
                                               if (finished)
                                               {
                                                   self.view.userInteractionEnabled = YES;
                                               }
                                           }];

                                      });
                   });
}

#pragma mark - UITextViewDelegate Method

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (SCREEN_HEIGHT <= 480)
    {
        [UIView animateWithDuration:0.3 animations:^{
            if (_imageSelectView.imagesArray.count >= 5                                                                       )
            {
                self.view.transform = CGAffineTransformMakeTranslation(0, -180);
            }
            else
            {
                CGAffineTransform transform = CGAffineTransformTranslate(self.view.transform, 0, -120);
                self.view.transform = transform;
                
            }
        }];
    }
    else if (SCREEN_HEIGHT <= 568)
    {
        [UIView animateWithDuration:0.3 animations:^{
            if (_imageSelectView.imagesArray.count >= 5                                                                       )
            {
                self.view.transform = CGAffineTransformMakeTranslation(0, -120);
            }

        }];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.view.transform = CGAffineTransformIdentity;
    return YES;
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
    self.view.transform = CGAffineTransformIdentity;
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
