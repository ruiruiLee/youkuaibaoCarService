//
//  InsurancePayInfoModel.h
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

///保险报价保单详情model类，包含该报价下的所有价格和优惠明细
@interface InsurancePayInfoModel : JsonBaseModel


@property (strong, nonatomic) NSString*bx_name;//保险名称

@property (strong, nonatomic) NSString*bx_user_name;//保险经纪人名字

@property (strong, nonatomic) NSString*contanct_phone;//保险经纪人联系电话

@property (strong, nonatomic) NSString*sy_price;//商业保险

@property (strong, nonatomic) NSString*sy_pay_price;//商业险实缴

@property (strong, nonatomic) NSString*insurance_no;//保险编号


@property (strong, nonatomic) NSString*sy_ratios;//商业保险优惠，|分隔数组，#分隔键值对 例：折扣80%#10000|70%#2000

@property (strong, nonatomic) NSString*jq_price;//交强险

@property (strong, nonatomic) NSString*jq_ratios;//交强险。同商业优惠

@property (strong, nonatomic) NSString*cc_price;//车船线

@property (strong, nonatomic) NSString*cc_ratios;//车船险。同商业优惠

@property (strong, nonatomic) NSString*fee_price;//商业险总价

@property (strong, nonatomic) NSString*total_price;//需支付总价

@property (strong, nonatomic) NSString*other_prices;//其他险 |分隔数组，#分隔键值对 例：交强险#10000|第三责任险#2000


@property (strong, nonatomic) NSString*gifts;//赠送  |分隔数组，#分隔键值对

@property (strong, nonatomic) NSString*code_count;//大于0，可以使用券支付

//以下为推荐券的字段
@property (strong, nonatomic) NSString *code_id;//

@property (strong, nonatomic) NSString *code_content;//

@property (strong, nonatomic) NSString *price;//

@property (strong, nonatomic) NSString *service_type;//

@property (strong, nonatomic) NSString *consume_type;//

@property (strong, nonatomic) NSString *create_time;//

@property (strong, nonatomic) NSString *code_name;//

@property (strong, nonatomic) NSString *begin_time;//

@property (strong, nonatomic) NSString *end_time;//

@property (strong, nonatomic) NSString *remain_times;//

@property (strong, nonatomic) NSString *code_desc;

@property (strong, nonatomic) NSString *comp_id;

@property (strong, nonatomic) NSString *comp_name;

@property (strong, nonatomic) NSString *pay_flag;

@property (strong, nonatomic) NSString *times_limit;

//保险2.0字段

@property (strong, nonatomic) NSString *img_addrs;//图片地址

@property (strong, nonatomic) NSString *pay_title;//支付标题

@property (strong, nonatomic) NSString *pay_content;//支付内容

@property (strong, nonatomic) NSString *total_price_title;//总价标题

@property (strong, nonatomic) NSString *total_price_content;//总价内容

@property (strong, nonatomic) NSString *zk_price;//折扣价

@property (strong, nonatomic) NSString *member_price;//实际支付价格

@property (strong, nonatomic) NSString *min_jsz_num;//驾驶证最小数量

@property (strong, nonatomic) NSString *max_jsz_num;//驾驶证最大数量

@property (strong, nonatomic) NSString *min_cid_num;//身份证最小数量

@property (strong, nonatomic) NSString *max_cid_num;//身份证最大数量

@property (strong, nonatomic) NSArray *comp_list;//







//自用字段

@property (strong, nonatomic) NSArray *giftsArray;

@property (strong, nonatomic) NSString *carCardFrontUrl;//行驶证正

@property (strong, nonatomic) NSString *carCardBackUrl;//行驶证副

@property (strong, nonatomic) NSArray *driveCardImageArray;//驾驶证

@property (strong, nonatomic) NSArray *idCardImageArray;//身份证

@property (strong, nonatomic) NSString *insuranceCompName;

@property (strong, nonatomic) NSString *jqccPrice;

@property (strong, nonatomic) NSString *scxPrice;







/**
 *	@brief	从各个价格字段中获取保险的数据模型InsuranceBaseItemModel，方法内已经按照保险和优惠匹配排序
 *
 *	@return	NSArray 存有InsuranceBaseItemModel数据模型的数组
 */
- (NSArray*)getInsuranceDetailItemsArray;
/**
 *	@brief	从各个价格和优惠字段中获取保险和优惠的数据模型InsuranceBaseItemModel和InsuranceRatioItemModel，方法内已经按照保险和优惠匹配排序
 *
 *	@return	NSArray 存有InsuranceBaseItemModel和InsuranceRatioItemModel数据模型的数组
 */
- (NSArray*)getPayInfoBaseItemArray;

/**
 *	@brief	从gift字段中获取礼包的数据模型InsurancePresentItemModel
 *
 *	@return	NSArray 存有InsurancePresentItemModel数据模型的数组
 */
- (NSArray*)getPayInfoPresentItemArray;




@end
