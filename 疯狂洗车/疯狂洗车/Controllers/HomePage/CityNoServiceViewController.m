//
//  CityNoServiceViewController.m
//  优快保
//
//  Created by cts on 15/6/14.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "CityNoServiceViewController.h"

@interface CityNoServiceViewController ()

@end

@implementation CityNoServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self.service_type isEqualToString:@"0"])
    {
        [self setTitle:@"洗车"];
    }
    else if ([self.service_type isEqualToString:@"1"])
    {
        [self setTitle:@"保养"];
    }
    else if ([self.service_type isEqualToString:@"2"])
    {
        [self setTitle:@"划痕"];
    }
    else if ([self.service_type isEqualToString:@"3"])
    {
        [self setTitle:@"美容"];
    }
    else if ([self.service_type isEqualToString:@"4"])
    {
        [self setTitle:@"救援"];
    }
    else if ([self.service_type isEqualToString:@"6"])
    {
        [self setTitle:@"速援"];
    }
    else if ([self.service_type isEqualToString:@"7"])
    {
        [self setTitle:@"免费送修理赔"];
    }
    else if ([self.service_type isEqualToString:@"8"])
    {
        [self setTitle:@"年检代办"];
    }
    else if ([self.service_type isEqualToString:@"20"])
    {
        [self setTitle:@"4S店服务"];
    }
    else if ([self.service_type isEqualToString:@"21"])
    {
        [self setTitle:@"VIP"];
    }
    else
    {
        [self setTitle:@"车保姆"];
    }
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
