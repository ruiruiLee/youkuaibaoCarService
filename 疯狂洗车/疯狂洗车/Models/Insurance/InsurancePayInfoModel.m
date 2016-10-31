//
//  Insurancem
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "InsurancePayInfoModel.h"
#import "InsuranceBaseItemModel.h"
#import "InsuranceRatioItemModel.h"
#import "InsurancePresentItemModel.h"

@implementation InsurancePayInfoModel


- (void)setGifts:(NSString *)gifts
{
    _gifts = gifts;
    if ([_gifts isEqualToString:@""] || _gifts == nil)
    {
        
    }
    else
    {
        self.giftsArray = [self getPayInfoPresentItemArray];
    }
}

- (void)setImg_addrs:(NSString *)img_addrs
{
    _img_addrs = img_addrs;
    
    if ([_img_addrs isEqualToString:@""] || _img_addrs == nil)
    {
        
    }
    else
    {
        NSArray *imageAddresStringArray = [_img_addrs componentsSeparatedByString:@"|"];
        
        NSMutableArray *driveCardImageSrings = [NSMutableArray array];
        NSMutableArray *idCardImagesStrings = [NSMutableArray array];
        
        for (int x = 0; x<imageAddresStringArray.count; x++)
        {
            NSString *tmpStrin = imageAddresStringArray[x];
            
            if (tmpStrin.length > 0)
            {
                NSRange verticalLineRange = [tmpStrin rangeOfString:@"#"];
                
                if (verticalLineRange.location != NSNotFound)
                {
                    NSString *subString = [tmpStrin substringWithRange:NSMakeRange(0, verticalLineRange.location)];
                    if ([subString isEqualToString:@"1"])
                    {
                        NSString *carCardFrontImageString = [tmpStrin substringWithRange:NSMakeRange(verticalLineRange.location+1, tmpStrin.length-verticalLineRange.location-1)];
                        self.carCardFrontUrl = carCardFrontImageString;
                    }
                    else if ([subString isEqualToString:@"2"])
                    {
                        NSString *carCardBackImageString = [tmpStrin substringWithRange:NSMakeRange(verticalLineRange.location+1, tmpStrin.length-verticalLineRange.location-1)];
                        self.carCardBackUrl = carCardBackImageString;
                    }
                    else if ([subString isEqualToString:@"3"])
                    {
                        [driveCardImageSrings addObject:[tmpStrin substringWithRange:NSMakeRange(verticalLineRange.location+1, tmpStrin.length-verticalLineRange.location-1)]];
                    }
                    else if ([subString isEqualToString:@"4"])
                    {
                        [idCardImagesStrings addObject:[tmpStrin substringWithRange:NSMakeRange(verticalLineRange.location+1, tmpStrin.length-verticalLineRange.location-1)]];
                    }
                }
            }
        }

        if (idCardImagesStrings.count > 0)
        {
            _idCardImageArray = idCardImagesStrings;
        }
        if (driveCardImageSrings.count > 0)
        {
            _driveCardImageArray = driveCardImageSrings;
        }
    }
}

- (void)setPay_content:(NSString *)pay_content
{
    _pay_content = pay_content;
    if ([_pay_content isEqualToString:@""] || _pay_content == nil)
    {
        self.insuranceCompName = self.comp_name;
        self.jqccPrice = [NSString stringWithFormat:@"￥%.2f",self.jq_price.floatValue+self.cc_price.floatValue];
        self.scxPrice = self.sy_pay_price;
    }
    else
    {
        NSArray *paycontentStringArray = [_pay_content componentsSeparatedByString:@"|"];
        
        for (int x = 0; x<paycontentStringArray.count; x++)
        {
            NSString *tmpStrin = paycontentStringArray[x];
            
            if (tmpStrin.length > 0)
            {
                NSArray *tmpArray = [tmpStrin componentsSeparatedByString:@"#"];
                if (tmpArray.count > 1)
                {
                    if ([tmpArray[0] isEqualToString:@"保险公司："])
                    {
                        self.insuranceCompName = [NSString stringWithFormat:@"%@",tmpArray[1]];
                    }
                    else if ([tmpArray[0] isEqualToString:@"交强险+车船税："])
                    {
                        self.jqccPrice = [NSString stringWithFormat:@"%@",tmpArray[1]];
                    }
                    else if ([tmpArray[0] isEqualToString:@"商车险："])
                    {
                        self.scxPrice = [NSString stringWithFormat:@"%@",tmpArray[1]];
                    }
                }
            }
        }
    }

}

- (NSArray*)getInsuranceDetailItemsArray
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    InsuranceBaseItemModel *ccjqmodel = [[InsuranceBaseItemModel alloc] init];
    ccjqmodel.insuranceName = @"交强险+车船税";
    ccjqmodel.insurancePrice = [NSString stringWithFormat:@"%.2f",self.cc_price.floatValue + self.jq_price.floatValue];
    [resultArray addObject:ccjqmodel];
    //商业原价
    //    if (![self.sy_price isEqualToString:@""] && self.sy_price != nil)
    //    {
    //        InsuranceBaseItemModel *model = [[InsuranceBaseItemModel alloc] init];
    //        model.insuranceName = @"商业险保费（原价）：";
    //        model.insurancePrice = self.sy_price;
    //        model.isSYPrice = YES;
    //        [resultArray addObject:model];
    //        if (![self.sy_ratios isEqualToString:@""] && self.sy_ratios != nil)
    //        {
    //            NSArray *ratioArray = [self.sy_ratios componentsSeparatedByString:@"|"];
    //            if (ratioArray.count > 0)
    //            {
    //                for (int x = 0; x<ratioArray.count; x++)
    //                {
    //                    NSString *ratioString = ratioArray[x];
    //                    NSArray *ratioItems = [ratioString componentsSeparatedByString:@"#"];
    //                    InsuranceRatioItemModel *ratioModel = [[InsuranceRatioItemModel alloc] init];
    //                    ratioModel.insuranceRatio = [NSString stringWithFormat:@"立省%@",ratioItems[0]];
    //                    ratioModel.insuranceRatioPrice = [NSString stringWithFormat:@"%@",ratioItems[1]];
    //                    [resultArray addObject:ratioModel];
    //                }
    //            }
    //
    //        }
    //    }
    
    //商业险
    if (![self.sy_pay_price isEqualToString:@""] && self.sy_pay_price != nil)
    {
        InsuranceBaseItemModel *model = [[InsuranceBaseItemModel alloc] init];
        model.insuranceName = @"商车险";
        model.insurancePrice = self.sy_pay_price;
        [resultArray addObject:model];
    }
    
    //交强险
    if (![self.jq_price isEqualToString:@""] && self.jq_price != nil)
    {
        InsuranceBaseItemModel *model = [[InsuranceBaseItemModel alloc] init];
        model.insuranceName = @"交强险保费（实缴）：";
        model.insurancePrice = self.jq_price;
        [resultArray addObject:model];
    }
    //车船税
    if (![self.cc_price isEqualToString:@""] && self.cc_price != nil)
    {
        InsuranceBaseItemModel *model = [[InsuranceBaseItemModel alloc] init];
        model.insuranceName = @"车船税税款（实缴）：";
        model.insurancePrice = self.cc_price;
        [resultArray addObject:model];
        //        if (![self.cc_ratios isEqualToString:@""] && self.cc_ratios != nil)
        //        {
        //            NSArray *ratioArray = [self.cc_ratios componentsSeparatedByString:@"|"];
        //            if (ratioArray.count > 0)
        //            {
        //                for (int x = 0; x<ratioArray.count; x++)
        //                {
        //                    NSString *ratioString = ratioArray[x];
        //                    NSArray *ratioItems = [ratioString componentsSeparatedByString:@"#"];
        //                    InsuranceRatioItemModel *ratioModel = [[InsuranceRatioItemModel alloc] init];
        //                    ratioModel.insuranceRatio = [NSString stringWithFormat:@"立省%@",ratioItems[0]];
        //                    ratioModel.insuranceRatioPrice = [NSString stringWithFormat:@"%@",ratioItems[1]];
        //                    [resultArray addObject:ratioModel];
        //                }
        //            }
        //
        //        }
    }
    
    
    
    //其他险
    if (![self.other_prices isEqualToString:@""] && self.other_prices != nil)
    {
        NSArray *ratioArray = [self.other_prices componentsSeparatedByString:@"|"];
        if (ratioArray.count > 0)
        {
            for (int x = 0; x<ratioArray.count; x++)
            {
                NSString *ratioString = ratioArray[x];
                NSArray *ratioItems = [ratioString componentsSeparatedByString:@"#"];
                InsuranceBaseItemModel *model = [[InsuranceBaseItemModel alloc] init];
                model.insuranceName = [NSString stringWithFormat:@"%@：",ratioItems[0]];
                model.insurancePrice = ratioItems[1];
                [resultArray addObject:model];
            }
        }
        
    }
    
    //总支付
    if (![self.total_price isEqualToString:@""] && self.total_price != nil)
    {
        InsuranceRatioItemModel *ratioModel = [[InsuranceRatioItemModel alloc] init];
        ratioModel.insuranceRatio = @"实付合计：";
        ratioModel.insuranceRatioPrice = self.total_price;
        ratioModel.isTotalPrice = YES;
        [resultArray addObject:ratioModel];
    }
    
    

    
    return resultArray;
}

- (NSArray*)getPayInfoBaseItemArray
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    //商业原价
//    if (![self.sy_price isEqualToString:@""] && self.sy_price != nil)
//    {
//        InsuranceBaseItemModel *model = [[InsuranceBaseItemModel alloc] init];
//        model.insuranceName = @"商业险保费（原价）：";
//        model.insurancePrice = self.sy_price;
//        model.isSYPrice = YES;
//        [resultArray addObject:model];
//        if (![self.sy_ratios isEqualToString:@""] && self.sy_ratios != nil)
//        {
//            NSArray *ratioArray = [self.sy_ratios componentsSeparatedByString:@"|"];
//            if (ratioArray.count > 0)
//            {
//                for (int x = 0; x<ratioArray.count; x++)
//                {
//                    NSString *ratioString = ratioArray[x];
//                    NSArray *ratioItems = [ratioString componentsSeparatedByString:@"#"];
//                    InsuranceRatioItemModel *ratioModel = [[InsuranceRatioItemModel alloc] init];
//                    ratioModel.insuranceRatio = [NSString stringWithFormat:@"立省%@",ratioItems[0]];
//                    ratioModel.insuranceRatioPrice = [NSString stringWithFormat:@"%@",ratioItems[1]];
//                    [resultArray addObject:ratioModel];
//                }
//            }
//            
//        }
//    }
    
    //商业险
    if (![self.sy_pay_price isEqualToString:@""] && self.sy_pay_price != nil)
    {
        InsuranceBaseItemModel *model = [[InsuranceBaseItemModel alloc] init];
        model.insuranceName = @"商业险保费（实缴）：";
        model.insurancePrice = self.sy_pay_price;
        [resultArray addObject:model];
    }
    
    //交强险
    if (![self.jq_price isEqualToString:@""] && self.jq_price != nil)
    {
        InsuranceBaseItemModel *model = [[InsuranceBaseItemModel alloc] init];
        model.insuranceName = @"交强险保费（实缴）：";
        model.insurancePrice = self.jq_price;
        [resultArray addObject:model];
    }
    //车船税
    if (![self.cc_price isEqualToString:@""] && self.cc_price != nil)
    {
        InsuranceBaseItemModel *model = [[InsuranceBaseItemModel alloc] init];
        model.insuranceName = @"车船税税款（实缴）：";
        model.insurancePrice = self.cc_price;
        [resultArray addObject:model];
//        if (![self.cc_ratios isEqualToString:@""] && self.cc_ratios != nil)
//        {
//            NSArray *ratioArray = [self.cc_ratios componentsSeparatedByString:@"|"];
//            if (ratioArray.count > 0)
//            {
//                for (int x = 0; x<ratioArray.count; x++)
//                {
//                    NSString *ratioString = ratioArray[x];
//                    NSArray *ratioItems = [ratioString componentsSeparatedByString:@"#"];
//                    InsuranceRatioItemModel *ratioModel = [[InsuranceRatioItemModel alloc] init];
//                    ratioModel.insuranceRatio = [NSString stringWithFormat:@"立省%@",ratioItems[0]];
//                    ratioModel.insuranceRatioPrice = [NSString stringWithFormat:@"%@",ratioItems[1]];
//                    [resultArray addObject:ratioModel];
//                }
//            }
//            
//        }
    }
    

    
    //其他险
    if (![self.other_prices isEqualToString:@""] && self.other_prices != nil)
    {
        NSArray *ratioArray = [self.other_prices componentsSeparatedByString:@"|"];
        if (ratioArray.count > 0)
        {
            for (int x = 0; x<ratioArray.count; x++)
            {
                NSString *ratioString = ratioArray[x];
                NSArray *ratioItems = [ratioString componentsSeparatedByString:@"#"];
                InsuranceBaseItemModel *model = [[InsuranceBaseItemModel alloc] init];
                model.insuranceName = [NSString stringWithFormat:@"%@：",ratioItems[0]];
                model.insurancePrice = ratioItems[1];
                [resultArray addObject:model];
            }
        }
        
    }

    //总支付
    if (![self.total_price isEqualToString:@""] && self.total_price != nil)
    {
        InsuranceRatioItemModel *ratioModel = [[InsuranceRatioItemModel alloc] init];
        ratioModel.insuranceRatio = @"实付合计：";
        ratioModel.insuranceRatioPrice = self.total_price;
        ratioModel.isTotalPrice = YES;
        [resultArray addObject:ratioModel];
    }

    
    return resultArray;
}

- (NSArray*)getPayInfoPresentItemArray
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    if (![self.gifts isEqualToString:@""] && self.gifts != nil)
    {
        NSArray *ratioArray = [self.gifts componentsSeparatedByString:@"|"];
        if (ratioArray.count > 0)
        {
            for (int x = 0; x<ratioArray.count; x++)
            {
                NSString *ratioString = ratioArray[x];
                NSArray *ratioItems = [ratioString componentsSeparatedByString:@"#"];
                InsurancePresentItemModel *model = [[InsurancePresentItemModel alloc] init];
                model.presentName = ratioItems[0];
                model.presentContent = ratioItems[1];
                [resultArray addObject:model];
            }
        }
        
    }

    return resultArray;
}


@end
