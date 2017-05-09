//
//  ADVModel.h
//  优快保
//
//  Created by cts on 15/6/13.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"

@interface ADVModel : JsonBaseModel

//@property (strong, nonatomic) NSString *adv_id;
//
//@property (strong, nonatomic) NSString *photo_addr;
//
//@property (strong, nonatomic) NSString *city_id;
//
//@property (strong, nonatomic) NSString *title;
//
//@property (strong, nonatomic) NSString *url;
//
//@property (strong, nonatomic) NSString *url_type;

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *imgUrl;
@property (strong, nonatomic) NSString *newsId;
@property (strong, nonatomic) NSString *createdAt;
@property (strong, nonatomic) NSString *isRedirect;
@property (strong, nonatomic) NSString *content;


@end
