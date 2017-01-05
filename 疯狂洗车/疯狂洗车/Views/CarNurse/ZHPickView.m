//
//  ZHPickView.m
//  ZHpickView
//
//  Created by liudianling on 14-11-18.
//  Copyright (c) 2014年 赵恒志. All rights reserved.
//
#define ZHToobarHeight 40
#import "ZHPickView.h"
#import "define.h"
#import "Util.h"
#import "Constants.h"

#define TIME_LIMIT 5

@interface ZHPickView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    int timeLimited;
}
@property(nonatomic,copy)NSString *plistName;
@property(nonatomic,strong)NSArray *plistArray;
@property(nonatomic,assign)BOOL isLevelArray;
@property(nonatomic,assign)BOOL isLevelString;
@property(nonatomic,assign)BOOL isLevelDic;
@property(nonatomic,strong)NSDictionary *levelTwoDic;
@property(nonatomic,strong)UIToolbar *toolbar;
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic,assign)NSDate *defaulDate;
@property(nonatomic,assign)BOOL isHaveNavControler;
@property(nonatomic,assign)NSInteger pickeviewHeight;
@property(nonatomic,copy)NSString *resultString;
@property(nonatomic,strong)NSMutableArray *componentArray;
@property(nonatomic,strong)NSMutableArray *dicKeyArray;
@property(nonatomic,copy)NSMutableArray *state;
@property(nonatomic,copy)NSMutableArray *city;

//add
@property (nonatomic, copy) NSMutableArray *dayArray;
@property (nonatomic, copy) NSMutableArray *hourArray;

@end

@implementation ZHPickView

-(NSArray *)plistArray{
    if (_plistArray==nil) {
        _plistArray=[[NSArray alloc] init];
    }
    return _plistArray;
}

-(NSArray *)componentArray{

    if (_componentArray==nil) {
        _componentArray=[[NSMutableArray alloc] init];
    }
    return _componentArray;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpToolBar];
        
    }
    return self;
}


-(instancetype)initPickviewWithPlistName:(NSString *)plistName isHaveNavControler:(BOOL)isHaveNavControler{
    
    self=[super init];
    if (self) {
        timeLimited = TIME_LIMIT;
        _plistName=plistName;
        self.plistArray=[self getPlistArrayByplistName:plistName];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
        
    }
    return self;
}
-(instancetype)initPickviewWithArray:(NSArray *)array isHaveNavControler:(BOOL)isHaveNavControler{
    self=[super init];
    if (self) {
        timeLimited = TIME_LIMIT;
        
        self.plistArray=array;
        _dayArray = [[NSMutableArray alloc] initWithArray:array[0]];
//        _hourArray = [[NSMutableArray alloc] initWithArray:array[1]];
        [self newHourDateArray:0];
        [self setArrayClass:array];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}

- (void) setPickviewWithArray:(NSArray*) array
{
    timeLimited = TIME_LIMIT;
    
    self.plistArray=array;
    _dayArray = [[NSMutableArray alloc] initWithArray:array[0]];
    //        _hourArray = [[NSMutableArray alloc] initWithArray:array[1]];
    [self newHourDateArray:0];
    [self setArrayClass:array];
    [self setUpPickView];
    
    [_pickerView reloadComponent:1];
}

-(instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler{
    
    self=[super init];
    if (self) {
        timeLimited = TIME_LIMIT;
        
        _defaulDate=defaulDate;
        [self setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode];
        [self setFrameWith:isHaveNavControler];
    }
    return self;
}


-(NSArray *)getPlistArrayByplistName:(NSString *)plistName{
    
    NSString *path= [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray * array=[[NSArray alloc] initWithContentsOfFile:path];
    [self setArrayClass:array];
    return array;
}

-(void)setArrayClass:(NSArray *)array{
    _dicKeyArray=[[NSMutableArray alloc] init];
    for (id levelTwo in array) {
        
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            _isLevelArray=YES;
            _isLevelString=NO;
            _isLevelDic=NO;
        }else if ([levelTwo isKindOfClass:[NSString class]]){
            _isLevelString=YES;
            _isLevelArray=NO;
            _isLevelDic=NO;
            
        }else if ([levelTwo isKindOfClass:[NSDictionary class]])
        {
            _isLevelDic=YES;
            _isLevelString=NO;
            _isLevelArray=NO;
            _levelTwoDic=levelTwo;
            [_dicKeyArray addObject:[_levelTwoDic allKeys] ];
        }
    }
}

-(void)setFrameWith:(BOOL)isHaveNavControler{
    CGFloat toolViewX = 0;
    CGFloat toolViewH = _pickeviewHeight+ZHToobarHeight;
    CGFloat toolViewY ;
    if (isHaveNavControler) {
        toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH-50;
    }else {
        toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH;
    }
    CGFloat toolViewW = [UIScreen mainScreen].bounds.size.width;
    self.frame = CGRectMake(toolViewX, toolViewY, toolViewW, toolViewH);
}
-(void)setUpPickView{
    
    UIPickerView *pickView=[[UIPickerView alloc] init];
    pickView.backgroundColor=_COLOR(252, 252, 252);
    _pickerView=pickView;
    pickView.delegate=self;
    pickView.dataSource=self;
    pickView.frame=CGRectMake(0, ZHToobarHeight, pickView.frame.size.width, pickView.frame.size.height);
    _pickeviewHeight=pickView.frame.size.height;
    [self addSubview:pickView];
}

-(void)setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode{
    UIDatePicker *datePicker=[[UIDatePicker alloc] init];
    
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.datePickerMode = datePickerMode;
    datePicker.backgroundColor=_COLOR(252, 252, 252);
    if (_defaulDate) {
        [datePicker setDate:_defaulDate];
    }
    _datePicker=datePicker;
    datePicker.frame=CGRectMake(0, ZHToobarHeight, datePicker.frame.size.width, datePicker.frame.size.height);
    _pickeviewHeight=datePicker.frame.size.height;
    [self addSubview:datePicker];
}

-(void)setUpToolBar{
    _toolbar=[self setToolbarStyle];
    [self setToolbarWithPickViewFrame];
    [self addSubview:_toolbar];
}
-(UIToolbar *)setToolbarStyle{
    UIToolbar *toolbar=[[UIToolbar alloc] init];
    
    UIBarButtonItem *leftSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    leftSpace.width = 15;
    
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:Abled_Color forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.titleLabel.font = _FONT(16);
    UIBarButtonItem *lefttem = [[UIBarButtonItem alloc] initWithCustomView:btnCancel];
    
    UIBarButtonItem *centerlSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, STATIC_SCREEN_HEIGHT, 20)];
    lbTitle.textColor = _COLOR(0x66, 0x66, 0x66);
    lbTitle.font = _FONT(14);
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.text = @"选择上门时间";
    lbTitle.textAlignment = NSTextAlignmentCenter;
    UIBarButtonItem *centeritem = [[UIBarButtonItem alloc] initWithCustomView:lbTitle];
    
    UIBarButtonItem *centerrSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [btnRight setTitle:@"确定" forState:UIControlStateNormal];
    [btnRight setTitleColor:Abled_Color forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    btnRight.titleLabel.font = _FONT(16);
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    
    UIBarButtonItem *rightSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    rightSpace.width = 15;
    
    toolbar.items=@[leftSpace,lefttem,centerlSpace, centeritem,centerrSpace, right,rightSpace];
    toolbar.backgroundColor = _COLOR(166, 166, 166);
    return toolbar;
}
-(void)setToolbarWithPickViewFrame{
    _toolbar.frame=CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, ZHToobarHeight);
}

#pragma mark piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    NSInteger component;
    component=_plistArray.count;
    return component;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
        return [_dayArray count];
    else
        return [_hourArray count];
}

- (NSString*) GetWeekString:(NSInteger) idx
{
    NSString *weekDay = @"";
    switch (idx) {
        case 1:
            weekDay=@"周日";
            break;
        case 2:
            weekDay=@"周一";
            break;
        case 3:
            weekDay=@"周二";
            break;
        case 4:
            weekDay=@"周三";
            break;
        case 5:
            weekDay=@"周四";
            break;
        case 6:
            weekDay=@"周五";
            break;
        case 7:
            weekDay=@"周六";
            break;
            
        default:
            break;
    }
    return weekDay;
}

#pragma mark UIPickerViewdelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *rowTitle=nil;
    if (_isLevelArray) {
        
        if(component == 0){
            NSDate *date = _dayArray[row];
            NSDate *cur = [NSDate date];
            
            NSCalendar *hebrew = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit;
            NSDateComponents *components = [hebrew components:unitFlags fromDate:date];
            
            NSInteger day1 = [components day]; // 15
            NSInteger month1 = [components month]; // 9
            NSInteger year1 = [components year]; // 5764
            
            NSDateComponents *components2 = [hebrew components:unitFlags fromDate:cur];
            NSInteger day2 = [components2 day]; // 15
            NSInteger month2 = [components2 month]; // 9
            NSInteger year2 = [components2 year]; // 5764
            
            if(month1 == month2 && year1 == year2){
                if(day1 == day2){
                    rowTitle = @"今天";
                }else{
                    rowTitle = [NSString stringWithFormat:@"%@%2ld月%2ld日", [self GetWeekString:[components weekday]], month1, day1];
                }
            }else{
                rowTitle = [NSString stringWithFormat:@"%@%2ld月%2ld日", [self GetWeekString:[components weekday]], month1, day1];
            }
        }
        else{
            rowTitle = [NSString stringWithFormat:@"%@时",  _hourArray[row]];
        }
        
    }else if (_isLevelString){
        rowTitle=_plistArray[row];
    }else if (_isLevelDic){
        NSInteger pIndex = [pickerView selectedRowInComponent:0];
        NSDictionary *dic=_plistArray[pIndex];
        if(component%2==0)
        {
            rowTitle=_dicKeyArray[row][component];
        }
        for (id aa in [dic allValues]) {
           if ([aa isKindOfClass:[NSArray class]]&&component%2==1){
                NSArray *bb=aa;
                if (bb.count>row) {
                    rowTitle=aa[row];
                }
                
            }
        }
    }
    return rowTitle;
}

-(void)newHourDateArray:(int) row
{
    NSDate *date = _dayArray[row];
    NSDate *cur = [NSDate date];
    
    NSCalendar *hebrew = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit;
    NSDateComponents *components = [hebrew components:unitFlags fromDate:date];
    
    NSInteger day1 = [components day]; // 15
    NSInteger month1 = [components month]; // 9
    NSInteger year1 = [components year]; // 5764
    
    NSDateComponents *components2 = [hebrew components:unitFlags fromDate:cur];
    NSInteger day2 = [components2 day]; // 15
    NSInteger month2 = [components2 month]; // 9
    NSInteger year2 = [components2 year]; // 5764
    NSInteger hour2 = [components2 hour];
    
    if(month1 == month2 && year1 == year2 && day1 == day2)
    {
        _hourArray = [[NSMutableArray alloc] init];
        NSArray *array = _plistArray[1];
        for (int i = 0; i < [array count]; i++) {
            int num = [[array objectAtIndex:i] intValue];
            if(num > hour2 + 1)
                [_hourArray addObject:[array objectAtIndex:i]];
        }
    }
    else{
        _hourArray = [[NSMutableArray alloc] initWithArray:_plistArray[1]];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if( component == 0){
        [self newHourDateArray:(int)row];
        [pickerView reloadComponent:1];
    }
    
    if (_isLevelDic&&component%2==0) {
        
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }
    if (_isLevelString) {
        _resultString=_plistArray[row];
        
    }else if (_isLevelArray){
        _resultString=@"";
        if (![self.componentArray containsObject:@(component)]) {
            [self.componentArray addObject:@(component)];
        }
        
        for (int i=0; i<_plistArray.count;i++) {
            if ([self.componentArray containsObject:@(i)]) {
                NSInteger cIndex = [pickerView selectedRowInComponent:i];
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][cIndex]];
            }else{
                _resultString=[NSString stringWithFormat:@"%@%@",_resultString,_plistArray[i][0]];
            }
        }
    }else if (_isLevelDic){
        if (component==0) {
          _state =_dicKeyArray[row][0];
        }else{
            NSInteger cIndex = [pickerView selectedRowInComponent:0];
            NSDictionary *dicValueDic=_plistArray[cIndex];
            NSArray *dicValueArray=[dicValueDic allValues][0];
            if (dicValueArray.count>row) {
                _city =dicValueArray[row];
            }
        }
    }
}

-(void)remove{
    
    [self removeFromSuperview];
}
-(void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}
-(void)doneClick
{
    NSInteger cIndex = [_pickerView selectedRowInComponent:0];
    NSDate *date = _dayArray[cIndex];
    NSCalendar *hebrew = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit;
    NSDateComponents *components = [hebrew components:unitFlags fromDate:date];
    NSInteger day1 = [components day]; // 15
    NSInteger month1 = [components month]; // 9
    NSInteger year1 = [components year]; // 5764
    if (_hourArray.count==0) {
        return;
    }
    cIndex = [_pickerView selectedRowInComponent:1];
    int hour = [_hourArray[cIndex] intValue];
    
    NSDate *returndate = [Constants convertDateFromString:[NSString stringWithFormat:@"%4ld-%2ld-%2ld %2d", year1, month1, day1, hour]];
    
    if ([self.delegate respondsToSelector:@selector(toobarDonBtnHaveClick:resultDate:)]) {
        [self.delegate toobarDonBtnHaveClick:self resultDate:returndate];
    }
    [self removeFromSuperview];
}

/**
 *  设置PickView的颜色
 */
-(void)setPickViewColer:(UIColor *)color{
    _pickerView.backgroundColor=color;
}
/**
 *  设置toobar的文字颜色
 */
-(void)setTintColor:(UIColor *)color{
    
    _toolbar.tintColor=color;
}
/**
 *  设置toobar的背景颜色
 */
-(void)setToolbarTintColor:(UIColor *)color{
    
    _toolbar.barTintColor=color;
}
-(void)dealloc{
    
    //NSLog(@"销毁了");
}
@end


