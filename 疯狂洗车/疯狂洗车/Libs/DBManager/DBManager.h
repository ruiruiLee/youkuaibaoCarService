//
//  DBManager.h
//  广东海事局
//
//  Created by Darsky on 8/26/14.
//  Copyright (c) 2014 Darsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "CarBrandModel.h"
#import "CarSeriesModel.h"
#import "CarKindModel.h"
#import "CityModel.h"
#import "MessageModel.h"

@interface DBManager : NSObject
{
    FMDatabase *_db;
}


+ (id)sharedDBManager;


+ (NSArray*)getAllCitys;

+ (NSArray*)getAllCarBrands;

+ (NSArray*)getCarSeriesByBrandID:(NSString*)brandID;

+ (NSArray*)getCarKindsBySeriesID:(NSString*)seriesID;

+ (NSArray*)getAllMessageByMemberID:(NSString*)memberID;

+ (int)queryUserUnReadMessageCountByUserId;

+ (void)updateMessageByMessageModel:(MessageModel*)model;


+ (NSDictionary*)queryCityByCityName:(NSString*)cityName;

+ (NSDictionary*)queryCityByCityID:(NSString*)cityID;

+ (CarBrandModel*)queryCarBrandByBrandName:(NSString*)brandName;

+ (CarSeriesModel*)queryCarSeriesBySeriesName:(NSString*)seriesName;


+ (void)insertDateToDBforTab:(NSInteger)tabIndex// 0.车品牌 1.车系 2.车款 10.城市 20 消息中心
                   withArray:(NSArray*)array
                      result:(void(^)(void))success
                       error:(void(^)(void))submitError;

@end
