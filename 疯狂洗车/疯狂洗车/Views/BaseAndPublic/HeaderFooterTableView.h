//
//  HeaderFooterTableView.h
//  疯狂洗车
//
//  Created by cts on 15/11/9.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderFooterTableView : UITableView

- (void)tableViewHeaderBeginRefreshing;

- (void)tableViewHeaderEndRefreshing;

- (void)tableViewfooterEndRefreshing;

- (void)addHeaderActionWithTarget:(id)target action:(SEL)action;

- (void)addFooterActionWithTarget:(id)target action:(SEL)action;

- (void)letTableViewHeaderHidden:(BOOL)shouldHide;

- (void)letTableViewFooterHidden:(BOOL)shouldHide;

@end
