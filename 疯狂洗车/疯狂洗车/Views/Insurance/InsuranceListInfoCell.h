//
//  InsuranceListInfoCell.h
//  
//
//  Created by cts on 15/9/16.
//
//

#import <UIKit/UIKit.h>
#import "InsuranceGroupModel.h"

@protocol InsuranceListInfoCellDelegate <NSObject>

- (void)didEditButtonTouched:(NSIndexPath*)indexPath;

- (void)didImageItemTouched:(NSIndexPath*)indexPath
              andImageIndex:(NSInteger)imageIndex;

@end

@interface InsuranceListInfoCell : UITableViewCell
{
    IBOutlet UILabel     *_insuranceTimeLabel;
    
    IBOutlet UILabel     *_insuranceCreateTimeLabel;
    
    IBOutlet UIView      *_shadowTopView;
    
    IBOutlet UIView      *_topInfoView;
    
    IBOutlet UILabel     *_insuranceIdLabel;

    IBOutlet UIButton    *_editButton;
    
    IBOutlet UILabel     *_cityLabel;
    
    IBOutlet UILabel     *_phoneLabel;
    
    IBOutlet UILabel     *_idCardNoLabel;
    
    IBOutlet UILabel     *_insruanceStatusLabel;
    
    IBOutlet UIView      *_imageDisplayView;
}

- (void)setDisplayInsuranceGroupInfo:(InsuranceGroupModel*)model;

@property (assign, nonatomic) id <InsuranceListInfoCellDelegate> delegate;

@property (strong, nonatomic) NSIndexPath *indexPath;

@end
