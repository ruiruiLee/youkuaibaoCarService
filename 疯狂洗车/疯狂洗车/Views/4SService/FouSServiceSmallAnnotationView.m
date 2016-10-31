//
//  FouSServiceSmallAnnotationView.m
//  疯狂洗车
//
//  Created by cts on 16/1/29.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "FouSServiceSmallAnnotationView.h"

@implementation FouSServiceSmallAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, -35);
        self.frame = CGRectMake(0, 0, 50, 77);
        
        
    }
    
    return self;
}

- (void)setCustomAnnotationSelect:(BOOL)shouldSelect
{
    _infoView.isSelected = shouldSelect;
}

- (void)setDisplayInfo:(CarNurseModel*)model
{
    if (_infoView == nil)
    {
        _infoView = [[FourSServiceSmallCallOutView alloc] initWithFrame:self.bounds];
        [self addSubview:_infoView];
    }
    
    [_infoView setDisplayCarWashInfo:model];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
