//
//  ShareMenuView.m
//  OldErp4iOS
//
//  Created by Darsky on 14/11/8.
//  Copyright (c) 2014年 HFT_SOFT. All rights reserved.
//

#import "ShareMenuView.h"

#import "YKBShareHelper.h"
//#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
//#import "WeiboSDK.h"

@implementation ShareMenuView

+ (id)sharedShareMenuView
{
    static ShareMenuView *shareMenuView = nil;
    //
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{shareMenuView = [[ShareMenuView alloc] initWithFrame:[UIScreen mainScreen].bounds];});
    //
    return shareMenuView;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        float width = self.frame.size.width;
        float height = 222;
        
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(5, self.frame.size.height+10, width-10, height+20)];
        _menuView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_menuView];
        _menuView.layer.masksToBounds = YES;
        _menuView.layer.cornerRadius = 5;
        
        
        NSArray *shareItemsArray = [self getShareItemList];
        
        float itemWidth = 46*[UIScreen mainScreen].bounds.size.width/320;
        
        float padding = (_menuView.frame.size.width - itemWidth*shareItemsArray.count)/(shareItemsArray.count+1);
        
        
        for (int x = 0; x<shareItemsArray.count; x++)
        {
            NSDictionary *shareDic = shareItemsArray[x];
            UIButton *shareItem = [UIButton buttonWithType:UIButtonTypeCustom];
            shareItem.frame = CGRectMake(padding+(itemWidth+padding)*x,
                                         20,
                                         itemWidth,
                                         itemWidth);
            [shareItem setImage:[UIImage imageNamed:[shareDic objectForKey:@"image"]]
                       forState:UIControlStateNormal];

            [shareItem addTarget:self
                          action:@selector(didShareItemTouch:)
                forControlEvents:UIControlEventTouchUpInside];
            shareItem.tag = x;
            UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(shareItem.frame.origin.x-5, shareItem.frame.origin.y+shareItem.frame.size.height+5, shareItem.frame.size.width+10, 14)];
            itemLabel.textAlignment = NSTextAlignmentCenter;
            itemLabel.text = [shareDic objectForKey:@"title"];
            itemLabel.font = [UIFont systemFontOfSize:11];
            [_menuView addSubview:shareItem];
            [_menuView addSubview:itemLabel];

        }
        
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(27,
                                        _menuView.frame.size.height-84,
                                        _menuView.frame.size.width-54,
                                        40);
        [cancelButton setTitle:@"取  消" forState:UIControlStateNormal];
        cancelButton.layer.borderWidth = 1;
        cancelButton.layer.masksToBounds = YES;
        cancelButton.layer.cornerRadius = 3;
        cancelButton.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [cancelButton setTitleColor:[UIColor darkGrayColor]
                           forState:UIControlStateNormal];
        [cancelButton setBackgroundColor:[UIColor clearColor]];
        [cancelButton addTarget:self
                         action:@selector(hideShareMenuView)
               forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:cancelButton];
        cancelButton.userInteractionEnabled = NO;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(hideShareMenuView)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

#pragma mark - didShareItemTouch

- (void)didShareItemTouch:(UIButton*)sender
{
    if (_shareTarget == 0)
    {
        if (sender.tag == 0)
        {
            [self hideShareMenuView];
            [self shareAppToWeixinfriends];
            
            
        }
        else if (sender.tag == 1)
        {
            [self hideShareMenuView];
            [self shareAppToWeixin];
            
            
        }
        else if (sender.tag == 2)
        {
            [self hideShareMenuView];
            [self shareAppToQQ];
            
        }
        else
        {
            [self hideShareMenuView];
            [self shareAppToSina];
            
        }
    }
    else
    {
        if (sender.tag == 0)
        {
            [self hideShareMenuView];
            [self shareContetAppToWeixinfriends];
            
            
        }
        else if (sender.tag == 1)
        {
            [self hideShareMenuView];
            [self shareContetAppToWeixin];
            
            
        }
        else if (sender.tag == 2)
        {
            [self hideShareMenuView];
            [self shareContetAppToQQ];
            
        }
        else
        {
            [self hideShareMenuView];
            [self shareContetAppToSina];
            
        }
    }


}

#pragma mark - AppShare

+ (void)showShareMenuViewAtTarget:(UIViewController*)controller
                      withContent:(NSString*)contentString
                        withTitle:(NSString *)title
                        withImage:(UIImage*)shareImage
                          withUrl:(NSString*)urlString
{
    [[ShareMenuView sharedShareMenuView] showShareMenuViewAtTarget:controller
                                                       withContent:contentString
                                                         withTitle:title
                                                         withImage:shareImage
                                                           withUrl:urlString];
}

- (void)showShareMenuViewAtTarget:(UIViewController*)controller
                      withContent:(NSString*)contentString
                        withTitle:(NSString *)title
                        withImage:(UIImage*)shareImage
                          withUrl:(NSString*)urlString
{
    self.target = controller;
    _shareTarget = 0;
    _titleString = title;
    _shareImage = shareImage;
    _contentString = contentString;
    _urlString = urlString;
    [self showShareMenuView];
}

#pragma mark - 优惠券Share

+ (void)showShareMenuViewAtTarget:(UIViewController *)controller
                      withContent:(NSString *)contentString
                        withTitle:(NSString *)title
                        withImageUrl:(NSString *)shareImageUrl
                          withUrl:(NSString *)urlString
{
    [[ShareMenuView sharedShareMenuView] showShareMenuViewAtTarget:controller
                                                       withContent:contentString
                                                         withTitle:title
                                                      withImageUrl:shareImageUrl
                                                           withUrl:urlString];
}

- (void)showShareMenuViewAtTarget:(UIViewController *)controller
                      withContent:(NSString *)contentString
                        withTitle:(NSString *)title
                     withImageUrl:(NSString *)shareImageUrl
                          withUrl:(NSString *)urlString
{
    self.target = controller;
    _shareTarget = 1;
    _titleString = title;
    _shareImageUrl = shareImageUrl;
    _contentString = contentString;
    _urlString = urlString;
    [self showShareMenuView];
}

+ (void)showShareMenuViewWithTarget:(UIViewController*)controller
{
    [[ShareMenuView sharedShareMenuView] showShareMenuViewWithTarget:controller];
}

- (void)showShareMenuViewWithTarget:(UIViewController*)controller
{
    self.target = controller;
    [self showShareMenuView];
}


- (void)showShareMenuView
{
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           UIWindow *window = [[UIApplication sharedApplication] keyWindow];
                           [window addSubview:self];
                           [self exChangeOutdur:0.3];
                       });

}


- (void)hideShareMenuView
{
    [UIView animateWithDuration:0.3
                     animations:^{
        _menuView.transform = CGAffineTransformIdentity;
    }
                     completion:^(BOOL finished)
     {
        if (finished)
        {
            [self removeFromSuperview];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shareAppHide"
                                                                object:nil];
        }
    }];

    
}


-(void)exChangeOutdur:(CFTimeInterval)dur
{
    if (self.target != nil)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shareAppShow"
                                                            object:nil];
        _menuView.hidden = NO;
        [UIView beginAnimations:@"showMenuView" context:nil];
        [UIView setAnimationDuration:dur];
        _menuView.transform = CGAffineTransformMakeTranslation(0, -_menuView.frame.size.height);
        
        [UIView commitAnimations];
    }

    return;
}

-(void)exChangeIndur:(CFTimeInterval)dur
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = dur;
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 0.7)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 0.5)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 0.1)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [_menuView.layer addAnimation:animation forKey:nil];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag)
    {
        self.hidden = YES;
    }
}

#pragma mark - 分享APP到个平台
- (void)shareAppToSina
{

    YKBShareRequest *shareRequest = [[YKBShareRequest alloc] init];
    shareRequest.shareTarget = ShareTargetSina;
    shareRequest.content = _contentString;
    shareRequest.title = nil;
    shareRequest.urlString = _urlString;
    shareRequest.image = _shareImage;
    
    [ShareHelper startShareWithRequest:shareRequest
                        normalResponse:^{
        
    }
                     exceptionResponse:^{
        
    }];
    
    
}

- (void)shareAppToWeixin
{
//    WXWebpageObject *ext = [WXWebpageObject object];
//    ext.webpageUrl = _urlString;
//    
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = _titleString;
//    message.description = _contentString;
//    message.thumbData = UIImageJPEGRepresentation(_shareImage, 1.0);
//    
//    message.mediaObject = ext;
//    
//    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
//    
//    sendReq.text = _contentString;
//    sendReq.message = message;
//    sendReq.bText = NO;
//    sendReq.scene = WXSceneSession;
//    
//    [WXApi sendReq:sendReq];
    
    YKBShareRequest *shareRequest = [[YKBShareRequest alloc] init];
    shareRequest.shareTarget = ShareTargetWeChatSession;
    shareRequest.content     = _contentString;
    shareRequest.title       = _titleString;
    shareRequest.urlString   = _urlString;
    shareRequest.image       = _shareImage;
    shareRequest.imageUrl    = _shareImageUrl;
    
    [ShareHelper startShareWithRequest:shareRequest
                        normalResponse:^{
                            
                        }
                     exceptionResponse:^{
                         
                     }];

}

- (void)shareAppToWeixinfriends
{
//    WXWebpageObject *ext = [WXWebpageObject object];
//    ext.webpageUrl = _urlString;
//    
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = _titleString;
//    message.description = _contentString;
//    message.thumbData = UIImageJPEGRepresentation(_shareImage, 1.0);
//    
//    message.mediaObject = ext;
//    
//    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
//    
//    sendReq.text = _contentString;
//    sendReq.message = message;
//    sendReq.bText = NO;
//    sendReq.scene = WXSceneTimeline;
//    
//    [WXApi sendReq:sendReq];
    
    YKBShareRequest *shareRequest = [[YKBShareRequest alloc] init];
    shareRequest.shareTarget = ShareTargetWeChatTimeline;
    shareRequest.content     = _contentString;
    shareRequest.title       = _titleString;
    shareRequest.urlString   = _urlString;
    shareRequest.image       = _shareImage;
    shareRequest.imageUrl    = _shareImageUrl;
    
    [ShareHelper startShareWithRequest:shareRequest
                        normalResponse:^{
                            
                        }
                     exceptionResponse:^{
                         
                     }];
}

- (void)shareAppToQQ
{
    YKBShareRequest *shareRequest = [[YKBShareRequest alloc] init];
    shareRequest.shareTarget = ShareTargetQQZone;
    shareRequest.content     = _contentString;
    shareRequest.title       = _titleString;
    shareRequest.urlString   = _urlString;
    shareRequest.image       = _shareImage;
    shareRequest.imageUrl    = _shareImageUrl;
    
    [ShareHelper startShareWithRequest:shareRequest
                        normalResponse:^{
                            
                        }
                     exceptionResponse:^{
                         
                     }];
    

}

#pragma mark - 分享内容到个平台
- (void)shareContetAppToSina
{
    UIImage *desImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_shareImageUrl]]];
    UIImage *thumbImg = [self thumbImageWithImage:desImage limitSize:CGSizeMake(150, 150)];

    
    YKBShareRequest *shareRequest = [[YKBShareRequest alloc] init];
    shareRequest.shareTarget = ShareTargetSina;
    shareRequest.content = _contentString;
    shareRequest.title = _titleString;
    shareRequest.urlString = _urlString;
    shareRequest.image = thumbImg;
    shareRequest.imageUrl = _shareImageUrl;
    
    [ShareHelper startShareWithRequest:shareRequest
                        normalResponse:^{
                            
                        }
                     exceptionResponse:^{
                         
                     }];
    
}

- (void)shareContetAppToWeixin
{
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = _urlString;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _titleString;
    message.description = _contentString;
    UIImage *desImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_shareImageUrl]]];
    UIImage *thumbImg = [self thumbImageWithImage:desImage limitSize:CGSizeMake(150, 150)];
    
    message.thumbData = UIImageJPEGRepresentation(thumbImg, 1);
    message.mediaObject = ext;
    
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    
    sendReq.text = _contentString;
    sendReq.message = message;
    sendReq.bText = NO;
    sendReq.scene = WXSceneSession;
    
    [WXApi sendReq:sendReq];
    
    
    
}

- (void)shareContetAppToWeixinfriends
{

    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = _urlString;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _titleString;
    message.description = _contentString;
    
    UIImage *desImage = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_shareImageUrl]]];
    UIImage *thumbImg = [self thumbImageWithImage:desImage limitSize:CGSizeMake(150, 150)];
    
    message.thumbData = UIImageJPEGRepresentation(thumbImg, 1);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    
    sendReq.text = _contentString;
    sendReq.message = message;
    sendReq.bText = NO;
    sendReq.scene = WXSceneTimeline;
    
    [WXApi sendReq:sendReq];
    
}

- (void)shareContetAppToQQ
{
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:_urlString]
                                                        title:_titleString
                                                  description:_contentString
                                             previewImageURL:[NSURL URLWithString:_shareImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    if (sent == EQQAPISENDSUCESS)
    {
        [Constants showMessage:@"分享成功"];
    }
}



+ (void)hideAllShareMenuView
{
    [[ShareMenuView sharedShareMenuView] hideAllShareMenuView];
}

- (void)hideAllShareMenuView
{
    self.target = nil;
}


#pragma mark - Other Method

- (NSArray*)getShareItemList
{
    NSArray *imageList = @[@"btn_share_timeseccion",@"btn_share_weChat",@"btn_share_QQ",@"btn_share_sina"];
    NSArray *titleList = @[@"微信朋友圈",@"微信好友",@"QQ好友",@"新浪微博"];
    NSMutableArray *shareItems = [NSMutableArray array];
    for (int x = 0; x<imageList.count; x++)
    {
        NSDictionary *itemDic = @{@"title":titleList[x],
                                  @"image":imageList[x]};
        [shareItems addObject:itemDic];
    }
    
    return shareItems;
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
