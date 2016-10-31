//
//  CustomActionSheet.m
//  
//
//  Created by cts on 15/10/20.
//
//

#import "CustomActionSheet.h"

#define itemButtonHeight 45

@interface CustomActionSheet ()
{
    UIView *_displayView;
    
    UIView *_itemImageView;

    UIView *_itemButtonView;
}



@end

@implementation CustomActionSheet

+ (id)sharedShareMenuView
{
    static CustomActionSheet *customActionSheet = nil;
    //
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{customActionSheet = [[CustomActionSheet alloc] initWithFrame:[UIScreen mainScreen].bounds];
        customActionSheet.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    });
    //
    return customActionSheet;
}

+ (void)showCustomActionSheetWithDelegate:(id<CustomActionSheetDelegate>)delegate
                                withItems:(NSArray*)itemArray
                     andCancelButtonTitle:(NSString*)titleString
{
    [[CustomActionSheet sharedShareMenuView] showCustomActionSheetWithDelegate:delegate
                                                                     withItems:itemArray
                                                          andCancelButtonTitle:titleString];
}

- (void)showCustomActionSheetWithDelegate:(id<CustomActionSheetDelegate>)delegate
                                withItems:(NSArray*)itemArray
                     andCancelButtonTitle:(NSString*)titleString
{
    self.delegate = delegate;
    
    if (_displayView)
    {
        if (_itemButtonView.subviews.count > 0)
        {
            for (UIView *tmpView in _itemButtonView.subviews)
            {
                [tmpView removeFromSuperview];
            }
        }
        if (_itemImageView.subviews.count > 0)
        {
            for (UIView *tmpView in _itemImageView.subviews)
            {
                [tmpView removeFromSuperview];
            }
        }

    }
    else
    {
        _displayView = [[UIView alloc] init];
        _displayView.backgroundColor = [UIColor clearColor];
        
        _itemButtonView = [[UIView alloc] init];
        _itemButtonView.backgroundColor = [UIColor colorWithRed:214/255.0 green:214/255.0 blue:218/255.0 alpha:1];
        _itemButtonView.layer.masksToBounds = YES;
        _itemButtonView.layer.cornerRadius = 5;
        
        _itemImageView = [[UIView alloc] init];
        _itemImageView.backgroundColor = [UIColor clearColor];

        
        [_displayView addSubview:_itemImageView];
        [_displayView addSubview:_itemButtonView];
    }
    
    float imageViewHeight = 0;
    
    float itemViewHeight = 0;
    
    float displayViewHeight = 0;
    
    float cancelViewPostionY = 0;
    
    
    for (int x = 0; x<itemArray.count; x++)
    {
        CustomActionSheetItem *item = itemArray[x];
        UIView *widgetView = [self creatWidgetByItem:item andIndex:x];
        if (widgetView != nil)
        {
            if (item.itemType == CustomActionSheetItemTypeImage)
            {
                widgetView.frame = CGRectMake(0,imageViewHeight, widgetView.frame.size.width, widgetView.frame.size.height);
                imageViewHeight+= widgetView.frame.size.height+1;
                [_itemImageView addSubview:widgetView];
            }
            else
            {
                widgetView.frame = CGRectMake(0,itemViewHeight, widgetView.frame.size.width, widgetView.frame.size.height);
                itemViewHeight+= widgetView.frame.size.height+1;
                [_itemButtonView addSubview:widgetView];
            }

        }
    }
    
    _itemImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 20, imageViewHeight);
    
    _itemButtonView.frame = CGRectMake(0, imageViewHeight+25
                                       , SCREEN_WIDTH - 20, itemViewHeight);
    
    CustomActionSheetItem *cancelItem = [[CustomActionSheetItem alloc] initWithType:CustomActionSheetItemTypeCancel
                                                                 andSubobject:titleString];
    
    cancelViewPostionY = _itemButtonView.frame.origin.y+_itemButtonView.frame.size.height+10;
    
    UIView *cancelView = [self creatWidgetByItem:cancelItem andIndex:99];
    
    cancelView.frame = CGRectMake(0,cancelViewPostionY, cancelView.frame.size.width, cancelView.frame.size.height);
    displayViewHeight += cancelViewPostionY+cancelView.frame.size.height+10;
    cancelView.layer.masksToBounds = YES;
    cancelView.layer.cornerRadius = 5;
    
    [_displayView addSubview:cancelView];
    
    _displayView.frame = CGRectMake(10, SCREEN_HEIGHT, SCREEN_WIDTH - 20, displayViewHeight);
    [self addSubview:_displayView];
    _displayView.hidden = YES;
    
    [self showCustomActionSheetView];
}


- (void)showCustomActionSheetView
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       UIWindow *window = [[UIApplication sharedApplication] keyWindow];
                       [window addSubview:self];
                       [self exChangeOutdur:0.3];
                   });
    
}

-(void)exChangeOutdur:(CFTimeInterval)dur
{
    if (self.delegate != nil)
    {
        _displayView.hidden = NO;
        [UIView beginAnimations:@"showMenuView" context:nil];
        [UIView setAnimationDuration:dur];
        _displayView.transform = CGAffineTransformMakeTranslation(0, -_displayView.frame.size.height);
        
        [UIView commitAnimations];
    }
    
    return;
}

- (void)hideCustomActionSheetView
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         _displayView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             [self removeFromSuperview];
         }
     }];
    
    
}


#pragma mark - 创建控件

- (UIView*)creatWidgetByItem:(CustomActionSheetItem*)itemModel
                    andIndex:(NSInteger)index
{
    UIView *resultView = nil;
    float widgetHeight = 0;
    
    if (itemModel.itemType == CustomActionSheetItemTypeButton)
    {
        widgetHeight = itemButtonHeight;
        
        resultView = [self creatWidgetItemViewWithHeight:widgetHeight];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, resultView.frame.size.width, resultView.frame.size.height);
        [button setTitle:[NSString stringWithFormat:@"%@",itemModel.object]
                forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:1/255.0
                                              green:117/255.0
                                               blue:235.0/255.0
                                              alpha:1.0]
                     forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.tag = index;
        [button addTarget:self
                   action:@selector(didCustomActionSheetItemTouch:)
         forControlEvents:UIControlEventTouchUpInside];
        [resultView addSubview:button];
    }
    else if (itemModel.itemType == CustomActionSheetItemTypeImage)
    {
        UIImage *targetImage = (UIImage*)itemModel.object;
        widgetHeight = targetImage.size.height+20;
        resultView = [self creatWidgetItemViewWithHeight:widgetHeight];
        resultView.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(resultView.frame.size.width/2-targetImage.size.width/2,
                                                                               10,
                                                                               targetImage.size.width,
                                                                               targetImage.size.height)];
        [imageView setImage:targetImage];
        [resultView addSubview:imageView];
    }
    else if (itemModel.itemType == CustomActionSheetItemTypeTitle)
    {
        widgetHeight = itemButtonHeight;
        
        resultView = [self creatWidgetItemViewWithHeight:widgetHeight];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, resultView.frame.size.width, resultView.frame.size.height)];
        lable.text = [NSString stringWithFormat:@"%@",itemModel.object];
        lable.textColor = [UIColor colorWithRed:137/255.0
                                          green:137/255.0
                                           blue:137.0/255.0
                                          alpha:1.0];
        lable.font = [UIFont systemFontOfSize:13];
        lable.textAlignment = NSTextAlignmentCenter;
        [resultView addSubview:lable];
    }
    else if (itemModel.itemType == CustomActionSheetItemTypeCancel)
    {
        widgetHeight = itemButtonHeight;
        
        resultView = [self creatWidgetItemViewWithHeight:widgetHeight];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, resultView.frame.size.width, resultView.frame.size.height);
        [button setTitle:[NSString stringWithFormat:@"%@",itemModel.object]
                forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:1/255.0
                                              green:117/255.0
                                               blue:235.0/255.0
                                              alpha:1.0]
                     forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        button.tag = index;
        [button addTarget:self
                   action:@selector(didCustomActionSheetItemTouch:)
         forControlEvents:UIControlEventTouchUpInside];
        [resultView addSubview:button];
    }
    
    
    return resultView;
}

- (UIView*)creatWidgetItemViewWithHeight:(float)widgetHeight
{
    UIView * resultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, widgetHeight)];
    resultView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    
    return resultView;
}


- (void)didCustomActionSheetItemTouch:(UIButton*)sender
{
    if (sender.tag != 99)
    {
        if ([self.delegate respondsToSelector:@selector(customActionWillDismissWithButtonIndex:andActionSheetTag:)])
        {
            [self.delegate customActionWillDismissWithButtonIndex:sender.tag
                                                andActionSheetTag:self.tag];
        }
    }

    
    [self hideCustomActionSheetView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
