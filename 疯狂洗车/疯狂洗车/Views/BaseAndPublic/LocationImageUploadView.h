//
//  LocationImageUploadView.h
//  
//
//  Created by cts on 15/9/16.
//
//

#import <UIKit/UIKit.h>
#import "UploadImageItem.h"

@protocol LocationImageUploadViewDelegate <NSObject>

/*!
 @method didNeedAddShowImagePicker:
 @abstract 当用户想要添加或编辑图片，点击图片控件后触发
 @discussion 当用户想要添加或编辑图片，点击图片控件后触发。
 @result void 当用户想要添加或编辑图片，点击图片控件后触发
 */
- (void)didNeedAddShowImagePicker:(UIView*)locationImageUploadView;;

- (void)didNeedEditShowImagePicker:(UIView*)locationImageUploadView;;

- (void)didLocationImageUploadViewFrameChanged:(UIView*)locationImageUploadView;


@end

@interface LocationImageUploadView : UIView<UploadImageItemDelegate,UIAlertViewDelegate>
{
    
    NSInteger       _selectedIndex;
    
    NSInteger       _minImageCount;
    
    NSInteger       _maxImageCount;
    
    float           _itemWidth;
    
}

- (id)initWithFrame:(CGRect)frame
andUploadImageRange:(NSRange)countRange;

- (void)addImagesToItem:(NSArray*)images;


- (void)updateImageToItem:(UIImage*)targetImage;

- (BOOL)didUpdateImageSatisfyMixCount;

- (NSArray*)getAllImageData;


@property (assign, nonatomic) id <LocationImageUploadViewDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *itemsArray;

@end
