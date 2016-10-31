//
//  HomeBulterMenuItem.h
//  
//
//  Created by cts on 15/10/29.
//
//

#import <UIKit/UIKit.h>

@protocol HomeBulterMenuItemDelegate <NSObject>

- (void)didHomeBulterMenuItemTouch:(NSInteger)indexTag;

@end

@interface HomeBulterMenuItem : UIView
{
    UIImageView  *_itemImageView;
    
    UIButton *_itemButton;
    
    UILabel  *_itemLabel;
}

@property (assign, nonatomic) id <HomeBulterMenuItemDelegate> delegate;

@property (nonatomic, assign) CGFloat showAnimationTime;

@property (nonatomic, assign) CGFloat endAnimationTime;



- (instancetype)initWithFrame:(CGRect)frame
                    withImageName:(NSString*)imageName
                    withTitle:(NSString*)titleString;


@end
