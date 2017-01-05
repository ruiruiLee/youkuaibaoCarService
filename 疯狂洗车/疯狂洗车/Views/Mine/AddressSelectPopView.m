//
//  AddressSelectPopView.m
//  疯狂洗车
//
//  Created by LiuZach on 2017/1/5.
//  Copyright © 2017年 龚杰洪. All rights reserved.
//

#import "AddressSelectPopView.h"
#import "define.h"
#import "AppInfoView.h"

#define ViewHeight 250

@implementation AddressSelectPopView
@synthesize bgView;
@synthesize view;
@synthesize delegate;
@synthesize btnCancel;

//- (id) initWithFrame:(CGRect) frame
//{
//    self = [super initWithFrame:CGRectMake(0, 0, STATIC_SCREEN_WIDTH, STATIC_SCREEN_HEIGHT)];
//    
//    if(self){
//        
//        //        self.backgroundColor = [UIColor blackColor];
//        
//        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, STATIC_SCREEN_WIDTH, STATIC_SCREEN_HEIGHT)];
//        [self addSubview:view];
//        view.backgroundColor = [UIColor clearColor];
//        
//        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, STATIC_SCREEN_HEIGHT, STATIC_SCREEN_WIDTH, ViewHeight)];
//        [self addSubview:bgView];
//        bgView.backgroundColor = _COLOR(235, 235, 235);
//        
//        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 120, 40)];
//        lbTitle.text = @"填写取车地址";
//        lbTitle.textColor = _COLOR(0x21, 0x21, 0x21);
//        lbTitle.font = _FONT(15);
//        [bgView addSubview:lbTitle];
//        
//        UIButton *btnOk = [[UIButton alloc] initWithFrame:CGRectMake(STATIC_SCREEN_WIDTH - 80, 68, 60, 40)];
//        [bgView addSubview:btnOk];
//        [btnOk setTitle:@"确定" forState:UIControlStateNormal];
//        [btnOk setTitleColor:_COLOR(0x21, 0x21, 0x21) forState:UIControlStateNormal];
//        btnOk.titleLabel.font = _FONT(15);
//        [btnOk addTarget:self action:@selector(handleControlClickedEvent:) forControlEvents:UIControlEventTouchUpInside];
//        
//        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, STATIC_SCREEN_WIDTH, 1)];
//        [bgView addSubview:line];
//        line.backgroundColor = _COLOR(0xe3, 0xe3, 0xe3);
//        
//        UILabel *lbExplain = [[UILabel alloc] initWithFrame:CGRectMake(20, 41, STATIC_SCREEN_WIDTH - 40, 20)];
//        [bgView addSubview:lbExplain];
//        lbExplain.text = @"目前仅限于成都市区";
//        lbExplain.font = _FONT(13);
//        lbExplain.textColor = _COLOR(0x75, 0x75, 0x75);
//        
//        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 61, STATIC_SCREEN_WIDTH, 1)];
//        [bgView addSubview:line1];
//        line1.backgroundColor = _COLOR(0xe3, 0xe3, 0xe3);
//        
//        _tfAddress = [[UITextField alloc] initWithFrame:CGRectMake(20, 72, STATIC_SCREEN_WIDTH - 80, 36)];
//        [bgView addSubview:_tfAddress];
//        _tfAddress.font = _FONT(13);
//        _tfAddress.textColor = _COLOR(0x21, 0x21, 0x21);
//        _tfAddress.clearButtonMode = UITextFieldViewModeWhileEditing;
//        
//        UIButton *btnMap = [[UIButton alloc] initWithFrame:CGRectMake(STATIC_SCREEN_WIDTH - 80, 70, 40, 40)];
//        [bgView addSubview:btnMap];
//        [btnMap addTarget:self action:@selector(HandleMapClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 118, STATIC_SCREEN_WIDTH, 1)];
//        [bgView addSubview:line2];
//        line2.backgroundColor = _COLOR(0xe3, 0xe3, 0xe3);
//        
//        btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(20, 190, STATIC_SCREEN_WIDTH - 20 * 2, 42)];
//        btnCancel.layer.cornerRadius = 3;
//        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
//        [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        btnCancel.titleLabel.font = _FONT(18);
//        btnCancel.backgroundColor = _COLOR(0xff, 0x66, 0x19);
//        [bgView addSubview:btnCancel];
//        [btnCancel addTarget:self action:@selector(handleCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
//    
//    return self;
//}
//
//- (void) HandleMapClicked:(UIButton *)sender
//{
//    
//}
//
//- (void) handleControlClickedEvent:(UIControl *) control
//{
//    NSInteger tag = control.tag;
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        view.alpha = 1;
//        view.backgroundColor = [UIColor clearColor];
//        bgView.frame = CGRectMake(0, STATIC_SCREEN_HEIGHT, STATIC_SCREEN_WIDTH, ViewHeight);
//    } completion:^(BOOL finished) {
//        self.hidden = YES;
//        
//    }];
//}
//
//- (void) show
//{
//    self.hidden = NO;
//    [UIView animateWithDuration:0.25 animations:^{
//        view.backgroundColor = [UIColor blackColor];
//        view.alpha = 0.3;
//        bgView.frame = CGRectMake(0, STATIC_SCREEN_HEIGHT - ViewHeight, STATIC_SCREEN_WIDTH, ViewHeight);
//    }];
//}
//
//- (void) hidden
//{
//    [UIView animateWithDuration:0.25 animations:^{
//        view.alpha = 1;
//        view.backgroundColor = [UIColor clearColor];
//        bgView.frame = CGRectMake(0, STATIC_SCREEN_HEIGHT, STATIC_SCREEN_WIDTH, ViewHeight);
//    } completion:^(BOOL finished) {
//        self.hidden = YES;
//    }];
//}
//
//- (void) handleCancelClicked:(UIButton *)sender
//{
//    [self hidden];
//}
//

@end
