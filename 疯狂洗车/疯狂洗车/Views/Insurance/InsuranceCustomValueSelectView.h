//
//  InsuranceCustomValueSelectView.h
//  
//
//  Created by cts on 15/10/15.
//
//

#import <UIKit/UIKit.h>
#import "InsuranceCustomSelectModel.h"

@protocol InsuranceCustomValueSelectViewDelegate <NSObject>

- (void)didFinishInsuranceCustomValueSelect:(InsuranceCustomSelectModel*)model;

@end

@interface InsuranceCustomValueSelectView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIView  *_valueSelectView;
    
    IBOutlet UILabel *_selectValueTitleLabel;
    
    IBOutlet UILabel *_selectValueIntroLabel;
    
    IBOutlet UILabel *_selectValueDesclabel;
    
    IBOutlet UITableView *_contextTableView;
    
    IBOutlet UIView *_bjmpView;
    
    IBOutlet UISwitch *_bjmpSwitch;
    
    IBOutlet UIButton *_cancelButton;
    
    IBOutlet UIButton *_confirmButton;
    
    
    NSInteger       _selectItemIndex;
    
    InsuranceCustomSelectModel *_settingPropertyModel;
    
    
#pragma others 
    
    int    _maxRowNumber;
}

- (void)showAndSetUpWithPropertyModel:(InsuranceCustomSelectModel*)model;

@property (assign, nonatomic) id <InsuranceCustomValueSelectViewDelegate> delegate;

@end
