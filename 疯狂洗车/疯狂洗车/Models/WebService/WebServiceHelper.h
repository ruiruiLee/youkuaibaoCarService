//
//  WebServiceHelper.h
//  康吴康
//
//  Created by 朱伟铭 on 14/12/26.
//  Copyright (c) 2014年 朱伟铭. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "JsonBaseModel.h"
#import "UIImageView+WebCache.h"


#define WebService [WebServiceHelper sharedWebServiceHelper]


@interface WebServiceHelper : NSObject
{
    NSString *_availableUrlString;
}

/**
 *  初始化出本类的单例，用于调用一大堆方法
 *
 *  @return instants type
 */
+ (id)sharedWebServiceHelper;

/**
 *  最底层的json对象请求方法
 *
 *  @param param             参数，NSDictionary *
 *  @param action            接口方法名
 *  @param normalResponse    常规block
 *  @param exceptionResponse 错误block
 */
- (void)requestJsonOperationWithParam:(NSDictionary *)param
                               action:(NSString *)action
                      normalResponse:(void(^)(NSString *status, id data))normalResponse
                   exceptionResponse:(void(^)(NSError *error))exceptionResponse;

- (void)requestJsonWXOperationWithParam:(NSDictionary *)param
                                 action:(NSString *)action
                         normalResponse:(void(^)(NSString *status, id data))normalResponse
                      exceptionResponse:(void(^)(NSError *error))exceptionResponse;
/**
 *  发送返回值为JsonBaseModel对象的接口
 *
 *  @param param             参数，NSDictionary *
 *  @param action            接口方法名
 *  @param normalResponse    常规block，返回JsonBaseModel或其子类
 *  @param exceptionResponse 错误block
 */
- (void)requestJsonModelWithParam:(NSDictionary *)param
                           action:(NSString *)action
                       modelClass:(Class)modelClass
                   normalResponse:(void(^)(NSString *status, id data, JsonBaseModel *model))normalResponse
                exceptionResponse:(void(^)(NSError *error))exceptionResponse;


- (void)requestJsonArrayOperationWithParam:(NSDictionary *)param
                                    action:(NSString *)action
                                modelClass:(Class)modelClass
                            normalResponse:(void(^)(NSString *status, id data, NSMutableArray *array))normalResponse
                         exceptionResponse:(void(^)(NSError *error))exceptionResponse;

//微信端
- (void)requestJsonArrayWXOperationWithParam:(NSDictionary *)param
                                      action:(NSString *)action
                                  modelClass:(Class)modelClass
                              normalResponse:(void(^)(NSString *status, id data, NSMutableArray *array))normalResponse
                           exceptionResponse:(void(^)(NSError *error))exceptionResponse;

//learnCloud
- (void)requestJsonArrayLearnCloudOperationWithParam:(NSDictionary *)param
                                              action:(NSString *)action
                                          modelClass:(Class)modelClass
                                      normalResponse:(void(^)(NSString *status, id data, NSMutableArray *array))normalResponse
                                   exceptionResponse:(void(^)(NSError *error))exceptionResponse;


//新的图片上传接口
- (void)uploadImageWithParam:(NSDictionary *)param
                      action:(NSString *)action
                   imageData:(NSData *)imageData
                    imageKey:(NSString *)imageKey
              normalResponse:(void (^)(NSString *status, id data))normalResponse
           exceptionResponse:(void (^)(NSError *error))exceptionRespons;

- (void)uploadImageWithParam:(NSDictionary *)param
                      action:(NSString *)action
                  imageDatas:(NSArray *)imageDatas
                    imageKey:(NSString *)imageKey
              normalResponse:(void (^)(NSString *status, id data))normalResponse
           exceptionResponse:(void (^)(NSError *error))exceptionRespons;

- (void)uploadImageWithParam:(NSDictionary *)param
                      action:(NSString *)action
                   imagePath:(NSString *)imagePath
                    imageKey:(NSString *)imageKey
              normalResponse:(void(^)(NSString *status, id data))normalResponse
           exceptionResponse:(void(^)(NSError *error))exceptionRespons;

- (void)uploadFileWithInfo:(NSDictionary *)info
               serviceType:(NSString *)serviceType
                    action:(NSString *)action
                  filePath:(NSString *)filePath
                   fileKey:(NSString *)fileKey
            normalResponse:(void(^)(NSString *status, id data))normalResponse
         exceptionResponse:(void(^)(NSError *error))exceptionResponse;

- (void)startGetWeatherInfoWithCityInfo:(NSString *)cityInfo
                         normalResponse:(void(^)(NSString *status, id data))normalResponse
                      exceptionResponse:(void(^)(NSError *error))exceptionResponse;

/**
 *	@brief	单独下载图片并保存
 *
 *	@return	void
 */
- (void)downloadImageFromServiceWithUrl:(NSString*)targetUrl
                                forName:(NSString*)imageName
                           andMediaType:(NSString*)mediaType;

- (void)downloadImageFromServiceWithUrl:(NSString*)targetUrl
                                forName:(NSString*)imageName
                           andMediaType:(NSString*)mediaType
                         normalResponse:(void(^)(void))normalResponse
                      exceptionResponse:(void(^)(void))exceptionResponse;


@end
