//
//  InsuranceHelper.m
//  疯狂洗车
//
//  Created by cts on 15/11/26.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "InsuranceHelper.h"
#import "WebServiceHelper.h"
#import "InsuranceListViewController.h"
#import "InsuranceSubmitViewController.h"

@implementation InsuranceHelper

+ (id)defaultHelper
{
    static InsuranceHelper *defaultHelper = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
                  {
                      defaultHelper = [[InsuranceHelper alloc] init];
                  });
    
    return defaultHelper;
}

#pragma mark - 获取保险首页

+ (void)requestInsuranceHomeModelNormalResponse:(void(^)(void))normalResponse
                              exceptionResponse:(void(^)(void))exceptionResponse
{
    [[InsuranceHelper defaultHelper] requestInsuranceHomeModelNormalResponse:^{
        normalResponse();
        return ;
    }
                                                           exceptionResponse:^{
                                                               exceptionResponse();
                                                               return ;
    }];
}

- (void)requestInsuranceHomeModelNormalResponse:(void(^)(void))normalResponse
                              exceptionResponse:(void(^)(void))exceptionResponse
{
//    NSDictionary *submitDic = @{@"member_id":!_userInfo.member_id?@"":_userInfo.member_id};
//    [WebService requestJsonModelWithParam:submitDic
//                                   action:@"insurance/service/intro"
//                               modelClass:[InsuranceHomeModel class]
//                           normalResponse:^(NSString *status, id data, JsonBaseModel *model)
//     {
//         _insuranceHomeModel = (InsuranceHomeModel*)model;
//         normalResponse();
//         return ;
//         
//     }
//                        exceptionResponse:^(NSError *error)
//    {
//        exceptionResponse();
//        return ;
//                        }];

}

+ (void)getDesiredInsuranceControllerResultResponse:(void(^)(id targetController))normalResponse;
{
    [[InsuranceHelper defaultHelper] getDesiredInsuranceControllerResultResponse:^(id targetController) {
        normalResponse(targetController);
    }];
}

- (void)getDesiredInsuranceControllerResultResponse:(void(^)(id targetController))normalResponse;
{
    if (_insuranceHomeModel.is_used.intValue > 0)
    {
        NSDictionary *submitDic = @{@"member_id":_userInfo.member_id,
                                    @"page_index":[NSNumber numberWithInteger:1],
                                    @"page_size":[NSNumber numberWithInteger:20],
                                    @"ver_no":@"2"};
        

        [WebService requestJsonArrayOperationWithParam:submitDic
                                                action:@"insurance/service/list"
                                            modelClass:[InsuranceGroupModel class]
                                        normalResponse:^(NSString *status, id data, NSMutableArray *array)
         {

             id resultController = nil;
             if (array.count >1)
             {
                 InsuranceListViewController *viewController = [[InsuranceListViewController alloc] initWithNibName:@"InsuranceListViewController"
                                                                                                             bundle:nil];
                 resultController = viewController;
             }
             else
             {
                 InsuranceGroupModel *targetModel = nil;
                 if (array.count > 0)
                 {
                     targetModel = array[0];
                 }
                 if (targetModel == nil)
                 {
                     InsuranceSubmitViewController *viewController = [[InsuranceSubmitViewController alloc] initWithNibName:@"InsuranceSubmitViewController" bundle:nil];
                     
                     resultController = viewController;
                 }
                 else if (targetModel.insur_status.intValue == 4)
                 {
                     InsuranceSubmitViewController *viewController = [[InsuranceSubmitViewController alloc] initWithNibName:@"InsuranceSubmitViewController"
                                                                                                                     bundle:nil];
                     viewController.isEdit = YES;
                     viewController.insuranceGroupModel = targetModel;
                     viewController.isCustomdSubmited = NO;
                     resultController = viewController;
                 }
                 else
                 {
                     InsuranceListViewController *viewController = [[InsuranceListViewController alloc] initWithNibName:@"InsuranceListViewController"
                                                                                                                 bundle:nil];
                     resultController = viewController;
                 }
             }
             normalResponse(resultController);

         }
                                     exceptionResponse:^(NSError *error)
         {

             InsuranceListViewController *viewController = [[InsuranceListViewController alloc] initWithNibName:@"InsuranceListViewController"
                                                                                                         bundle:nil];
             normalResponse(viewController);
         }];
    }
    else
    {
        InsuranceSubmitViewController *viewController = [[InsuranceSubmitViewController alloc] initWithNibName:@"InsuranceSubmitViewController" bundle:nil];

        normalResponse(viewController);
    }
}

#pragma mark - 得到理想的页面或者对象模型

+ (void)getDesiredInsuranceControllerResultResponse:(void(^)(id targetController))normalResponse
                              orUnFinishedInsurance:(void(^)(InsuranceGroupModel *insuranceGroupModel))unFinishRespone
{
    [[InsuranceHelper defaultHelper] getDesiredInsuranceControllerResultResponse:^(id targetController) {
        normalResponse(targetController);
        return ;
    }
                                                           orUnFinishedInsurance:^(InsuranceGroupModel *insuranceGroupModel) {
                                                               unFinishRespone(insuranceGroupModel);
                                                               return ;
    }];
}

- (void)getDesiredInsuranceControllerResultResponse:(void(^)(id targetController))normalResponse
                              orUnFinishedInsurance:(void(^)(InsuranceGroupModel *insuranceGroupModel))unFinishRespone
{
    NSDictionary *submitDic = @{@"member_id":_userInfo.member_id,
                                @"page_index":[NSNumber numberWithInteger:1],
                                @"page_size":[NSNumber numberWithInteger:20],
                                @"ver_no":@"2"};
    
    

    [WebService requestJsonArrayOperationWithParam:submitDic
                                            action:@"insurance/service/list"
                                        modelClass:[InsuranceGroupModel class]
                                    normalResponse:^(NSString *status, id data, NSMutableArray *array)
     {

         id resultController = nil;
         if (array.count >1)
         {
             InsuranceListViewController *viewController = [[InsuranceListViewController alloc] initWithNibName:@"InsuranceListViewController"
                                                                                                         bundle:nil];
             resultController = viewController;
         }
         else
         {
             InsuranceGroupModel *targetModel = nil;
             if (array.count > 0)
             {
                 targetModel = array[0];
             }
             if (targetModel == nil)
             {
                 InsuranceSubmitViewController *viewController = [[InsuranceSubmitViewController alloc] initWithNibName:@"InsuranceSubmitViewController" bundle:nil];
                 
                 resultController = viewController;
             }
             else if (targetModel.insur_status.intValue == 4)
             {
                 InsuranceSubmitViewController *viewController = [[InsuranceSubmitViewController alloc] initWithNibName:@"InsuranceSubmitViewController"
                                                                                                                 bundle:nil];
                 viewController.isEdit = YES;
                 viewController.insuranceGroupModel = targetModel;
                 viewController.isCustomdSubmited = NO;
                 resultController = viewController;
                 unFinishRespone(targetModel);
                 return ;
             }
             else
             {
                 InsuranceListViewController *viewController = [[InsuranceListViewController alloc] initWithNibName:@"InsuranceListViewController"
                                                                                                             bundle:nil];
                 resultController = viewController;
             }
         }
         normalResponse(resultController);
         
     }
                                 exceptionResponse:^(NSError *error)
     {

         InsuranceListViewController *viewController = [[InsuranceListViewController alloc] initWithNibName:@"InsuranceListViewController"
                                                                                                     bundle:nil];
         normalResponse(viewController);
     }];

}


#pragma mark - 创建自定义选项代码

+ (NSMutableArray*)createAndSettingDefaultEconomicalValueModelArray//生成经济型默认选项
{
    return [[InsuranceHelper defaultHelper] createAndSettingDefaultEconomicalValueModelArray];
}

- (NSMutableArray*)createAndSettingDefaultEconomicalValueModelArray//生成经济型默认选项
{
    InsuranceCustomSelectModel *jqModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"交强险+车船税"
                                                                                                        andIntro:@""
                                                                                                         andDesc:@"发生车险事故时，赔偿对第三方造成的人身及财产损失（不保本车，以及车上的成员，强制购买）。"
                                                                                               andValueModelType:CustomSelectValueTypeJQCC
                                                                                                 andDefaultIndex:0
                                                                                             andShouldBjmpEnable:NO];
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:@[jqModel]];
    
    return resultArray;
}

+ (NSMutableArray*)createAndSettingDefaultEconomicalAdditionalValueModelArray//经济型附加险
{
    return [[InsuranceHelper defaultHelper] createAndSettingDefaultEconomicalAdditionalValueModelArray];
}

- (NSMutableArray*)createAndSettingDefaultEconomicalAdditionalValueModelArray//经济型附加险
{
    NSMutableArray *resultArray = nil;
    
    return resultArray;
}

+ (NSMutableArray*)createAndSettingDefaultPopularValueModelArray//大众型
{
    return [[InsuranceHelper defaultHelper] createAndSettingDefaultPopularValueModelArray];
}


- (NSMutableArray*)createAndSettingDefaultPopularValueModelArray//大众型
{
    //交强险
    InsuranceCustomSelectModel *jqModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"交强险+车船税"
                                                                                                        andIntro:@""
                                                                                                         andDesc:@"发生车险事故时，赔偿对第三方造成的人身及财产损失（不保本车，以及车上的成员，强制购买）。"
                                                                                               andValueModelType:CustomSelectValueTypeJQCC
                                                                                                 andDefaultIndex:0
                                                                                             andShouldBjmpEnable:NO];
    
    // 车损险
    InsuranceCustomSelectModel *csModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"车损险"
                                                                                                        andIntro:@"购买率95%"
                                                                                                         andDesc:@"发生车辆碰撞时，赔偿自己车辆损失的费用，是对车最基本的保障"
                                                                                               andValueModelType:CustomSelectValueTypeCS
                                                                                                 andDefaultIndex:1
                                                                                             andShouldBjmpEnable:YES];
    
    // 三责险
    InsuranceCustomSelectModel *szModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"三者险"
                                                                                                        andIntro:@"购买率99%"
                                                                                                         andDesc:@"装伤土豪、撞坏豪车真心配不起，而三者险就是用于赔偿这类对他人造成的人身及财产损失。"
                                                                                               andValueModelType:CustomSelectValueTypeSZ
                                                                                                 andDefaultIndex:4
                                                                                             andShouldBjmpEnable:YES];
    
    // 乘客险
    InsuranceCustomSelectModel *ckModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"乘客险"
                                                                                                        andIntro:@"购买率81%"
                                                                                                         andDesc:@"发生车险事故时，赔偿车内乘客的伤亡和医疗赔偿费用。"
                                                                                               andValueModelType:CustomSelectValueTypeCK
                                                                                                 andDefaultIndex:1
                                                                                             andShouldBjmpEnable:YES];
    // 司机险
    InsuranceCustomSelectModel *sjModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"司机险"
                                                                                                        andIntro:@"购买率81%"
                                                                                                         andDesc:@"由于驾驶者自身责任发生车险事故，赔偿车内驾驶员自身的伤亡和医疗费用。"
                                                                                               andValueModelType:CustomSelectValueTypeSJ
                                                                                                 andDefaultIndex:1
                                                                                             andShouldBjmpEnable:YES];
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:@[jqModel,csModel,szModel,ckModel,sjModel]];
    
    return resultArray;
}

+ (NSMutableArray*)createAndSettingDefaultPopularAdditionalValueModelArray//大众型附加险
{
    return [[InsuranceHelper defaultHelper] createAndSettingDefaultPopularAdditionalValueModelArray];
}


- (NSMutableArray*)createAndSettingDefaultPopularAdditionalValueModelArray//大众型附加险
{
    NSMutableArray *resultArray = nil;
    
    return resultArray;
}

+ (NSMutableArray*)createAndSettingDefaultOverallValueModelArray//全面性
{
    return [[InsuranceHelper defaultHelper] createAndSettingDefaultOverallValueModelArray];
}



- (NSMutableArray*)createAndSettingDefaultOverallValueModelArray//全面性
{
    
    //交强险
    InsuranceCustomSelectModel *jqModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"交强险+车船税"
                                                                                                        andIntro:@""
                                                                                                         andDesc:@"发生车险事故时，赔偿对第三方造成的人身及财产损失（不保本车，以及车上的成员，强制购买）。"
                                                                                               andValueModelType:CustomSelectValueTypeJQCC
                                                                                                 andDefaultIndex:0
                                                                                             andShouldBjmpEnable:NO];
    
    // 车损险
    InsuranceCustomSelectModel *csModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"车损险"
                                                                                                        andIntro:@"购买率95%"
                                                                                                         andDesc:@"发生车辆碰撞时，赔偿自己车辆损失的费用，是对车最基本的保障"
                                                                                               andValueModelType:CustomSelectValueTypeCS
                                                                                                 andDefaultIndex:1
                                                                                             andShouldBjmpEnable:YES];
    
    // 三责险
    InsuranceCustomSelectModel *szModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"三者险"
                                                                                                        andIntro:@"购买率99%"
                                                                                                         andDesc:@"装伤土豪、撞坏豪车真心配不起，而三者险就是用于赔偿这类对他人造成的人身及财产损失。"
                                                                                               andValueModelType:CustomSelectValueTypeSZ
                                                                                                 andDefaultIndex:6
                                                                                             andShouldBjmpEnable:YES];
    
    // 盗抢险
    InsuranceCustomSelectModel *dqModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"盗抢险"
                                                                                                        andIntro:@"购买率40%"
                                                                                                         andDesc:@"赔偿全车被盗、抢劫、抢夺造成的车辆损失。"
                                                                                               andValueModelType:CustomSelectValueTypeDQ
                                                                                                 andDefaultIndex:1
                                                                                             andShouldBjmpEnable:YES];
    
    // 司机险
    InsuranceCustomSelectModel *sjModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"司机险"
                                                                                                        andIntro:@"购买率81%"
                                                                                                         andDesc:@"由于驾驶者自身责任发生车险事故，赔偿车内驾驶员自身的伤亡和医疗费用。"
                                                                                               andValueModelType:CustomSelectValueTypeSJ
                                                                                                 andDefaultIndex:1
                                                                                             andShouldBjmpEnable:YES];
    // 乘客险
    InsuranceCustomSelectModel *ckModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"乘客险"
                                                                                                        andIntro:@"购买率81%"
                                                                                                         andDesc:@"发生车险事故时，赔偿车内乘客的伤亡和医疗赔偿费用。"
                                                                                               andValueModelType:CustomSelectValueTypeCK
                                                                                                 andDefaultIndex:1
                                                                                             andShouldBjmpEnable:YES];
    
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:@[jqModel,csModel,szModel,ckModel,sjModel,dqModel]];
    
    return resultArray;
}

+ (NSMutableArray*)createAndSettingDefaultOverallAdditionalValueValueModelArray//全面性
{
    return [[InsuranceHelper defaultHelper] createAndSettingDefaultOverallAdditionalValueValueModelArray];
}

- (NSMutableArray*)createAndSettingDefaultOverallAdditionalValueValueModelArray//全面性
{
    // 玻璃险
    InsuranceCustomSelectModel *blModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"玻璃险"
                                                                                                        andIntro:@"购买率41%"
                                                                                                         andDesc:@"赔偿车窗、挡风玻璃的单独开裂、破碎损失。"
                                                                                               andValueModelType:CustomSelectValueTypeBL
                                                                                                 andDefaultIndex:1
                                                                                             andShouldBjmpEnable:NO];
    
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:@[blModel]];
    
    return resultArray;
}


+ (NSMutableArray*)createAndSettingDefaultCustomValueModelArray//全面性
{
    return [[InsuranceHelper defaultHelper] createAndSettingDefaultCustomValueModelArray];
}

- (NSMutableArray*)createAndSettingDefaultCustomValueModelArray//自定义
{
    
    //交强险
    InsuranceCustomSelectModel *jqModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"交强险+车船税"
                                                                                                        andIntro:@""
                                                                                                         andDesc:@"发生车险事故时，赔偿对第三方造成的人身及财产损失（不保本车，以及车上的成员，强制购买）。"
                                                                                               andValueModelType:CustomSelectValueTypeJQCC
                                                                                                 andDefaultIndex:0
                                                                                             andShouldBjmpEnable:NO];
    
    // 车损险
    InsuranceCustomSelectModel *csModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"车损险"
                                                                                                        andIntro:@"购买率95%"
                                                                                                         andDesc:@"发生车辆碰撞时，赔偿自己车辆损失的费用，是对车最基本的保障"
                                                                                               andValueModelType:CustomSelectValueTypeCS
                                                                                                 andDefaultIndex:1
                                                                                             andShouldBjmpEnable:YES];
    
    // 三责险
    InsuranceCustomSelectModel *szModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"三者险"
                                                                                                        andIntro:@"购买率99%"
                                                                                                         andDesc:@"装伤土豪、撞坏豪车真心配不起，而三者险就是用于赔偿这类对他人造成的人身及财产损失。"
                                                                                               andValueModelType:CustomSelectValueTypeSZ
                                                                                                 andDefaultIndex:4
                                                                                             andShouldBjmpEnable:YES];
    
    // 盗抢险
    InsuranceCustomSelectModel *dqModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"盗抢险"
                                                                                                        andIntro:@"购买率40%"
                                                                                                         andDesc:@"赔偿全车被盗、抢劫、抢夺造成的车辆损失。"
                                                                                               andValueModelType:CustomSelectValueTypeDQ
                                                                                                 andDefaultIndex:0
                                                                                             andShouldBjmpEnable:YES];
    
    // 司机险
    InsuranceCustomSelectModel *sjModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"司机险"
                                                                                                        andIntro:@"购买率81%"
                                                                                                         andDesc:@"由于驾驶者自身责任发生车险事故，赔偿车内驾驶员自身的伤亡和医疗费用。"
                                                                                               andValueModelType:CustomSelectValueTypeSJ
                                                                                                 andDefaultIndex:1
                                                                                             andShouldBjmpEnable:YES];
    // 乘客险
    InsuranceCustomSelectModel *ckModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"乘客险"
                                                                                                        andIntro:@"购买率81%"
                                                                                                         andDesc:@"发生车险事故时，赔偿车内乘客的伤亡和医疗赔偿费用。"
                                                                                               andValueModelType:CustomSelectValueTypeCK
                                                                                                 andDefaultIndex:1
                                                                                             andShouldBjmpEnable:YES];
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:@[jqModel,csModel,szModel,ckModel,sjModel,dqModel]];
    
    return resultArray;
}

+ (NSMutableArray*)createAndSettingDefaultCustomAdditionalValueModelArray//全面性
{
    return [[InsuranceHelper defaultHelper] createAndSettingDefaultCustomAdditionalValueModelArray];
}

- (NSMutableArray*)createAndSettingDefaultCustomAdditionalValueModelArray//自定义附加险
{
    // 玻璃险
    InsuranceCustomSelectModel *blModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"玻璃险"
                                                                                                        andIntro:@"购买率41%"
                                                                                                         andDesc:@"赔偿车窗、挡风玻璃的单独开裂、破碎损失。"
                                                                                               andValueModelType:CustomSelectValueTypeBL
                                                                                                 andDefaultIndex:0
                                                                                             andShouldBjmpEnable:NO];
    // 涉水险
    InsuranceCustomSelectModel *ssModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"涉水险"
                                                                                                        andIntro:@"购买率20%"
                                                                                                         andDesc:@"车辆在积水路面涉水行驶或被水淹后，致使发动机损坏给予赔偿。"
                                                                                               andValueModelType:CustomSelectValueTypeSS
                                                                                                 andDefaultIndex:0
                                                                                             andShouldBjmpEnable:YES];
    // 划痕险
    InsuranceCustomSelectModel *hhModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"划痕险"
                                                                                                        andIntro:@"购买率10%"
                                                                                                         andDesc:@"赔偿车身表面油漆单独划上的损失。"
                                                                                               andValueModelType:CustomSelectValueTypeHH
                                                                                                 andDefaultIndex:0
                                                                                             andShouldBjmpEnable:YES];
    // 自然险
    InsuranceCustomSelectModel *zrModel = [[InsuranceCustomSelectModel alloc] initWithCustomSelectModelWithTitle:@"自燃险"
                                                                                                        andIntro:@"购买率30%"
                                                                                                         andDesc:@"因车辆自身发生问题引起燃烧时，赔偿因此造成的电路线路和供电系统的维修损失。"
                                                                                               andValueModelType:CustomSelectValueTypeZR
                                                                                                 andDefaultIndex:0
                                                                                             andShouldBjmpEnable:YES];
    
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:@[blModel,ssModel,hhModel,zrModel]];
    
    return resultArray;
}


+ (NSMutableArray*)filterValueModelFormDetailItemModel:(InsuranceDetailItemModel*)detailModel
                                       withSuggestType:(NSString*)suggestType
{
    return [[InsuranceHelper defaultHelper] filterValueModelFormDetailItemModel:detailModel
                                                                withSuggestType:suggestType];
}

- (NSMutableArray*)filterValueModelFormDetailItemModel:(InsuranceDetailItemModel*)detailModel
                             withSuggestType:(NSString*)suggestType
{
    NSMutableArray *resultArray = nil;
    if (suggestType.intValue == 1)
    {
        resultArray = [self createAndSettingDefaultEconomicalValueModelArray];
    }
    else if (suggestType.intValue == 2)
    {
        resultArray = [self createAndSettingDefaultPopularValueModelArray];
    }
    else if (suggestType.intValue == 3)
    {
        resultArray = [self createAndSettingDefaultOverallValueModelArray];
    }
    else if (suggestType.intValue == 4)
    {
        resultArray = [self createAndSettingDefaultCustomValueModelArray];
    }
    
    for (int x = 0; x<resultArray.count; x++)
    {
        InsuranceCustomSelectModel *model = resultArray[x];
        if (model.valueType == CustomSelectValueTypeJQCC)
        {
            
        }
        else if (model.valueType == CustomSelectValueTypeCS)
        {
            model.bjmpEnable = YES;
            model.selectedIndex = detailModel.cs_status.intValue > 0?1:0;
            model.bjmpSelected = detailModel.cs_bjmp_status.intValue > 0?YES:NO;
        }
        else if (model.valueType == CustomSelectValueTypeSZ)
        {
            model.bjmpEnable = YES;
            NSArray *valueArray =  @[@"0",@"5",@"10",@"15",@"20",@"30",@"50",@"100"];
            for (int x =0; x<valueArray.count; x++)
            {
                NSString *valuePrice = valueArray[x];
                if (detailModel.sz_price.intValue == valuePrice.intValue)
                {
                    model.selectedIndex = x;
                }
            }
         
            model.bjmpSelected = detailModel.sz_bjmp_status.intValue > 0?YES:NO;

        }
        else if (model.valueType == CustomSelectValueTypeDQ)
        {
            model.bjmpEnable = YES;
            model.selectedIndex = detailModel.dq_status.intValue > 0?1:0;
            model.bjmpSelected = detailModel.dq_bjmp_status.intValue > 0?YES:NO;


        }
        else if (model.valueType == CustomSelectValueTypeSJ)
        {
            model.bjmpEnable = YES;
            NSArray *valueArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"10"];
            for (int x =0; x<valueArray.count; x++)
            {
                NSString *valuePrice = valueArray[x];
                if (detailModel.sj_price.intValue == valuePrice.intValue)
                {
                    model.selectedIndex = x;
                }
            }
            
            model.bjmpSelected = detailModel.sj_bjmp_status.intValue > 0?YES:NO;

        }
        else if (model.valueType == CustomSelectValueTypeCK)
        {
            model.bjmpEnable = YES;
            NSArray *valueArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"10"];
            for (int x =0; x<valueArray.count; x++)
            {
                NSString *valuePrice = valueArray[x];
                if (detailModel.ck_price.intValue == valuePrice.intValue)
                {
                    model.selectedIndex = x;
                }
            }
            
            model.bjmpSelected = detailModel.ck_bjmp_status.intValue > 0?YES:NO;
        }
    }
        
    
    return resultArray;
}

+ (NSMutableArray*)filterAdditionalValueModelFormDetailItemModel:(InsuranceDetailItemModel*)detailModel
                             withSuggestType:(NSString*)suggestType
{
    return [[InsuranceHelper defaultHelper] filterAdditionalValueModelFormDetailItemModel:detailModel
                                                                          withSuggestType:suggestType];
}

- (NSMutableArray*)filterAdditionalValueModelFormDetailItemModel:(InsuranceDetailItemModel*)detailModel
                                       withSuggestType:(NSString*)suggestType
{
    NSMutableArray *resultArray = nil;
    if (suggestType.intValue == 1)
    {
        resultArray = [self createAndSettingDefaultEconomicalAdditionalValueModelArray];
    }
    else if (suggestType.intValue == 2)
    {
        resultArray = [self createAndSettingDefaultPopularAdditionalValueModelArray];
    }
    else if (suggestType.intValue == 3)
    {
        resultArray = [self createAndSettingDefaultOverallAdditionalValueValueModelArray];
    }
    else if (suggestType.intValue == 4)
    {
        resultArray = [self createAndSettingDefaultCustomAdditionalValueModelArray];
    }
    
    for (int x = 0; x<resultArray.count; x++)
    {
        InsuranceCustomSelectModel *model = resultArray[x];
        if (model.valueType == CustomSelectValueTypeBL)
        {
            model.bjmpEnable = YES;
            NSArray *valueArray =  @[@"0",@"1",@"2"];
            for (int x =0; x<valueArray.count; x++)
            {
                if ([detailModel.bl_stauts isEqualToString:valueArray[x]])
                {
                    model.selectedIndex = x;
                }
            }
        }
        else if (model.valueType == CustomSelectValueTypeSS)
        {
            model.bjmpEnable = YES;
            model.selectedIndex = detailModel.ss_status.intValue > 0?1:0;
            model.bjmpSelected = detailModel.ss_bjmp_status.intValue > 0?YES:NO;
        }
        else if (model.valueType == CustomSelectValueTypeHH)
        {
            model.bjmpEnable = YES;
            NSArray *valueArray =  @[@"0",@"2000",@"5000",@"1",@"2"];
            for (int x =0; x<valueArray.count; x++)
            {
                NSString *valuePrice = valueArray[x];
                if (detailModel.hh_price.intValue == valuePrice.intValue)
                {
                    model.selectedIndex = x;
                }
            }
            
            model.bjmpSelected = detailModel.hh_bjmp_status.intValue > 0?YES:NO;
            
        }
        else if (model.valueType == CustomSelectValueTypeZR)
        {
            model.selectedIndex = detailModel.zr_status.intValue > 0?1:0;
            //model.bjmpEnable = YES;
            model.bjmpSelected = detailModel.zr_bjmp_status.intValue > 0?YES:NO;
            
            if (detailModel.cs_bjmp_status.intValue == 0 || detailModel.cs_status == 0)
            {
                model.bjmpEnable = NO;
                model.bjmpSelected = NO;
            }
            else
            {
                model.bjmpEnable = YES;
            }

        }
    }

    
    return resultArray;
}
@end
