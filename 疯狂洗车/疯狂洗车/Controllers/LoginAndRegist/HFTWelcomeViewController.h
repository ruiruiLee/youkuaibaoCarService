
/*!
 @header HFTWelcomeViewController.h
 @abstract 该类第一次启动APP的引导页
 @author 朱伟铭
 @version 1.00 2014/01/03 Creation
 */
#import <UIKit/UIKit.h>

/*!
 @class HFTWelcomeViewController
 @abstract 该类第一次启动APP的引导页
 */
@interface HFTWelcomeViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    IBOutlet UIScrollView       *_welceomSV;
    
             NSMutableArray     *topListArray;
}

@end
