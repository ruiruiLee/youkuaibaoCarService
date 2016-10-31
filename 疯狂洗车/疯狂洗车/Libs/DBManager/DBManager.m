//
//  DBManager.m
//  广东海事局
//
//  Created by Darsky on 8/26/14.
//  Copyright (c) 2014 Darsky. All rights reserved.
//

#import "DBManager.h"

//表index 说明 0.CarBrand 1.CarSeries 2.CarKind 10.city 20.MessageCenter



@implementation DBManager

+ (id)sharedDBManager
{
    static DBManager *dbManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{dbManager = [[DBManager alloc] init];});
    
    return dbManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _db = [FMDatabase databaseWithPath:[self filePathDB]];

    }
    return self;
}


+ (void)insertDateToDBforTab:(NSInteger)tabIndex
                   withArray:(NSArray*)array
                      result:(void(^)(void))success
                       error:(void(^)(void))submitError
{
    [[DBManager sharedDBManager] insertDateToDBforTab:tabIndex
                                            withArray:array
                                               result:^{
                                                   success();
                                                   return ;
    }
                                                error:^{
                                                    submitError();
                                                    return ;
    }];
}

- (void)insertDateToDBforTab:(NSInteger)tabIndex
                   withArray:(NSArray*)array
                      result:(void(^)(void))success
                       error:(void(^)(void))submitError
{
    if (![_db open])
    {
        [_db close];
        return;
    }
    
    NSString *tableName = nil;
    NSString *sqliteString = nil;

    if (tabIndex == 0)
    {
        tableName = [self CheckBrandTableExists];
        sqliteString = [NSString stringWithFormat:@"INSERT INTO %@ (BRAND_ID,LETTER,LOGO,NAME,VER_NO) VALUES (?, ?, ?, ?, ?)",tableName];
    }
    else if (tabIndex == 1)
    {
        tableName = [self CheckSeriesTableExists];
        sqliteString = [NSString stringWithFormat:@"INSERT INTO %@ (SERIES_ID, BRAND_ID, NAME, VER_NO) VALUES (?, ?, ?, ?)",tableName];

    }
    else if (tabIndex == 20)
    {
        tableName = [self CheckMessageTableExists];
        sqliteString = [NSString stringWithFormat:@"INSERT INTO %@ (MSG_ID, USER_ID, USER_TYPE, MSG_TITLE, MSG_CONTENT, PHOTO_ADDR, IS_READ, CREATE_TIME, MSG_TYPE, JSON) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ",tableName];
     
        
    }
    else
    {
        tableName = [self CheckKindTableExists];
        sqliteString = [NSString stringWithFormat:@"INSERT INTO %@ (KIND_ID, SERIES_ID, NAME, VER_NO) VALUES (?, ?, ?, ?)",tableName];
    }
    
    int successNumber = 0;
    for (int x = 0; x<array.count; x++)
    {
        if (tabIndex == 0)
        {
            CarBrandModel *model = array[x];

            if ([_db executeUpdate:sqliteString,model.BRAND_ID,model.LETTER,model.LOGO,model.NAME,model.VER_NO ])
            {
                successNumber++;
            }
        }
        else if (tabIndex == 1)
        {
            CarSeriesModel *model = array[x];
            if ([_db executeUpdate:sqliteString,model.SERIES_ID,model.BRAND_ID,model.NAME,model.VER_NO ])
            {
                successNumber++;
            }
        }
        else if (tabIndex == 20)
        {
            MessageModel *model = array[x];
            if ([_db executeUpdate:sqliteString,model.msg_id,model.user_id,model.user_type,model.msg_title,model.msg_content,model.photo_addr,model.is_read,model.create_time,model.msg_type,model.json])
            {
                successNumber++;
            }
            
        }
        else 
        {
            CarKindModel *model = array[x];
            if ([_db executeUpdate:sqliteString,model.KIND_ID,model.SERIES_ID,model.NAME,model.VER_NO ])
            {
                successNumber++;
            }
        }
    }
    
    [_db close];

    if (successNumber == array.count)
    {
        success();
        return;
    }
    else
    {
        submitError();
        return;
    }
}


#pragma mark - 条件查询
+ (NSArray*)getAllCitys
{
    return [[DBManager sharedDBManager] getAllCitys];
}

- (NSArray*)getAllCitys
{
    NSMutableArray *resultArray = [NSMutableArray array];
    if (![_db open]) {
        [_db close];
        return nil;
    }
    NSString *tableName = [self CheckCityTableExists];
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    FMResultSet *list= [_db executeQuery:queryString];
    while ([list next])
    {
        NSDictionary *tmpDic = @{@"city_id":[list stringForColumn:@"city_id"],
                                 @"province_id":[list stringForColumn:@"province_id"],
                                 @"city_name":[list stringForColumn:@"city_name"],
                                 @"py_code":[list stringForColumn:@"py_code"],
                                 @"seq_no":[list stringForColumn:@"seq_no"],
                                 @"longitude":[list stringForColumn:@"longitude"],
                                 @"latitude":[list stringForColumn:@"latitude"],
                                 @"tel_code":[list stringForColumn:@"tel_code"],
                                 @"c_city_name":[list stringForColumn:@"c_city_name"],
                                 @"c_py_code":[list stringForColumn:@"c_py_code"],
                                 @"open_flag":[list stringForColumn:@"open_flag"]};
        [resultArray addObject:tmpDic];
    }
    [list close];
    [_db close];
    return resultArray;

}

+ (NSArray*)getAllCarBrands
{
    return [[DBManager sharedDBManager] getAllCarBrands];
}

- (NSArray*)getAllCarBrands
{
    NSMutableArray *resultArray = [NSMutableArray array];
    if (![_db open]) {
        [_db close];
        return nil;
    }
    NSString *tableName = [self CheckBrandTableExists];
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    FMResultSet *list= [_db executeQuery:queryString];
    while ([list next])
    {
        NSDictionary *tmpDic = @{@"BRAND_ID":[list stringForColumn:@"BRAND_ID"],
                                 @"LETTER":[list stringForColumn:@"LETTER"],
                                 @"LOGO":[list stringForColumn:@"LOGO"],
                                 @"NAME":[list stringForColumn:@"NAME"],
                                 @"VER_NO":[list stringForColumn:@"VER_NO"]};
        [resultArray addObject:tmpDic];
    }
    [list close];
    [_db close];
    return resultArray;
}

+ (NSArray*)getCarSeriesByBrandID:(NSString*)brandID
{
    return [[DBManager sharedDBManager] getCarSeriesByBrandID:brandID];
}

- (NSArray*)getCarSeriesByBrandID:(NSString*)brandID
{
    NSMutableArray *resultArray = [NSMutableArray array];
    if (![_db open]) {
        [_db close];
        return nil;
    }
    NSString *tableName = [self CheckSeriesTableExists];
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE BRAND_ID = %@",tableName,brandID];
    FMResultSet *list= [_db executeQuery:queryString];
    while ([list next])
    {
        NSDictionary *tmpDic = @{@"BRAND_ID":[list stringForColumn:@"BRAND_ID"],
                                 @"SERIES_ID":[list stringForColumn:@"SERIES_ID"],
                                 @"NAME":[list stringForColumn:@"NAME"],
                                 @"VER_NO":[list stringForColumn:@"VER_NO"]};
        [resultArray addObject:tmpDic];
    }
    [list close];
    [_db close];
    return resultArray;
}

+ (NSArray*)getCarKindsBySeriesID:(NSString*)seriesID
{
    return [[DBManager sharedDBManager] getCarKindsBySeriesID:seriesID];
}

- (NSArray*)getCarKindsBySeriesID:(NSString*)seriesID
{
    NSMutableArray *resultArray = [NSMutableArray array];
    if (![_db open]) {
        [_db close];
        return nil;
    }
    NSString *tableName = [self CheckKindTableExists];
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE SERIES_ID = %@",tableName,seriesID];
    FMResultSet *list= [_db executeQuery:queryString];
    while ([list next])
    {
        NSDictionary *tmpDic = @{@"KIND_ID":[list stringForColumn:@"KIND_ID"],
                                 @"SERIES_ID":[list stringForColumn:@"SERIES_ID"],
                                 @"NAME":[list stringForColumn:@"NAME"],
                                 @"VER_NO":[list stringForColumn:@"VER_NO"]};
        [resultArray addObject:tmpDic];
    }
    [list close];
    [_db close];
    return resultArray;
}

+ (NSArray*)getAllMessageByMemberID:(NSString*)memberID
{
    return [[DBManager sharedDBManager] getAllMessageByMemberID:memberID];
}

- (NSArray*)getAllMessageByMemberID:(NSString*)memberID
{
    NSMutableArray *resultArray = [NSMutableArray array];
    if (![_db open]) {
        [_db close];
        return nil;
    }
    NSString *tableName = [self CheckMessageTableExists];
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE USER_ID = %@ ORDER BY CREATE_TIME DESC",tableName,memberID];
    FMResultSet *list= [_db executeQuery:queryString];
    while ([list next])
    {
        NSDictionary *tmpDic = @{@"msg_id":[list stringForColumn:@"MSG_ID"],
                                 @"user_id":[list stringForColumn:@"USER_ID"],
                                 @"user_type":[list stringForColumn:@"USER_TYPE"],
                                 @"msg_title":[list stringForColumn:@"MSG_TITLE"],
                                 @"msg_content":[list stringForColumn:@"MSG_CONTENT"],
                                 @"photo_addr":[list stringForColumn:@"PHOTO_ADDR"],
                                 @"is_read":[list stringForColumn:@"IS_READ"],
                                 @"create_time":[list stringForColumn:@"CREATE_TIME"],
                                 @"msg_type":[list stringForColumn:@"MSG_TYPE"],
                                 @"json":[list stringForColumn:@"JSON"]};
        [resultArray addObject:tmpDic];
        
    }
    [list close];
    [_db close];
    return resultArray;
}

+ (int)queryUserUnReadMessageCountByUserId
{
    return [[DBManager sharedDBManager] queryUserUnReadMessageCountByUserId];
}

- (int)queryUserUnReadMessageCountByUserId
{
    int resultCount = 0;
    if (![_db open]) {
        [_db close];
        return resultCount;
    }
    NSString *tableName = [self CheckMessageTableExists];
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE USER_ID = %@ AND IS_READ = 0 ORDER BY CREATE_TIME DESC",tableName,_userInfo.member_id];
    FMResultSet *list= [_db executeQuery:queryString];
    while ([list next])
    {
        resultCount ++;
        
    }
    [list close];
    [_db close];
    return resultCount;
}

+ (void)updateMessageByMessageModel:(MessageModel *)model
{
    [[DBManager sharedDBManager] updateMessageByMessageModel:model];
}


- (void)updateMessageByMessageModel:(MessageModel *)model
{
    if (![_db open]) {
        [_db close];
        return;
    }
    NSString *tableName = [self CheckMessageTableExists];
    NSString *sqliteString = [NSString stringWithFormat:@"UPDATE %@ SET IS_READ = %@ WHERE MSG_ID = %@",tableName,model.is_read,model.msg_id];

    [_db executeUpdate:sqliteString];
    [_db close];
}


+ (NSDictionary*)queryCityByCityName:(NSString*)cityName
{
    return [[DBManager sharedDBManager] queryCityByCityName:cityName];
}

- (NSDictionary*)queryCityByCityName:(NSString*)cityName
{
    NSDictionary *resultDic = nil;
    
    if (![_db open]) {
        [_db close];
        return nil;
    }
    NSString *tableName = [self CheckCityTableExists];
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE CITY_NAME LIKE '%%%@%%'",tableName,[cityName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    FMResultSet *list= [_db executeQuery:queryString];
    while ([list next])
    {
        resultDic = @{@"CITY_ID":[list stringForColumn:@"CITY_ID"],
                      @"PROVINCE_ID":[list stringForColumn:@"PROVINCE_ID"],
                      @"CITY_NAME":[list stringForColumn:@"CITY_NAME"],
                      @"PY_CODE":[list stringForColumn:@"PY_CODE"],
                      @"SEQ_NO":[list stringForColumn:@"SEQ_NO"],
                      @"LONGITUDE":[list stringForColumn:@"LONGITUDE"],
                      @"LATITUDE":[list stringForColumn:@"LATITUDE"],
                      @"TEL_CODE":[list stringForColumn:@"TEL_CODE"],
                      @"C_CITY_NAME":[list stringForColumn:@"C_CITY_NAME"],
                      @"C_PY_CODE":[list stringForColumn:@"C_PY_CODE"],
                      @"OPEN_FLAG":[list stringForColumn:@"OPEN_FLAG"]};

    }
    [list close];
    [_db close];
    
    return resultDic;

}

+ (NSDictionary*)queryCityByCityID:(NSString*)cityID
{
    return [[DBManager sharedDBManager] queryCityByCityID:cityID];
}

- (NSDictionary*)queryCityByCityID:(NSString*)cityID
{
    NSDictionary *resultDic = nil;
    
    if (![_db open]) {
        [_db close];
        return nil;
    }
    NSString *tableName = [self CheckCityTableExists];
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE CITY_ID = %@",tableName,cityID];
    
    FMResultSet *list= [_db executeQuery:queryString];
    while ([list next])
    {
        resultDic = @{@"CITY_ID":[list stringForColumn:@"CITY_ID"],
                      @"PROVINCE_ID":[list stringForColumn:@"PROVINCE_ID"],
                      @"CITY_NAME":[list stringForColumn:@"CITY_NAME"],
                      @"PY_CODE":[list stringForColumn:@"PY_CODE"],
                      @"SEQ_NO":[list stringForColumn:@"SEQ_NO"],
                      @"LONGITUDE":[list stringForColumn:@"LONGITUDE"],
                      @"LATITUDE":[list stringForColumn:@"LATITUDE"],
                      @"TEL_CODE":[list stringForColumn:@"TEL_CODE"],
                      @"C_CITY_NAME":[list stringForColumn:@"C_CITY_NAME"],
                      @"C_PY_CODE":[list stringForColumn:@"C_PY_CODE"],
                      @"OPEN_FLAG":[list stringForColumn:@"OPEN_FLAG"]};
        
    }
    [list close];
    [_db close];
    
    return resultDic;
    
}


#pragma mark - 车辆品牌和型号id查询

+ (CarBrandModel*)queryCarBrandByBrandName:(NSString*)brandName
{
  return [[DBManager sharedDBManager] queryCarBrandByBrandName:brandName];
}

- (CarBrandModel*)queryCarBrandByBrandName:(NSString*)brandName
{
    CarBrandModel *resultModel = nil;
    
    if (brandName == nil || [brandName isEqualToString:@""])
    {
        return nil;
    }
    NSDictionary *resultDic = nil;
    
    if (![_db open]) {
        [_db close];
        return nil;
    }

    NSString *tableName = [self CheckBrandTableExists];
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE NAME LIKE '%%%@%%'",tableName,[brandName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    FMResultSet *list= [_db executeQuery:queryString];
    while ([list next])
    {
        resultDic = @{@"BRAND_ID":[list stringForColumn:@"BRAND_ID"],
                      @"LETTER":[list stringForColumn:@"LETTER"],
                      @"LOGO":[list stringForColumn:@"LOGO"],
                      @"NAME":[list stringForColumn:@"NAME"]};
        
    }
    [list close];
    [_db close];
    
    if ([resultDic allValues].count > 0)
    {
        resultModel = [[CarBrandModel alloc] initWithDictionary:resultDic];
    }
    
    
    return resultModel;
}


+ (CarSeriesModel*)queryCarSeriesBySeriesName:(NSString*)seriesName
{
    return [[DBManager sharedDBManager] queryCarSeriesBySeriesName:seriesName];
}

- (CarSeriesModel*)queryCarSeriesBySeriesName:(NSString*)seriesName
{
    if (seriesName == nil || [seriesName isEqualToString:@""])
    {
        return nil;
    }
    CarSeriesModel *resultModel = nil;

    NSDictionary *resultDic = nil;
    
    if (![_db open]) {
        [_db close];
        return nil;
    }
    
    NSString *tableName = [self CheckSeriesTableExists];
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE NAME LIKE '%%%@%%'",tableName,[seriesName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    FMResultSet *list= [_db executeQuery:queryString];
    while ([list next])
    {
        resultDic = @{@"SERIES_ID":[list stringForColumn:@"SERIES_ID"],
                      @"BRAND_ID":[list stringForColumn:@"BRAND_ID"],
                      @"NAME":[list stringForColumn:@"NAME"]};
        
    }
    [list close];
    [_db close];
    
    if ([resultDic allValues].count > 0)
    {
        resultModel = [[CarSeriesModel alloc] initWithDictionary:resultDic];
    }
    
    return resultModel;

}

#pragma mark - 消息中心
#pragma mark


#pragma mark - DBConfig Method

- (NSString*)filePathDB
{
    NSArray *myPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *myDocPath = [myPath objectAtIndex:0];
    NSString *filename = [NSString stringWithFormat:@"%@",[myDocPath stringByAppendingPathComponent:localDBName]];
    return filename;
}

- (BOOL)tableExists:(NSString*)tableName {
    
    tableName = [tableName lowercaseString];
    
    FMResultSet *rs = [_db executeQuery:@"select [sql] from sqlite_master where [type] = 'table' and lower(name) = ?", tableName];
    
    //if at least one next exists, table exists
    BOOL returnBool = [rs next];
    
    //close and free object
    [rs close];
    
    return returnBool;
}


#pragma mark - ChecktableExists


- (NSString*)CheckBrandTableExists
{
    NSString *tableName = @"brand";
    if (![self tableExists:tableName])
    {
        NSLog(@"不存在表，创建表%@",tableName);
        [_db executeUpdate:@"create table brand (BRAND_ID text primary key, LETTER text, LOGO text, NAME text, VER_NO text)"];
    }
    return tableName ;
}

- (NSString*)CheckSeriesTableExists
{
    NSString *tableName = @"series";
    if (![self tableExists:tableName])
    {
        NSLog(@"不存在表，创建表%@",tableName);
        [_db executeUpdate:@"create table series (SERIES_ID text primary key, BRAND_ID text, NAME text, VER_NO text)"];
    }
    return tableName ;
}

- (NSString*)CheckKindTableExists
{
    NSString *tableName = @"kind";
    if (![self tableExists:tableName])
    {
        NSLog(@"不存在表，创建表%@",tableName);
        [_db executeUpdate:@"create table kind (KIND_ID text primary key,SERIES_ID text, NAME text, VER_NO text)"];
    }
    return tableName ;
}


- (NSString*)CheckCityTableExists
{
    NSString *tableName = @"C_CITY";
    if (![self tableExists:tableName])
    {
        NSLog(@"不存在表，创建表%@",tableName);
        [_db executeUpdate:@"create table C_CITY (CITY_ID text primary key,PROVINCE_ID text, CITY_NAME text, PY_CODE text, SEQ_NO text, LONGITUDE text, LATITUDE text, TEL_CODE text, C_CITY_NAME text, C_PY_CODE text, OPEN_FLAG text)"];
    }
    return tableName ;

}

- (NSString*)CheckMessageTableExists
{
    NSString *tableName = @"message";
    if (![self tableExists:tableName])
    {
        NSLog(@"不存在表，创建表%@",tableName);
        [_db executeUpdate:@"create table message (MSG_ID text primary key, USER_ID text, USER_TYPE text, MSG_TITLE text, MSG_CONTENT text, PHOTO_ADDR text, IS_READ text, CREATE_TIME text, MSG_TYPE text, JSON text)"];
    }
    return tableName ;

}


/*
 NSString*              _cityName;
 NSString*              _name;
 CLLocationCoordinate2D _pt;
 */


@end
