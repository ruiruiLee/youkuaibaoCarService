//
//  LicensePlateSelecter.h
//  优快保
//
//  Created by cts on 15/3/19.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LicensePlateSelecterDeleagte <NSObject>

- (void)didFinishLicensePlateSelect:(NSString*)resultString;

@end

@interface LicensePlateSelecter : UIView<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    NSArray     *_provincesNameArray;
    
    NSArray     *_chartArray;
    
    UITableView *_provincesTableView;
    
    UITableView *_chartTableView;
    
    UIView      *_selectView;
    
    UILabel     *_titleLabel;
    
}

@property (assign, nonatomic) id <LicensePlateSelecterDeleagte> delegate;

- (void)showLincensePlateSelecter;

- (void)hideLincensePlateSelecter;

@end
