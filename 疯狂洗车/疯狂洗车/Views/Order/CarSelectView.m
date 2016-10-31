//
//  CarSelectView.m
//  优快保
//
//  Created by Darsky on 15/2/7.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CarSelectView.h"
#import "CarSelectCell.h"

@implementation CarSelectView

static NSString *cellIndentifier =  @"CarSelectCell";

+ (id)sharedCarSelectView
{
    static CarSelectView *carSelectView = nil;
    //
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{carSelectView = [[CarSelectView alloc] initWithFrame:[UIScreen mainScreen].bounds];});
    //
    return carSelectView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        float width = [UIScreen mainScreen].bounds.size.width - 40;
        float height = 200;

        UIButton  *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = self.bounds;
        [cancelButton setBackgroundColor:[UIColor clearColor]];
        [cancelButton addTarget:self action:@selector(hideCarSelectView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        _carView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-width/2,
                                                            [UIScreen mainScreen].bounds.size.height/2-height/2,
                                                            width, height)];
        _carView.backgroundColor = [UIColor whiteColor];
        _carView.layer.shadowPath =[UIBezierPath bezierPathWithRect:_carView.bounds].CGPath;
        _carView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        _carView.layer.shadowOffset = CGSizeMake(0, 4);
        _carView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
        _carView.layer.shadowRadius = 5;//阴影半径，默认3
        
        _carListView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     _carView.frame.size.width,
                                                                     _carView.frame.size.height-40)
                                                    style:UITableViewStylePlain];
        _carListView.dataSource = self;
        _carListView.delegate   = self;
        _carListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_carView addSubview:_carListView];
        
        UINib *nib = [UINib nibWithNibName:@"CarSelectCell" bundle:nil];
        [_carListView registerNib:nib
           forCellReuseIdentifier:cellIndentifier];
        

        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(0, _carView.frame.size.height-40, _carView.frame.size.width, 40);
        [_addButton setTitle:@"新增车辆" forState:UIControlStateNormal];
        [_addButton setBackgroundColor:[UIColor clearColor]];
        [_addButton setTitleColor:[UIColor orangeColor]
                         forState:UIControlStateNormal];
        [_addButton setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
        [_addButton addTarget:self
                       action:@selector(didAddButtonTouch)
             forControlEvents:UIControlEventTouchUpInside];
        [_carView addSubview:_addButton];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _carView.frame.size.width, 1)];
        lineLabel.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        [_addButton addSubview:lineLabel];
        
        [self addSubview:_carView];
    }
    
    return self;
}

#pragma mark - UITabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _carsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (cell == nil)
    {
        cell = [[CarSelectCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellIndentifier];
    }
    
    CarInfos *car = _carsArray[indexPath.row];
    
    NSString *carType = car.car_type.intValue == 1?@"轿车":@"SUV";
    cell.carInfoLabel.text = [NSString stringWithFormat:@"[%@] %@·%@",carType,[car.car_no substringWithRange:NSMakeRange(0, 2)],[car.car_no substringWithRange:NSMakeRange(2, car.car_no.length-2)]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectACar:)])
    {
        CarInfos *car = _carsArray[indexPath.row];
        
        [self.delegate didSelectACar:car];
    }
    [self hideCarSelectView];
}


#pragma mark - MainMethod

- (void)didAddButtonTouch
{
    if ([self.delegate respondsToSelector:@selector(didAddButtonTouched)])
    {
        [self.delegate didAddButtonTouched];
    }
    [self hideCarSelectView];
}

+ (void)showCarSelectViewWithCars:(NSArray*)cars
                        ForTarget:(id)target;
{
    [[CarSelectView sharedCarSelectView] showCarSelectViewWithCars:cars
                                                         ForTarget:target];
}

- (void)showCarSelectViewWithCars:(NSArray*)cars
                        ForTarget:(id)target;
{
    _carsArray = [cars mutableCopy];
    if (_carsArray.count > 4)
    {
        _carView.frame = CGRectMake(_carView.frame.origin.x, [UIScreen mainScreen].bounds.size.height/2-200/2, _carView.frame.size.width, 200);
        _carListView.frame = CGRectMake(0, 0, _carView.frame.size.width, _carView.frame.size.height-40);
        _carListView.scrollEnabled = YES;
        _addButton.frame = CGRectMake(0, _carView.frame.size.height-40, _carView.frame.size.width, 40);
        _carView.layer.shadowPath =[UIBezierPath bezierPathWithRect:_carView.bounds].CGPath;

        
    }
    else
    {
        float height = _carsArray.count*40;
        _carView.frame = CGRectMake(_carView.frame.origin.x, [UIScreen mainScreen].bounds.size.height/2-height/2-20, _carView.frame.size.width, height+40);
        _carListView.frame = CGRectMake(0, 0, _carView.frame.size.width, _carView.frame.size.height-40);
        _carListView.scrollEnabled = NO;
        _addButton.frame = CGRectMake(0, _carView.frame.size.height-40, _carView.frame.size.width, 40);
        _carView.layer.shadowPath =[UIBezierPath bezierPathWithRect:_carView.bounds].CGPath;
    }
    [_carListView reloadData];
    self.delegate = target;
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       UIWindow *window = [[UIApplication sharedApplication]keyWindow];
                       [window addSubview:self];
                       [self exChangeOutdur:0.3];
                   });
}



- (void)hideCarSelectView
{
    [self exChangeIndur:0.3];
    [self removeFromSuperview];
    
}

-(void)exChangeOutdur:(CFTimeInterval)dur
{
    if (self.delegate != nil)
    {
        CAKeyframeAnimation * animation;
        animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = dur;
        animation.delegate = self;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 0.3)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 0.5)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 0.7)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        animation.values = values;
        animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
        [_carView.layer addAnimation:animation forKey:nil];
    }
    
    return;
}

-(void)exChangeIndur:(CFTimeInterval)dur
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = dur;
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 0.7)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 0.5)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 0.1)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [_carView.layer addAnimation:animation forKey:nil];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
