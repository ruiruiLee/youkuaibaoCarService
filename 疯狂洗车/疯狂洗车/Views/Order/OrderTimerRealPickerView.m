//
//  OrderTimerPickerView.m
//  优快保
//
//  Created by cts on 15/3/26.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "OrderTimerRealPickerView.h"

@implementation OrderTimerRealPickerView


- (id)initWithFrame:(CGRect)frame withTimeRange:(NSRange)timeRange
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
        _timeRange = timeRange;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        float timeWidth = [UIScreen mainScreen].bounds.size.width;

        _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, timeWidth, timeWidth)];
        _timeView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _timeView.backgroundColor = [UIColor whiteColor];
        _timeView.layer.masksToBounds = YES;
        _timeView.layer.cornerRadius = 5;
        
        [self addSubview:_timeView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _timeView.frame.size.width, 40)];
        _titleLabel.text = @"请选择服务时间";
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_timeView addSubview:_titleLabel];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40, _timeView.frame.size.width, 1)];
        topLine.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
        
        [_timeView addSubview:topLine];
        
        _datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40,_timeView.frame.size.width, _timeView.frame.size.height-84)];
        
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PRC"];
        [_datePickerView setTimeZone:timeZone];
        [_datePickerView setMinimumDate:[NSDate date]];
        [_datePickerView setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:24*60*60*7]];
        

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        
        [_timeView addSubview:_datePickerView];
        
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, _timeView.frame.size.height-44, _timeView.frame.size.width/2, 44);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(didCancelButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        [_timeView addSubview:_cancelButton];
        
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.frame = CGRectMake(_timeView.frame.size.width/2, _timeView.frame.size.height-44, _timeView.frame.size.width/2, 44);
        [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(didSubmitButtonTouch) forControlEvents:UIControlEventTouchUpInside];
        [_timeView addSubview:_submitButton];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, _timeView.frame.size.height-44, _timeView.frame.size.width, 1)];
        bottomLine.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
        
        [_timeView addSubview:bottomLine];
    }
    
    return self;
}

- (void)setCarWashCountDownDuration:(NSTimeInterval)carWashCountDownDuration
{
    _carWashCountDownDuration = carWashCountDownDuration;
//    if (_timePickerView)
//    {
//        _timePickerView.countDownDuration = _carWashCountDownDuration;
//    }
}

- (void)didCancelButtonTouch
{
    [self removeFromSuperview];
}

- (void)showOrderTimerPickerView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
        //[self updateMinTime];
        [self exChangeOutdur:0.3];
        
    });
}


-(void)exChangeOutdur:(CFTimeInterval)dur
{
    _timeView.hidden = NO;
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = dur;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [_timeView.layer addAnimation:animation forKey:nil];
    self.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:0.7];
}

- (void)didSubmitButtonTouch
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSString *targetTimeString = [formatter stringFromDate:_datePickerView.date];
    NSString *hourString = [targetTimeString substringWithRange:NSMakeRange(11, 2)];
    NSString *minString = [targetTimeString substringWithRange:NSMakeRange(targetTimeString.length-2, 2)];
    NSTimeInterval targetTime = hourString.intValue*60*60+minString.intValue*60;
    if (self.showLimite)
    {
        if (targetTime > _timeRange.length || targetTime < _timeRange.location)
        {
            int minHourInt = (double)_timeRange.location/60/60;
            NSString *minHourString = minHourInt<10?[NSString stringWithFormat:@"0%d",minHourInt]:[NSString stringWithFormat:@"%d",minHourInt];
            int minMinInt = (int)(_timeRange.location - minHourInt*60*60)/60;
            NSString *minMinString = minMinInt<10?[NSString stringWithFormat:@"0%d",minMinInt]:[NSString stringWithFormat:@"%d",minMinInt];
            
            
            int maxHourInt = (double)_timeRange.length/60/60;
            NSString *maxHourString = maxHourInt<10?[NSString stringWithFormat:@"0%d",maxHourInt]:[NSString stringWithFormat:@"%d",maxHourInt];
            
            int maxMinInt = (int)(_timeRange.length - maxHourInt*60*60)/60;
            NSString *maxMinString = maxMinInt<10?[NSString stringWithFormat:@"0%d",maxMinInt]:[NSString stringWithFormat:@"%d",maxMinInt];
            
            
            NSString *bussnessTime = [NSString stringWithFormat:@"请选择营业时间(%@:%@~%@:%@)范围内",minHourString,minMinString,maxHourString,maxMinString];
            
            [Constants showMessage:bussnessTime];
            return;
        }
    }
   
    
    if ([self.delegate respondsToSelector:@selector(didFinishOrderTimerPicker:)])
    {
        
        [self.delegate didFinishOrderTimerPicker:targetTimeString];
    }
    [self didCancelButtonTouch];
}


#pragma mark - UIPickerViewDelegate

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
