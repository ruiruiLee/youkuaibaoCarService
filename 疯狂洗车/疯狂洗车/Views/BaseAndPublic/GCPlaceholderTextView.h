/*!
 @header GCPlaceholderTextView.h
 @abstract 用于显示带placeholder的UITextView
 @author Created by 朱伟铭 on 14-4-23.
 @version Copyright (c) 2014年 HFT_SOFT. All rights reserved.
 */

#import <UIKit/UIKit.h>

/*!
 @class GCPlaceholderTextView
 @abstract 用于显示带placeholder的UITextView，可以自定义placeholder的文字，真实文字的颜色，placeholder的颜色
 */
@interface GCPlaceholderTextView : UITextView 

/*!
 @property placeholder
 @abstract placeholder 文字
 */
@property(nonatomic, strong) NSString *placeholder;

/*!
 @property realTextColor
 @abstract 真实文字的颜色，设置后会自动刷新显示(UI_APPEARANCE_SELECTOR)
 */
@property (nonatomic, strong) UIColor *realTextColor UI_APPEARANCE_SELECTOR;

/*!
 @property placeholderColor
 @abstract placeholder文字的颜色，设置后会自动刷新显示(UI_APPEARANCE_SELECTOR)
 */
@property (nonatomic, strong) UIColor *placeholderColor UI_APPEARANCE_SELECTOR;

@end
