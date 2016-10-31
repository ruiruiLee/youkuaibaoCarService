//
//  CityHeaderView.m
//  
//
//  Created by cts on 15/9/24.
//
//

#import "CityHeaderView.h"

@implementation CityHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setCityHeaderTitle:(NSString*)titleString
{
    _headerTitleLabel.text = titleString;
}

@end
