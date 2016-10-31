//
//  WashYardImageViewController.m
//  优快保
//
//  Created by cts on 15/7/20.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "WashYardImageViewController.h"
#import "QBImagePickerController.h"
#import "MBProgressHUD+Add.h"


@interface WashYardImageViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,QBImagePickerControllerDelegate>
{
    UIButton *_rightButton;
    
    BOOL      _isEditImage;
}
@end

@implementation WashYardImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"车场图片"];
    
    _imageUploadView.delegate = self;
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 64, 32)];
    [_rightButton setTitle:@"确定上传" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_rightButton setTitleColor:[UIColor colorWithRed:235.0/255.0
                                                green:84.0/255.0
                                                 blue:1.0/255.0
                                                alpha:1.0] forState:UIControlStateNormal];
    
    [_rightButton addTarget:self action:@selector(didRightButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    if (self.uploadImageArray.count)
    {
        NSMutableArray *targetArray = [NSMutableArray array];
        for (int x = 0; x<self.uploadImageArray.count; x++)
        {
            NSData *imageData = self.uploadImageArray[x];
            UIImage *tmpImage = [UIImage imageWithData:imageData];
            [targetArray addObject:tmpImage];
        }
        [_imageUploadView setUploadImageItems:targetArray];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}


#pragma mark - 图片选择
- (void)didNeedAddShowImagePicker
{
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
                imagePickerController.maximumNumberOfSelection = 9 - _imageUploadView.imagesArray.count;
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
    [_imageUploadView setUploadImageItem:uploadImage];
    self.view.userInteractionEnabled = YES;

    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   
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
                                          [_imageUploadView setUploadImageItems:resultArray];
                                          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                          self.view.userInteractionEnabled = YES;
                                          
                                      });
                   });
}


- (void)didRightButtonTouch
{
    if ([self.delegate respondsToSelector:@selector(didFinishWasyYardImageSelect:)])
    {
        [self.delegate didFinishWasyYardImageSelect:[_imageUploadView getAllImageData]];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
