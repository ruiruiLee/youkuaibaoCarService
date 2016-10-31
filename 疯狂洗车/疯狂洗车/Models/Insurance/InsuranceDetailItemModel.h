//
//  InsuranceDetailItemModel.h
//  
//
//  Created by cts on 15/9/22.
//
//

#import "JsonBaseModel.h"

@interface InsuranceDetailItemModel : JsonBaseModel

@property (strong, nonatomic) NSString *insur_status;

@property (strong, nonatomic) NSString *pay_price;

@property (strong, nonatomic) NSString *contact_phone;

@property (strong, nonatomic) NSString *contact_name;

@property (strong, nonatomic) NSString *suggest_url;

@property (strong, nonatomic) NSString *bixu_title;

@property (strong, nonatomic) NSString *sy_title;

@property (strong, nonatomic) NSString *sy_content;

@property (strong, nonatomic) NSString *bjmp_title;

@property (strong, nonatomic) NSString *bjmp_content;

@property (strong, nonatomic) NSString *bjmp_desc;

@property (strong, nonatomic) NSString *total_content;

@property (strong, nonatomic) NSString *fk_member_price;

@property (strong, nonatomic) NSString *fk_orginal_price;

@property (strong, nonatomic) NSString *contanct_phone;

@property (strong, nonatomic) NSString *gifts;

@property (strong, nonatomic) NSString *paid_status;

@property (strong, nonatomic) NSArray  *giftArray;

@property (strong, nonatomic) NSString *suggest_type;

//自选报价字段

@property (strong, nonatomic) NSString *define_id;

@property (strong, nonatomic) NSString *create_time;

@property (strong, nonatomic) NSString *jq_status;

@property (strong, nonatomic) NSString *cc_status;

@property (strong, nonatomic) NSString *cs_status;

@property (strong, nonatomic) NSString *sz_price;

@property (strong, nonatomic) NSString *sz_bjmp_status;

@property (strong, nonatomic) NSString *cs_bjmp_status;

@property (strong, nonatomic) NSString *dq_status;

@property (strong, nonatomic) NSString *dq_bjmp_status;

@property (strong, nonatomic) NSString *sj_price;

@property (strong, nonatomic) NSString *sj_bjmp_status;

@property (strong, nonatomic) NSString *ck_price;

@property (strong, nonatomic) NSString *ck_bjmp_status;

@property (strong, nonatomic) NSString *bl_stauts;

@property (strong, nonatomic) NSString *ss_status;

@property (strong, nonatomic) NSString *ss_bjmp_status;

@property (strong, nonatomic) NSString *hh_price;

@property (strong, nonatomic) NSString *hh_bjmp_status;

@property (strong, nonatomic) NSString *zr_status;

@property (strong, nonatomic) NSString *zr_bjmp_status;

@property (strong, nonatomic) NSString *insurance_id;

@property (strong, nonatomic) NSString *suggest_id;

@property (strong, nonatomic) NSString *comp_id;


//自用字段

@property (strong, nonatomic) NSString *total_content_title;

@property (strong, nonatomic) NSString *total_content_price;

@property (strong, nonatomic) NSString *giftsString;



- (NSMutableArray*)getInsuranceDetailElementsArray;

@end
