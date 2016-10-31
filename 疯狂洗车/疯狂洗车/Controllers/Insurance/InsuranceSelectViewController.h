//
//  InsuranceSelectViewController.h
//  疯狂洗车
//
//  Created by cts on 15/11/19.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "BaseViewController.h"
#import "InsuranceDetailModel.h"
#import "InsuranceHelper.h"

//车险险种选择页面
@interface InsuranceSelectViewController : BaseViewController
{
    IBOutlet UISegmentedControl *_segmentControl;
    
    IBOutlet UITableView *_contextTableView;
    
    IBOutlet UIButton    *_submitButton;
    
    IBOutlet UIView      *_submitSuccessView;
    
    IBOutlet UIButton    *_backListButton;
    
    IBOutlet UIView      *_topShadowView;
    
    IBOutlet UIView      *_bottomShadowView;
}

@property (strong, nonatomic) NSMutableArray *preValueModelArray;//用户上次选择的基本险数据

@property (strong, nonatomic) NSMutableArray *preAdditionalValueModelArray;//用户上次选择的附加险数据

@property (assign, nonatomic) NSInteger    preValueType;//用户上次选择报价类型

@property (strong, nonatomic) NSString     *insuranceIDForCustom;//用户上次选择报价id

@property (assign, nonatomic) BOOL         isForSubmit;

@property (strong, nonatomic) InsuranceDetailModel *selectedInsuranceDetailModel;

@end
