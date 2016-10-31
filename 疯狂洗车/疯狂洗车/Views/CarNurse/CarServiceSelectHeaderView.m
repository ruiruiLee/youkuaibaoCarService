//
//  CarServiceSelectHeaderView.m
//  疯狂洗车
//
//  Created by cts on 16/1/27.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "CarServiceSelectHeaderView.h"
#import "ServiceGroupModel.h"

@implementation CarServiceSelectHeaderView


- (void)awakeFromNib
{
    [super awakeFromNib];
    if (_itemArray == nil)
    {
        _itemArray = [NSMutableArray array];
        [_itemArray addObjectsFromArray:@[_firstButton,_secondButton,_thirdButton]];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setDisplayInfoWithCarNurseModel:(CarNurseModel*)model withSelectedIndex:(NSInteger)selectIndex
{
    for (int x = 0; x<_itemArray.count; x++)
    {
        UIButton *button = _itemArray[x];
        if (x > model.serviceArray.count - 1)
        {
            button.hidden = YES;
        }
        else
        {
            ServiceGroupModel *groupModel = model.serviceArray[x];
            [button setTitle:groupModel.serviceGroupName forState:UIControlStateNormal];
            if (x == (int)selectIndex)
            {
                button.selected = YES;
            }
            else
            {
                button.selected = NO;
            }
        }
    }
    [self updateButtonsStatus];
}
- (IBAction)didServiceSegmentCHnage:(UIButton*)sender
{
    if (sender.selected)
    {
        return;
    }
    else
    {
        sender.selected = YES;
    }
    [self updateButtonsStatus];
    if ([self.delegate respondsToSelector:@selector(didServiceChange:)])
    {
        [self.delegate didServiceChange:sender.tag];
    }
}

- (void)updateButtonsStatus
{
    for (int x = 0; x<_itemArray.count; x++)
    {
        UIButton *button = _itemArray[x];
        if (button.selected)
        {
            _selectedViewLeadingConstraint.constant = SCREEN_WIDTH/3*(int)button.tag+SCREEN_WIDTH/3/2-75/2;
        }
    }

}

@end
