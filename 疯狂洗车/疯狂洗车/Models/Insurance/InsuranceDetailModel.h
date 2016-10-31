//
//  InsuranceDetailModel.h
//  
//
//  Created by cts on 15/9/15.
//
//

#import "JsonBaseModel.h"
#import "InsuranceInfoModel.h"
#import "InsuranceDetailItemModel.h"

@interface InsuranceDetailModel : JsonBaseModel

@property (strong, nonatomic) NSString *insurance_id;

@property (strong, nonatomic) InsuranceInfoModel *insuranceInfoModel;

@property (strong, nonatomic) InsuranceDetailItemModel *insuranceDetailItemModel;

@property (strong, nonatomic) NSMutableArray *detailItemModelsArray;



@end
