//
//  InsuranceCustomValueSelectView.m
//  
//
//  Created by cts on 15/10/15.
//
//

#import "InsuranceCustomValueSelectView.h"
#import "InsuranceCustomValueCell.h"

@implementation InsuranceCustomValueSelectView

static NSString *insuranceCustomValueCellIdentifier = @"InsuranceCustomValueCell";


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _valueSelectView.layer.masksToBounds = YES;
    _valueSelectView.layer.cornerRadius = 5;
    
    [_contextTableView registerNib:[UINib nibWithNibName:insuranceCustomValueCellIdentifier
                                                  bundle:[NSBundle mainBundle]]
            forCellReuseIdentifier:insuranceCustomValueCellIdentifier];
    
    if (SCREEN_HEIGHT <= 568)
    {
        _maxRowNumber = 4;
    }
    else if (SCREEN_WIDTH < 414 )
    {
        _maxRowNumber = 6;
    }
    else
    {
        _maxRowNumber = 7;
    }
    
    _cancelButton.layer.masksToBounds = YES;
    _cancelButton.layer.cornerRadius = 5;
    _cancelButton.layer.borderWidth = 1;
    _cancelButton.layer.borderColor = [UIColor colorWithRed:235/255.0 green:84/255.0 blue:1/255.0 alpha:1.0].CGColor;
    
    _confirmButton.layer.masksToBounds = YES;
    _confirmButton.layer.cornerRadius = 5;

    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)showAndSetUpWithPropertyModel:(InsuranceCustomSelectModel*)model
{
    _selectValueTitleLabel.text = model.selectTitle;
    _selectValueIntroLabel.text = model.selectIntro;
    _selectValueDesclabel.text = model.selectDesc;
    
    _selectItemIndex = model.selectedIndex;
    
    if (model.bjmpEnable)
    {
        _bjmpView.hidden = NO;
        [_bjmpSwitch setOn:model.bjmpSelected];
        if (model.selectedIndex == 0)
        {
            _bjmpSwitch.userInteractionEnabled = NO;
        }
        else
        {
            _bjmpSwitch.userInteractionEnabled = YES;
        }
    }
    else
    {
        _bjmpView.hidden = YES;
    }
    
    _settingPropertyModel = model;
    
    [_contextTableView reloadData];
    
    [self updateContextTableViewConstraints];
    
    [self updateBjmpViewConstraints];
    
    [self showCusotomValueSelectViewOnWindow];
}

#pragma mark - 更熟列表和约束的代码

- (void)updateContextTableViewConstraints
{
    for (int x = 0; x<_contextTableView.constraints.count; x++)
    {
        NSLayoutConstraint *layoutConstraint = _contextTableView.constraints[x];
        if (layoutConstraint.firstAttribute == NSLayoutAttributeHeight)
        {
            [_contextTableView removeConstraint:layoutConstraint];
            break;
        }
        
    }

    

    NSDictionary* views = NSDictionaryOfVariableBindings(_contextTableView);
    
    NSString *constrainString = nil;
    
    if (_settingPropertyModel.itemsArray.count > _maxRowNumber)
    {
        constrainString = [NSString stringWithFormat:@"V:[_contextTableView(%d)]",_maxRowNumber*40];
        _contextTableView.scrollEnabled = YES;
    }
    else
    {
        constrainString = [NSString stringWithFormat:@"V:[_contextTableView(%d)]",(int)_settingPropertyModel.itemsArray.count*40];
        _contextTableView.scrollEnabled = NO;
    }
    
    
    [_contextTableView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constrainString
                                                                        options:0
                                                                        metrics:nil
                                                                          views:views]];

}

- (void)updateBjmpViewConstraints
{
    for (int x = 0; x<_bjmpView.constraints.count; x++)
    {
        NSLayoutConstraint *layoutConstraint = _bjmpView.constraints[x];
        if (layoutConstraint.firstAttribute == NSLayoutAttributeHeight)
        {
            [_bjmpView removeConstraint:layoutConstraint];
            break;
        }
        
    }
    
    NSDictionary* views = NSDictionaryOfVariableBindings(_bjmpView);
    
    NSString *constrainString = nil;
    
    if (_bjmpView.hidden)
    {
        constrainString = @"V:[_bjmpView(0)]";
    }
    else
    {
        constrainString = @"V:[_bjmpView(40)]";
    }
    
    
    [_bjmpView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:constrainString
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views]];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _settingPropertyModel.itemsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InsuranceCustomValueCell *cell = [tableView dequeueReusableCellWithIdentifier:insuranceCustomValueCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[InsuranceCustomValueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:insuranceCustomValueCellIdentifier];
    }
    
    InsuranceCustomValueModel *model = _settingPropertyModel.itemsArray[indexPath.row];
    
    [cell setDisplayEventName:model.valueName];
    if (_selectItemIndex == indexPath.row)
    {
        cell.selectIcon.highlighted = YES;
    }
    else
    {
        cell.selectIcon.highlighted = NO;
    }
    
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _selectItemIndex)
    {
        
    }
    else
    {
        _selectItemIndex = indexPath.row;
        if (indexPath.row == 0)
        {
            _bjmpSwitch.userInteractionEnabled = NO;
            [_bjmpSwitch setOn:NO
                      animated:YES];
        }
        else
        {
            _bjmpSwitch.userInteractionEnabled = YES;
        }
        [_contextTableView reloadData];
    }
}

#pragma mark - 现实或隐藏整个view的代码

- (void)showCusotomValueSelectViewOnWindow
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
        //[self updateMinTime];
        [self exChangeOutdur:0.3];
        [_contextTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectItemIndex
                                                                     inSection:0]
                                 atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
    });
}



-(void)exChangeOutdur:(CFTimeInterval)dur
{
    _valueSelectView.hidden = NO;
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
    [_valueSelectView.layer addAnimation:animation forKey:nil];
}

- (IBAction)didCancelButtonTouch:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)didConfirmButtonTouch:(id)sender
{
    InsuranceCustomSelectModel *resuletModel = _settingPropertyModel;
    resuletModel.selectedIndex = _selectItemIndex;
    if (resuletModel.bjmpEnable)
    {
        resuletModel.bjmpSelected = _bjmpSwitch.isOn;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(didFinishInsuranceCustomValueSelect:)])
    {
        [self.delegate didFinishInsuranceCustomValueSelect:resuletModel];
    }
    
    [self didCancelButtonTouch:nil];
}


@end
