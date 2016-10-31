//
//  FourSServiceSmallCallOutView.m
//  疯狂洗车
//
//  Created by cts on 16/1/29.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "FourSServiceSmallCallOutView.h"
#import "UIImageView+WebCache.h"

@implementation FourSServiceSmallCallOutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_bgImageView setHighlightedImage:[UIImage imageNamed:@"img_4s_pin_selected"]];
        [_bgImageView setImage:[UIImage imageNamed:@"img_4s_pin_unselected"]];
        [self addSubview:_bgImageView];
        
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
        _logoImageView.layer.masksToBounds = YES;
        _logoImageView.layer.cornerRadius = 40/2;
        _logoImageView.layer.borderWidth = 3;
        _logoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview:_logoImageView];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setDisplayCarWashInfo:(CarNurseModel*)model
{
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:model.logo]
                      placeholderImage:[UIImage imageNamed:@"img_default_logo"]];
}

- (void)setIsSelected:(BOOL)isSelected
{
    if (_isSelected == isSelected)
    {
        return;
    }
    _isSelected = isSelected;
    _bgImageView.highlighted = _isSelected;
}


@end
