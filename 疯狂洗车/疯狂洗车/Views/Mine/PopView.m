//
//  PopView.m
//  SpringCare
//
//  Created by LiuZach on 15/11/20.
//  Copyright © 2015年 cmkj. All rights reserved.
//

#import "PopView.h"
#import "define.h"
#import "AppInfoView.h"

#define ViewHeight 250

@implementation PopView
@synthesize bgView;
@synthesize view;
@synthesize delegate;
@synthesize btnCancel;

- (id) initWithImageArray:(NSArray*) images nameArray:(NSArray*) names
{
    self = [super initWithFrame:CGRectMake(0, 0, STATIC_SCREEN_WIDTH, STATIC_SCREEN_HEIGHT)];
    
    if(self){
        
//        self.backgroundColor = [UIColor blackColor];
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, STATIC_SCREEN_WIDTH, STATIC_SCREEN_HEIGHT)];
        [self addSubview:view];
        view.backgroundColor = [UIColor clearColor];
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, STATIC_SCREEN_HEIGHT, STATIC_SCREEN_WIDTH, ViewHeight)];
        [self addSubview:bgView];
        bgView.backgroundColor = _COLOR(235, 235, 235);
        
        CGFloat btnWidth = 140;
        
        CGFloat step = (STATIC_SCREEN_WIDTH - [names count] * btnWidth) /  ([names count] + 1);
        
        CGFloat ox = step;
        
        imageArrays = images;
        
        for (int i = 0; i < [names count]; i++) {
            
            AppInfoView *control = [[AppInfoView alloc] initWithFrame:CGRectMake(ox, 25, btnWidth, btnWidth)];
            [bgView addSubview:control];
            control.lbName.text = [names objectAtIndex:i];
            control.logo.image = ThemeImage([images objectAtIndex:i]);
            [control addTarget:self action:@selector(handleControlClickedEvent:) forControlEvents:UIControlEventTouchUpInside];
//            control.lbName.font = _FONT(14);
//            CGRect rect = control.lbName.frame;
//            control.lbName.frame = CGRectMake(rect.origin.x, rect.origin.y + 15, rect.size.width, rect.size.height);
            
            control.tag = 1000 + i;
            
            ox += (step + btnWidth);
        }
        
        btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(20, 190, STATIC_SCREEN_WIDTH - 20 * 2, 42)];
        btnCancel.layer.cornerRadius = 3;
        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnCancel.titleLabel.font = _FONT(18);
        btnCancel.backgroundColor = _COLOR(0xff, 0x66, 0x19);
        [bgView addSubview:btnCancel];
        [btnCancel addTarget:self action:@selector(handleCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}

- (void) handleControlClickedEvent:(UIControl *) control
{
    NSInteger tag = control.tag;
    
    [UIView animateWithDuration:0.25 animations:^{
        view.alpha = 1;
        view.backgroundColor = [UIColor clearColor];
        bgView.frame = CGRectMake(0, STATIC_SCREEN_HEIGHT, STATIC_SCREEN_WIDTH, ViewHeight);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        if(delegate && [delegate respondsToSelector:@selector(HandleItemSelect:selectImageName:)])
        {
            [delegate HandleItemSelect:self selectImageName:[imageArrays objectAtIndex:tag - 1000]];
        }
        
    }];
}

- (void) show
{
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.3;
        bgView.frame = CGRectMake(0, STATIC_SCREEN_HEIGHT - ViewHeight, STATIC_SCREEN_WIDTH, ViewHeight);
    }];
}

- (void) hidden
{
    [UIView animateWithDuration:0.25 animations:^{
        view.alpha = 1;
        view.backgroundColor = [UIColor clearColor];
        bgView.frame = CGRectMake(0, STATIC_SCREEN_HEIGHT, STATIC_SCREEN_WIDTH, ViewHeight);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void) handleCancelClicked:(UIButton *)sender
{
    [self hidden];
}

@end
