//
//  HeaderFooterTableView.m
//  疯狂洗车
//
//  Created by cts on 15/11/9.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "HeaderFooterTableView.h"
#import "MJRefresh.h"



@implementation HeaderFooterTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)tableViewHeaderBeginRefreshing
{
    [self headerBeginRefreshing];
}

- (void)tableViewHeaderEndRefreshing
{
    [self headerEndRefreshing];
}

- (void)tableViewfooterEndRefreshing
{
    [self footerEndRefreshing];
}

- (void)addHeaderActionWithTarget:(id)target action:(SEL)action
{
    [self addHeaderWithTarget:target action:action];
}

- (void)addFooterActionWithTarget:(id)target action:(SEL)action
{
    [self addFooterWithTarget:target action:action];
}

- (void)letTableViewHeaderHidden:(BOOL)shouldHide
{
    self.headerHidden = shouldHide;
}

- (void)letTableViewFooterHidden:(BOOL)shouldHide
{
    self.footerHidden = shouldHide;
}

@end
