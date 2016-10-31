//
//  CarNurseDetailViewController.h
//  优快保
//
//  Created by cts on 15/6/11.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "CarNurseModel.h"
#import "ButlerView.h"

@interface ButlerDetailViewController : BaseViewController<UIActionSheetDelegate>
{
    
    ButlerView *_butlerView;
}

@property (strong, nonatomic) NSString *service_type;

@property (strong, nonatomic) CarNurseModel *selectedCarNurse;

@end
