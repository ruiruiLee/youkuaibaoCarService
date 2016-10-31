//
//  MyCarsController.h
//  优快保
//
//  Created by 朱伟铭 on 15/1/27.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "BaseViewController.h"
#import "HeaderFooterTableView.h"

//我的车辆页面
@interface MyCarsController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet HeaderFooterTableView    *_myCarsTable;
    
    IBOutlet UIButton       *_addNewCarBtn;
    
    
    IBOutlet UILabel        *_noCarLabel;
}

@end
