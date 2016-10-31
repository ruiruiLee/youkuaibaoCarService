//
//  YKBShareRequest.h
//  疯狂洗车
//
//  Created by cts on 16/6/28.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "JsonBaseModel.h"

typedef enum
{
    ShareTargetSina  = 0,       //新浪微博
    ShareTargetWeChatSession,   //微信朋友
    ShareTargetWeChatTimeline,  //微信朋友圈
    ShareTargetQQFrinde,        //QQ好友
    ShareTargetQQZone,          //QQ空间

}ShareTarget;

@interface YKBShareRequest : JsonBaseModel

@property (assign, nonatomic) ShareTarget shareTarget;

@property (strong, nonatomic) NSString    *title;

@property (strong, nonatomic) NSString    *content;

@property (strong, nonatomic) UIImage     *image;

@property (strong, nonatomic) NSString     *imageUrl;

@property (strong, nonatomic) NSString    *urlString;


@end
