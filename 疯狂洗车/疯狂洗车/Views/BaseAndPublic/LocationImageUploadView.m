//
//  LocationImageUploadView.m
//  
//
//  Created by cts on 15/9/16.
//
//

#import "LocationImageUploadView.h"

@implementation LocationImageUploadView

- (instancetype)initWithFrame:(CGRect)frame
andUploadImageRange:(NSRange)countRange
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _itemsArray = [NSMutableArray array];
        _itemWidth = (SCREEN_WIDTH - 60)/3.0;
        _maxImageCount = countRange.length;
        _minImageCount = countRange.location;
        [self addEmptyItem];

    }
    
    return self;
}


- (void)addImagesToItem:(NSArray*)images
{
    for (int x = 0; x<images.count; x++)
    {
        UploadImageItem *item = _itemsArray[_selectedIndex];
        
        [item setUploadImage:images[x]];
        
        if (_itemsArray.count < _maxImageCount)
        {
            [self addEmptyItem];
        }
    }
    [self updateThisViewFrame];

}

- (void)updateImageToItem:(UIImage*)targetImage
{
    UploadImageItem *item = _itemsArray[_selectedIndex];
    
    [item setUploadImage:targetImage];
}

- (void)didUploadImageDelete:(UIView*)deleteItem
{
    _selectedIndex = deleteItem.tag;
    
    [Constants showMessage:@"删除这张图片？"
                  delegate:self
                       tag:77
              buttonTitles:@"取消",@"确定", nil];
}
- (void)didUploadImageAdd:(UIView*)deleteItem
{
    _selectedIndex = deleteItem.tag;
    if ([self.delegate respondsToSelector:@selector(didNeedAddShowImagePicker:)])
    {
        [self.delegate didNeedAddShowImagePicker:self];
    }
}

- (void)didUploadImageEdit:(UIView*)deleteItem
{
    _selectedIndex = deleteItem.tag;
    if ([self.delegate respondsToSelector:@selector(didNeedEditShowImagePicker:)])
    {
        [self.delegate didNeedEditShowImagePicker:self];
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 77 && buttonIndex == 1)
    {
        [UIView beginAnimations:@"DeleteUploadImage" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDidStopSelector:@selector(deleteUploadImage)];
        [UIView setAnimationDelegate:self];
        
        for (int x = (int)_selectedIndex; x < _itemsArray.count; x++)
        {
            UploadImageItem *item = _itemsArray[x];
            if (_selectedIndex == x)
            {
                [item removeFromSuperview];
            }
            else
            {
                
                int cloum = x/3.0;
                
                int row = x%3;
                
                if (row > 0 && row < 3)
                {
                    //水平前进
                    item.frame = CGRectMake(item.frame.origin.x - (_itemWidth+10), item.frame.origin.y, item.frame.size.width, item.frame.size.height);
                }
                else if (cloum > 0)
                {
                    //上移前进
                    item.frame =CGRectMake(20+2*(_itemWidth+10), item.frame.origin.y - (_itemWidth + 10), item.frame.size.width, item.frame.size.height);
                }
                
            }
        }
        [UIView commitAnimations];
    }
}

- (void)deleteUploadImage
{
    [_itemsArray removeObjectAtIndex:_selectedIndex];
    
    for (int x = 0; x<_itemsArray.count; x++)
    {
        UploadImageItem *item = _itemsArray[x];
        item.tag = x;
    }

    UploadImageItem *lastItem = [_itemsArray lastObject];
    
    if (!lastItem.isNil && _itemsArray.count<_maxImageCount)
    {
        [self addEmptyItem];
    }
    [self updateThisViewFrame];
}

- (void)addEmptyItem
{
    int itemCount = (int)_itemsArray.count;
    
    float cloumFloat = itemCount/3.0;
    int cloum = (int)cloumFloat;
    
    int row = itemCount%3;
    if (row == 3)
    {
        row = 0;
    }
    _selectedIndex = _itemsArray.count;
    UploadImageItem *item = [[UploadImageItem alloc] initWithFrame:CGRectMake(20+row*(_itemWidth+10), cloum*(_itemWidth+10), _itemWidth, _itemWidth)];
    item.tag = _itemsArray.count;
    item.deletage = self;
    [self addSubview:item];
    [_itemsArray addObject:item];
}

- (void)updateThisViewFrame
{
    float targetHeight = 0;
    int itemCount = (int)_itemsArray.count;
    float cloumFloat = itemCount/3.0;
    int cloum = (int)cloumFloat;
    if (cloumFloat > cloum )
    {
        cloum += 1;
    }
    if (cloum > 1)
    {
        targetHeight = cloum*_itemWidth+(cloum -1)*5;
    }
    else
    {
        targetHeight = _itemWidth;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, targetHeight);
    
    if ([self.delegate respondsToSelector:@selector(didLocationImageUploadViewFrameChanged:)])
    {
        [self.delegate didLocationImageUploadViewFrameChanged:self];
    }
}

- (BOOL)didUpdateImageSatisfyMixCount
{
    int resultCount = 0;
    for (int x = 0; x<self.itemsArray.count; x++)
    {
        UploadImageItem *item = _itemsArray[x];
        if (!item.isNil)
        {
            resultCount ++ ;
        }
    }
    if (resultCount >= _minImageCount)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSArray*)getAllImageData
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (UploadImageItem *item in _itemsArray)
    {
        if (!item.isNil)
        {
            [resultArray addObject:[item retureUploadImageData]];
        }
    }
    return resultArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
