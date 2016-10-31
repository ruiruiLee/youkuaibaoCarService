//
//  HomeBulterMenuView.h
//  
//
//  Created by cts on 15/10/29.
//
//

#import <UIKit/UIKit.h>
#import "HomeBulterMenuItem.h"

@protocol HomeBulterMenuViewDelegate <NSObject>

- (void)didHomeBulterItemTouched:(NSInteger)itemIndex;

- (void)didHomeBulterAppear;


@end

@interface HomeBulterMenuView : UIView<HomeBulterMenuItemDelegate>
{
    NSMutableArray *_itemsArray;
    
    UIImageView     *_blurBGView;
    
    UIButton       *_closeButton;
}

@property (assign, nonatomic) id <HomeBulterMenuViewDelegate> delegate;

+ (void)homeBulterMenuViewShowWithTarget:(id)target;

@end
