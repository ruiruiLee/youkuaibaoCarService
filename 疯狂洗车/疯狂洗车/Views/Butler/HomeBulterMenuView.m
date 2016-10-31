//
//  HomeBulterMenuView.m
//  
//
//  Created by cts on 15/10/29.
//
//

#import "HomeBulterMenuView.h"
#define RGB_COLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define MenuItemWidth 75

#define MenuItemHeight (MenuItemWidth+30)

#define MenuItemBigWidth 155



@implementation HomeBulterMenuView

+ (id)sharedHomeBulterMenuView
{
    static HomeBulterMenuView *homeBulterMenuView = nil;
    //
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{homeBulterMenuView = [[HomeBulterMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];});
    //
    return homeBulterMenuView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        float sectionPadding = (SCREEN_HEIGHT - 435)/3;
        
        _blurBGView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_blurBGView setImage:[UIImage imageNamed:@"bg_JKMenu_blur"]];
        _blurBGView.alpha = 0;
        
        [self addSubview:_blurBGView];
        
        _itemsArray = [NSMutableArray array];
        
        float xOffset = (SCREEN_WIDTH - MenuItemWidth*3)/4.0;
        NSArray *titleArray = @[@"免费送修",@"年检代办",@"划痕补漆",@"美容",@"保养",@"救援"];
        
        for (int x = 0; x<6; x++)
        {
            int y_index = x/3;
            int x_index = x%3;
            HomeBulterMenuItem *menuItem = [[HomeBulterMenuItem alloc] initWithFrame:CGRectMake(x_index*(MenuItemWidth+xOffset)+xOffset,
                                                                                                sectionPadding+y_index*(MenuItemHeight+30)+SCREEN_HEIGHT, MenuItemWidth, MenuItemHeight)
                                                                       withImageName:[NSString stringWithFormat:@"img_JKMenu_%d",x]
                                                                           withTitle:titleArray[x]];
            menuItem.delegate = self;
            menuItem.tag = x;
            if (x == 0 || x == 1 || x == 2)
            {
                menuItem.showAnimationTime = 0.0 + 0.03*y_index+x_index*0.05;
                menuItem.endAnimationTime = 0.2 + 0.03*y_index-x_index*0.05;

            }
            else
            {
                menuItem.showAnimationTime = 0.1 + 0.03*y_index+x_index*+0.05;
                menuItem.endAnimationTime = 0.1 + 0.03*y_index-x_index*0.05;
            }

            [_itemsArray addObject:menuItem];
            [self addSubview:menuItem];
        }
        
        HomeBulterMenuItem *menuItem = [[HomeBulterMenuItem alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - MenuItemBigWidth/2,
                                                                                            SCREEN_HEIGHT-40-sectionPadding-MenuItemBigWidth+SCREEN_HEIGHT, MenuItemBigWidth, MenuItemBigWidth+30)
                                                                   withImageName:@"img_JKMenu_6"
                                                                       withTitle:@""];
        menuItem.delegate = self;
        menuItem.tag = 10;
        menuItem.showAnimationTime = 0.2 + 0.03*2;
        menuItem.endAnimationTime = 0.0 + 0.03*2-0.05;
        [_itemsArray addObject:menuItem];
        [self addSubview:menuItem];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 40);
        [_closeButton setImage:[UIImage imageNamed:@"img_JKMenu_close"]
                      forState:UIControlStateNormal];
        [_closeButton setBackgroundColor:[UIColor whiteColor]];
        [_closeButton addTarget:self action:@selector(didCloseButtonTouch)
               forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
        self.userInteractionEnabled = NO;
    }
    return self;
}


+ (void)homeBulterMenuViewShowWithTarget:(id)target;
{
    [[HomeBulterMenuView sharedHomeBulterMenuView] homeBulterMenuViewShowWithTarget:target];
}

- (void)homeBulterMenuViewShowWithTarget:(id)target;
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       UIWindow *window = [[UIApplication sharedApplication] keyWindow];
                       [window addSubview:self];
                       self.delegate = target;
                       [self showBlurBgView:0.3];
                   });
}

- (void)showBlurBgView:(CFTimeInterval)dur
{
    [UIView animateWithDuration:dur
                     animations:^{
                         _blurBGView.alpha = 1;
                     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             [self shouwOrHideCloseButton:YES];
             
         }
     }];

}

- (void)showAllMenuItem
{
    for (int x = 0; x<_itemsArray.count; x++)
    {
        HomeBulterMenuItem *menuItem = _itemsArray[x];
        
        float delayInSeconds = menuItem.showAnimationTime;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self appearMenuItem:menuItem animated:YES];
        });

    }
    [self performSelector:@selector(recoverUserInteraction)
               withObject:nil
               afterDelay:1.1];
}

- (void)recoverUserInteraction
{
    self.userInteractionEnabled = YES;
    if ([self.delegate respondsToSelector:@selector(didHomeBulterAppear)])
    {
        [self.delegate didHomeBulterAppear];
    }
}

- (void)appearMenuItem:(HomeBulterMenuItem *)item animated:(BOOL )animated
{
    CGPoint point0 = CGPointMake(item.center.x, item.center.y);
    CGPoint point1 = CGPointMake(point0.x, item.center.y-SCREEN_HEIGHT);
    CGPoint point2 = CGPointMake(point1.x, point1.y + 20);
    
    if (animated)
    {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.values = @[[NSValue valueWithCGPoint:point0], [NSValue valueWithCGPoint:point1], [NSValue valueWithCGPoint:point2]];
        animation.keyTimes = @[@(0), @(0.6), @(1)];
        animation.timingFunctions = @[[CAMediaTimingFunction functionWithControlPoints:0.10 :0.87 :0.68 :1.0], [CAMediaTimingFunction functionWithControlPoints:0.66 :0.37 :0.70 :0.95]];
        animation.duration = 0.5f;
        [item.layer addAnimation:animation forKey:@"kStringMenuItemAppearKey"];
    }
    item.layer.position = point2;
}

- (void)hideAllMenuItem
{
    for (int x = 0; x<_itemsArray.count; x++)
    {
        HomeBulterMenuItem *menuItem = _itemsArray[x];
        
        float delayInSeconds = menuItem.endAnimationTime;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self disappearMenuItem:menuItem animated:YES];
        });
    }
    
    [self performSelector:@selector(hideBlurBgView:) withObject:nil afterDelay:0.3];
}

- (void)disappearMenuItem:(HomeBulterMenuItem *)item animated:(BOOL )animated
{
    CGPoint point = item.center;
    CGPoint finalPoint = CGPointMake(point.x, point.y - 20+SCREEN_HEIGHT);
    if (animated) {
        CABasicAnimation *disappear = [CABasicAnimation animationWithKeyPath:@"position"];
        disappear.duration = 0.3;
        disappear.fromValue = [NSValue valueWithCGPoint:point];
        disappear.toValue = [NSValue valueWithCGPoint:finalPoint];
        disappear.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [item.layer addAnimation:disappear forKey:@"kStringMenuItemAppearKey"];
    }
    item.layer.position = finalPoint;
}

- (void)hideBlurBgView:(CFTimeInterval)dur
{
    if (SCREEN_HEIGHT == 480)
    {
        [self removeFromSuperview];
        return;
    }
    
    double targetTime = 0;
    if (dur == 0)
    {
        targetTime = 0.3;
    }
    else
    {
        targetTime = dur;
    }
    
    [UIView animateWithDuration:targetTime
                     animations:^{
                         _blurBGView.alpha = 0;
                     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             [self removeFromSuperview];
         }
     }];

}

- (void)shouwOrHideCloseButton:(BOOL)shouldShow
{
    self.userInteractionEnabled = NO;
    [UIView beginAnimations:@"shouwOrHideCloseButton"
                    context:nil];
    [UIView setAnimationDuration:0.2 ];
    [UIView setAnimationDelegate:self];

    if (shouldShow)
    {

        [UIView setAnimationDidStopSelector:@selector(showAllMenuItem)];
        _closeButton.transform = CGAffineTransformMakeTranslation(0, -40);
    }
    else
    {
        [UIView setAnimationDidStopSelector:@selector(hideAllMenuItem)];
        _closeButton.transform = CGAffineTransformIdentity;
    }
    [UIView commitAnimations];
}

- (void)didCloseButtonTouch
{
    [self shouwOrHideCloseButton:NO];
}

- (void)didHomeBulterMenuItemTouch:(NSInteger)indexTag
{
    if ([self.delegate respondsToSelector:@selector(didHomeBulterItemTouched:)])
    {
        [self.delegate didHomeBulterItemTouched:indexTag];
    }
    [self shouwOrHideCloseButton:NO];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
