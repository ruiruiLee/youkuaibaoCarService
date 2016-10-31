//
//  CarServiceDetailViewController.h
//  疯狂洗车
//
//  Created by cts on 15/11/9.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "BaseViewController.h"
#import "CarNurseModel.h"

typedef enum
{
    CarServiceTypeXiChe,
    CarServiceTypeCheFuWu,
    CarServiceTypeJiuYuan,
    CarServiceTypeCheBaoMu
}CarServiceType;

//车服务车场展示页面
@interface CarServiceDetailViewController : BaseViewController
{
    
}

@property (strong, nonatomic) NSString *service_type;

@property (strong, nonatomic) CarNurseModel *selectedCarNurse;

@end
