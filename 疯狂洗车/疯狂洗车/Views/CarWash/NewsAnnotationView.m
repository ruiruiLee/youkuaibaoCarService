//
//  NewsAnnotationView.m
//  优快保
//
//  Created by 朱伟铭 on 13-7-15.
//  Copyright (c) 2013年 朱伟铭. All rights reserved.
//

#import "NewsAnnotationView.h"
#import <QuartzCore/QuartzCore.h>


#define  Arror_height 6
@implementation NewsAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}
-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        //        self.centerOffset = CGPointMake(0, -55);
        //        self.frame = CGRectMake(0, 0, 240, 80);
        //        self.centerOffset = CGPointMake(100, -100);
        self.centerOffset = CGPointMake(0, -40);
        self.frame = CGRectMake(0, 0, 126, 54);
        
        if (self.infoView == nil)
        {
            self.infoView = [[NSBundle mainBundle] loadNibNamed:@"NewsOutCell"
                                                 owner:self
                                               options:nil][0];
            
            [self.infoView setFrame:CGRectMake(0, 0, 126, 54)];
            [self addSubview:self.infoView];
        }
    }
    return self;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.infoView.frame = CGRectMake(0, 0, 126, 54);
}


//-(void)refrashView
//{
//    self.frame=CGRectMake(0, 0, 116, self.contentView.bounds.size.height);
//    NSLog(@"%f",self.contentView.bounds.size.height+20);
//    self.centerOffset=CGPointMake(0,self.frame.size.height/2);
//    [self setNeedsDisplay];
//}
//
//- (void)dealloc
//{
//    
//}
//
//- (void)setContentView:(UIView *)contentView
//{
//    [contentView setFrame:CGRectMake(10, 5, self.frame.size.width - 20, self.frame.size.height - 20)];
//    contentView.backgroundColor   = [UIColor clearColor];
//    _contentView = contentView;
//    [self addSubview:_contentView];
//}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
