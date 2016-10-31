//
//  NannyModel.h
//  优快保
//
//  Created by cts on 15/4/15.
//  Copyright (c) 2015年 朱伟铭. All rights reserved.
//

#import "JsonBaseModel.h"
///车大白信息model类，包含一条车大白信息的内容和回复内容等信息
@interface NannyModel : JsonBaseModel

@property (strong, nonatomic) NSString *nanny_id;//提问id

@property (strong, nonatomic) NSString *member_id;//用户id

@property (strong, nonatomic) NSString *nanny_type;//类型
/*
0或者空.未分类
1.养车
2.保养
3.划痕
4.违规
5.取车
6.代驾
 */

@property (strong, nonatomic) NSString *question_content;//"留言：" + 提问内容

@property (strong, nonatomic) NSString *question_time;//提问时间

@property (strong, nonatomic) NSString *reply_id;//回复id

@property (strong, nonatomic) NSString *reply_time;//回复时间

@property (strong, nonatomic) NSString *crm_user;//回复人： "大白车保姆"

@property (strong, nonatomic) NSString *reply_content;//"大白回复：" + 回复内容

@property (strong, nonatomic) NSString *phone;//用户电话

@property (strong, nonatomic) NSString *photo_addrs;//图片地址,逗号分隔

@property (strong, nonatomic) NSString *photo_status;


@property (strong, nonatomic) NSArray  *imageAddrsArray;





@end
