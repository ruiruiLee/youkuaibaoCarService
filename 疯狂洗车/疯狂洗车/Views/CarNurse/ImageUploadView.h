/*!
 @header ImageUploadView.h
 @abstract 上传图片预览和编辑控件，该控件提供给用户选择图片接口，预览要上传的图片
 @author Darsky
 @version 3.01 2014/05/28 Creation
 */
#import <UIKit/UIKit.h>
#import "UploadImageItem.h"

/*!
 @protocol ImageUploadViewDelegate
 @abstract 这个ImageUploadView类的一个protocol
 @discussion 当用户触发添加操作时触发
 */
@protocol ImageUploadViewDelegate <NSObject>

/*!
 @method didNeedAddShowImagePicker:
 @abstract 当用户想要添加或编辑图片，点击图片控件后触发
 @discussion 当用户想要添加或编辑图片，点击图片控件后触发。
 @result void 当用户想要添加或编辑图片，点击图片控件后触发
 */
- (void)didNeedAddShowImagePicker;

- (void)didNeedEditShowImagePicker;

- (void)didImageUploadViewDelegateImage;


@end

/*!
 @class ImageUploadView
 @abstract 上传图片预览和编辑控件，该控件提供给用户选择图片接口，预览要上传的图片
 */
@interface ImageUploadView : UIView<UIScrollViewDelegate,UploadImageItemDelegate,UIAlertViewDelegate>
{        
    UIViewController *_targetViewController;
    
    UploadImageItem *_deleteItem;
        
    CGFloat      _itemWidth;
    
    CGFloat      _itemHeight;

}

/*!
 @method setUploadImageItem:
 @abstract 传入用户从相机或相册里选择的图片
 @discussion 传入用户从相机或相册里选择的图片。
 @param image 选择的图片
 @result void 传入用户从相机或相册里选择的图片
 */
- (void)setUploadImageItem:(UIImage*)image;


- (void)setUploadImageItems:(NSArray*)images;

/*!
 @method getAllImage
 @abstract 得到所有选择的图片
 @discussion 得到所有选择的图片。
 @result NSArray 得到所有选择的图片
 */
- (NSArray*)getAllImage;

- (NSArray*)getAllImageData;

/*!
 @method removeAllImages
 @abstract 清空所有图片
 @discussion 清空所有图片。
 @result void 清空所有图片
 */
- (void)removeAllImages;

/*!
 @property delegate
 @abstract 这是AgentPlaceReplayDelegate的delegate
 */
@property (assign, nonatomic) id <ImageUploadViewDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *imagesArray;


@end
