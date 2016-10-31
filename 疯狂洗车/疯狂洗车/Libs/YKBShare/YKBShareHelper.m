//
//  YKBShareHelper.m
//  疯狂洗车
//
//  Created by cts on 16/6/28.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "YKBShareHelper.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"

#define SinaRedirectURI  @"http://www.car517.com"

@implementation YKBShareHelper

+ (id)sharedYKBShareHelper
{
    static YKBShareHelper *shareHelper = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{shareHelper = [[YKBShareHelper alloc] initSingleton];});
    return shareHelper;
}

- (id)init
{
    NSAssert(NO, @"Cannot create instance of Singleton");
    return nil;
}


- (id)initSingleton
{
    self = [super init];
    
    if (self != nil)
    {
    }
    
    return self;
}


- (void)startShareWithRequest:(YKBShareRequest*)request
               normalResponse:(void(^)(void))successResponse
            exceptionResponse:(void(^)(void))exceptionResponse
{
    if (request.shareTarget == ShareTargetSina)
    {
        [self shareRequestToSina:request
                  normalResponse:^{
                      successResponse();
                      return ;
        }
               exceptionResponse:^{
                   exceptionResponse();
                   return ;
        }];
    }
    else if (request.shareTarget == ShareTargetWeChatSession ||
             request.shareTarget == ShareTargetWeChatTimeline)
    {
        [self shareRequestToWeChat:request
                  normalResponse:^{
                      successResponse();
                      return ;
                  }
               exceptionResponse:^{
                   exceptionResponse();
                   return ;
               }];
    }
    else if (request.shareTarget == ShareTargetQQFrinde ||
             request.shareTarget == ShareTargetQQZone)
    {
        [self shareRequestToQQ:request
                    normalResponse:^{
                        successResponse();
                        return ;
                    }
                 exceptionResponse:^{
                     exceptionResponse();
                     return ;
                 }];
    }

}

- (void)shareRequestToSina:(YKBShareRequest*)request
            normalResponse:(void(^)(void))successResponse
         exceptionResponse:(void(^)(void))exceptionResponse
{
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = SinaRedirectURI;
    authRequest.scope = @"all";
    
    WBMessageObject *sendMessageObject = [WBMessageObject message];
    
    sendMessageObject.text = [NSString stringWithFormat:@"%@~%@",request.content,request.urlString];
    WBImageObject *sendImage = [WBImageObject object];
    sendImage.imageData = UIImageJPEGRepresentation(request.image, 1.0);
    sendMessageObject.imageObject = sendImage;
    WBSendMessageToWeiboRequest *sinaRequest = [WBSendMessageToWeiboRequest requestWithMessage:sendMessageObject];
    
    [WeiboSDK sendRequest:sinaRequest];
}

- (void)shareRequestToWeChat:(YKBShareRequest*)request
            normalResponse:(void(^)(void))successResponse
         exceptionResponse:(void(^)(void))exceptionResponse
{
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = request.urlString;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = request.title;
    message.description = request.content;
    
    UIImage *thumbImg = nil;
    if (!request.image)
    {
        UIImage *desImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:request.imageUrl]]];
        thumbImg = [self thumbImageWithImage:desImage limitSize:CGSizeMake(150, 150)];
    }
    else
    {
        thumbImg = [self thumbImageWithImage:request.image limitSize:CGSizeMake(150, 150)];
    }
    message.thumbData = UIImageJPEGRepresentation(thumbImg, 1);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    
    sendReq.text = request.content;
    sendReq.message = message;
    sendReq.bText = NO;
    sendReq.scene = request.shareTarget == ShareTargetWeChatTimeline?WXSceneTimeline:WXSceneSession;
    
    if ([WXApi sendReq:sendReq])
    {
        successResponse();
        return;
    }
    else
    {
        exceptionResponse();
        return;
    }
}

- (void)shareRequestToQQ:(YKBShareRequest*)request
              normalResponse:(void(^)(void))successResponse
           exceptionResponse:(void(^)(void))exceptionResponse
{
    QQApiNewsObject *sendTarget = nil;
    
    if (!request.image)
    {
        sendTarget = [QQApiNewsObject objectWithURL:[NSURL URLWithString:request.urlString]
                                              title:request.title
                                        description:request.content
                                    previewImageURL:[NSURL URLWithString:request.imageUrl]];
    }
    else
    {
        sendTarget = [QQApiNewsObject objectWithURL:[NSURL URLWithString:request.urlString]
                                              title:request.title
                                        description:request.content
                                   previewImageData:UIImageJPEGRepresentation(request.image, 1)];
        
    }
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:sendTarget];
    QQApiSendResultCode sent = request.shareTarget == ShareTargetQQFrinde?[QQApiInterface sendReq:req]:[QQApiInterface SendReqToQZone:req];
    if (sent == EQQAPISENDSUCESS)
    {
        successResponse();
        return;
    }
    else
    {
        exceptionResponse();
        return;
    }

}



- (UIImage *)thumbImageWithImage:(UIImage *)scImg limitSize:(CGSize)limitSize
{
    if (scImg.size.width <= limitSize.width && scImg.size.height <= limitSize.height) {
        return scImg;
    }
    CGSize thumbSize;
    if (scImg.size.width / scImg.size.height > limitSize.width / limitSize.height) {
        thumbSize.width = limitSize.width;
        thumbSize.height = limitSize.width / scImg.size.width * scImg.size.height;
    }
    else {
        thumbSize.height = limitSize.height;
        thumbSize.width = limitSize.height / scImg.size.height * scImg.size.width;
    }
    UIGraphicsBeginImageContext(thumbSize);
    [scImg drawInRect:(CGRect){CGPointZero,thumbSize}];
    UIImage *thumbImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbImg;
}

@end
