//
//  AppInfoView.m
//  SpringCare
//
//  Created by LiuZach on 15/10/27.
//  Copyright © 2015年 cmkj. All rights reserved.
//

#import "AppInfoView.h"
#import "define.h"

@implementation AppInfoView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        _logo = [[UIImageView alloc] initWithFrame:CGRectMake(40, 25, 60, 60)];
        [self addSubview:_logo];
        _logo.clipsToBounds = NO;
        _logo.userInteractionEnabled = NO;
        
        
        _lbName = [[UILabel alloc] initWithFrame:CGRectMake(20, 102, 100, 18)];
        _lbName.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbName];
        _lbName.backgroundColor = [UIColor clearColor];
        _lbName.textColor = _COLOR(0x21, 0x21, 0x21);
        _lbName.font = _FONT(18);
        
        self.layer.cornerRadius = 4;
        self.layer.borderWidth = 1;
        self.layer.borderColor = _COLOR(0xe3, 0xe3, 0xe3).CGColor;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

@end
