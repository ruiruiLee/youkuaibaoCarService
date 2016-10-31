//
//  CarNurseModel.m
//  优快保
//
//  Created by cts on 15/4/4.
//  Copyright (c) 2015年 龚杰洪. All rights reserved.
//

#import "CarNurseModel.h"

@implementation CarNurseModel



- (void)setService_names:(NSString *)service_names
{
    _service_names = service_names;
    
    NSArray *serviceArray = [_service_names componentsSeparatedByString:@","];

    _supportServiceArray = serviceArray;
}

- (void)setService_types:(NSString *)service_types
{
    NSArray *serviceArray = [service_types componentsSeparatedByString:@","];
    NSMutableArray *supportServiceArray = [NSMutableArray array];
    NSMutableString *service_typesString = [NSMutableString string];
    for (int x = 0; x<serviceArray.count; x++)
    {
        NSString *tmpString = serviceArray[x];
        NSString *targetString = nil;
        if ([tmpString isEqualToString:@"1"])
        {
            targetString = @"保养";
        }
        else if ([tmpString isEqualToString:@"2"])
        {
            targetString = @"划痕";
        }
        else if ([tmpString isEqualToString:@"3"])
        {
            targetString = @"美容";
        }
        if (x == serviceArray.count - 1)
        {
            [service_typesString appendString:targetString];
        }
        else
        {
            [service_typesString appendFormat:@"%@、",targetString];
        }
        [supportServiceArray addObject:[NSString stringWithFormat:@"%@",targetString]];
    }
    _service_types = service_typesString;
    
    _supportServiceArray = supportServiceArray;
}

//- (void)createDemoStrings
//{
//    NSArray *titleArray = @[@"保养",@"美容",@"划痕"];
//    int length = arc4random() % 2+1;
//    NSMutableString *demoString = [NSMutableString string];
//    for (int y = 0; y<length; y++)
//    {
//        int index = arc4random() % 2;
//        if (y == length -1)
//        {
//            [demoString appendFormat:@"%@",titleArray[index]];
//        }
//        else
//        {
//            [demoString appendFormat:@"%@,",titleArray[index]];
//            
//        }
//    }
//    [self setService_names:demoString];
//}

@end
