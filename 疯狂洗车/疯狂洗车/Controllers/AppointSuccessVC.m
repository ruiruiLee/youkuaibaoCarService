//
//  AppointSuccessVC.m
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/13.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "AppointSuccessVC.h"
#import "MyAppointVC.h"

@interface AppointSuccessVC ()

@end

@implementation AppointSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"预约成功"];
    
    self.btnReturnHome.layer.cornerRadius = 4;
    self.btnReturnHome.layer.borderWidth = 1;
    self.btnReturnHome.layer.borderColor = [UIColor colorWithRed:0xff/255.0 green:0x66/255.0 blue:0x19/255.0 alpha:1].CGColor;
    
    self.btnAppointList.layer.cornerRadius = 4;
    
    self.lbCarNo.text = self.carNo;
    self.lbServiceTime.text = [NSString stringWithFormat:@"%@ %@点-%@点", [_successDic objectForKey:@"reserve_day"], [_successDic objectForKey:@"b_time"], [_successDic objectForKey:@"e_time"]];
    
    if(self.service_type == enumSmenquche){
        self.lbServiceType.text = @"上门取车";
    }
    else{
        self.lbServiceType.text = @"自驾到店";
    }
    
    switch (self.fuwuType) {
        case 0:
        {
            self.lbSAerviceName.text = @"洗车";
        }
            break;
        case 1:
        {
            self.lbSAerviceName.text = @"保养";
        }
            break;
        case 2:
        {
            self.lbSAerviceName.text = @"板喷／快修";
        }
            break;
        case 3:
        {
            self.lbSAerviceName.text = @"美容";
        }
            break;
        case 4:
        {
            self.lbSAerviceName.text = @"救援";
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doBtnReturnHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)doBtn2AppointList:(id)sender
{
    MyAppointVC *vc = [[MyAppointVC alloc] initWithNibName:@"MyAppointVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
