//
//  OrderTimerPickerView.m
//  优快保
//
//  Created by cts on 15/3/26.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "OrderTimerPickerView.h"

@implementation OrderTimerPickerView


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
        
        _datePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40,_timeView.frame.size.width, _timeView.frame.size.height-84)];
        _datePickerView.dataSource = self;
        _datePickerView.delegate = self;
        

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PRC"];
        [formatter setTimeZone:timeZone];
        
        NSDate *todayDate = [NSDate date];
        
        NSString *todayDateString = [formatter stringFromDate:todayDate];
        
        
        _dayArray = [NSMutableArray array];
        [_dayArray addObject:todayDateString];
        
        for (int x = 1; x<=6; x++)
        {
            NSDate *tmpDate = [todayDate dateByAddingTimeInterval:24*60*60*x];
            NSString *timeString = [formatter stringFromDate:tmpDate];
            [_dayArray addObject:timeString];
            
        }
        
        [_timeView addSubview:_datePickerView];
        
        double minHour = _timeRange.location/3600;
        double maxHour = _timeRange.length/3600;
        
        int hourInterval = maxHour - minHour;
        
        _hourArray = [NSMutableArray array];
        if (minHour < 10)
        {
            [_hourArray addObject:[NSString stringWithFormat:@"0%d",(int)minHour]];
        }
        else
        {
            [_hourArray addObject:[NSString stringWithFormat:@"%d",(int)minHour]];
        }
        for (int x = 1; x< hourInterval; x++)
        {
            int targetHour = minHour + x;
            if (targetHour < 10)
            {
                [_hourArray addObject:[NSString stringWithFormat:@"0%d",(int)targetHour]];
            }
            else
            {
                [_hourArray addObject:[NSString stringWithFormat:@"%d",(int)targetHour]];
            }
        }
        if (maxHour < 10)
        {
            [_hourArray addObject:[NSString stringWithFormat:@"0%d",(int)maxHour]];
        }
        else
        {
            [_hourArray addObject:[NSString stringWithFormat:@"%d",(int)maxHour]];
        }
        
        [_datePickerView reloadAllComponents];
        
        NSDateFormatter *formatterHour = [[NSDateFormatter alloc] init];
        [formatterHour setDateFormat:@"HH:mm"];
        [formatterHour setTimeZone:timeZone];
        
        int  currentHour = [[formatterHour stringFromDate:todayDate] substringWithRange:NSMakeRange(0, 2)].intValue;
        int  currentMin = [[formatterHour stringFromDate:todayDate] substringWithRange:NSMakeRange(3, 2)].intValue;
        
        if (currentHour >= (int)maxHour)
        {
            if (currentMin > 0)
            {
                [_dayArray removeObjectAtIndex:0];
            }
            else
            {
                [_datePickerView selectRow:1 inComponent:2 animated:NO];
            }
        }
        else if (currentHour < minHour)
        {

        }
        else
        {
            for (int x = 0; x<_hourArray.count; x++)
            {
                NSString *hourString = _hourArray[x];
                if (hourString.intValue == currentHour)
                {
                    if (currentMin == 0)
                    {
                        [_datePickerView selectRow:x inComponent:1 animated:NO];
                        [_datePickerView selectRow:0 inComponent:2 animated:NO];
                    }
                    else if (currentMin > 30)
                    {
                        [_datePickerView selectRow:x+1 inComponent:1 animated:NO];
                        [_datePickerView selectRow:1 inComponent:2 animated:NO];
                    }
                    else
                    {
                        [_datePickerView selectRow:x+1 inComponent:1 animated:NO];
                        [_datePickerView selectRow:0 inComponent:2 animated:NO];
                    }
                }
            }
        }
        
        
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
    NSString *dayString = _dayArray[[_datePickerView selectedRowInComponent:0]];
    NSString *hourString = _hourArray[[_datePickerView selectedRowInComponent:1]];
    NSString *minString = nil;
    if ([_datePickerView selectedRowInComponent:2] > 0)
    {
       minString = @"30";
    }
    else
    {
        minString = @"00";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSString *targetTimeString = [NSString stringWithFormat:@"%@ %@:%@",dayString,hourString,minString];
    
    NSDate *targetDate = [formatter dateFromString:targetTimeString];
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval time = [targetDate timeIntervalSinceDate:currentDate];
    
    NSTimeInterval targetTime = hourString.intValue*60*60+minString.intValue*60;
    
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

    if (time <= 1800 && self.showLimite)
    {
        [Constants showMessage:@"请选择您半小时以后的时间"];
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(didFinishOrderTimerPicker:)])
        {
            
            [self.delegate didFinishOrderTimerPicker:targetTimeString];
        }
        [self didCancelButtonTouch];
    }
    

}


#pragma mark - UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return _dayArray.count;
    }
    else if (component == 1)
    {
        return _hourArray.count;
    }
    else
    {
        return 2;
    }
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return _dayArray[row];
    }
    else if (component == 1)
    {
        return _hourArray[row];
    }
    else
    {
        if (row == 0)
        {
            return @"00";
        }
        else
        {
            return @"30";
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0)
    {
        return SCREEN_WIDTH*0.6;
    }
    else if (component == 1)
    {
        return SCREEN_WIDTH*0.2;
    }
    else
    {
        return SCREEN_WIDTH*0.2;
    }
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
