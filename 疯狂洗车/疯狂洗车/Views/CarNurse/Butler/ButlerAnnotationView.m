//
//  CarWashAnnotationView.m
//  优快保
//
//  Created by cts on 15/5/4.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "ButlerAnnotationView.h"

@implementation ButlerAnnotationView


- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, -40);
        self.frame = CGRectMake(0, 0, 190, 62);
    }
    
    return self;
}

- (void)setDisplayInfo:(CarNurseModel*)model
{
    if (_infoView == nil)
    {
        _infoView = [[ButlerInfoCallOutView alloc] initWithFrame:self.bounds withClubMode:self.isClubMode];
        [self addSubview:_infoView];
    }
    
    CGSize carNameSize = CGSizeMake(MAXFLOAT, 18);
    CGSize nameSize =[model.short_name boundingRectWithSize:carNameSize
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                                    context:nil].size;
    
    CGSize priceframeSize = CGSizeMake(MAXFLOAT, 16);
    CGSize priceSize =[model.service_types boundingRectWithSize:priceframeSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]}
                                                       context:nil].size;
    float callOutWidth = 0;
    if (nameSize.width > 120 && priceSize.width+10 > 120)
    {
        callOutWidth = 190;
    }
    else if (nameSize.width < priceSize.width)
    {
        callOutWidth = priceSize.width + 70;
    }
    else
    {
        callOutWidth = nameSize.width + 70;
    }
    
    _infoView.frame = CGRectMake(self.frame.size.width/2-callOutWidth/2, 0, callOutWidth, 62);



    
    [_infoView setDisplayCarWashInfo:model];
}

- (void)setCustomAnnotationSelect:(BOOL)shouldSelect
{
    _infoView.isSelected = shouldSelect;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/



@end
