/*!
 @header NSTimer+Addition.h
 @abstract NSTimer 类别，主要增加暂停，重新启动，延迟一段时间后启动等操作
 @author Created by 朱伟铭 on 14-8-11.
 @version Copyright (c) 2014年 HFT_SOFT. All rights reserved.
 */

#import <Foundation/Foundation.h>

/*!
 @category NSTimer
 @abstract NSTimer的Category，主要增加暂停，重新启动，延迟一段时间后启动等操作
 */
@interface NSTimer (Addition)

/*!
 @method
 @abstract 暂停timer
 @discussion 通过setFireDate 无限制延期实现
 @result void
 */
- (void)pauseTimer;

/*!
 @method
 @abstract 重启timer
 @discussion 通过setFireDate 为当前时间实现重启操作
 @result void
 */
- (void)resumeTimer;

/*!
 @method
 @abstract 延迟一段时间后重启timer
 @discussion 通过setFireDate 当前时间延迟interval秒后重启
 @param interval 延迟的时间数
 @result void
 */
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
