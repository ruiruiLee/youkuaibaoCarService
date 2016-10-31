//
//  OrderTimerPickerView.h
//  优快保
//
//  Created by cts on 15/3/26.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderTimerPickerViewDelegate <NSObject>

- (void)didFinishOrderTimerPicker:(NSString*)resultString;


@end

@interface OrderTimerPickerView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>
{
    UILabel       *_titleLabel;
    
    UIView        *_timeView;
    
    UIPickerView  *_datePickerView;
    
    UIButton      *_cancelButton;
    
    UIButton      *_submitButton;
    
    NSRange        _timeRange;
    
    NSMutableArray *_dayArray;
    
    NSMutableArray *_hourArray;
}

- (void)showOrderTimerPickerView;

@property (assign, nonatomic) id <OrderTimerPickerViewDelegate> delegate;

@property (assign, nonatomic) NSTimeInterval carWashCountDownDuration;

@property (assign, nonatomic) BOOL  showLimite;

- (id)initWithFrame:(CGRect)frame withTimeRange:(NSRange)timeRange;

@end
