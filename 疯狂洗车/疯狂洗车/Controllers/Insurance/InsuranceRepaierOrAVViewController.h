//
//  InsuranceRepaierOrAVViewController.h
//  
//
//  Created by cts on 15/10/29.
//
//

#import "BaseViewController.h"
#import "CarReviewModel.h"

//该类只作为保险用户理赔送修和年检代办的网页显示
@interface InsuranceRepaierOrAVViewController : BaseViewController<UIWebViewDelegate>
{
    
    IBOutlet UIWebView *_webView;
}

@property (assign, nonatomic) BOOL isAVService;

@property (strong, nonatomic) CarReviewModel *carReviewModel;


@end
