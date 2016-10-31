//
//  InsuranceHelper.h
//  疯狂洗车
//
//  Created by cts on 15/11/26.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InsuranceCustomSelectModel.h"
#import "InsuranceGroupModel.h"

@interface InsuranceHelper : NSObject

+ (id)defaultHelper;

+ (void)requestInsuranceHomeModelNormalResponse:(void(^)(void))normalResponse
                              exceptionResponse:(void(^)(void))exceptionResponse;

+ (void)getDesiredInsuranceControllerResultResponse:(void(^)(id targetController))normalResponse;

+ (void)getDesiredInsuranceControllerResultResponse:(void(^)(id targetController))normalResponse
                              orUnFinishedInsurance:(void(^)(InsuranceGroupModel *insuranceGroupModel))unFinishRespone;

#pragma mark - 生成自定义选项模型的方法
+ (NSMutableArray*)createAndSettingDefaultEconomicalValueModelArray;//生成经济型默认选项
+ (NSMutableArray*)createAndSettingDefaultEconomicalAdditionalValueModelArray;//经济型附加险
+ (NSMutableArray*)createAndSettingDefaultPopularValueModelArray;//大众型
+ (NSMutableArray*)createAndSettingDefaultPopularAdditionalValueModelArray;//大众型附加险
+ (NSMutableArray*)createAndSettingDefaultOverallValueModelArray;//全面性
+ (NSMutableArray*)createAndSettingDefaultOverallAdditionalValueValueModelArray;//全面性附加险
+ (NSMutableArray*)createAndSettingDefaultCustomValueModelArray;//自定义
+ (NSMutableArray*)createAndSettingDefaultCustomAdditionalValueModelArray;//自定义附加险

#pragma mark - 根据报价详情返回自定义选项模型的方法
+ (NSMutableArray*)filterValueModelFormDetailItemModel:(InsuranceDetailItemModel*)detailModel
                                       withSuggestType:(NSString*)suggestType;

+ (NSMutableArray*)filterAdditionalValueModelFormDetailItemModel:(InsuranceDetailItemModel*)detailModel
                                                 withSuggestType:(NSString*)suggestType;
@end
