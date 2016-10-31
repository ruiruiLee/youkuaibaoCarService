//
//  HFTRadionButton.m
//  OldErp4iOS
//
//  Created by Darsky on 14-4-10.
//  Copyright (c) 2014年 HFT_SOFT. All rights reserved.
//

#import "HFTRadionButton.h"

@implementation HFTRadionButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}



- (CGRect)imageRectForContentRect:(CGRect)contentRect
{

    return CGRectMake(1,self.frame.size.height/2-22/2, 22, 22);
}

- (CGRect)backgroundRectForBounds:(CGRect)bounds
{
    return CGRectMake(1,self.frame.size.height/2-22/2, 22, 22);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(25, contentRect.origin.y, contentRect.size.width-25, contentRect.size.height);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
