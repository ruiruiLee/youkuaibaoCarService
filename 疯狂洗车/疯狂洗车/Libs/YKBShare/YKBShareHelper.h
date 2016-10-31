//
//  YKBShareHelper.h
//  疯狂洗车
//
//  Created by cts on 16/6/28.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "JsonBaseModel.h"
#import "YKBShareRequest.h"

@interface YKBShareHelper : JsonBaseModel

#define ShareHelper [YKBShareHelper sharedYKBShareHelper]

+ (id)sharedYKBShareHelper;

- (void)startShareWithRequest:(YKBShareRequest*)request
               normalResponse:(void(^)(void))successResponse
            exceptionResponse:(void(^)(void))exceptionResponse;


@end
