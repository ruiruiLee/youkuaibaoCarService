//
//  CheXiaoBaoViewController.h
//  疯狂洗车
//
//  Created by LiuZach on 2016/12/26.
//  Copyright © 2016年 龚杰洪. All rights reserved.
//

#import "BaseViewController.h"

@interface CheXiaoBaoViewController : BaseViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *_webView;
}

@property (nonatomic, strong) NSString *webUrl;

@end
