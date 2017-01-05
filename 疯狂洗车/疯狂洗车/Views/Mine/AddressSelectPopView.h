//
//  AddressSelectPopView.h
//  疯狂洗车
//
//  Created by LiuZach on 2017/1/5.
//  Copyright © 2017年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressSelectPopView;

@protocol AddressSelectPopViewDelegate <NSObject>

- (void) HandleAddressSelectViewWith:(AddressSelectPopView *) popView address:(NSString *) address;
- (void) HandleAddressSelectViewSelectWithMap:(AddressSelectPopView *) popView;

@end

@interface AddressSelectPopView : UIView
{
    UITextField *_tfAddress;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIButton *btnCancel;

@property (nonatomic, weak) id<AddressSelectPopViewDelegate> delegate;

@end
