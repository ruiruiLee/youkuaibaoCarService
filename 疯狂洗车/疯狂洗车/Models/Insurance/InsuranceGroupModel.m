//
//  InsuranceGroupModel.m
//  优快保
//
//  Created by cts on 15/7/9.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "InsuranceGroupModel.h"
#import "UploadImageModel.h"

@implementation InsuranceGroupModel

- (void)setImg_list:(NSArray *)img_list
{
    NSMutableArray *resultArray = [NSMutableArray array];
    NSMutableArray *firstArray = [NSMutableArray array];
    NSMutableArray *secondArray = [NSMutableArray array];
    for (int x = 0; x<img_list.count; x++)
    {
        id object = img_list[x];
        UploadImageModel *model = nil;
        if ([object isKindOfClass:[NSDictionary class]])
        {
            model = [[UploadImageModel alloc] initWithDictionary:object];
        }
        else if ([object isKindOfClass:[UploadImageModel class]])
        {
            model = (UploadImageModel*)object;
        }
        
        if (model != nil)
        {
            if ([model.img_type isEqualToString:@"1"])
            {
                self.photo_addr = model.img_url;
                [firstArray insertObject:model atIndex:0];
            }
            else if ([model.img_type isEqualToString:@"2"])
            {
                self.photo_addr2 = model.img_url;
                [firstArray addObject:model];
            }
            else
            {
                [secondArray addObject:model];
            }
        }
    }
    if (firstArray.count > 0)
    {
        [resultArray addObjectsFromArray:firstArray];
    }
    if (secondArray.count > 0)
    {
        [resultArray addObjectsFromArray:secondArray];
    }
    _img_list = resultArray;
}


@end
