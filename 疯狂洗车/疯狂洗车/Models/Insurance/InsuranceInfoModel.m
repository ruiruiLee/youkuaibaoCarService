//
//  InsuranceInfoModel.m
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "InsuranceInfoModel.h"

@implementation InsuranceInfoModel

- (void)setGifts:(NSString *)gifts
{
    _gifts = gifts;
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    if (![self.gifts isEqualToString:@""] && self.gifts != nil)
    {
        NSArray *ratioArray = [self.gifts componentsSeparatedByString:@"|"];
        if (ratioArray.count > 0)
        {
            for (int x = 0; x<ratioArray.count; x++)
            {
                NSString *ratioString = ratioArray[x];
                
                [resultArray addObject:[ratioString stringByReplacingOccurrencesOfString:@"#" withString:@"："]];
            }
        }
        
        if (resultArray.count > 0)
        {
            NSMutableString *giftsString = [NSMutableString string];
            for (int x = 0; x<resultArray.count; x++)
            {
                NSString *appendString = resultArray[x];
                if ([appendString isEqualToString:@""] || [appendString isEqualToString:@" "])
                {
                    continue;
                }
                else if (x == 0)
                {
                    [giftsString appendFormat:@"%@",resultArray[x]];
                }
                else
                {
                    [giftsString appendFormat:@"\n%@",resultArray[x]];
                }
            }
            
            _giftsString = giftsString;
        }
        
    }
    
}

@end
