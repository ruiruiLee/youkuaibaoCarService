//
//  OrderTimerPickerView.h
//  优快保
//
//  Created by cts on 15/3/26.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderTimerRealPickerViewDelegate <NSObject>

- (void)didFinishOrderTimerPicker:(NSString*)resultString;


@end

@interface OrderTimerRealPickerView : UIView 
{
    UILabel       *_titleLabel;
    
    UIView        *_timeView;
    
    UIDatePicker  *_datePickerView;
        
    UIButton      *_cancelButton;
    
    UIButton      *_submitButton;
    
    NSRange        _timeRange;
    
}

- (void)showOrderTimerPickerView;

@property (assign, nonatomic) id <OrderTimerRealPickerViewDelegate> delegate;

@property (assign, nonatomic) NSTimeInterval carWashCountDownDuration;

@property (assign, nonatomic) BOOL  showLimite;

- (id)initWithFrame:(CGRect)frame withTimeRange:(NSRange)timeRange;

@end
