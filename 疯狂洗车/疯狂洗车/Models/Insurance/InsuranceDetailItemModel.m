//
//  InsuranceDetailItemModel.m
//  
//
//  Created by cts on 15/9/22.
//
//

#import "InsuranceDetailItemModel.h"
#import "InsuranceBaseItemModel.h"
#import "InsuranceDetailOthersItemModel.h"
#import "InsurancePresentItemModel.h"

@implementation InsuranceDetailItemModel

- (void)setGifts:(NSString *)gifts
{
    _gifts = gifts;
    
    if (![_gifts isEqualToString:@""] && _gifts != nil)
    {
        NSArray *giftsStringArray = [_gifts componentsSeparatedByString:@"|"];
        if (giftsStringArray.count > 0)
        {
            NSMutableString *giftsString = [NSMutableString string];
            NSMutableArray *resultArray = [NSMutableArray array];
            for (int x = 0; x<giftsStringArray.count; x++)
            {
                NSString *giftString = giftsStringArray[x];
                
                NSArray *giftArray = [giftString componentsSeparatedByString:@"#"];
                if (giftArray.count > 1)
                {
                    
                    InsurancePresentItemModel *targetModel = [[InsurancePresentItemModel alloc] init];
                    targetModel.presentName = giftArray[0];
                    targetModel.presentContent = giftArray[1];
                    if (x == giftsStringArray.count - 1)
                    {
                        [giftsString appendFormat:@"%@",targetModel.presentContent];
                    }
                    else
                    {
                        [giftsString appendFormat:@"%@，",targetModel.presentContent];
                    }
                    [resultArray addObject:targetModel];
                }
            }
            
            _giftsString = giftsString;
            self.giftArray = resultArray;
        }
    }
    
}

- (void)setTotal_content:(NSString *)total_content
{
    _total_content = total_content;
    if (![_total_content isEqualToString:@""] && _total_content != nil)
    {
        NSArray *totalContentStringArray = [_total_content componentsSeparatedByString:@"#"];
        if (totalContentStringArray.count > 1)
        {
            self.total_content_title = totalContentStringArray[0];
            self.total_content_price= totalContentStringArray[1];
        }

    }
}

- (NSMutableArray*)getInsuranceDetailElementsArray
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    //交强险
    InsuranceBaseItemModel *ccjqmodel = [[InsuranceBaseItemModel alloc] init];
    ccjqmodel.insuranceName = @"交强险+车船税";
    if ([self.bixu_title isEqualToString:@""] || self.bixu_title == nil)
    {
        ccjqmodel.insurancePrice = @"";
    }
    else
    {
        NSArray *bixuTitleArray = [self.bixu_title componentsSeparatedByString:@"#"];
        if (bixuTitleArray.count > 1)
        {
            NSString *ccjqPriceString = bixuTitleArray[1];
            ccjqmodel.insurancePrice = ccjqPriceString;
        }
        else
        {
            ccjqmodel.insurancePrice = @"";
        }

    }
    [resultArray addObject:ccjqmodel];
    
    if (![self.sy_title isEqualToString:@""] && self.sy_title != nil)
    {
        NSArray *bixuTitleArray = [self.sy_title componentsSeparatedByString:@"#"];
        if (bixuTitleArray.count > 1)
        {
            InsuranceBaseItemModel *model = [[InsuranceBaseItemModel alloc] init];
            model.insuranceName = bixuTitleArray[0];
            NSString *ccjqPriceString = bixuTitleArray[1];
            model.insurancePrice = ccjqPriceString;
            [resultArray addObject:model];

        }
    }
  

    if (![self.sy_content isEqualToString:@""] && self.sy_content != nil)
    {
        NSArray *syContentArray = [self.sy_content componentsSeparatedByString:@"|"];
        if (syContentArray.count > 0)
        {
            for (int x = 0; x<syContentArray.count; x++)
            {
                NSString *syContentString = syContentArray[x];
                NSArray *subTitleArray = [syContentString componentsSeparatedByString:@"#"];
                if (subTitleArray.count > 1)
                {
                    InsuranceBaseItemModel *model = [[InsuranceBaseItemModel alloc] init];
                    model.insuranceName = subTitleArray[0];
                    NSString *ccjqPriceString = subTitleArray[1];
                    model.insurancePrice = ccjqPriceString;
                    [resultArray addObject:model];
                    
                }
            }
        }
    }
    
    if (![self.bjmp_title isEqualToString:@""] && self.bjmp_title != nil)
    {
        InsuranceDetailOthersItemModel *model = [[InsuranceDetailOthersItemModel alloc] init];
        model.insuranceOtherName = self.bjmp_title;
        model.insuranceOtherContent = self.bjmp_content;
        model.insuranceOtherDesc = self.bjmp_desc;
        [resultArray addObject:model];
    }
    
    return resultArray;
}

@end
