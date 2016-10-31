//
//  UploadImageItem.m
//  OldErp4iOS
//
//  Created by Darsky on 5/29/14.
//  Copyright (c) 2014 HFT_SOFT. All rights reserved.
//

#import "UploadImageItem.h"

@implementation UploadImageItem

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageButton.frame = self.bounds;
        [_imageButton setBackgroundImage:[UIImage imageNamed:@"btn_b_pic_only"] forState:UIControlStateNormal];
        [_imageButton addTarget:self
                         action:@selector(didAddItemPressed)
               forControlEvents:UIControlEventTouchUpInside];
        _imageButton.userInteractionEnabled = YES;
        _imageButton.contentMode = UIViewContentModeScaleAspectFill;
        _imageButton.clipsToBounds = YES;
        _imageButton.layer.masksToBounds = YES;
        _imageButton.layer.cornerRadius = 5;
        _imageButton.layer.borderColor = [UIColor colorWithRed:235/255.0
                                                         green:235/255.0
                                                          blue:235/255.0
                                                         alpha:1.0].CGColor;
        _imageButton.layer.borderWidth = 1;
        [self addSubview:_imageButton];
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(self.frame.size.width-18.5, -5, 22.5, 22.5);
        _deleteBtn.tag = 10;
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"deleteUpImage"]
                              forState:UIControlStateNormal];
        [_deleteBtn addTarget:self
                       action:@selector(didDeleteImagePressed)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn];
        _deleteBtn.hidden = YES;
        self.isNil = YES;
    }
    return self;
}

- (void)setUploadImage:(UIImage*)image
{
    [_imageButton setBackgroundImage:image
                            forState:UIControlStateNormal];
    
    _imageButton.selected = YES;
    _deleteBtn.hidden     = NO;
    
    self.isNil = NO;
}

- (void)didAddItemPressed
{
    if (self.isNil)
    {
        if ([self.deletage respondsToSelector:@selector(didUploadImageAdd:)])
        {
            [self.deletage didUploadImageAdd:self];
        }
    }
    else
    {
        if ([self.deletage respondsToSelector:@selector(didUploadImageEdit:)])
        {
            [self.deletage didUploadImageEdit:self];
        }
    }

}
- (void)didDeleteImagePressed
{
    if ([self.deletage respondsToSelector:@selector(didUploadImageDelete:)])
    {
        [self.deletage didUploadImageDelete:self];
    }
}

- (UIImage*)retureUploadImage
{
    if (!self.isNil)
    {
        NSData *uploadImageData = UIImageJPEGRepresentation([_imageButton backgroundImageForState:UIControlStateNormal], 0.5);
        return [UIImage imageWithData:uploadImageData];
    }
    else
        return nil;
}

- (NSData*)retureUploadImageData
{
    if (!self.isNil)
    {
        UIImage *uploadImage = [_imageButton backgroundImageForState:UIControlStateNormal];
        NSData *uploadImageData = UIImageJPEGRepresentation(uploadImage, 0.1);
        if (uploadImageData.length > 20000)
        {
            return UIImageJPEGRepresentation(uploadImage, 0.1);;
        }
        else
        {
            return uploadImageData;
        }
    }
    else
        return nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
