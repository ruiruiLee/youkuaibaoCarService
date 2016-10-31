//
//  CarWashAnnotationView.m
//  优快保
//
//  Created by cts on 15/5/4.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CarWashAnnotationView.h"

@implementation CarWashAnnotationView


- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, -40);
        self.frame = CGRectMake(0, 0, 126, 54);
        
    }
    
    return self;
}

- (void)setDisplayInfo:(CarWashModel*)model
{
    if (_infoView == nil)
    {
        _infoView = [[CarWashInfoCallOutView alloc] initWithFrame:self.bounds
                                                     withClubMode:self.isClubMode];
        [self addSubview:_infoView];
    }
    
    CGSize carNameSize = CGSizeMake(MAXFLOAT, 16);
    CGSize nameSize =[model.short_name boundingRectWithSize:carNameSize
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}
                                              context:nil].size;
    
    CGSize priceframeSize = CGSizeMake(MAXFLOAT, 15);
    CGSize priceSize =[model.car_member_price boundingRectWithSize:priceframeSize
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]}
                                                    context:nil].size;
    CGSize oldPriceSize =[model.car_original_price boundingRectWithSize:priceframeSize
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0]}
                                                     context:nil].size;
    float callOutWidth = 0;
    if (nameSize.width <= 90 && priceSize.width + oldPriceSize.width + 16 <= 90)
    {
        callOutWidth = 110;
    }
    else if (nameSize.width < priceSize.width + oldPriceSize.width + 16)
    {
        callOutWidth = priceSize.width + oldPriceSize.width + 36;
    }
    else
    {
        callOutWidth = nameSize.width + 20;
    }

    _infoView.frame = CGRectMake(self.frame.size.width/2-callOutWidth/2, 0, callOutWidth, 54);

    
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
