//
//  InsuranceCompTopView.m
//  
//
//  Created by cts on 15/9/15.
//
//

#import "InsuranceCompTopView.h"
#import "InsuranceInfoModel.h"
#import "InsuranceDetailModel.h"

@implementation InsuranceCompTopView

- (void)setUpWithInsuranceComps:(NSArray*)insuranceComps
{
    if (insuranceComps.count > 0)
    {
        _padRect = SCREEN_WIDTH/insuranceComps.count;
        _itemWidth = 90;
        _itemHeight = 25;
        
        _selectedView = [[UIView alloc] initWithFrame:CGRectMake(_padRect/2-_itemWidth/2, 15/2.0, _itemWidth, 25)];
        _selectedView.backgroundColor = [UIColor colorWithRed:248/255.0 green:218/255.0 blue:201/255.0 alpha:0.8];
        _selectedView.layer.masksToBounds = YES;
        _selectedView.layer.cornerRadius = 10;
        [self addSubview:_selectedView];
        
        for (int x = 0; x<insuranceComps.count; x++)
        {
            InsuranceDetailModel *model = insuranceComps[x];
            
            InsuranceInfoModel *companyModel = model.insuranceInfoModel;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(x*_padRect+_padRect/2-_itemWidth/2, self.frame.size.height/2-_itemHeight/2.0, _itemWidth, _itemHeight);
            [button setTitle:companyModel.insurance_name
                    forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:235/255.0
                                                  green:84/255.0
                                                   blue:1/255.0
                                                  alpha:1.0]
                         forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.tag = x;
            [button addTarget:self
                       action:@selector(didSelectInsuranceCompItem:)
             forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
        
    }

}

- (void)didSelectInsuranceCompItem:(UIButton*)sender
{
    if (sender.selected == YES)
    {
        return;
    }
    [self moveSelectToTarget:sender.tag];
    if ([self.delegate respondsToSelector:@selector(didSelectedInsuranceCompItem:)])
    {
        [self.delegate didSelectedInsuranceCompItem:sender.tag];
    }

}

- (void)moveSelectToTarget:(NSInteger)targetIndex
{
    [UIView animateWithDuration:0.3 animations:^{
        
        for (UIView *view in self.subviews)
        {
            if ([view isKindOfClass:[UIButton class]])
            {
                UIButton *button = (UIButton*)view;
                if (button.tag != targetIndex)
                {
                    button.selected = NO;
                }
                else
                {
                    button.selected = YES;
                    _selectedView.center = CGPointMake(button.center.x, button.center.y);
                }
            }
        }
    }
                     completion:^(BOOL finished) {
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
