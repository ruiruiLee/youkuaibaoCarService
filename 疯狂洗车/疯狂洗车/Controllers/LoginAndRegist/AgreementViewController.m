//
//  AgreementViewController.m
//  优快保
//
//  Created by cts on 15/4/18.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "AgreementViewController.h"
#import "WebServiceHelper.h"

@interface AgreementViewController ()
{
    IBOutlet UITextView *_contextTextView;
}

@end

@implementation AgreementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"服务协议"];
    [WebService requestJsonOperationWithParam:nil
                                       action:@"system/service/config"
                               normalResponse:^(NSString *status, id data)
     {
         if (status.intValue > 0)
         {
             _contextTextView.text = [data objectForKey:@"agreement_desc"];
         }
    }
                            exceptionResponse:^(NSError *error) {
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
