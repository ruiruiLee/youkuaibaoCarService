//
//  LicensePlateSelecter.m
//  优快保
//
//  Created by cts on 15/3/19.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "LicensePlateSelecter.h"
#import "ProvincesCell.h"
#import "ChartCell.h"

@implementation LicensePlateSelecter

static NSString *provincesCellIdentifier = @"ProvincesCell";

static NSString *chartCellIdentifier     = @"ChartCell";


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        cancel.frame = self.bounds;
        [self addSubview:cancel];
        [cancel addTarget:self action:@selector(hideLincensePlateSelecter) forControlEvents:UIControlEventTouchUpInside];
        
        _provincesNameArray = @[@"京", @"沪", @"津", @"渝", @"黑", @"吉", @"辽", @"蒙", @"冀", @"新",
                                @"甘", @"青", @"陕", @"宁", @"豫", @"鲁", @"晋", @"皖", @"鄂", @"湘",
                                @"苏", @"川", @"黔", @"滇", @"桂", @"藏", @"浙", @"赣", @"粤", @"闽",
                                @"台", @"琼", @"港", @"澳"];
        
        _chartArray = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L",@"M",
                        @"N",@"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
        
        float selectViewWidth = [UIScreen mainScreen].bounds.size.width-100;
        float selectViewHeight = [UIScreen mainScreen].bounds.size.width-50;

        
        _selectView = [[UIView alloc] initWithFrame:CGRectMake(50, [UIScreen mainScreen].bounds.size.height/2-selectViewHeight/2,selectViewWidth, selectViewHeight)];
        [_selectView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _selectView.frame.size.width, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"车牌选择";
        [_selectView addSubview:_titleLabel];
        
        
        _provincesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                            _titleLabel.frame.size.height,
                                                                            120,
                                                                            _selectView.frame.size.height-_titleLabel.frame.size.height)
                                                           style:UITableViewStylePlain];
        _provincesTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _provincesTableView.delegate = self;
        _provincesTableView.dataSource = self;
        
        [_provincesTableView registerNib:[UINib nibWithNibName:provincesCellIdentifier
                                                        bundle:[NSBundle mainBundle]]
                  forCellReuseIdentifier:provincesCellIdentifier];
        
        _chartTableView = [[UITableView alloc] initWithFrame:CGRectMake(_provincesTableView.frame.size.width,
                                                                            _titleLabel.frame.size.height,
                                                                            _selectView.frame.size.width-_provincesTableView.frame.size.width,
                                                                            _selectView.frame.size.height-_titleLabel.frame.size.height)
                                                           style:UITableViewStylePlain];
        _chartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chartTableView.backgroundColor = [UIColor clearColor];
        _chartTableView.delegate = self;
        _chartTableView.dataSource = self;
        
        [_chartTableView registerNib:[UINib nibWithNibName:chartCellIdentifier
                                                    bundle:[NSBundle mainBundle]]
              forCellReuseIdentifier:chartCellIdentifier];
        
        _selectView.layer.masksToBounds = YES;
        _selectView.layer.cornerRadius = 10;
        [_selectView addSubview:_provincesTableView];
        [_selectView addSubview:_chartTableView];
        _chartTableView.hidden = YES;
        
        
        [self addSubview:_selectView];
        
        
    }
    
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _provincesTableView)
    {
        return _provincesNameArray.count;
    }
    else
    {
        return _chartArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _provincesTableView)
    {
        ProvincesCell *cell = [tableView dequeueReusableCellWithIdentifier:provincesCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[ProvincesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:provincesCellIdentifier];
        }
        
        cell.provincesLabel.text = _provincesNameArray[indexPath.row];
        return cell;
    }
    else
    {
        ChartCell *cell = [tableView dequeueReusableCellWithIdentifier:chartCellIdentifier];
        if (cell == nil)
        {
            cell = [[ChartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chartCellIdentifier];
        }
        
        cell.chartLabel.text = _chartArray[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _provincesTableView)
    {
        [_chartTableView deselectRowAtIndexPath:_chartTableView.indexPathForSelectedRow animated:NO];
        [_chartTableView setContentOffset:CGPointMake(0, 0)];
        _chartTableView.hidden = NO;
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(didFinishLicensePlateSelect:)])
        {
            NSString *provinceString = _provincesNameArray[_provincesTableView.indexPathForSelectedRow.row];
            NSString *chartString = _chartArray[indexPath.row];

            [self.delegate didFinishLicensePlateSelect:[NSString stringWithFormat:@"%@%@",provinceString,chartString]];
        }
        [self hideLincensePlateSelecter];
    }
}

- (void)showLincensePlateSelecter
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
        [self exChangeOutdur:0.5];
        
    });
}

-(void)exChangeOutdur:(CFTimeInterval)dur
{
    _selectView.hidden = NO;
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
    [_selectView.layer addAnimation:animation forKey:nil];
    self.backgroundColor = [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:0.7];
}

#pragma mark UIGestureRecognizer Method

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == _selectView||
        [touch.view isKindOfClass:[UITableView class]]||
        [touch.view isKindOfClass:[UITableViewCell class]])
    {
        return NO;
    }
    return YES;
}


- (void)hideLincensePlateSelecter
{
    [self removeFromSuperview];
}

@end
