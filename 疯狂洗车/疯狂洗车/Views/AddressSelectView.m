//
//  AddressSelectView.m
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/23.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "AddressSelectView.h"
#import "define.h"

#define ViewHeight 210

@implementation AddressSelectView
@synthesize bgView;
@synthesize view;
@synthesize delegate;
@synthesize btnSubmit;

- (void) awakeFromNib
{
    [btnSubmit addTarget:self action:@selector(handleSubmitClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    view.alpha = 1;
    view.backgroundColor = [UIColor clearColor];
    CGRect frame = bgView.frame;
    bgView.frame = CGRectMake(0, STATIC_SCREEN_HEIGHT, STATIC_SCREEN_WIDTH, frame.size.height);
    
}

- (void) handleControlClickedEvent:(UIControl *) control
{
//    NSInteger tag = control.tag;
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        view.alpha = 1;
//        view.backgroundColor = [UIColor clearColor];
//        bgView.frame = CGRectMake(0, STATIC_SCREEN_HEIGHT, STATIC_SCREEN_WIDTH, ViewHeight);
//    } completion:^(BOOL finished) {
//        self.hidden = YES;
//        if(delegate && [delegate respondsToSelector:@selector(HandleItemSelect:selectImageName:)])
//        {
//            [delegate HandleItemSelect:self selectImageName:[imageArrays objectAtIndex:tag - 1000]];
//        }
//        
//    }];
}

- (void) show
{
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.3;
        CGRect frame = bgView.frame;
        bgView.frame = CGRectMake(0, STATIC_SCREEN_HEIGHT - frame.size.height, STATIC_SCREEN_WIDTH, frame.size.height);
    }];
}

- (void) hidden
{
    [UIView animateWithDuration:0.25 animations:^{
        view.alpha = 1;
        view.backgroundColor = [UIColor clearColor];
        CGRect frame = bgView.frame;
        bgView.frame = CGRectMake(0, STATIC_SCREEN_HEIGHT, STATIC_SCREEN_WIDTH, frame.size.height);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void) handleSubmitClicked:(UIButton *)sender
{
    if(delegate && [delegate respondsToSelector:@selector(addressSelectView:WithCarInfo:Address:)]){
        
        [delegate addressSelectView:self WithCarInfo:_carInfo Address:_addressInfo];
        
    }
    [self hidden];
}

- (void) setAddressInfo:(CityInfoModel *)info
{
    _addressInfo = info;
    [self updateInfoOnView];
}

- (void) setCarInfo:(CarInfos *)info
{
    _carInfo = info;
    [self updateInfoOnView];
}

- (void) updateInfoOnView{
    self.lbGPS.text = [NSString stringWithFormat:@"%.8f,%.8f", _addressInfo.location.latitude, _addressInfo.location.longitude];
    if(_carInfo){
        self.lbCarNo.text = _carInfo.car_no;
        self.lbAddCar.text = @"选择车辆";
    }else{
        self.lbAddCar.text = @"添加车辆";
        self.lbCarNo.text = @"";
    }
    
    self.lbAddress.text = [NSString stringWithFormat:@"%@%@", _addressInfo.address, _addressInfo.name];
}

- (IBAction)doBtnSelectNewCar:(id)sender
{
    if(_carInfo){
        if(delegate && [delegate respondsToSelector:@selector(addressSelectView:withBlock:)]){
            __weak AddressSelectView *weakself = self;
            [delegate addressSelectView:self withBlock:^(CarInfos *info) {
                weakself.carInfo = info;
            }];
        }
    }else{
        if(delegate && [delegate respondsToSelector:@selector(addressSelectView:addCarWithBlock:)]){
            [delegate addressSelectView:self addCarWithBlock:nil];
        }
        
        [self hidden];
    }
}

- (IBAction)doBtnCancel:(id)sender
{
    [self hidden];
}

@end
