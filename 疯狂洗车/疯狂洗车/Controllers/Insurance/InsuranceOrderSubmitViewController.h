//
//  InsuranceOrderSubmitViewController.h
//  
//
//  Created by cts on 15/9/16.
//
//

#import "BaseViewController.h"
#import "WebServiceHelper.h"
#import "UIImageView+WebCache.h"
#import "InsurancePayInfoModel.h"
#import "InsuranceInfoModel.h"
#import "InsuranceHomeModel.h"
#import "InsuranceDetailModel.h"


//保险报价信息提交页面
@interface InsuranceOrderSubmitViewController : BaseViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    IBOutlet UIScrollView *_contextScrollView;
#pragma mark - 支付信息
    IBOutlet UIView *_priceInfoView;
    
    IBOutlet UILabel *_insuranceCompNameLabel;
    
    IBOutlet UILabel *_jqccPriceLabel;
    
    IBOutlet UILabel *_syPriceLabel;
    
    IBOutlet UILabel *_jqccsyPriceLabel;
    
    IBOutlet UILabel *_reducePriceLabel;
    
    IBOutlet UILabel *_payPriceLabel;
    
    IBOutlet UILabel *_giftsLabel;
    
    IBOutlet UIView  *_giftsView;
    
    
#pragma mark - 证件信息
    
    IBOutlet UIView *_uploadImageView;
    
    IBOutlet UIView *_carCardView;
    
    IBOutlet UIImageView *_carCardFrontImageView;
    
    IBOutlet UIImageView *_carCardBackImageView;
    
    UIImage              *_uploadCarCardBackImage;
    
    NSString             *_uploadCarCardBackImageUrl;

    IBOutlet UIButton *_deleteCarCardBackButton;
    
    IBOutlet UIView   *_driveCardView;
    
    IBOutlet UIView   *_idCardView;
    
#pragma mark - 更多信息
    IBOutlet UIView   *_moreInfoView;
    
    IBOutlet UITextField *_addressField;
    
    IBOutlet UITextField *_phoneField;
    
    IBOutlet UITextField *_moreRequestField;
    
    IBOutlet UIButton    *_submitButton;
    
    
}

@property (strong, nonatomic) InsuranceHomeModel *homeModel;

@property (strong, nonatomic) InsurancePayInfoModel *payInfoModel;

@property (strong, nonatomic) InsuranceDetailModel *detailModel;

@property (strong, nonatomic) InsuranceInfoModel *infoModel;

@property (assign, nonatomic) NSRange      driveCardImgRequestNumber;

@property (assign, nonatomic) NSRange      idCardImgRequestNumber;

@property (strong, nonatomic) NSString     *suggestType;


@end
