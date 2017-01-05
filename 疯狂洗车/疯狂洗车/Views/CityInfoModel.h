//
//  CityInfoModel.h
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/22.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduMapAPI_Search/BMKSearchComponent.h"//引入检索功能所有的头文件
#import "BaiduMapAPI_Cloud/BMKCloudSearchComponent.h"//引入云检索功能所有的头文件

@interface CityInfoModel : NSObject

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *address;

@property (nonatomic, assign) CLLocationCoordinate2D location;

@property (nonatomic, strong) BMKPoiInfo *info;

@end
