//
//  UserAnnotationView.m
//  优快保
//
//  Created by cts on 15/3/30.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "UserAnnotationView.h"

@implementation UserAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        if (_headingImageView == nil)
        {
            _headingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-23/2, 0, 23, 23)];
            [_headingImageView setImage:[UIImage imageNamed:@"img_location_heading"]];
            [self addSubview:_headingImageView];
        }

    }
    
    return self;
}


- (void)updateUserLocationHeading:(CLHeading*)userHeading
{
    _headingImageView.transform = CGAffineTransformMakeRotation(userHeading.trueHeading/180*M_PI);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
