//
//  InsuranceDetailsViewController.h
//  
//
//  Created by cts on 15/9/15.
//
//

#import "BaseViewController.h"
#import "InsuranceInfoModel.h"
#import "InsuranceDetailModel.h"
#import "InsuranceHelper.h"


typedef enum
{
    OrderDetailStateNormal,
    OrderDetailStateWatting,
    OrderDetailStateNone,
    OrderDetailStateError,
    OrderDetailStateCustom
}OrderDetailState;

//用户报价方案详情页面
@interface InsuranceDetailsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIView               *_compTopView;
    
    IBOutlet UISegmentedControl   *_companySegmentControl;
    
    IBOutlet UITableView          *_displayTableView;
    
    InsuranceDetailModel          *_selectedInsuranceDetailModel;
    
    IBOutlet UIView               *_caculatingView;
    
    IBOutlet UILabel              *_caculatingStateLabel;
    
    IBOutlet UILabel              *_caculatingDesLabel;
    
    IBOutlet UIView               *_bottomShadowView;
    
    IBOutlet UIView               *_bottomView;
    
    IBOutlet UIButton             *_insuranceEditButton;
    
    IBOutlet UIButton             *_insuranceOrderButton;
    
    
}

@property (assign, nonatomic) NSInteger  defaultCompanyIndex;

@property (strong, nonatomic) NSMutableArray *insurancesArray;

@property (assign, nonatomic) BOOL isForCustomSelect;

@property (strong, nonatomic) NSString *customInsuranceID;



@end
