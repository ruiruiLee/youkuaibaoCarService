//
//  BaseViewController.h
//  康吾康
//
//  Created by 朱伟铭 on 14/12/29.
//  Copyright (c) 2014年 朱伟铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface BaseViewController : UIViewController
{
    AppDelegate     *_appDelegate;
}


@property (assign , nonatomic) BOOL isClubController;
@end
