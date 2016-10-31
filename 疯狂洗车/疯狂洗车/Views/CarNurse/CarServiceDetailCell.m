//
//  CarServiceDetailCell.m
//  疯狂洗车
//
//  Created by cts on 15/11/11.
//  Copyright © 2015年 龚杰洪. All rights reserved.
//

#import "CarServiceDetailCell.h"

@implementation CarServiceDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayCarServiceDetailInfoWithCarNurse:(CarNurseModel*)carNurseModel
                                        andCarInfo:(CarInfos*)serviceCar
                                andCarNurseService:(CarNurseServiceModel*)serviceModel
{
    _carNurseNameLabel.text = [NSString stringWithFormat:@"%@",carNurseModel.name];
    
    
    NSString *carTitle = [NSString stringWithFormat:@"[%@] %@·%@ %@ %@",[serviceCar.car_type isEqualToString:@"1"]?@"轿车" : @"SUV",
                          [serviceCar.car_no substringWithRange:NSMakeRange(0, 2)],
                          [serviceCar.car_no substringWithRange:NSMakeRange(2, serviceCar.car_no.length-2)],
                          serviceCar.car_brand == nil ?@"无品牌信息":serviceCar.car_brand,
                          serviceCar.car_xilie == nil?@"":serviceCar.car_xilie ];
    
    _serviceCarLabel.text = [NSString stringWithFormat:@"%@",carTitle];
    
    NSString *serviceTypeString = nil;
    if ([serviceModel.service_type isEqualToString:@"1"])
    {
        serviceTypeString = @"保养服务";
    }
    else if ([serviceModel.service_type isEqualToString:@"2"])
    {
        serviceTypeString = @"划痕服务";
    }
    else if ([serviceModel.service_type isEqualToString:@"3"])
    {
        serviceTypeString = @"美容服务";
    }
    else if ([serviceModel.service_type isEqualToString:@"4"])
    {
        serviceTypeString = @"道路救援";
    }
    else if ([serviceModel.service_type isEqualToString:@"5"])
    {
        serviceTypeString = @"车保姆服务";
    }
    
    else
    {
        serviceTypeString = @"其他服务";
    }
    
    if ([serviceModel.service_type isEqualToString:@"4"] || [serviceModel.service_type isEqualToString:@"5"])
    {
        _serviceTypeAndWayLabel.text = [NSString stringWithFormat:@"%@",serviceTypeString];
    }
    else
    {
        _serviceTypeAndWayLabel.text = [NSString stringWithFormat:@"%@ - %@",serviceTypeString,serviceModel.service_name];
    }
    
    if ([serviceModel.service_content isEqualToString:@""] || serviceModel.service_content == nil)
    {
        _serviceContextLabel.text = @"暂无内容";
    }
    else
    {
        _serviceContextLabel.text = serviceModel.service_content;
    }
    if ([serviceModel.accessories isEqualToString:@""] || serviceModel.accessories == nil)
    {
        _servicePartsLabel.text   = @"暂无材料";
    }
    else
    {
        _servicePartsLabel.text   = serviceModel.accessories;
    }

}

@end
