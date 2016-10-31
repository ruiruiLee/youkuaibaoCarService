//
//  ImageUploadView.m
//  OldErp4iOS
//
//  Created by Darsky on 5/28/14.
//  Copyright (c) 2014 HFT_SOFT. All rights reserved.
//

#import "ImageUploadView.h"

@implementation ImageUploadView


- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
           }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (_imagesArray.count <= 0)
    {
        _imagesArray = [NSMutableArray array];
        _itemWidth = (SCREEN_WIDTH - 50)/4.0;
        UploadImageItem *item = [[UploadImageItem alloc] initWithFrame:CGRectMake(10, 10, _itemWidth, _itemWidth)];
        item.tag = 0;
        item.deletage = self;
        [self addSubview:item];
        [_imagesArray addObject:item];
    }
}

- (void)resetScrollView
{
    if (_imagesArray.count <= 0)
    {
        UploadImageItem *item = [[UploadImageItem alloc] initWithFrame:CGRectMake(10, 10, _itemWidth, _itemWidth)];
        item.tag = 0;
        item.deletage = self;
        item.isNil = YES;
        [self addSubview:item];
        [_imagesArray addObject:item];

    }
    else
    {
        for (int x = 0; x<_imagesArray.count; x++)
        {
            UploadImageItem *item = _imagesArray[x];
            item.tag = x;
            NSLog(@"reset tag %d",x);
        }
    }
}

- (void)addImageItem
{
    if (_imagesArray.count<8)
    {
        UploadImageItem *item = nil;
        
        if (_imagesArray.count <4)
        {
            item = [[UploadImageItem alloc] initWithFrame:CGRectMake(10+_imagesArray.count*(_itemWidth+10), 10, _itemWidth, _itemWidth)];
        }
        else
        {
            item = [[UploadImageItem alloc] initWithFrame:CGRectMake(10+(_imagesArray.count-4)*(_itemWidth+10), 20+_itemWidth, _itemWidth, _itemWidth)];
        }
        item.tag = _imagesArray.count;
        item.deletage = self;
        item.isNil = YES;
        [self addSubview:item];
        [_imagesArray addObject:item];
        [self resetScrollView];
    }
}

- (void)didUploadImageDelete:(UIView *)deleteItem
{
    _deleteItem = (UploadImageItem*)deleteItem;
    
    [Constants showMessage:@"删除这张图片？"
                  delegate:self
                       tag:77
              buttonTitles:@"取消",@"确定", nil];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 77 && buttonIndex == 1)
    {
        [UIView beginAnimations:@"DeleteUploadImage" context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDidStopSelector:@selector(deleteUploadImage)];
        [UIView setAnimationDelegate:self];
        
        for (int x = (int)_deleteItem.tag+1; x < _imagesArray.count; x++)
        {
            UploadImageItem *item = _imagesArray[x];
            if (x<=3)
            {
                item.frame = CGRectMake(item.frame.origin.x - (_itemWidth+10), 10, _itemWidth, _itemWidth);
            }
            else if (x == 4)
            {
                item.frame =CGRectMake(10+3*(_itemWidth+10), 10, _itemWidth, _itemWidth);
            }
            else
            {
                item.frame =CGRectMake(item.frame.origin.x - (_itemWidth+10), 20+_itemWidth, _itemWidth, _itemWidth);
            }
        }
        
        _deleteItem.frame = CGRectMake(_deleteItem.frame.origin.x,
                                       _deleteItem.frame.origin.y+300,
                                       _deleteItem.frame.size.width,
                                       _deleteItem.frame.size.height);
        [UIView commitAnimations];
        
        [_deleteItem removeFromSuperview];

    }
}

- (void)didUploadImageAdd:(UIView *)deleteItem
{
    _deleteItem = (UploadImageItem*)deleteItem;
    if ([self.delegate respondsToSelector:@selector(didNeedAddShowImagePicker)])
    {
        [self.delegate didNeedAddShowImagePicker];
    }
}

- (void)didUploadImageEdit:(UIView *)deleteItem
{
    _deleteItem = (UploadImageItem*)deleteItem;
    if ([self.delegate respondsToSelector:@selector(didNeedEditShowImagePicker)])
    {
        [self.delegate didNeedEditShowImagePicker];
    }
}

- (void)setUploadImageItem:(UIImage*)image
{
    [_deleteItem setUploadImage:image];
    
    for (UploadImageItem *item in _imagesArray)
    {
        if (item.isNil)
        {
            return;
        }
    }

    [self addImageItem];
}


- (void)setUploadImageItems:(NSArray*)images
{
    for (int x = 0; x<images.count; x++)
    {
        [_deleteItem setUploadImage:images[x]];
        
        if (_imagesArray.count<8)
        {
            UploadImageItem *item = nil;
            
            if (_imagesArray.count <4)
            {
                item = [[UploadImageItem alloc] initWithFrame:CGRectMake(10+_imagesArray.count*(_itemWidth+10), 10, _itemWidth, _itemWidth)];
            }
            else
            {
                item = [[UploadImageItem alloc] initWithFrame:CGRectMake(10+(_imagesArray.count-4)*(_itemWidth+10), 20+_itemWidth, _itemWidth, _itemWidth)];
            }
            item.isNil = YES;
            item.tag = _imagesArray.count;
            item.deletage = self;
            [self addSubview:item];
            _deleteItem = item;
            [_imagesArray addObject:item];
        }
    }
    [self resetScrollView];
}



- (void)deleteUploadImage
{
    [_imagesArray removeObjectAtIndex:_deleteItem.tag];
    _deleteItem = nil;
    [self resetScrollView];
    UploadImageItem *lastItem = [_imagesArray lastObject];
    
    if (!lastItem.isNil && _imagesArray.count<8)
    {
        UploadImageItem *item = nil;
        
        if (_imagesArray.count <4)
        {
            item = [[UploadImageItem alloc] initWithFrame:CGRectMake(10+_imagesArray.count*(_itemWidth+10), 10, _itemWidth, _itemWidth)];
        }
        else
        {
            item = [[UploadImageItem alloc] initWithFrame:CGRectMake(10+(_imagesArray.count-4)*(_itemWidth+10), 20+_itemWidth, _itemWidth, _itemWidth)];
        }
        item.tag = _imagesArray.count;
        item.deletage = self;
        item.isNil = YES;
        [self addSubview:item];
        [_imagesArray addObject:item];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(didImageUploadViewDelegateImage)])
    {
        [self.delegate didImageUploadViewDelegateImage];
    }
}
- (void)removeAllImages
{
    for (UploadImageItem *item in _imagesArray)
    {
        [item removeFromSuperview];
    }
    [_imagesArray removeAllObjects];
    [self resetScrollView];
}

- (NSArray*)getAllImage
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (UploadImageItem *item in _imagesArray)
    {
        if (!item.isNil)
        {
            [resultArray addObject:[item retureUploadImage]];
        }
    }
    return resultArray;
}

- (NSArray*)getAllImageData
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (UploadImageItem *item in _imagesArray)
    {
        if (!item.isNil)
        {
            [resultArray addObject:[item retureUploadImageData]];
        }
    }
    return resultArray;
}
//- (void)didImageButtibn
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
